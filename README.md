# Theia Cloud Helm Charts

This repository contains the helm charts for Theia Cloud.

There are three charts:

* `theia-cloud-base` installs cluster wide resources that may be used by multiple Theia Cloud installations
* `theia-cloud-crds` installs the custom resource definitions
* `theia-cloud` installs Theia Cloud itself and depends on `theia-cloud-base` and `theia-cloud-cds`

## Versioning

`appVersion` will be updated to the used docker-image tag in all cases.

The chart `version` should get updated on every change/commit/PR.\
However only changed charts should get an increased version, e.g. when a commit changes the theia-cloud chart, only this chart version has to be increased.\
See below for more information:

```yaml
# Releases
# follow semantic versioning (starting with release 1.0.0)
version: 1.0.0

# Pre-Releases
# append -v<number> to the next version. Number should be increased on every change/commit/PR
version: 1.0.0-v001
version: 1.0.0-v002
# for special pre-releases, like milestone or release candidates will, please append further information at the end
version: 1.0.0-v003-MS1
version: 1.0.0-v004
version: 1.0.0-v005-MS2
version: 1.0.0-v006-RC1
```

## How to generate Chart READMEs

```bash
docker run --rm --volume "$(pwd)/charts:/helm-docs" -u $(id -u) jnorwood/helm-docs:latest
```
