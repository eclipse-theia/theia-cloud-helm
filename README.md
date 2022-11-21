## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

    helm repo add theia-cloud-remote https://github.eclipsesource.com/theia-cloud-helm

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
theia-cloud-remote` to see the charts.

To install the theia-cloud chart:

    helm install my-theia-cloud theia-cloud-remote/theia-cloud

To uninstall the chart:

    helm delete my-theia-cloud
