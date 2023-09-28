# theia-cloud-crds

As long as the private-key-secret is not deleted the certificate and the ca bundle will stay the same.

Right now:

1. build `webhook:local`
2. apply the helm chart
3. get the ca bundle from the secret
4. put it in the crd
5. reapply
