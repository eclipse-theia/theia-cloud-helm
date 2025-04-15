# theia-cloud

![Version: 1.1.0-next.4](https://img.shields.io/badge/Version-1.1.0--next.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.1.0-next](https://img.shields.io/badge/AppVersion-1.1.0--next-informational?style=flat-square)

A Helm chart for Theia Cloud

*This chart was tested with Helm version v3.17.0.*
*Other versions may work as well, but if you encounter any issues, we recommend trying with the tested version to rule out version-specific problems.*

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app | object | (see details below) | General information about the deployed app |
| app.id | string | `"asdfghjkl"` | The app id which is used in the communication between website and REST-API as a spam migitation. This id is public. Please choose an random generated string. |
| app.name | string | `"Theia Blueprint"` | The name of the application that may be displayed e.g. on the landing pages |
| demoApplication | object | (see details below) | Information about the demo application to be installed |
| demoApplication.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the main application's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| demoApplication.install | bool | `true` | Should the demo application be installed |
| demoApplication.monitor | object | (see details below) | Values that are used by the monitor |
| demoApplication.monitor.activityTracker | object | (see details below) | Values that are used by the activityTracker module |
| demoApplication.monitor.activityTracker.notifyAfter | int | `25` | Minutes of inactivity that lead to a warning displayed to the user Make greater than timeoutAfter to disable |
| demoApplication.monitor.activityTracker.timeoutAfter | int | `30` | Minutes of inactivity that lead to pod shutdown |
| demoApplication.monitor.port | int | `3000` | At which port the monitor extension is available For the Theia extension take the same as the application port For the VSCode extension take 8081 (default) or the port specified via the THEIACLOUD_MONITOR_PORT env variable |
| demoApplication.name | string | `"theiacloud/theia-cloud-demo:1.1.0-next"` | The name of docker image to be used |
| demoApplication.pullSecret | string | `""` | the image pull secret. Leave empty if registry is public |
| demoApplication.timeout | string | `"30"` | Limit in minutes |
| hosts | object | (see details below) | You may adjust the hostname below. |
| hosts.allWildcardInstances | list | `[]` | all additional wildcard hostnames that may be required in the launched Theia-applications, e.g. "*.webview." which leads to "*.webview.ws.192.168.39.173.nip.io" to expose webviews. Please note that this means that this usually means that all "ingressHostnamePrefixes" patterns from all app definitions need to be added. IMPORTANT: If this gets updated, the helm chart needs to be re-installed because helm upgrade will not properly update this at the moment. These are required to configure TLS (if enabled via ingress.tls == true) I.e. custom certificates or a cert-manager provider that can handle wildcard certificates need to be configured. |
| hosts.configuration | object | (see details below) | Configuration for the hostnames. Contains the baseHost and afixes for all services |
| hosts.configuration.baseHost | string | `"192.168.39.173.nip.io"` | baseHost configures the host for all services. Depending on hosts.usePaths the services will be prepended as a subdomain or appended as a path |
| hosts.configuration.instance | string | `"instances"` | afix for deployed instances |
| hosts.configuration.landing | string | `"trynow"` | afix of the landing page |
| hosts.configuration.service | string | `"servicex"` | afix of the REST service |
| hosts.usePaths | bool | `false` | Use paths configures that all services should run on the same host but on different paths. true uses paths false uses an explicit host for each service |
| imagePullPolicy | string | `"Always"` | The default imagePullPolicy for containers of theia cloud. Can be overridden for individual components by specifying the imagePullPolicy variable there. Possible values: - Always - IfNotPresent - Never |
| ingress | object | (see details below) | Values to influence the ingresses |
| ingress.addTLSSecretName | bool | `true` | whether the default Theia Cloud tls secret names should be used. If false no tls secret name will be set on the ingress only needed when ingress.tls == true |
| ingress.certManagerAnnotations | bool | `true` | When set to true the cert-manager.io annotations will be set. Only used when ingress.addTLSSecretName === true When false certificate management is handled outside of Theia Cloud. |
| ingress.clusterIssuer | string | `"letsencrypt-prod"` | The cluster issuer to use Only needed when ingress.certManagerAnnotations is true |
| ingress.instances | object | `{"allWildcardSecretNames":{},"configurationSnippets":["proxy_set_header 'X-Forwarded-Uri' $request_uri"],"name":"theia-cloud-demo-ws-ingress","proxyBodySize":"1m"}` | Values to influence the instances ingress |
| ingress.instances.allWildcardSecretNames | object | `{}` | All additional wildcard hostnames and the respective TLS secret names. Use this for wildcard hostnames that should use a TLS certificate with a `secretName` different from the default one. Only accepts wildcard hostnames that are configured in `hosts.allWildcardInstances`. |
| ingress.instances.configurationSnippets | list | `["proxy_set_header 'X-Forwarded-Uri' $request_uri"]` | Additional configuration to the ingress configuration via the `nginx.ingress.kubernetes.io/configuration-snippet` annotation. One entry in this array results in a line for the annotation. Do not add a semicolon at the end of the line here, it is automatically added. Note: Since ingress-nginx version 1.10 this annotation needs to be enabled. See [this README](../../README.md#cluster-prerequisites) for more information. |
| ingress.instances.name | string | `"theia-cloud-demo-ws-ingress"` | The name of the ingress which will be updated to publish new theia application. If this is not existing it will be created. You may chose to set the ingress up yourself and point Theia Cloud to the ingress via the name |
| ingress.instances.proxyBodySize | string | `"1m"` | Sets the maximum allowed size of the client request body inside the application (e.g. file uploads in Theia). Defaults to 1m. Setting size to 0 disables checking of client request body size. |
| ingress.theiaCloudCommonName | bool | `false` | When set to true the cert-manager.io/common-name annotation will be set. This is only required when the issued certificate by the cert-manager misses a common-name Only needed when ingress.certManagerAnnotations is true |
| ingress.tls | bool | `true` | Does Theia Cloud expect TLS connections (true) or is TLS terminated outside of Theia Cloud (e.g. via a Load Balancer) (false) |
| issuer | object | (see details below) | Values related to certificates/Cert-manager |
| issuer.email | string | `"mmorlock@example.com"` | EMail address of the certificate issuer. |
| keycloak | object | (see details below) | Values related to Keycloak |
| keycloak.adminGroup | string | `"theia-cloud/admin"` | The name of the Keycloak group identifying admin users who are allowed to access the service's admin endpoints. |
| keycloak.authUrl | string | `"https://keycloak.url/auth/"` | Key cloak auth URL. Only has to be specified when enable: true |
| keycloak.clientId | string | `"theia-cloud"` | The client-id. Only has to be specified when enable: true |
| keycloak.clientSecret | string | `"publicbutoauth2proxywantsasecret"` | The oaid client secret. In case you configure your keycloak client as confidential, then you may specifiy the secret here. If you stick with our default public client, you may leave below value. For public clients keycloak does not generate a client-secret, but in order to make oath2-proxy happy, we will pass a value |
| keycloak.cookieSecret | string | `"OQINaROshtE9TcZkNAm5Zs2Pv3xaWytBmc5W7sPX7ws="` | The cookie secret. This should not be public! Only has to be specified when enable: true See https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/overview/#generating-a-cookie-secret for how to generate a strong cookie secret. |
| keycloak.enable | bool | `false` | Whether keycloak authentication shall be used |
| keycloak.realm | string | `"TheiaCloud"` | The Keycloak Realm. Only has to be specified when enable: true |
| landingPage | object | (see details below) | Values related to the landing page |
| landingPage.additionalApps | string | `nil` | The page may show these additional apps in a drop down. This is a map. The key maps to the app definition name The value is the label that is supposed to be shown in the UI  Example: different-app-definition:   label: "Different App Definition" further-app-definition:   label: "Further App Definition" |
| landingPage.appDefinition | string | `"theia-cloud-demo"` | the app id to launch |
| landingPage.disableInfo | bool | `false` | Should showing info title and text below the launch button be disabled true hides the info title and text false shows the info title and text |
| landingPage.enabled | bool | `true` | Whether the landing page shall be enabled |
| landingPage.ephemeralStorage | bool | `true` | If set to true no persisted storage is used when creating sessions on the landing page. Set to false if you want to use persisted storage. |
| landingPage.image | string | `"theiacloud/theia-cloud-landing-page:1.1.0-next"` | the landing page image to use |
| landingPage.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the landing page's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| landingPage.imagePullSecret | string | `nil` | Optional: the image pull secret |
| landingPage.infoText | string | `nil` | Optional: If specified with a value, this overrides the info text shown on the landing page. Empty values are ignored. Use `disableInfo` to deactivate showing the info completely. |
| landingPage.infoTitle | string | `nil` | Optional: If specified with a value, this overrides the title of the info text shown on the landing page. Empty values are ignored. Use `disableInfo` to deactivate showing the info completely. |
| landingPage.loadingText | string | `nil` | Optional: If specified with a value, this overrides the message shown to the user while the session is started. Empty values are ignored and the default text is used. |
| landingPage.logo | string | `"logos/theiablueprint.svg"` | The logo of the application that should be displayed on the landing pages |
| landingPage.logoData | string | `nil` | set landingPage.logoData=$(cat path/to/file.svg | base64 -w 0 -) Another way is to directly add the base64 string to the values file. |
| landingPage.logoFileExtension | string | `"svg"` | The file extension of the logo. Must be set to match the logo respectively the logoData. This is required because browsers cannot show a binary image (e.g. png) with a svg ending and vice-versa. |
| monitor | object | (see details below) | Values to influence the monitor initialization on the operator |
| monitor.activityTracker | object | (see details below) | Values to influence the activityTracker module |
| monitor.activityTracker.enable | bool | `true` | Should the activityTracker module be enabled |
| monitor.activityTracker.interval | int | `1` | Minutes between re-pinging the pods |
| monitor.enable | bool | `true` | Should the monitor be enabled |
| oauth2Proxy | object | `{"cookieDomains":[],"whitelistDomains":[]}` | Values related to OAuth2 Proxy configuration |
| operator | object | (see details below) | Values related to the operator |
| operator.bandwidthLimiter | string | `"K8SANNOTATION"` | Whether Theia Cloud shall limit network speed. This might not be fully supported on all cloud provider/in all clusters. Possible values: - K8SANNOTATION                   Set via kubernetes annotations (kubernetes.io/egress-bandwidth and kubernetes.io/ingress-bandwidth) - WONDERSHAPER                    Set via wondershaper init container - K8SANNOTATIONANDWONDERSHAPER    Set Kubernetes annotations and use wondershaper init container |
| operator.cloudProvider | string | `"K8S"` | Select your cloud provider. Possible values: - K8S      Plain Kubernetes - MINIKUBE Local deployment on Minikube |
| operator.continueOnException | bool | `false` | Whether the operator should stop in cases where an exception is not handled |
| operator.eagerStart | bool | `false` | Whether theia applications shall be started eager. This means that the application is already running without a user. When a user requests a new session, one of the already launched ones is assigned.  Currently only false is fully supported. |
| operator.image | string | `"theiacloud/theia-cloud-operator:1.1.0-next"` | The operator image |
| operator.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the operator's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| operator.imagePullSecret | string | `nil` | Optional: the image pull secret |
| operator.leaderElection | object | (see details below) | Options to influence the operator's leader election |
| operator.logging | object | (see details below) | Allows to override the operator's log4j configuration |
| operator.maxWatchIdleTime | string | `"3600000"` | Configures the timeout in milliseconds when a watcher for either AppDefinitions, Workspaces, or Sessions is assumed to be not working. When this is detected the operator instance will stop and a new operator will set up fresh watchers. |
| operator.oAuth2ProxyVersion | string | `"v7.5.1"` | The version to use of the quay.io/oauth2-proxy/oauth2-proxy image |
| operator.replicas | int | `1` | Number of operator instances to create |
| operator.requestedStorage | string | `"250Mi"` | The amount of requested storage for each persistent volume claim (PVC) for workspaces. This is directly passed to created PVCs and must be a valid Kubernetes quantity. See https://kubernetes.io/docs/reference/kubernetes-api/common-definitions/quantity/ |
| operator.sessionsPerUser | string | `"1"` | Set the number of active sessions a single user can launch |
| operator.storageClassName | string | `"default"` | The name of the storage class for persistent volume claims for workspaces. This storage class must be present on the cluster. Most cloud providers offer a default storage class without additional configuration. |
| operator.wondershaperImage | string | `"theiacloud/theia-cloud-wondershaper:1.1.0-next"` | If bandwidthLimiter is set to WONDERSHAPER or K8SANNOTATIONANDWONDERSHAPER this image will be used for the wondershaper init container |
| operatorrole.name | string | `"operator-api-access"` |  |
| preloading | object | (see details below) | Values to configure preloading of images on Kubernetes nodes. |
| preloading.enable | bool | `true` | Is image preloading enabled. |
| preloading.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the image preloading containers. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| preloading.images | list | `[]` | Images to preload. Images must support running /bin/sh. If the list is empty and demoApplication.install == true, demoApplication.name is automatically added. |
| service | object | (see details below) | Values of the Theia Cloud REST service |
| service.image | string | `"theiacloud/theia-cloud-service:1.1.0-next"` | The image to use |
| service.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the service's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| service.imagePullSecret | string | `nil` | Optional: the image pull secret |
| service.port | int | `8081` | service port (default: 8081) |
| service.protocol | string | `"https"` | protocol of the REST-API |
| servicerole.name | string | `"service-api-access"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
