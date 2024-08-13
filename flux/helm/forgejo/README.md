# Forgejo

## Extra Configuration

To allow SSH Ingress, add the following config here: `/var/lib/rancher/k3s/server/manifests/traefik-ssh.yaml`
Might have to manually apply afterwards.

```yaml
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
  name: traefik
  namespace: kube-system
spec:
  valuesContent: |-
    ports:
      ssh:
        port: 2222
        expose: true
        exposedPort: 2222
```
