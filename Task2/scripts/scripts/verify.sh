
#!/usr/bin/env bash
set -Eeuo pipefail

PROFILE="guestbook"
KUBECTL=(minikube -p "$PROFILE" kubectl --)

echo "========== CLUSTER NODES =========="
"${KUBECTL[@]}" get nodes -o wide

echo
echo "========== APPLICATION PODS =========="
"${KUBECTL[@]}" get pods -n default -o wide

echo
echo "========== PERSISTENT VOLUME =========="
"${KUBECTL[@]}" get pv

echo
echo "========== PERSISTENT VOLUME CLAIM =========="
"${KUBECTL[@]}" get pvc -n default

echo
echo "========== SERVICES =========="
"${KUBECTL[@]}" get services -n default

echo
echo "========== INGRESS =========="
"${KUBECTL[@]}" get ingress -n default

echo
echo "========== VERIFICATION COMPLETED =========="
