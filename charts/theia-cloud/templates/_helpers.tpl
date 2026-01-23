{{/*
Return the ingress class name
*/}}
{{- define "theiacloud.ingress.className" -}}
{{- if .Values.ingress.ingressClassName -}}
{{ .Values.ingress.ingressClassName }}
{{- else if eq .Values.ingress.controller "nginx" -}}
nginx
{{- else -}}
{{ .Values.ingress.controller }}
{{- end -}}
{{- end -}}

{{/*
Return the annotations for the instances ingress
*/}}
{{- define "theiacloud.ingress.instances.annotations" -}}
{{- $annotations := dict -}}
{{- if .Values.ingress.instances.annotations -}}
{{- $annotations = .Values.ingress.instances.annotations -}}
{{- else -}}
{{- if eq .Values.ingress.controller "nginx" -}}
{{- $annotations = include "theiacloud.ingress.nginx.instances.defaultAnnotations" . | fromYaml | default (dict) -}}
{{- end -}}
{{- end -}}
{{- $certAnnotations := include "theiacloud.ingress.certManagerAnnotations" . | fromYaml | default (dict) -}}
{{- $annotations = merge $annotations $certAnnotations -}}
{{- $annotations | toYaml -}}
{{- end -}}

{{/*
Return the annotations for the landing page ingress
*/}}
{{- define "theiacloud.ingress.landingPage.annotations" -}}
{{- $annotations := dict -}}
{{- if .Values.ingress.landingPage.annotations -}}
{{- $annotations = .Values.ingress.landingPage.annotations -}}
{{- else -}}
{{- if eq .Values.ingress.controller "nginx" -}}
{{- $annotations = include "theiacloud.ingress.nginx.landingPage.defaultAnnotations" . | fromYaml | default (dict) -}}
{{- end -}}
{{- end -}}
{{- $certAnnotations := include "theiacloud.ingress.certManagerAnnotations" (dict "root" . "includeHttp01" false) | fromYaml | default (dict) -}}
{{- $annotations = merge $annotations $certAnnotations -}}
{{- $annotations | toYaml -}}
{{- end -}}

{{/*
Return the annotations for the service ingress
*/}}
{{- define "theiacloud.ingress.service.annotations" -}}
{{- $annotations := dict -}}
{{- if .Values.ingress.service.annotations -}}
{{- $annotations = .Values.ingress.service.annotations -}}
{{- else -}}
{{- if eq .Values.ingress.controller "nginx" -}}
{{- $annotations = include "theiacloud.ingress.nginx.service.defaultAnnotations" . | fromYaml | default (dict) -}}
{{- end -}}
{{- end -}}
{{- $certAnnotations := include "theiacloud.ingress.certManagerAnnotations" . | fromYaml | default (dict) -}}
{{- $annotations = merge $annotations $certAnnotations -}}
{{- $annotations | toYaml -}}
{{- end -}}

{{/*
Return default nginx annotations for instances ingress
*/}}
{{- define "theiacloud.ingress.nginx.instances.defaultAnnotations" -}}
{{- if not .Values.ingress.tls }}
nginx.ingress.kubernetes.io/ssl-redirect: "false"
{{- end }}
nginx.ingress.kubernetes.io/proxy-buffer-size: "128k"
nginx.ingress.kubernetes.io/rewrite-target: /$2
{{- if .Values.ingress.instances.configurationSnippets }}
nginx.ingress.kubernetes.io/configuration-snippet: |
  {{- range .Values.ingress.instances.configurationSnippets }}
  {{ . }};
  {{- end }}
{{- else }}
nginx.ingress.kubernetes.io/configuration-snippet: |
  proxy_set_header 'X-Forwarded-Uri' $request_uri;
{{- end }}
nginx.ingress.kubernetes.io/proxy-body-size: {{ tpl (.Values.ingress.instances.proxyBodySize | toString) . }}
{{- end -}}

{{/*
Return default nginx annotations for landing page ingress (path-based)
*/}}
{{- define "theiacloud.ingress.nginx.landingPage.defaultAnnotations" -}}
{{- if not .Values.ingress.tls }}
nginx.ingress.kubernetes.io/ssl-redirect: "false"
{{- end }}
{{- if .Values.hosts.usePaths }}
{{- if .Values.hosts.configuration.landing }}
nginx.ingress.kubernetes.io/rewrite-target: /$2
{{- end }}
nginx.ingress.kubernetes.io/configuration-snippet: |
  rewrite ^([^.?]*[^/])$ $1/ redirect;
{{- end }}
{{- end -}}

{{/*
Return default nginx annotations for service ingress
*/}}
{{- define "theiacloud.ingress.nginx.service.defaultAnnotations" -}}
{{- if not .Values.ingress.tls }}
nginx.ingress.kubernetes.io/ssl-redirect: "false"
{{- end }}
nginx.ingress.kubernetes.io/rewrite-target: /service$1
{{- end -}}

{{/*
Return cert-manager annotations if enabled
Params:
  . - root context
  includeHttp01 - (optional) whether to include HTTP-01 specific annotations
*/}}
{{- define "theiacloud.ingress.certManagerAnnotations" -}}
{{- $includeHttp01 := true -}}
{{- if hasKey . "includeHttp01" -}}
{{- $includeHttp01 = .includeHttp01 -}}
{{- end -}}
{{- $root := . -}}
{{- if hasKey . "root" -}}
{{- $root = .root -}}
{{- end -}}
{{- if $root.Values.ingress.addTLSSecretName }}
{{- if $root.Values.ingress.certManagerAnnotations }}
cert-manager.io/cluster-issuer: {{ tpl ($root.Values.ingress.clusterIssuer | toString) $root }}
{{- if and $includeHttp01 $root.Values.ingress.theiaCloudCommonName }}
cert-manager.io/common-name: "Theia Cloud"
{{- end }}
{{- if $includeHttp01 }}
acme.cert-manager.io/http01-ingress-class: {{ include "theiacloud.ingress.className" $root }}
{{- end }}
{{- end }}
{{- end }}
{{- end -}}
