# argocd-demo-environments

This repository contains manifests for all ArgoCD tenant projects and applications to be synced to one or more environments.

Environments are organised as top level folders. Inside each environment we use namespaces and ArgoCD AppProjects to group related ArgoCD Applications. In this demo, manifests for the actual applications themselves reside in their own repositories, and are merely pointed to by the ArgoCD manifests in this repository. You can think of this repository as the centralised system of record for which applications are deployed to which environments, with the details of the specific configuration of each application living in its own repository.

## Adding a new project

## Adding a new application

We'll use `kpt` and the packages from the stencil repo to simplify creation of the argocd `Application` resource

```
STENCIL_REPO=https://github.com/bernos/argocd-demo-stencils.git
STENCIL=argocd/application
ENVIRONMENT=production
PROJECT=my-project
APP=my-app
APP_REPO=https://github.com/bernos/argocd-demo-web-service.git

# Get the kpt pkg
kpt pkg get $STENCIL_REPO/$STENCIL $ENVIRONMENT/$PROJECT/apps/$APP

# Set the `project` and `name` for the application using `kpt`
kpt cfg set $ENVIRONMENT/$PROJECT/apps/$APP project $PROJECT
kpt cfg set $ENVIRONMENT/$PROJECT/apps/$APP name $APP

# Set the repo, repo path end optinally revision containing the manifests of the application. Argo will sync this repo/revision
kpt cfg set $ENVIRONMENT/$PROJECT/apps/$APP repo $APP_REPO
kpt cfg set $ENVIRONMENT/$PROJECT/apps/$APP repo-path .
kpt cfg set $ENVIRONMENT/$PROJECT/apps/$APP target-revision HEAD

# Finally, add commit and push the new application
git add -A && git commit -m "Added the $ENVIRONMENT/$PROJECT/$APP application" && git push
```
