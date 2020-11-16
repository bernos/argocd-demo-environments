#! /usr/bin/env bash
set -eou pipefail

usage() {
  cat << EOF
Usage: $(basename "${0}") <environment> <project>

Adds a new project to an existing environment environment
EOF
}

(($# != 2)) && usage

environment="${1}"
project="${2}"

[ -d "${environment}" ] || { echo "ERROR: '${environment}' is not a valid environment"; exit 1;}
[ -d "${environment}/${project}" ] && { echo "ERROR: Project '${project}' already exists in the environment '${environment}'"; exit 1; }

kpt pkg get https://github.com/bernos/argocd-demo-stencils.git/argocd/project "${environment}/${project}"
kpt cfg set "${environment}/${project}" project "${project}"

mkdir "${environment}/${project}/apps"
