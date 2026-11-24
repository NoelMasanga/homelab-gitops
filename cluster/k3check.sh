#!/bin/bash
# k3s cluster probe (run INSIDE k3s-01 LXC)
K=/usr/local/bin/kubectl
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
echo "=== kubectl ==="; $K version 2>/dev/null | grep -E "Client|Server" 
echo "=== nodes ==="; $K get nodes -o wide 2>&1 | head
echo "=== kube-system svc ==="; $K get svc -n kube-system 2>/dev/null | grep -E "NAME|svclb|traefik"
echo "=== outbound test ==="; curl -s -o /dev/null -w "github-https:%{http_code}\n" --connect-timeout 6 https://raw.githubusercontent.com 2>&1 || echo "no-outbound-github"
