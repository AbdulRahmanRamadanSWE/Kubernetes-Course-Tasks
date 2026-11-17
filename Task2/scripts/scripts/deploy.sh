
#!/usr/bin/env bash
set -Eeuo pipefail

PROFILE="guestbook"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

KUBECTL=(minikube -p "$PROFILE" kubectl --)

echo "Checking MySQL Secret..."

if ! "${KUBECTL[@]}" get secret mysql-secret -n default >/dev/null 2>&1; then
    echo "ERROR: mysql-secret does not exist."
    echo "Create the Secret before deployment."
    exit 1
fi

echo "Enabling NGINX Ingress..."

minikube -p "$PROFILE" addons enable ingress

echo "Deploying Kubernetes resources..."

"${KUBECTL[@]}" apply -f k8s/mysql-pv.yaml
"${KUBECTL[@]}" apply -f k8s/mysql-pvc.yaml
"${KUBECTL[@]}" apply -f k8s/webapp-config.yaml

"${KUBECTL[@]}" apply -f k8s/mysql-service.yaml
"${KUBECTL[@]}" apply -f k8s/mysql-deployment.yaml

"${KUBECTL[@]}" apply -f k8s/webapp-service.yaml
"${KUBECTL[@]}" apply -f k8s/webapp-deployment.yaml
"${KUBECTL[@]}" apply -f k8s/webapp-ingress.yaml

echo "Deployment resources applied successfully."
