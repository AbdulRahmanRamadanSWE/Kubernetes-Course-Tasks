# Kubernetes Guestbook API

A containerized Guestbook REST API built with **FastAPI** and **MySQL**, deployed on a three-node Kubernetes cluster using Minikube.

The project demonstrates Kubernetes application deployment, service discovery, Ingress routing, persistent storage, and data persistence after Pod restart.

## Project Architecture

The application consists of:

- **FastAPI:** Provides the REST API.
- **MySQL 8.4:** Stores guestbook messages.
- **Kubernetes Deployments:** Manage the API replicas and MySQL Pod.
- **Kubernetes Services:** Enable internal communication between application components.
- **NGINX Ingress:** Provides external access to the API.
- **PersistentVolume (PV):** Provides persistent storage.
- **PersistentVolumeClaim (PVC):** Requests and binds the storage volume.

### Architecture Flow

```text
Client
  |
  v
NGINX Ingress
  |
  v
Webapp Service
  |
  v
FastAPI Pods (2 replicas)
  |
  v
MySQL Service
  |
  v
MySQL Pod
  |
  v
PersistentVolumeClaim
  |
  v
PersistentVolume
```

## Technologies Used

| Technology | Purpose |
|---|---|
| Kubernetes | Container orchestration |
| Minikube | Local Kubernetes cluster |
| Docker | Container runtime and image building |
| FastAPI | REST API development |
| MySQL 8.4 | Relational database |
| NGINX Ingress | External HTTP routing |
| PersistentVolume | Persistent data storage |

## Project Structure

```text
Task-2/
├── app/
│   ├── main.py
│   ├── database.py
│   ├── models.py
│   ├── requirements.txt
│   └── Dockerfile
├── k8s/
│   ├── mysql-pv.yaml
│   ├── mysql-pvc.yaml
│   ├── mysql-deployment.yaml
│   ├── mysql-service.yaml
│   ├── webapp-config.yaml
│   ├── webapp-deployment.yaml
│   ├── webapp-service.yaml
│   └── webapp-ingress.yaml
├── scripts/
├── screenshots/
└── README.md
```

## API Endpoints

The API is exposed through Kubernetes Ingress.

| Endpoint | Method | Description |
|---|---|---|
| `/api/info` | GET | Returns API information |
| `/api/messages` | GET | Retrieves guestbook messages |
| `/api/messages` | POST | Creates a new guestbook message |

Interactive API documentation is available at:

```text
/docs
```

## Persistent Storage

MySQL uses a PersistentVolumeClaim bound to a PersistentVolume with the following configuration:

- Storage capacity: 2Gi
- Access mode: ReadWriteOnce
- Volume type: hostPath
- Reclaim policy: Retain

The volume is associated with the Kubernetes node `guestbook-m02`.

## Screenshots

### 1. API Information – Ingress Access

Shows successful access to the `/api/info` endpoint through Kubernetes Ingress.

![API Info](screenshots/01-api-info.png)

### 2. Guestbook Messages – Ingress Access

Shows the response from the `/api/messages` endpoint.

![API Messages](screenshots/02-api-messages.png)

### 3. Persistent Volume and Persistent Volume Claim

Shows the PersistentVolume and PersistentVolumeClaim successfully bound.

![PV and PVC](screenshots/03-pv-pvc.png)

### 4. Data Persistence After Pod Restart

Demonstrates that previously stored guestbook messages remain available after the MySQL Pod is deleted and recreated.

![Data Persistence](screenshots/04-data-persistence.png)

## Data Persistence Verification

The persistence test follows these steps:

1. Create a guestbook message through the API.
2. Verify that the message is stored and returned successfully.
3. Delete the MySQL Pod.
4. Allow Kubernetes to recreate the MySQL Pod.
5. Retrieve the messages again through the API.
6. Verify that the previously created message is still available.

## Security

- Database credentials are managed through Kubernetes Secrets.
- Sensitive credentials must not be committed to the Git repository.
- Configuration values are managed separately using ConfigMaps.

## Deployment Environment

The project is deployed using a three-node Minikube cluster.

Kubernetes resources are currently organized in the `default` namespace.

---

**Project:** Kubernetes Guestbook API  
**Task:** Task 2  
**Repository:** Task-2
