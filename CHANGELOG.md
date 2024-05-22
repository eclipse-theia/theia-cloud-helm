# Changelog

## [0.11.0] - estimated 2024-07

- [theia-cloud-crds] Add option field to CRDs and increase version to `Session.v1beta8`, `Workspace.v1beta5` and `AppDefinition.v1beta10` [#55](https://github.com/eclipsesource/theia-cloud-helm/pull/55) | [#293](https://github.com/eclipsesource/theia-cloud/pull/293)
- [theia-cloud] Add configurable image preloading [#56](https://github.com/eclipsesource/theia-cloud-helm/pull/56)
- [theia-cloud] Add landing page configuration options for logo file extension, loading text, user info title & text [#58](https://github.com/eclipsesource/theia-cloud-helm/pull/58) - contributed on behalf of STMicroelectronics

## [0.10.0] - 2024-04-02

- [theia-cloud-crds] Provide conversion webhook for newer versions of CRDs [#49](https://github.com/eclipsesource/theia-cloud-helm/pull/49) | [#283](https://github.com/eclipsesource/theia-cloud/pull/283) - contributed on behalf of STMicroelectronics
  - This webhook is called, whenever a resource is requested in a specific version
  - This is enabled from these versions: `AppDefintion.v1beta8`, `Session.v1beta6` and `Workspace.v1beta3`
  - Older versions are deprecated and no longer in the definition
- [theia-cloud-crds] Move status like fields to status [#](https://github.com/eclipsesource/theia-cloud-helm/pull/49) | [#283](https://github.com/eclipsesource/theia-cloud/pull/283) - contributed on behalf of STMicroelectronics
  - `Session.v1beta7`: Move `url`, `lastActivity` and `error` fields from the spec to the status.
  - `Workspace.v1beta4`: Move the `error` field from the spec to the status. Also add the `error` field to `Workspace.v1beta3` as it was missing
- [theia-cloud-crds] Remove `timeout.strategy` from AppDefinition [#](https://github.com/eclipsesource/theia-cloud-helm/pull/49) | [#283](https://github.com/eclipsesource/theia-cloud/pull/283) - contributed on behalf of STMicroelectronics
  - `AppDefinition.v1beta9`: Removed `timeout.strategy` and `timeout.limit` is now just `timeout`. This was done, as there is only one Strategy left.
- [theia-cloud-crds] Provide shortnames for AppDefinition (appdef, ad) and Workspaces (ws) [#52](https://github.com/eclipsesource/theia-cloud-helm/pull/52) | [#289](https://github.com/eclipsesource/theia-cloud/pull/289) - contributed on behalf of STMicroelectronics
- [theia-cloud] Make demo application optional (`demoApplication.install`) and group relevant fields together [#52](https://github.com/eclipsesource/theia-cloud-helm/pull/52) | [#289](https://github.com/eclipsesource/theia-cloud/pull/289) - contributed on behalf of STMicroelectronics
  - `image` -> `demoApplication`
  - `monitor.port` -> `demoApplication.monitor.port`
  - `monitor.activityTracker.timeoutAfter` -> `demoApplication.monitor.activityTracker.timeoutAfter`
  - `monitor.activityTracker.notifyAfter` -> `demoApplication.monitor.activityTracker.notifyAfter`

## [0.9.0] - 2024-01-23

- [All charts] Align [versioning](https://github.com/eclipsesource/theia-cloud-helm#versioning) between all components and introduce changelog [#45](https://github.com/eclipsesource/theia-cloud-helm/pull/45) | [#258](https://github.com/eclipsesource/theia-cloud/pull/258) - contributed on behalf of STMicroelectronics
- [All charts] Change CRD versions from `vXbeta` to `v1betaX` and only keep latest two versions [#46](https://github.com/eclipsesource/theia-cloud-helm/pull/46) | [#266](https://github.com/eclipsesource/theia-cloud/pull/266) - contributed on behalf of STMicroelectronics

## [0.8.1] - 2023-10-01

- Last Milestone based version. No changelog available due to alpha-phase.
