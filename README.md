# Kubernetes Monitoring Stack

## Overview
This repository contains a Helm umbrella chart for deploying a comprehensive monitoring solution using Prometheus and Grafana, along with supporting components.

## Components

### Prometheus
- Time-series database for metrics collection and storage
- Configured with 15-day retention period
- Resource limits: 200m CPU, 512Mi memory
- Persistent storage: 10Gi using local-path StorageClass
- Includes ServiceMonitor configuration for auto-discovery

### Grafana
- Metrics visualization platform
- Default credentials: admin/admin
- Persistent storage: 10Gi using local-path StorageClass
- Installed plugins:
  - grafana-piechart-panel
  - grafana-clock-panel
- Accessible via Ingress (grafana.local)

### Prometheus Operator
- Manages Prometheus instances
- Handles CRD management
- Includes admission webhooks with cert-manager integration
- Configures ServiceMonitor auto-discovery

### Node Exporter
- Collects hardware and OS metrics
- Port: 9100
- Disabled host network to avoid port conflicts

### Kube State Metrics
- Collects Kubernetes cluster metrics
- Monitors pods, nodes, deployments, etc.
- RBAC configured for cluster-wide access
- Ports: 8080 (metrics), 8081 (telemetry)

### Kafka Monitoring
- Includes ServiceMonitor for Kafka metrics
- Configured lag threshold: 5000
- Scrape interval: 60s
- Namespace: kafka-dev

## Installation

```bash
# Add Prometheus repository
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install the chart
helm install prometheus ./umbrella_prometheus -n monitoring --create-namespace

# Access Grafana
kubectl port-forward svc/prometheus-monitoring-grafana -n monitoring 3000:80 &

# Access prometheus
kubectl port-forward svc/prometheus-monitoring-kube-prometheus -n monitoring 9090:9090 &

# Passwords for the first login: 
admin/admin 
```

Grafana will be available at: http://localhost:3000


## Requirements
- Kubernetes cluster
- Helm v3
- cert-manager (for webhook certificates)
- local-path StorageClass