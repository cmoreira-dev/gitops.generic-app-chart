# gitops.generic-app-chart

Chart Helm genérico e reutilizável para apps próprias do homelab, cobrindo:

- `Namespace` (criação opcional)
- `Deployment` (imagem, probes, recursos, node placement x86/ARM64, securityContext)
- `Service`
- `HTTPRoute` (Gateway API, alvo NGINX Gateway Fabric)
- `ExternalSecret` (via `ClusterSecretStore`/`SecretStore` já existente no cluster)

## Por que este repo existe fora do padrão `helm/<app>` de cada `gitops.*`

Os demais repos `gitops.*` são *wrapper charts* em torno de um chart upstream (ex.:
`gitops.headlamp` depende do chart público do Headlamp). Não existia, até esta migração,
nenhum chart próprio para workloads homemade — o único exemplo (`gitops.echoserver`) usa
Kustomize puro. Este repo preenche essa lacuna como uma dependência Helm compartilhada.

## Nota sobre o ApplicationSet

O `ApplicationSet/gitops-repos` no ArgoCD casa qualquer repositório `^gitops\..*` e gera uma
Application apontando para o path `argocd/` desse repo (padrão app-of-apps usado pelos outros
`gitops.*`). Este repo **não tem workload próprio para deployar** — é só uma dependência de
chart. Por isso a pasta `argocd/` aqui é intencionalmente vazia (só um README), para que a
Application gerada automaticamente sincronize com sucesso e fique `Healthy`/`Synced` com zero
recursos, em vez de falhar por falta de manifests.

## Uso

Cada app consumidora (`gitops.<app>`) referencia este chart como dependência no seu
`Chart.yaml`:

```yaml
dependencies:
  - name: generic-app
    version: "0.1.0"
    repository: "git+https://github.com/cmoreira-dev/gitops.generic-app-chart.git@charts/generic-app?ref=main"
```

e fornece seu próprio `values.yaml`. Veja `examples/values-headlamp.yaml` para um exemplo
completo migrando o Headlamp (hoje exposto via Istio) para este chart + NGINX Gateway Fabric.

> Nota: charts Helm via dependência git (`git+https://...`) exigem Helm 3.x com o plugin de
> resolução de dependência git, ou publicar o chart num repositório OCI/Helm real (ex.
> `oci://ghcr.io/cmoreira-dev/charts`) via CI. Ainda não decidido — ver `docs/migration-istio-to-nginx-gateway-fabric.md`
> na seção de riscos.
