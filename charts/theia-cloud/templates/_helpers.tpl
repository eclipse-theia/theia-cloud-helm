{{/*
Return the ingress path suffix based on controller
For nginx: (/|$)(.*) - regex pattern for capture group rewrite-target
For haproxy: empty - HAProxy uses prefix matching and config-backend for rewrites
*/}}
{{- define "theiacloud.ingress.pathSuffix" -}}
{{- if eq .Values.ingress.controller "haproxy" -}}
{{- /* empty for haproxy - uses prefix matching */ -}}
{{- else -}}
(/|$)(.*)
{{- end -}}
{{- end -}}

{{/*
Return the ingress pathType - always ImplementationSpecific for regex support
*/}}
{{- define "theiacloud.ingress.pathType" -}}
ImplementationSpecific
{{- end -}}

{{/*
Return the ingress class name
*/}}
{{- define "theiacloud.ingress.className" -}}
{{- if .Values.ingress.ingressClassName -}}
{{ .Values.ingress.ingressClassName }}
{{- else if eq .Values.ingress.controller "nginx" -}}
nginx
{{- else if eq .Values.ingress.controller "haproxy" -}}
haproxy
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
{{- else if eq .Values.ingress.controller "haproxy" -}}
{{- $annotations = include "theiacloud.ingress.haproxy.instances.defaultAnnotations" . | fromYaml | default (dict) -}}
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
{{- else if eq .Values.ingress.controller "haproxy" -}}
{{- $annotations = include "theiacloud.ingress.haproxy.landingPage.defaultAnnotations" . | fromYaml | default (dict) -}}
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
{{- else if eq .Values.ingress.controller "haproxy" -}}
{{- $annotations = include "theiacloud.ingress.haproxy.service.defaultAnnotations" . | fromYaml | default (dict) -}}
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
nginx.ingress.kubernetes.io/rewrite-target: /service$1$2
{{- end -}}

{{/*
Return default haproxy annotations for instances ingress
For path-based: rewrites /instances/<session-id>/path -> /path
For subdomain-based: rewrites /<session-id>/path -> /path
*/}}
{{- define "theiacloud.ingress.haproxy.instances.defaultAnnotations" -}}
{{- if not .Values.ingress.tls }}
haproxy-ingress.github.io/ssl-redirect: "false"
{{- end }}
haproxy-ingress.github.io/proxy-body-size: {{ tpl (.Values.ingress.instances.proxyBodySize | toString) . }}
haproxy-ingress.github.io/timeout-tunnel: {{ tpl (.Values.ingress.instances.timeoutTunnel | toString) . }}
{{- if .Values.hosts.usePaths }}
{{- $instancesPath := tpl (.Values.hosts.configuration.instance | toString) . }}
haproxy-ingress.github.io/path-type: prefix
haproxy-ingress.github.io/config-backend: |
  http-request set-header X-Forwarded-Uri %[path]%[query]
  http-request replace-path ^/{{ $instancesPath }}/([^/]+)(/.*)?$ \2
  http-request replace-path ^$ /
{{- else }}
haproxy-ingress.github.io/path-type: prefix
haproxy-ingress.github.io/config-backend: |
  http-request set-header X-Forwarded-Uri %[path]%[query]
  http-request replace-path ^/([^/]+)(/.*)?$ \2
  http-request replace-path ^$ /
{{- end }}
{{- end -}}

{{/*
Return default haproxy annotations for landing page ingress (path-based)
Rewrites /trynow/path -> /path (when landing page path is "trynow")
*/}}
{{- define "theiacloud.ingress.haproxy.landingPage.defaultAnnotations" -}}
{{- if not .Values.ingress.tls }}
haproxy-ingress.github.io/ssl-redirect: "false"
{{- end }}
{{- if .Values.hosts.usePaths }}
{{- if .Values.hosts.configuration.landing }}
{{- $landingPath := tpl (.Values.hosts.configuration.landing | toString) . }}
haproxy-ingress.github.io/path-type: prefix
haproxy-ingress.github.io/config-backend: |
  http-request redirect code 302 location %[path]/ if { path_reg ^/{{ $landingPath }}$ }
  http-request replace-path ^/{{ $landingPath }}(/.*)?$ \1
  http-request replace-path ^$ /
{{- end }}
{{- end }}
{{- end -}}

{{/*
Return default haproxy annotations for service ingress
For path-based: rewrites /servicex/service/path -> /service/path (when service path is "servicex")
For subdomain-based: rewrites /service/path -> /service/path (no change needed, but normalize)
*/}}
{{- define "theiacloud.ingress.haproxy.service.defaultAnnotations" -}}
{{- if not .Values.ingress.tls }}
haproxy-ingress.github.io/ssl-redirect: "false"
{{- end }}
{{- if .Values.hosts.usePaths }}
{{- $servicePath := tpl (.Values.hosts.configuration.service | toString) . }}
haproxy-ingress.github.io/path-type: prefix
haproxy-ingress.github.io/config-backend: |
  http-request replace-path ^/{{ $servicePath }}/service(/.*)?$ /service\1
  http-request replace-path ^/service$ /service/
{{- else }}
haproxy-ingress.github.io/path-type: prefix
haproxy-ingress.github.io/config-backend: |
  http-request replace-path ^/service$ /service/
{{- end }}
{{- end -}}

{{/*
Validate that OpenShift cloudProvider is not used with usePaths
*/}}
{{- define "theiacloud.validateOpenShift" -}}
{{- if and (eq .Values.operator.cloudProvider "OPENSHIFT") (.Values.hosts.usePaths) -}}
{{- fail "OpenShift cloudProvider does not support hosts.usePaths: true. Set hosts.usePaths to false." -}}
{{- end -}}
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
