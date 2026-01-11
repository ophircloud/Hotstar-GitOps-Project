# Deploying a Secure Hotstar Clone with GitOps & Kubernetes

As a DevOps enthusiast, I had tinkered with CI/CD pipelines before, but I realized I had never truly built a project that integrated DevOps + Security (DevSecOps) + GitOps principles end-to-end. That’s when the idea struck:

Why not try building a Hotstar clone, and then deploy it with a full DevSecOps CI/CD pipeline?

That single thought kicked off my journey.

The Challenge I Set for Myself
I didn’t want this to be just another CI/CD demo. Instead, I set three goals:

Security First → Integrate DevSecOps practices (image scanning, secret management, policy enforcement).
Automation Everywhere → Use GitOps to make deployments hands-off, traceable, and rollback-friendly.
Real-World Use Case → Use a media-streaming clone (Hotstar-like) so it feels relevant and fun.
It sounded ambitious at first… but that’s what made it exciting.

**The Tech Stack I Chose**

I carefully picked a stack that mirrors what real-world teams use today:

Kubernetes → The foundation for container orchestration.
GitHub + GitOps (ArgoCD/Flux) → Every config change flows through Git, the single source of truth.
Docker → Containerized the Hotstar clone app.
CI/CD (GitHub Actions/Jenkins) → Automated builds, tests, and deployments.
Security Tools → Image scanning (Trivy), secret management (Sealed Secrets), policy enforcement (OPA/Gatekeeper).
Monitoring & Logging → Prometheus + Grafana for observability.
With this arsenal, I felt ready to bring my Hotstar clone to life.

**The Journey: Building the Pipeline**
**Step 1: Containerizing the Hotstar Clone**
The first step was packaging the app into Docker. That was straightforward, but I had to ensure:

No secrets inside images.
Used a lightweight base image.
Ran as a non-root user.

**Step 2: Adding Security Gates in CI/CD**
Before anything reached production, my pipeline enforced:

Static Code Analysis → Checking for vulnerabilities early.
Docker Image Scanning → Using Trivy to block insecure builds.
Policy Checks → Rejecting configs that violated security rules.

**Step 3: GitOps for Deployment**
Here’s where the magic happened. Instead of manually deploying, I connected ArgoCD to my Git repo.

Every commit to main automatically synced to Kubernetes.
Rollbacks were as simple as reverting a Git commit.
Full history of deployments → just by looking at Git logs.

**Step 4: Monitoring & Alerts**
Finally, I wired Prometheus and Grafana to watch everything: CPU usage, memory, errors, and stream performance.
This way, the system wasn’t just automated — it was observable.

**Step 1: Clone the Repository**
https://github.com/ophircloud/Hotstar-GitOps-Project.git

**Step 2: Navigate into the Project**
ls
cd Hotstar-GitOps-project
ls

**Step 3: Create S3 Buckets for Terraform State**
These buckets will store terraform.tfstate files.
cd s3-buckets/
ls
terraform init
terraform plan
terraform apply -auto-approve

✅ 3. AWS Console

Log in to the AWS S3 Console.
bucket name : hotstaarumullaa
bucket name : hotstaaluru
Search for your bucket name in the list.
If it’s there, it was created successfully.

**Step 4: Create Network**
Navigate to Terraform EC2 folder:
cd ../terraform_main_ec2

**2. Run Terraform:**

terraform init
terraform plan
terraform apply -auto-approve

example output :
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.
Outputs:
jumphost_public_ip = “18.208.229.108”
region = “us-east-1”

**3. The command terraform state list is used to list all resources tracked in your current Terraform state file.**

terraform state list

**Step 5: Connect to EC2 and Access Jenkins**
Go to AWS Console → EC2
Click your instance → Connect
Once connected, switch to root:
sudo -i

**4. DevOps Tool Installation Check & Version Report**

  [Git]="git --version"
  [Java]="java -version"
  [Jenkins]="jenkins --version"
  [Terraform]="terraform -version"
  [Maven]="mvn -v"
  [kubectl]="kubectl version --client --short"
  [eksctl]="eksctl version"
  [Helm]="helm version --short"
  [Docker]="docker --version"
  [Trivy]="trivy --version"
  [SonarQube]="docker ps | grep sonar"
  [Grafana]="kubectl get pods -A | grep grafana"
  [Prometheus]="kubectl get pods -A | grep prometheus"
  [AWS_CLI]="aws --version"
  [MariaDB]="mysql --version"
**5. Get the initial Jenkins admin password:**

cat /var/lib/jenkins/secrets/initialAdminPassword

example output : 0c39f23132004d508132ae3e0a7c70e4
Copy that password!

Step 6: Jenkins Setup in Browser
Open browser and go to:
http://<EC2 Public IP>:8080
2. Paste the password from last step.
3. Click Install suggested plugins
4. Create first user:
Click through: Save and Continue → Save and Finish → Start using Jenkins

🔌 Step :7 Install Jenkins Plugin
Jenkins Dashboard → Manage Jenkins
Go to: Plugins
Click Available plugins
Search for:
pipeline: stage view
Docker
Docker Pipeline
Kubernetes
Kubernetes CLI
5. Install it

Step 8: Create a Jenkins Pipeline Job (Create EKS Cluster)
Go to Jenkins Dashboard
Click New Item
Name it: eks-terraform
Select: Pipeline
Click OK
Pipeline:
Definition : Pipeline script from SCM
SCM : Git
Repositories : https://github.com/ophircloud/Hotstar-GitOps-Project.git
Branches to build : */master
Script Path : eks-terraform/eks-jenkinsfile
Apply
Save
6. click Build with Parameters

ACTION :
Select Terraform action : apply
Build
7. To verify your EKS cluster, connect to your EC2 jumphost server and run:

aws eks --region us-east-1 update-kubeconfig --name project-eks
kubectl get nodes
Step 9: Create a Jenkins Pipeline Job (Create Elastic Container Registry (ecr))
Go to Jenkins Dashboard
Click New Item
Name it: ecr-terraform
Select: Pipeline
Click OK
Pipeline:
Definition : Pipeline script from SCM
SCM : Git
Repositories : https://github.com/ophircloud/Hotstar-GitOps-Project.git
Branches to build : */master
Script Path : ecr-terraform/ecr-jenkinfile
Apply
Save
6. click Build with Parameters

ACTION :
Select Terraform action : apply
Build
7. To verify your EKS cluster, connect to your EC2 jumphost server and run:

aws ecr describe-repositories --region us-east-1
Step 10: Create a Jenkins Pipeline Job for Build and Push Docker Images to ECR
🔐 Step 10.1: Add GitHub PAT to Jenkins Credentials

Navigate to Jenkins Dashboard → Manage Jenkins → Credentials → (global) → Global credentials (unrestricted).
Click “Add Credentials”.
In the form:
Kind: Secret text
Secret: ghp_HKMhfhfdTPOKYE2LLxGuytsimxnnl5d1f73zh
ID: my-git-pattoken
Description: git credentials
4. Click “OK” to save.

🚀 Step 10.2: ⚖️ Jenkins Pipeline Setup: Build and Push and update Docker Images to ECR

Go to Jenkins Dashboard
Click New Item
Name it: hotstar
Select: Pipeline
Click OK
Pipeline:
Definition : Pipeline script from SCM
SCM : Git
Repositories : https://github.com/ophircloud/Hotstar-GitOps-Project.git
Branches to build : */master
Script Path : jenkinsfiles/hotstar
Apply
Save
6. **click Build**

### To verify your EKS cluster, connect to your EC2 jumphost server and run:

aws eks --region us-east-1 update-kubeconfig --name project-eks
kubectl get nodes



🖥️ **Step 11: Install ArgoCD in Jumphost EC2**
### 11.1: Create Namespace for ArgoCD
kubectl create namespace argocd

### 11.2: Install ArgoCD in the Created Namespace

kubectl apply -n argocd \
  -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

### 11.3: Verify the Installation

Ensure all pods are in Running state.

kubectl get pods -n argocd

### 11.4: Validate the Cluster

Check your nodes and create a test pod if necessary:

kubectl get nodes

### 11.5: List All ArgoCD Resources

kubectl get all -n argocd

### Sample output:

NAME                                                    READY   STATUS    RESTARTS   AGE
pod/argocd-application-controller-0                     1/1     Running   0          106m
pod/argocd-applicationset-controller-787bfd9669-4mxq6   1/1     Running   0          106m
pod/argocd-dex-server-bb76f899c-slg7k                   1/1     Running   0          106m
pod/argocd-notifications-controller-5557f7bb5b-84cjr    1/1     Running   0          106m
pod/argocd-redis-b5d6bf5f5-482qq                        1/1     Running   0          106m
pod/argocd-repo-server-56998dcf9c-c75wk                 1/1     Running   0          106m
pod/argocd-server-5985b6cf6f-zzgx8                      1/1     Running   0   


### 11.6: Expose ArgoCD Server Using LoadBalancer

### 11.6.1: Edit the ArgoCD Server Service

kubectl edit svc argocd-server -n argocd

### 11.6.2: Change the Service Type

Find this line:

type: ClusterIP
Change it to:

type: LoadBalancer
Save and exit (:wq for vi).

### 11.6.3: Get the External Load Balancer DNS

kubectl get svc argocd-server -n argocd

### Sample output:

NAME            TYPE           CLUSTER-IP     EXTERNAL-IP                           PORT(S)                          AGE
argocd-server   LoadBalancer   172.20.1.100   a1b2c3d4e5f6.elb.amazonaws.com  

### 11.6.4: Access the ArgoCD UI

### Use the DNS:
https://<EXTERNAL-IP>.amazonaws.com

### 11.7: 🔐 Get the Initial ArgoCD Admin Password

kubectl get secret argocd-initial-admin-secret -n argocd \

### Login Details:
Username: admin
Password: (The output of the above command)
  -o jsonpath="{.data.password}" | base64 -d && echo


### Step 12: Deploying with ArgoCD

**Step 12.1: Create Namespace in EKS (from Jumphost EC2)**

Run these commands on your jumphost EC2 server:

kubectl create namespace dev
kubectl get namespaces

### Step 12.2: Create New Applicatio with ArgoCD

Open the ArgoCD UI in your browser.

Click + NEW APP.

Fill in the following:

Application Name: project
Project Name: default
Sync Policy: Automatic

Repository URL: https://github.com/ophircloud/Hotstar-GitOps-project.git
Revision: HEAD

Path: kubernetes-files

Cluster URL: https://kubernetes.default.svc

Namespace: dev

4. Click Create.

ArgoCD will now automatically sync your manifests to the dev namespace.

### Step 12.3: Copy the Load Balancer URL

Once the application is deployed:

Go to the Services section in Kubernetes:
kubectl get svc -n dev

