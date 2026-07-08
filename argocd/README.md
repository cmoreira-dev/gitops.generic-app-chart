# argocd/

Pasta intencionalmente sem manifests. Este repo é uma dependência de chart Helm, não um
workload a ser deployado — ver a seção "Nota sobre o ApplicationSet" no README raiz.

O `ApplicationSet/gitops-repos` vai gerar uma Application "gitops.generic-app-chart" apontando
para este diretório; como não há YAMLs aqui, o sync resulta em zero recursos (Healthy/Synced).
