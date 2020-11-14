# argocd-demo-environments

This repository contains manifests for all ArgoCD tenant projects and applications to be synced to one or more environments.

Environments are organised as top level folders. Inside each environment we use namespaces and ArgoCD AppProjects to group related ArgoCD Applications. In this demo, manifests for the actual applications themselves reside in their own repositories, and are merely pointed to by the ArgoCD manifests in this repository. You can think of this repository as the centralised system of record for which applications are deployed to which environments, with the details of the specific configuration of each application living in its own repository.
