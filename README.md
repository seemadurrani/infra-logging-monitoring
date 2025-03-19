# Datadog Agent Installation Script for Kubernetes

This repository contains a Bash script to automate the installation of the Datadog agent on your Kubernetes cluster using Helm.

## Prerequisites
Ensure you have the following tools installed:
- **Helm** (v3 or later)
- **kubectl** (configured for your Kubernetes cluster)

## Installation Steps

1. **Clone the Repository**
```bash
git clone <repository-url>
cd <repository-folder>
```

2. **Set Your Datadog API and APP Keys**
In the `install-datadog.sh` file, replace the placeholders with your actual keys:
```bash
DATADOG_API_KEY="YOUR_DATADOG_API_KEY"
DATADOG_APP_KEY="YOUR_DATADOG_APP_KEY"
```

3. **Run the Installation Script**
```bash
chmod +x install-datadog.sh
./install-datadog.sh
```

4. **Verify Installation**
Run the following command to confirm the Datadog agent pods are running:
```bash
kubectl get pods -n datadog
```

## Configuration
The script creates a `values.yaml` file with the following features enabled:
- **Kubernetes Metrics** via `kube-state-metrics`
- **Cluster Agent** with metrics provider enabled
- **Log Collection** with `containerCollectAll: true`
- **EKS Support** (enabled by default)

For additional configurations, modify the `values.yaml` file accordingly.

## Uninstallation
To remove the Datadog agent from your cluster, run:
```bash
helm uninstall datadog-agent -n datadog
kubectl delete namespace datadog
```

## Troubleshooting
If you encounter issues:
- Ensure your Helm and kubectl versions are up to date.
- Verify the namespace and secrets are correctly created.
- Check Datadog logs using:
```bash
kubectl logs -n datadog <datadog-agent-pod-name>
```

## License
This project is licensed under the [MIT License](LICENSE).

