#!/bin/bash

# Set Namespace
NAMESPACE=monitoring

# Create Namespace if it doesn't exist
kubectl get namespace $NAMESPACE &>/dev/null || kubectl create namespace $NAMESPACE

# Add Helm Repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace $NAMESPACE \
  --set prometheus.service.type=NodePort

# Verify Installation
kubectl get pods -n $NAMESPACE
