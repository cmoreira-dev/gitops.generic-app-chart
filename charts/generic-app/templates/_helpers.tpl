{{/*
Expand the name of the chart.
*/}}
{{- define "generic-app.name" -}}
{{- .Values.nameOverride | default .Chart.Name | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Full app name. Truncated to 63 chars because some Kubernetes name fields are limited to this.
*/}}
{{- define "generic-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := .Values.nameOverride | default .Chart.Name }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Namespace this release targets — either the override or the Helm release namespace.
*/}}
{{- define "generic-app.namespace" -}}
{{- .Values.namespace.name | default .Release.Namespace }}
{{- end }}

{{- define "generic-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "generic-app.labels" -}}
helm.sh/chart: {{ include "generic-app.chart" . }}
{{ include "generic-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "generic-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "generic-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ConfigMap name to use
*/}}
{{- define "generic-app.configMapName" -}}
{{- .Values.configMap.name | default (include "generic-app.fullname" .) }}
{{- end }}

{{/*
ECR pull secret (ExternalSecret + generated Secret) name to use
*/}}
{{- define "generic-app.ecrPullSecretName" -}}
{{- .Values.ecrPullSecret.name | default (printf "%s-ecr-pull" (include "generic-app.fullname" .)) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Service account name to use
*/}}
{{- define "generic-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- .Values.serviceAccount.name | default (include "generic-app.fullname" .) }}
{{- else }}
{{- .Values.serviceAccount.name | default "default" }}
{{- end }}
{{- end }}
