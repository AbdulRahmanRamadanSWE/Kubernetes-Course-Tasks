# Testing and Validation

## 1. Cluster Validation

Command:
kubectl get nodes -o wide

Expected:
- Three nodes in Ready state.

## 2. Pod Validation

Command:
kubectl get pods -n mlops-task -o wide

Expected:
- Three application Pods.
- Two running containers per Pod.
- Pods distributed across three nodes.

## 3. Service Validation

Command:
kubectl get svc -n mlops-task

Expected:
- Service type: NodePort.
- Service port: 80.
- NodePort: 30080.

## 4. HTTP Validation

Command:
curl -v http://localhost:8080/

Expected:
- HTTP 200 OK.
- HTML response with application heading and UTC timestamp.

## 5. Timestamp Validation

Command:
for i in 1 2 3; do
  curl -s http://localhost:8080/ | grep -A1 "Current UTC Timestamp"
  sleep 6
done

Expected:
- Three different timestamps.
- Timestamp updates every five seconds.

## 6. Init Container Failure Test

A separate Pod was created with an Init Container that intentionally exits with status code 1.

Expected:
- Pod enters Init:CrashLoopBackOff.
- Main application container does not start.

## 7. Deployment Rollout

Command:
kubectl rollout status deployment/hello-deployment -n mlops-task

Expected:
- Deployment successfully rolled out.
