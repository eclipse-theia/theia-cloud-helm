# theia-cloud

![Version: 0.8.1-v008-MS2](https://img.shields.io/badge/Version-0.8.1--v008--MS2-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.8.1.MS2](https://img.shields.io/badge/AppVersion-0.8.1.MS2-informational?style=flat-square)

A Helm chart for Theia.cloud

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| app | object | (see details below) | General information about the deployed app |
| app.id | string | `"asdfghjkl"` | The app id which is used in the communication between website and REST-API as a spam migitation. This id is public. Please choose an random generated string. |
| app.logo | string | `"logos/theiablueprint.svg"` | The logo of the application that should be displayed on the landing pages |
| app.logoData | string | `nil` | set app.logoData=$(cat path/to/file.svg | base64 -w 0 -) Another way is to directly add the base64 string to the values file. |
| app.name | string | `"Theia Blueprint"` | The name of the application that should be displayed on the landing pages |
| hosts | object | (see details below) | You may adjust the hostname below. |
| hosts.instance | string | `"ws.192.168.39.173.nip.io"` | hostname for the launched Theia-applications |
| hosts.landing | string | `"theia.cloud.192.168.39.173.nip.io"` | hostname of the landing page |
| hosts.paths.baseHost | string | `"192.168.39.173.nip.io"` | baseHost configures the host for all services when usePaths == true. Otherwise the explicit host definitions of the services are used. |
| hosts.paths.instance | string | `"instances"` | path for deployed instances |
| hosts.paths.landing | string | `"trynow"` | path of the landing page |
| hosts.paths.service | string | `"servicex"` | path of the REST service |
| hosts.service | string | `"service.192.168.39.173.nip.io"` | hostname of the REST-API |
| hosts.servicePort | int | `8081` | service port (default: 8081) |
| hosts.serviceProtocol | string | `"https"` | protocol of the REST-API |
| hosts.tls | bool | `true` | Does Theia Cloud expect TLS connections (true) or is TLS terminated outside of Theia Cloud (e.g. via a Load Balancer) (false) |
| hosts.usePaths | bool | `false` | Use paths configures that all services should run on the same host but on different paths. true uses paths false uses an explicit host for each service |
| hosts.useServicePortInHostname | bool | `false` | whether the service port needs to be part of the service URL (default: false) |
| image | object | (see details below) | Docker image of the main application |
| image.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the main application's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| image.name | string | `"theiacloud/theia-cloud-demo:0.8.1.MS2"` | The name of docker image to be used |
| image.pullSecret | string | `""` | the image pull secret. Leave empty if registry is public |
| image.timeoutLimit | string | `"30"` | Limit in minutes |
| image.timeoutStrategy | string | `"FIXEDTIME"` | Configures how sessions will be stopped. This defines the strategy and the limit in minutes and will override any specification from an appDefinition. Possible values for strategy: - FIXEDTIME   Sessions will be stopped after a fixed limit |
| imagePullPolicy | string | `"Always"` | The default imagePullPolicy for containers of theia cloud. Can be overridden for individual components by specifying the imagePullPolicy variable there. Possible values: - Always - IfNotPresent - Never |
| ingress | object | (see details below) | Values to influence the ingresses |
| ingress.clusterIssuer | string | `"letsencrypt-prod"` | The cluster issuer to use |
| ingress.instanceName | string | `"theia-cloud-demo-ws-ingress"` | The name of the ingress which will be updated to publish new theia application. If this is not existing it will be created. You may chose to set the ingress up yourself and point theia.cloud to the ingress via the name |
| ingress.proxyBodySize | string | `"1m"` | Sets the maximum allowed size of the client request body inside the application (e.g. file uploads in Theia). Defaults to 1m. Setting size to 0 disables checking of client request body size. |
| ingress.theiaCloudCommonName | bool | `false` | When set to true the cert-manager.io/common-name annotation will be set. This is only required when the issued certificate by the cert-manager misses a common-name |
| issuer | object | (see details below) | Values related to certificates/Cert-manager |
| issuer.email | string | `"mmorlock@example.com"` | EMail address of the certificate issuer. |
| issuerprod.name | string | `"letsencrypt-prod"` |  |
| issuerstaging.name | string | `"theia-cloud-selfsigned-issuer"` |  |
| keycloak | object | (see details below) | Values related to Keycloak |
| keycloak.authUrl | string | `"https://keycloak.url/auth/"` | Key cloak auth URL. Only has to be specified when enable: true |
| keycloak.clientId | string | `"theia-cloud"` | The client-id. Only has to be specified when enable: true |
| keycloak.clientSecret | string | `"publicbutoauth2proxywantsasecret"` | The oaid client secret. In case you configure your keycloak client as confidential, then you may specifiy the secret here. If you stick with our default public client, you may leave below value. For public clients keycloak does not generate a client-secret, but in order to make oath2-proxy happy, we will pass a value |
| keycloak.cookieSecret | string | `"OQINaROshtE9TcZkNAm5Zs2Pv3xaWytBmc5W7sPX7ws="` | The cookie secret. This should not be public! Only has to be specified when enable: true See https://oauth2-proxy.github.io/oauth2-proxy/docs/configuration/overview/#generating-a-cookie-secret for how to generate a strong cookie secret. |
| keycloak.enable | bool | `false` | Whether keycloak authentication shall be used |
| keycloak.realm | string | `"TheiaCloud"` | The Keycloak Realm. Only has to be specified when enable: true |
| landingPage | object | (see details below) | Values related to the landing page |
| landingPage.additionalApps | string | `nil` | The page may show these additional apps in a drop down. This is a map. The key maps to the app definition name The value is the label that is supposed to be shown in the UI  Example:  different-app-definition:   label: "Different App Definition" further-app-definition:   label: "Further App Definition" |
| landingPage.appDefinition | string | `"theia-cloud-demo"` | the app id to launch |
| landingPage.ephemeralStorage | bool | `true` | If set to true no persisted storage is used when creating sessions on the landing page. Set to false if you want to use persisted storage. |
| landingPage.image | string | `"theiacloud/theia-cloud-landing-page:0.8.1.MS2"` | the landing page image to use |
| landingPage.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the landing page's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| landingPage.imagePullSecret | string | `nil` | Optional: the image pull secret |
| monitor | object | (see details below) | Values to influence the monitor |
| monitor.activityTracker | object | (see details below) | Values to influence the activityTracker module |
| monitor.activityTracker.enable | bool | `true` | Should the activityTracker module be enabled |
| monitor.activityTracker.interval | int | `1` | Minutes between re-ping by the operator |
| monitor.activityTracker.notifyAfter | int | `25` | Minutes of inactivity that lead to a warning displayed to the user Make greater than timeoutAfter to disable |
| monitor.activityTracker.timeoutAfter | int | `30` | Minutes of inactivity that lead to pod shutdown |
| monitor.enable | bool | `true` | Should the monitor be enabled |
| monitor.port | int | `3000` | At which port the monitor extension is available Choose the same as the application port for the theia extension |
| operator | object | (see details below) | Values related to the operator |
| operator.bandwidthLimiter | string | `"K8SANNOTATION"` | Whether Theia Cloud shall limit network speed. This might not be fully supported on all cloud provider/in all clusters. Possible values: - K8SANNOTATION                   Set via kubernetes annotations (kubernetes.io/egress-bandwidth and kubernetes.io/ingress-bandwidth) - WONDERSHAPER                    Set via wondershaper init container - K8SANNOTATIONANDWONDERSHAPER    Set Kubernetes annotations and use wondershaper init container |
| operator.cloudProvider | string | `"K8S"` | Select your cloud provider. Possible values: - K8S      Plain Kubernetes - MINIKUBE Local deployment on Minikube |
| operator.continueOnException | bool | `false` | Whether the operator should stop in cases where an exception is not handled |
| operator.eagerStart | bool | `false` | Whether theia applications shall be started eager. This means that the application is already running without a user. When a user requests a new session, one of the already launched ones is assigned.  Currently only false is fully supported. |
| operator.image | string | `"theiacloud/theia-cloud-operator:0.8.1.MS2v2"` | The operator image |
| operator.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the operator's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| operator.imagePullSecret | string | `nil` | Optional: the image pull secret |
| operator.leaderElection | object | (see details below) | Options to influence the operator's leader election |
| operator.logging | object | (see details below) | Allows to override the operator's log4j configuration |
| operator.maxWatchIdleTime | string | `"3600000"` | Configures the timeout in milliseconds when a watcher for either AppDefinitions, Workspaces, or Sessions is assumed to be not working. When this is detected the operator instance will stop and a new operator will set up fresh watchers. |
| operator.replicas | int | `2` | Number of operator instances to create |
| operator.requestedStorage | string | `"250Mi"` | The amount of requested storage for each persistent volume claim (PVC) for workspaces. This is directly passed to created PVCs and must be a valid Kubernetes quantity. See https://kubernetes.io/docs/reference/kubernetes-api/common-definitions/quantity/ |
| operator.sessionsPerUser | string | `"1"` | Set the number of active sessions a single user can launch |
| operator.storageClassName | string | `"default"` | The name of the storage class for persistent volume claims for workspaces. This storage class must be present on the cluster. Most cloud providers offer a default storage class without additional configuration. |
| operator.wondershaperImage | string | `"theiacloud/theia-cloud-wondershaper:0.8.1.MS2"` | If bandwidthLimiter is set to WONDERSHAPER or K8SANNOTATIONANDWONDERSHAPER this image will be used for the wondershaper init container |
| operatorrole.name | string | `"operator-api-access"` |  |
| service | object | (see details below) | Values of the Theia.cloud REST service |
| service.image | string | `"theiacloud/theia-cloud-service:0.8.1.MS2"` | The image to use |
| service.imagePullPolicy | string | `nil` | Optional: Override the imagePullPolicy for the service's docker image. If this is omitted or empty, the root at .Values.imagePullPolicy is used. |
| service.imagePullSecret | string | `nil` | Optional: the image pull secret |
| servicerole.name | string | `"service-api-access"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.11.0](https://github.com/norwoodj/helm-docs/releases/v1.11.0)
