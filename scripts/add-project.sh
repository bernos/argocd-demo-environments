#! /usr/bin/env bash
set -eou pipefail

usage() {
  cat << EOF
Usage: $(basename "${0}") <project>

Adds a new project
EOF
}

(($# != 1)) && usage

project="${1}"

for environment in "development" "production"
do
  mkdir -p "${environment}"

  [ -d "${environment}/${project}" ] && { echo "ERROR: Project '${project}' already exists in the environment '${environment}'"; exit 1; }

  kpt pkg get https://github.com/bernos/argocd-demo-stencils.git/argocd/project "${environment}/${project}"
  kpt cfg set "${environment}/${project}" project "${project}"

  mkdir "${environment}/${project}/apps"
done


