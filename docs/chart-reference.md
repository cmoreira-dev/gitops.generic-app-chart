# Chart reference

Values are documented inline in `charts/generic-app/values.yaml`
(each key has a `# --` comment) and enforced by
`charts/generic-app/values.schema.json`. This page covers the parts
worth knowing before touching a consumer's `values-<app>.yaml`.

## Resources rendered

- `Deployment`
- `Service`
- `HTTPRoute` (Gateway API — the `gateway.name`/`gateway.namespace` a
  consumer points at is the NGINX Gateway Fabric `Gateway` from
  `gitops.core-addons`)
- `ConfigMap` (optional)
- `ExternalSecret` (optional, generic key/value)
- `ExternalSecret` for ECR pull credentials (`ecrPullSecret`, enabled by
  default)
- `ServiceAccount`

No `Namespace` — namespace creation is delegated to the consuming
ArgoCD `Application` (`syncOptions: CreateNamespace=true`).

## Scheduling

The cluster mixes an x86 control-plane node with ARM64 (Raspberry Pi)
workers. `nodeSelector`/`tolerations`/`affinity` default to `{}` —
set `nodeSelector: {kubernetes.io/arch: arm64}` explicitly for any
image that isn't multi-arch, rather than relying on scheduler defaults.

`runtimeClassName` defaults to `""`; set it to `"nvidia"` for GPU
workloads (registered via Talos's `nvidia-container-toolkit` extension)
— without it the container runs under plain `runc` and NVML fails with
`ERROR_LIBRARY_NOT_FOUND`.

`strategy` defaults to Kubernetes' own default (`RollingUpdate`
25%/25%). Single-instance workloads holding a scarce resource (e.g. one
GPU slot) need `{"type": "Recreate"}` — a `RollingUpdate` would try to
schedule a surge pod that can never get the resource.

## Version history

See the annotated `version:` history at the top of
`charts/generic-app/Chart.yaml` for the full list of breaking vs.
additive changes (0.2.0 through the current release) — notably 0.4.0's
`restricted` PodSecurity defaults and 0.7.0's container-name change,
both called out on the [home page](index.md).
