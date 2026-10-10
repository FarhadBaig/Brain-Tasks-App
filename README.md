# Brain Tasks App — AWS DevOps Deployment

A DevOps practice project demonstrating Docker containerization, Amazon ECR, Amazon EKS, Kubernetes, and AWS CI/CD services.

## Architecture

GitHub → AWS CodePipeline → AWS CodeBuild → Amazon ECR → Amazon EKS → Kubernetes LoadBalancer → Browser

## Project Structure

```text
Brain-Tasks-App/
├── dist/                  # Prebuilt static application
├── Screenshots/            # Deployment evidence
├── Dockerfile              # Docker image configuration
├── default.conf            # Nginx configuration for port 3000
├── deployment.yaml         # Kubernetes Deployment
├── service.yaml            # Kubernetes LoadBalancer Service
├── buildspec.yml           # Docker build and ECR push
├── buildspec-deploy.yml    # Kubernetes deployment commands
└── README.md
```

## Technologies

- Docker and Nginx
- Amazon ECR
- Amazon EKS and Kubernetes
- AWS CodeBuild and CodePipeline
- Amazon CloudWatch
- Git and GitHub

## Application Details

This repository contains prebuilt static files in `dist/`. It does not contain the original React source code or `package.json`. Therefore, Nginx serves the existing build instead of compiling the React application.

- Container port: `3000`
- Kubernetes Service port: `80`
- Service type: `LoadBalancer`
- AWS Region: `ap-south-1`
- ECR repository: `brain-tasks-app`
- EKS cluster: `brain-tasks-eks`

## Run Locally with Docker

Build the image:

```bash
docker build -t brain-tasks-app:1.0 .
```

Run the container:

```bash
docker run -d --name brain-tasks-app -p 3000:3000 brain-tasks-app:1.0
```

If the container already exists, start it with:

```bash
docker start brain-tasks-app
```

Open `http://localhost:3000` in a browser.

Inspect the container and logs:

```bash
docker ps
docker logs brain-tasks-app
```

## Amazon ECR Image

The image is published in Amazon ECR:

`395307915231.dkr.ecr.ap-south-1.amazonaws.com/brain-tasks-app:1.0`

## Kubernetes Deployment

Configure kubectl for the EKS cluster:

```bash
aws eks update-kubeconfig --region ap-south-1 --name brain-tasks-eks
```

Apply the Kubernetes resources:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

Verify the resources:

```bash
kubectl get deployments
kubectl get pods -o wide
kubectl get svc brain-tasks-service
```

Get the public LoadBalancer hostname:

```bash
kubectl get svc brain-tasks-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
```

Open `http://<load-balancer-hostname>` in a browser.

## CI/CD Configuration

- `buildspec.yml` defines the Docker image build and push to Amazon ECR.
- `buildspec-deploy.yml` defines the Kubernetes rollout using kubectl.
- A CodePipeline can connect a GitHub source stage, an image-build CodeBuild project, and a deployment CodeBuild project.

Before automated deployments work, configure the GitHub connection, CodeBuild projects, ECR permissions, EKS access for the deployment role, and the CodePipeline stages.

## Logging and Troubleshooting

Inspect application logs in Kubernetes:

```bash
kubectl logs deployment/brain-tasks-app

### Live Deployment

- **Application URL:** http://aac3cc909c8a14ecc961f73d6db68192-1863119058.ap-south-1.elb.amazonaws.com
- **AWS Region:** `ap-south-1`
- **EKS Cluster:** `brain-tasks-eks`
- **Kubernetes Deployment:** `brain-tasks-app`
- **Kubernetes Service:** `brain-tasks-service`
- **LoadBalancer Name:** `aac3cc909c8a14ecc961f73d6db68192`
- **LoadBalancer Type:** Classic Load Balancer
- **Scheme:** Internet-facing
- **Traffic:** Port 80 → NodePort 31419 → Application port 3000

The application is deployed on Amazon EKS using a Docker image stored in Amazon ECR. The CI/CD workflow uses GitHub, AWS CodePipeline, and AWS CodeBuild.

```

Inspect deployment status:

```bash
kubectl rollout status deployment/brain-tasks-app
kubectl describe deployment brain-tasks-app
kubectl describe svc brain-tasks-service
```

CodeBuild build logs can be sent to CloudWatch Logs through the CodeBuild project settings. Kubernetes application logs can be viewed with kubectl; centralized application logging requires an appropriate CloudWatch logging agent or add-on.

## Screenshots

The `Screenshots/` directory contains evidence of the local application, Docker image and container, ECR image, EKS cluster, Kubernetes resources, LoadBalancer service, and working public application.

## Cleanup

AWS resources may continue to incur charges while running. After assessment and submission, delete resources that are no longer required, including the EKS cluster, LoadBalancer, CodePipeline, and CodeBuild projects. Retain screenshots and any required ECR image until submission is complete.
