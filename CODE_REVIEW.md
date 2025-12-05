# Kubernetes Code Review

This document provides a review of the Kubernetes configuration in this repository. The review is focused on security, reliability, and best practices.

## Security

### 1. Vault Initialization Keys in Git

**Summary:** The `kube-system/vault/init-keys.json` file, which likely contains the root keys for the Vault instance, is stored in this Git repository. This is a critical security vulnerability. If this repository were to be compromised, the attacker would have full control over the Vault instance.

**Recommendation:** Immediately remove the `init-keys.json` file from the repository's history. These keys should be stored in a secure location, such as a hardware security module (HSM) or a secure secret store.

### 2. Privileged Namespace for MetalLB

**Summary:** The `metallb-system` namespace is labeled to enforce a `privileged` pod security standard. This is a significant security risk and should be avoided. While the speaker pods need some elevated permissions, the entire namespace should not be privileged.

**Recommendation:** Remove the `pod-security.kubernetes.io/enforce: privileged` label from the `metallb-system` namespace. Instead, use a more restrictive Pod Security Standard, and grant the necessary permissions to the speaker pods using a dedicated service account and role.

### 3. Hardcoded CA Bundle in MetalLB CRDs

**Summary:** The MetalLB CRD definitions in `k8s/metallb/metallb-native.yaml` have a hardcoded `caBundle`. This makes certificate rotation difficult and is not a recommended practice.

**Recommendation:** The `caBundle` should be managed by a tool like cert-manager. This can be done by using the `cert-manager.io/inject-ca-from` annotation on the CRD's `conversion.webhook.clientConfig`.

## Reliability

### 1. Missing Resource Requests and Limits

**Summary:** The Prometheus and Velero deployments do not have resource requests or limits specified for their pods. This can lead to resource contention and instability in the cluster. If a pod starts consuming too many resources, it can affect other pods on the same node.

**Recommendation:** Set appropriate resource requests and limits for the Prometheus and Velero pods. This will help to ensure that they have the resources they need to run reliably, and will prevent them from consuming too many resources and affecting other pods.

### 2. No Pod Disruption Budget for Velero

**Summary:** The Velero deployment does not have a Pod Disruption Budget (PDB) configured. A PDB would ensure that the Velero deployment is not disrupted during voluntary disruptions, such as node maintenance.

**Recommendation:** Create a Pod Disruption Budget for the Velero deployment. This will ensure that at least one Velero pod is running at all times, which is critical for maintaining the ability to back up and restore the cluster.

### 3. Velero Snapshots Disabled

**Summary:** In the Velero configuration, `snapshotsEnabled` is set to `false`. While this may be an intentional choice, it's worth noting that volume snapshots are a powerful feature for backing up stateful applications.

**Recommendation:** If you are running stateful applications in your cluster, consider enabling snapshots in Velero. This will allow you to take application-consistent backups of your data.

## Best Practices

### 1. Complex Traefik Configuration

**Summary:** The Traefik configuration in `kube-system/ingress/traefik/base` is split across many files, which can make it difficult to understand and maintain.

**Recommendation:** Consider consolidating some of the Traefik resources to improve readability. For example, you could combine the dashboard-related resources into a single file.

### 2. Unused Files

**Summary:** The repository contains a number of unused files, such as `k8s/apps/nr-k8s.yaml` and `k8s/apps/snmp-exporter.yaml`.

**Recommendation:** Remove any unused files from the repository to keep it clean and organized.
