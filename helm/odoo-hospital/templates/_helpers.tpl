{{/*
Expand the name of the chart.
*/}}
{{- define "odoo-hospital.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "odoo-hospital.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label
*/}}
{{- define "odoo-hospital.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to all resources
*/}}
{{- define "odoo-hospital.labels" -}}
helm.sh/chart: {{ include "odoo-hospital.chart" . }}
app.kubernetes.io/name: {{ include "odoo-hospital.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/part-of: odoo-hospital
environment: {{ .Values.global.environment }}
{{- end }}

{{/*
Selector labels — used in matchLabels (must be stable, no chart version)
*/}}
{{- define "odoo-hospital.selectorLabels" -}}
app.kubernetes.io/name: {{ include "odoo-hospital.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Odoo-specific selector labels
*/}}
{{- define "odoo-hospital.odooSelectorLabels" -}}
{{ include "odoo-hospital.selectorLabels" . }}
app.kubernetes.io/component: application
{{- end }}

{{/*
PostgreSQL-specific selector labels
*/}}
{{- define "odoo-hospital.pgSelectorLabels" -}}
{{ include "odoo-hospital.selectorLabels" . }}
app.kubernetes.io/component: database
{{- end }}

{{/*
Secret name
*/}}
{{- define "odoo-hospital.secretName" -}}
{{- printf "%s-secrets" (include "odoo-hospital.fullname" .) }}
{{- end }}

{{/*
Odoo PVC name
*/}}
{{- define "odoo-hospital.odooPvcName" -}}
{{- printf "%s-odoo-data" (include "odoo-hospital.fullname" .) }}
{{- end }}

{{/*
PostgreSQL PVC name
*/}}
{{- define "odoo-hospital.pgPvcName" -}}
{{- printf "%s-postgres-data" (include "odoo-hospital.fullname" .) }}
{{- end }}

{{/*
Service account name
*/}}
{{- define "odoo-hospital.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "odoo-hospital.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
