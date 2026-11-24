# Homelab GitOps

GitOps-managed Kubernetes demonstrating platform engineering, observability, and security operations.

## Overview
- **Cluster:** K3s (single control-plane HA-embedded-etcd layout)
- **GitOps:** ArgoCD for declarative, versioned app delivery
- **Networking/LB:** in-cluster Service LB (Klipper) — validated because MetalLB layer-2 ARP does not work inside unprivileged containers on this hypervisor
- **TLS:** cert-manager + internal CA with automated expiry sync
- **Observability:** Wazuh SIEM (fleet-wide agents), Beszel monitoring, Loki/Promtail/Grafana
- **Mesh/access:** Tailscale zero-trust, key-only SSH

## Repo layout (sanitized)
- `apps/` — ArgoCD Application manifests
- `manifests/` — declarative workloads & services
- `cluster/` — cluster bootstrap/init
- `docs/` — topology, hardening, DR notes

> Security: public-facing **sanitized** export — secrets, tokens, keys, certs and internal IP detail removed. See `SANITIZE.md`.

## Tech
K3s · ArgoCD · cert-manager · Wazuh · Beszel · Tailscale · Docker

---
© Noel Masanga — shared for demonstration of skills. Reach me at noel@quescom.co.zw
