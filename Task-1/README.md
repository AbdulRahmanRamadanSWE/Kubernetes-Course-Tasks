# Kubernetes Task 1 – Dynamic Timestamp Application

A multi-container Kubernetes application deployed on a three-node Minikube cluster.

The application uses Nginx as a reverse proxy and a Python sidecar container to serve a dynamic HTML page containing a UTC timestamp updated every five seconds.

## Architecture

The cluster consists of:

- 1 control-plane node
- 2 worker nodes
- 3 application replicas
- 2 containers per application Pod
- 1 Init Container per Pod
- 1 NodePort Service

### Application Components

| Component | Responsibility |
|---|---|
| Nginx | Receives HTTP requests and forwards them to the sidecar |
| Time Updater | Generates and serves the dynamic timestamp page |
| Init Container | Performs initialization before application containers start |
| Kubernetes Service | Exposes the application through NodePort |

## Request Flow

1. Client sends an HTTP request.
2. Kubernetes Service routes the request to an application Pod.
3. Nginx receives the request on port 80.
4. Nginx forwards the request to the Python sidecar on port 8080.
5. The sidecar returns an HTML page containing the latest UTC timestamp.

## Project Structure

```text
Task-1/
├── k8s/
│   └── deployment.yaml
├── docs/
│   ├── architecture.md
│   └── testing.md
├── screenshots/
└── README.md
```

## Prerequisites

- Kubernetes cluster
- kubectl
- Minikube
- Three available cluster nodes

## Deployment

```bash
kubectl apply -f k8s/deployment.yaml
kubectl get nodes -o wide
kubectl get pods -n mlops-task -o wide
kubectl get svc -n mlops-task
```

## Accessing the Application

Start port forwarding:

```bash
kubectl port-forward -n mlops-task svc/hello-service 8080:80
```

In another terminal:

```bash
curl http://localhost:8080/
```

## Testing

- Three-node cluster readiness.
- Three application replicas running.
- Distribution of Pods across three nodes.
- HTTP response validation (200 OK).
- Timestamp update validation at five-second intervals.
- Init Container failure scenario.
- Deployment rollout validation.

See [Testing Documentation](docs/testing.md).

## Architecture Documentation

See [Architecture Documentation](docs/architecture.md).

## Design Constraints

- No Kubernetes Volumes.
- No shared process namespace.
- Nginx and the timestamp server run in separate containers.
- Communication between Nginx and the sidecar uses localhost.
- Timestamp generation interval is five seconds.

## Cleanup

```bash
kubectl delete -f k8s/deployment.yaml
```

## Author

Kubernetes Course Task – MLOps MENA Community
