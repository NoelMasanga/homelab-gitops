#!/bin/bash
# Install MetalLB (native manifests) on the k3s cluster + IP pool + L2 adv.
K=/usr/local/bin/kubectl
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
set -e
echo "== apply MetalLB v0.17.0 manifests =="
curl -fsSL https://raw.githubusercontent.com/metallb/metallb/v0.17.0/config/manifests/metallb-native.yaml | $K apply -f -
echo "== create IPAddressPool + L2Advertisement =="
$K apply -f - <<'EOF'
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: homelab-pool
  namespace: metallb-system
spec:
  addresses:
    - 172.16.0.220-172.16.0.229
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: homelab-l2
  namespace: metallb-system
spec:
  ipAddressPools:
    - homelab-pool
EOF
echo "== wait for controller+speaker =="
$K -n metallb-system rollout status deploy/controller --timeout=120s 2>&1 | tail -1
echo "== pods =="
$K -n metallb-system get pods -o wide 2>&1 | tail -6
