#!/bin/bash

# Set Namespace
NAMESPACE=monitoring

# Create Namespace if it doesn't exist
kubectl get namespace $NAMESPACE &>/dev/null || kubectl create namespace $NAMESPACE

# Add Helm Repo
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Grafana
helm install grafana grafana/grafana \
  --namespace $NAMESPACE \
  --set service.type=NodePort

# Verify Installation
kubectl get pods -n $NAMESPACE
