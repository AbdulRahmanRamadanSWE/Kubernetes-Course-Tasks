
#!/usr/bin/env bash
set -Eeuo pipefail

PROFILE="guestbook"
IMAGE="guestbook-api:v1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
APP_DIR="$PROJECT_DIR/app"

echo "Building Docker image..."

minikube -p "$PROFILE" image build \
    -t "$IMAGE" \
    "$APP_DIR"

echo "Image built successfully: $IMAGE"

