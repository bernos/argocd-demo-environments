#! /usr/bin/env bash
set -eou pipefail

usage() {
  cat << EOF
Usage: $(basename "${0}") <environment> <project> <application-name>

Adds a new application to a project.
EOF
}

(($# != 3)) && usage

environment="${1}"
project="${2}"
application="${3}"

[ -d "${environment}" ] || { echo "ERROR: '${environment}' is not a valid environment"; exit 1;}
[ -d "${environment}/${project}" ] || { echo "ERROR: '${environment}' does not contain a project named '${project}'"; exit 1;}
[ -d "${environment}/${project}/apps/${application}" ] && { echo "ERROR: Project '${project}' in the environment '${environment}' already contains an application named '${application}'"; exit 1; }

read -p 'URL of the repo containing application source: ' repo
read -p 'Path within the repo containing application source (use . to indicate the root folder): ' repo_path
# Fetch the kpt package containing the argocd Application stencil
kpt pkg get https://github.com/bernos/argocd-demo-stencils.git/argocd/application "${environment}/${project}/apps/${application}"

# Update kpt configuration for the new project
kpt cfg set "${environment}/${project}/apps/${application}" project "${project}"
kpt cfg set "${environment}/${project}/apps/${application}" name "${application}"
kpt cfg set "${environment}/${project}/apps/${application}" repo "${repo}"
kpt cfg set "${environment}/${project}/apps/${application}" repo-path "${repo-path}"

# Destination namespace for the application. We'll update the AppProject resource yaml to
# allow apps within the project to be deployed into this namespace
dest_namespace="${project}-${application}"

#
# WARNING: updating yaml files that are also controlled via kpt is probably not a good idea,
# as it it possible that a future kpt pkg update command could revert some these changes.
# until there is a way to append objects to yaml lists in kpt though, this is probably the
# most pragmatic way to add the destination namespace and source repository to the list of
# allowed sources and destinations in the AppProject resource yaml
#
# Write yaml for destination namespace to a temp file, so that we can merge it with the 
# project argocd resource 
tmpfile=$(mktemp)
cat << EOF > "${tmpfile}"
spec:
  destinations:
    - server: https://kubernetes.default.svc
      namespace: ${dest_namespace}
EOF

yq m -i -d1 -a "${environment}/${project}/project.yaml" "${tmpfile}"
yq w -i -d1 "${environment}/${project}/project.yaml" "spec.sourceRepos[+]" "${repo}"
