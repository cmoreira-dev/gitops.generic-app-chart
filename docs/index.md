# gitops.generic-app-chart

A shared, reusable Helm chart (`charts/generic-app`) for homegrown
homelab apps — Deployment + Service + Gateway API `HTTPRoute` +
`ConfigMap` + `ExternalSecret`. Published as an OCI artifact to
`oci://ghcr.io/cmoreira-dev/charts/generic-app`.

This repo is a **library, not a deployable workload** — its own
`argocd/` folder is intentionally empty so the `gitops-repos`
ApplicationSet syncs it to zero resources instead of failing.

## Who consumes it

Every product's `gitops.<product>` repo wraps this chart as a dependency
for its `helm/api` and `helm/ui` subcharts:

- [`gitops.teupadel.com`](https://github.com/cmoreira-dev/gitops.teupadel.com)
- [`gitops.local-sara`](https://github.com/cmoreira-dev/gitops.local-sara)

A consumer bumps the `dependencies:` version in its own `Chart.yaml` to
pick up a new `generic-app` release — nothing here rolls out
automatically to consumers.

## Key defaults to know before adopting it

- **`podSecurityContext`/`securityContext` default to PodSecurity
  `restricted`-compliant** (`runAsNonRoot`, dropped capabilities,
  `seccompProfile: RuntimeDefault`) since 0.4.0. An image that runs as
  root or binds a privileged port (e.g. a Next.js server on `:80`) must
  override both back to `{}` and fix its Dockerfile before adopting —
  this is what broke the `ui.ia.*` images the first time around.
- **Namespace lifecycle is owned by ArgoCD**, not this chart —
  `syncOptions: CreateNamespace=true` on the consuming `Application`,
  not a rendered `Namespace` object here.
- **`ecrPullSecret` defaults to enabled** — every homelab app pulls from
  a private ECR repo by default; extra `imagePullSecrets` entries merge
  in rather than replacing it.
- Since 0.7.0, the container name matches the app name
  (`nameOverride`/`generic-app.name`) instead of a fixed `generic-app` —
  needed for correct `container` labels in Loki and service-name
  auto-discovery. Adopting this bump causes a rolling restart.

See [Chart reference](chart-reference.md) for the full values schema and
version history, and `examples/values-headlamp.yaml` in this repo for a
worked example against a real app.
