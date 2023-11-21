# Theia Cloud Helm Charts

This repository contains the helm charts for Theia Cloud.

There are three charts:

* `theia-cloud-base` installs cluster wide resources that may be used by multiple Theia Cloud installations
* `theia-cloud-crds` installs the custom resource definitions
* `theia-cloud` installs Theia Cloud itself and depends on `theia-cloud-base` and `theia-cloud-cds`

## Versioning

The chart `version` should get updated on every change/commit/PR.\
However only changed charts should get an increased version, e.g. when a commit changes the theia-cloud chart, only this chart version has to be increased.\
See below for more information:

```yaml
# Releases
# follow semantic versioning (starting with release 0.9.0)
version: 1.0.0

# Pre-Releases
# append -next.X to the next version. X should be increased on every change/commit/PR
version: 1.0.0-next.0
version: 1.0.0-next.1
```

The `appVersion` is pointing to the `<version>-next` tag this means that the images consumed are bound to change, when a new pre-release of that component is published.

Therefore, you should only use full releases for deployments, as the next tag might change at any time.
If you still want to use a next version you should pin the used images to a specific version (`<version>-next.<commitSHA>`).

### Release a new version

New release every three months.

Provide a commit where the next parts are removed from the `version` and the `appVersion` fields of ALL charts.
Also set the images used in charts to the version of the release.
The release should be done after the main repository provided a release and the docker images were pushed.

With next change after a release needs the version number should be bumped and `-next.0/-next` should be added to the version/appVersion fields.
Furthermore, the new version, together with a release estimation date, should be added to the changelog.

## How to generate Chart READMEs

```bash
docker run --rm --volume "$(pwd)/charts:/helm-docs" -u $(id -u) jnorwood/helm-docs:latest
```
