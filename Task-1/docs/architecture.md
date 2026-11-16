# Kubernetes Task 1 – Architecture

## 1. Overview

This project deploys a containerized web application on a three-node Kubernetes cluster.

The application uses Nginx as a reverse proxy and a Python sidecar container to generate a dynamic UTC timestamp.

## 2. Cluster Architecture

The Kubernetes cluster consists of:

- One control-plane node.
- Two worker nodes.
- Three application replicas.
- One Kubernetes Service.

## 3. Pod Architecture

Each application Pod contains two containers:

### Nginx

- Listens on port 80.
- Receives incoming HTTP requests.
- Proxies requests to the sidecar on localhost:8080.

### Time Updater

- Runs a lightweight Python HTTP server.
- Generates a UTC timestamp.
- Updates the timestamp every five seconds.
- Serves the HTML page requested through Nginx.

### Init Container

The `init-done` container runs before the application containers.

It completes an initialization task and must exit successfully before Nginx and the sidecar start.

## 4. Request Flow

1. A client sends an HTTP request.
2. Kubernetes Service routes the request to an application Pod.
3. Nginx receives the request on port 80.
4. Nginx forwards the request to the sidecar on port 8080.
5. The sidecar returns an HTML page containing the current UTC timestamp.
6. Nginx returns the response to the client.

## 5. Design Constraints

- No Kubernetes Volumes.
- No shared process namespace.
- Three application replicas.
- Pod distribution across the three cluster nodes.
- Timestamp refresh interval: five seconds.
