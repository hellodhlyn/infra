# Tailscale Operator
## Installation

Read the [official documentation](https://tailscale.com/kb/1236/kubernetes-operator) for more details.

```bash
# Add Tailscale Helm repository
helm repo add tailscale https://pkgs.tailscale.com/helmcharts
helm repo update

# Install Tailscale Operator
helm upgrade --install tailscale-operator tailscale/tailscale-operator \
  --namespace tailscale \
  --kubeconfig ../kubeconfig \
  --set-string oauth.clientId="OAUTH_CLIENT_ID" \
  --set-string oauth.clientSecret="OAUTH_CLIENT_SECRET" \
  --wait
```
