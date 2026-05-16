# Keycloak Sizing Calculator

**Red Hat Build of Keycloak v26.x** — full-stack infrastructure sizing tool.

🔗 **[Open the tool](https://YOUR_USERNAME.github.io/keycloak-sizing/)**

## What it sizes

| Tier | Tool |
|---|---|
| **Keycloak** | CPU request/limit, memory request/limit, JVM heap, DB pool, HTTP threads |
| **Infinispan / Data Grid** | Pods, CPU, memory, heap, concurrent session capacity |
| **PostgreSQL** | vCPU, RAM, storage, IOPS, `shared_buffers`, `effective_cache_size`, `work_mem` |

## Two input modes

**⚡ Quick Estimate** — enter just 4 numbers (users, applications, RPS, TPS). All assumptions are visible and editable.

**🔬 Detailed Mode** — full slider control over every workload parameter (logins/sec, grants/sec, refresh/sec, pods, sessions, etc.).

## Generated outputs

- Kubernetes Deployment YAML
- Keycloak Operator CR (`k8s.keycloak.org/v2alpha1`)
- Infinispan Operator CR (`infinispan.org/v1`) + Cache CRs
- CloudNativePG Cluster CR (`postgresql.cnpg.io/v1`)
- JVM flags (Keycloak + Data Grid)
- HPA + PodDisruptionBudget
- Presentation-ready summary (Print / Save PDF + Copy as text)

## Offline use

The tool is a **single self-contained HTML file** — copy `index.html` anywhere and open it. No server required. No data is sent anywhere.

## Sizing basis

All formulas from the [official Keycloak sizing guide](https://www.keycloak.org/high-availability/multi-cluster/concepts-memory-and-cpu-sizing) and [Keycloak Benchmark v26.4](https://www.keycloak.org/2025/10/keycloak-benchmark). Reference architecture: OpenShift 4.18 (ROSA) · Aurora PostgreSQL multi-AZ · OpenJDK 21 · Argon2id 5 iterations · 1M users / 20K clients.

Always validate with your own load tests before production.

---

*Red Hat, OpenShift, and Keycloak are trademarks of Red Hat, Inc.*
