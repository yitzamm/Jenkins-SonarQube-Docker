# Jenkins-SonarQube-Docker

Octubre 3, 2026

This project demonstrates a complete CI/CD pipeline using Jenkins integrated with SonarQube for code quality analysis and Docker for application deployment, all running on AWS EC2 infrastructure.

The pipeline retrieves application code from a GitHub repository, performs a SonarQube static code analysis, and if the quality checks pass, automatically deploys the application by building a Docker image and running a container on a remote server.

The environment was built using three separate EC2 instances to simulate a distributed DevOps architecture:
- Jenkins Server – CI/CD orchestration and pipeline execution
- SonarQube Server – static code analysis and quality gates
- Docker Server – application deployment and container runtime

This setup replicates a realistic multi-node CI/CD workflow commonly used in modern DevOps environments.

## Architecture Diagram

<img width="541" height="223" alt="Jenkins end-to-end diagram" src="https://github.com/user-attachments/assets/7046a835-38d8-4631-a7aa-a4a8b579640c" />

## Key Technologies

- **Jenkins –** CI/CD automation server
- **SonarQube –** Static code analysis and code quality inspection
- **Docker –** Containerization and application deployment
- **AWS EC2 –** Cloud infrastructure hosting the services
- **GitHub –** Source code repository and webhook trigger
- **NGINX –** Web server running inside the Docker container
- **SSH –** Secure communication between servers
- **Linux (Ubuntu)** – Operating system for all instances

## Pipeline Workflow

### AWS EC2
**Instance set-up:**
- 3 instances were created for the Jenkins, SonarQube and Docker servers
- The ports 8080, 9000 and 8085:80 were respectively opened for each one of the instances
<img width="778" height="206" alt="image" src="https://github.com/user-attachments/assets/4f3c7790-cb42-471e-a9ac-c669c8064bfe" />

### Jenkins and GitHub
**GitHub Webhook Trigger:**
- Code push triggers Jenkins automatically.
**Source Code Retrieval:**
- Jenkins pulls the latest version of the repository from GitHub.
<img width="942" height="355" alt="image" src="https://github.com/user-attachments/assets/18ca4c0b-c21f-4338-901c-d9b7130471f8" />

### SonarQube Scanning
**SonarQube Code Analysis:**
- The pipeline runs a SonarQube scan to analyze code quality and detect potential issues.
**Conditional Deployment:**
- If the scan completes successfully, Jenkins proceeds with the deployment stage.
<img width="290" height="233" alt="image" src="https://github.com/user-attachments/assets/7e2a8daf-aa58-4efb-b119-3ae48486ec4d" />

### Docker
**Docker Image Build:**
- Jenkins connects to the Docker server via SSH and builds a Docker image from the repository.
**Container Deployment:**
- The previous container (if any) is removed.
- A new container is started using the updated image.
<img width="925" height="177" alt="image" src="https://github.com/user-attachments/assets/3f4f7b45-c22a-4b15-af39-67723d45fa67" />
7. **Application Availability:**
- The web application becomes accessible via the Docker server on port 8085.
<img width="1899" height="867" alt="image" src="https://github.com/user-attachments/assets/6309ffae-c8dc-46e1-bcf8-e9fc90413f46" />

## Security and Access

Secure communication between servers was configured using SSH key-based authentication. From the Jenkins instance, an SSH key pair was generated and copied to the Docker server:
```
ssh-keygen
ssh-copy-id ubuntu@<docker-server-ip>
```
**NOTE:** This allowed Jenkins to securely deploy applications to the Docker host without requiring manual password entry. For testing purposes, password authentication was temporarily enabled on the Docker instance, but SSH keys were used for automated pipeline access.

## Docker Configuration

The application is deployed using a simple Dockerfile that uses NGINX as the web server.
```
FROM nginx
COPY ./web-app/ /usr/share/nginx/html/
```

This copies the website files into the NGINX web root so the application can be served from the container. The container is deployed using:
```
docker build -t mywebsite .
docker rm -f Yitza-Website || true
docker run -d -p 8085:80 --name Yitza-Website mywebsite
```

## What I Learned

This project helped reinforce several important DevOps concepts:

- Building multi-server CI/CD environments using AWS EC2
- Integrating SonarQube into Jenkins pipelines for automated code quality analysis
- Configuring GitHub webhooks to trigger CI pipelines
- Automating application deployment using Docker containers
- Using SSH keys for secure server-to-server communication
- Troubleshooting Linux permissions, Docker container conflicts, and SSH authentication issues
- Managing remote deployments through Jenkins pipelines
