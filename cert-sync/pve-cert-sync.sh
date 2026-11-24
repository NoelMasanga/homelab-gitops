#!/bin/bash
# Keep the Proxmox web UI certificate in sync with cert-manager's pve-tls secret.
set -u
CERT=$(/usr/sbin/pct exec 111 -- sh -c 'KUBECONFIG=/etc/rancher/k3s/k3s.yaml /usr/local/bin/kubectl -n cert-manager get secret pve-tls -o jsonpath="{.data.tls\.crt}"' 2>/dev/null | base64 -d 2>/dev/null)
KEY=$(/usr/sbin/pct exec 111 -- sh -c 'KUBECONFIG=/etc/rancher/k3s/k3s.yaml /usr/local/bin/kubectl -n cert-manager get secret pve-tls -o jsonpath="{.data.tls\.key}"' 2>/dev/null | base64 -d 2>/dev/null)

[ -n "${CERT:-}" ] && [ -n "${KEY:-}" ] || { echo "cert fetch failed"; exit 1; }

CURRENT=$(sha256sum /etc/pve/local/pveproxy-ssl.pem 2>/dev/null | cut -d' ' -f1)
NEW=$(printf '%s' "$CERT" | sha256sum | cut -d' ' -f1)

if [ "$CURRENT" = "$NEW" ]; then
  echo "unchanged"
  exit 0
fi

printf '%s' "$CERT" > /etc/pve/local/pveproxy-ssl.pem
printf '%s' "$KEY"  > /etc/pve/local/pveproxy-ssl.key
chown root:www-data /etc/pve/local/pveproxy-ssl.key
chmod 640 /etc/pve/local/pveproxy-ssl.key
systemctl restart pveproxy
echo "certificate updated and pveproxy restarted"
