#!/bin/bash

# Directory where CRDs will be downloaded
TEMP_DIR=$(mktemp -d)
TEMP_DIR="./manifests/setup"
echo "Creating directory: $TEMP_DIR"

# Check if directory exists, if not create it
if [ ! -d "$TEMP_DIR" ]; then
    echo "Directory $TEMP_DIR does not exist. Creating it..."
    mkdir -p "$TEMP_DIR"
    echo "Directory created successfully."
else
    echo "Directory $TEMP_DIR already exists."
fi

# Clean up namespace if it exists
if kubectl get namespace monitoring &> /dev/null; then
    echo "Namespace 'monitoring' exists. Deleting it..."
    kubectl delete namespace monitoring
    echo "Waiting for namespace deletion..."
    while kubectl get namespace monitoring &> /dev/null; do
        sleep 2
    done
    echo "Namespace deleted successfully"
fi

# Download CRDs
echo "Downloading CRDs..."
curl -L -o "$TEMP_DIR/prometheuses.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
curl -L -o "$TEMP_DIR/alertmanagers.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
curl -L -o "$TEMP_DIR/servicemonitors.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
curl -L -o "$TEMP_DIR/podmonitors.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
curl -L -o "$TEMP_DIR/prometheusrules.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
curl -L -o "$TEMP_DIR/alertmanagerconfigs.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagerconfigs.yaml
curl -L -o "$TEMP_DIR/probes.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_probes.yaml
curl -L -o "$TEMP_DIR/thanosrulers.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml
curl -L -o "$TEMP_DIR/scrapeconfigs.yaml" https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/main/example/prometheus-operator-crd/monitoring.coreos.com_scrapeconfigs.yaml

# Create namespace
echo "Creating monitoring namespace..."
kubectl create namespace monitoring

# # Apply CRDs using server-side apply
# echo "Applying CRDs..."
# for file in "$TEMP_DIR"/*.yaml; do
#     echo "Applying $file"
#     kubectl apply --server-side -f "$file"
# done

# # Wait for CRDs to be established
# echo "Waiting for CRDs to be established..."
# kubectl wait \
#     --for condition=Established \
#     --all CustomResourceDefinition \
#     --namespace=monitoring

# echo "Clean up temporary directory..."
# rm -rf "$TEMP_DIR"

# echo "CRDs installation completed!"
