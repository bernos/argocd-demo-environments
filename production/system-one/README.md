# system-one

This is an example "system". A system is a group of one or more applications which work together and share a common namespace and security policy boundary.

Each system resides in a single namespace and is modelled as an ArgoCD AppProject resource in `project.yaml`. The AppProject resource allows us to limit the git respositories that can be synced from, the types of cluster and namespace resources that ArgoCD can create when syncing Applications in the AppProject, and also allows us to define roles which can be mapped to OIDC groups, to control which ArgoCD users can and cannot read and write the Applications in the AppProject.
