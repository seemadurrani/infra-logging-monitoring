#!/bin/bash

# Variables - Replace these with your actual keys
DATADOG_API_KEY="YOUR_DATADOG_API_KEY"
DATADOG_APP_KEY="YOUR_DATADOG_APP_KEY"
NAMESPACE="datadog"

# Check for required commands
command -v helm >/dev/null 2>&1 || { echo >&2 "Helm is required but not installed. Aborting."; exit 1; }
command -v kubectl >/dev/null 2>&1 || { echo >&2 "kubectl is required but not installed. Aborting."; exit 1; }

# Add Datadog Helm repository
helm repo add datadog https://helm.datadoghq.com
helm repo update

# Create Datadog secret
kubectl create namespace $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic datadog-secret \
  --from-literal=api-key=$DATADOG_API_KEY \
  --from-literal=app-key=$DATADOG_APP_KEY \
  -n $NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Create a values.yaml file for customization
cat <<EOF > values.yaml
datadog:
  apiKeyExistingSecret: datadog-secret
  appKeyExistingSecret: datadog-secret

  # Kubernetes-specific settings
  kubeStateMetricsEnabled: true
  clusterAgent:
    enabled: true
    metricsProvider:
      enabled: true

  # Log collection
  logs:
    enabled: true
    containerCollectAll: true

  # EKS/Azure Support
  eks:
    enabled: true
EOF

# Install Datadog agent using Helm
helm install datadog-agent datadog/datadog \
  --values values.yaml \
  --namespace $NAMESPACE --create-namespace

# Verify installation
kubectl get pods -n $NAMESPACE
