8Byte DevOps Assignment



End-to-end DevOps implementation covering AWS infrastructure

provisioning, containerized application deployment, CI/CD automation,

monitoring, centralized logging, security scanning, and documentation.



Assignment Scope



This project implements the four required areas:



Infrastructure Provisioning -- Terraform-based AWS

infrastructure.



Deployment Automation -- GitHub Actions CI/CD, automated tests,

Docker image build/push, and security scanning.



Monitoring \& Logging -- Prometheus, Grafana, Loki, Promtail,

application/database/infrastructure metrics, and two meaningful

Grafana dashboards.



Documentation \& Best Practices -- setup instructions,

architecture decisions, security considerations, cost optimization,

backup strategy, and troubleshooting notes.



Architecture Overview



&#x20;                        GitHub Repository

&#x20;                               |

&#x20;                               v

&#x20;                   +------------------------+

&#x20;                   |    GitHub Actions      |

&#x20;                   |------------------------|

&#x20;                   | Unit + Integration     |

&#x20;                   | Docker Build           |

&#x20;                   | Trivy Security Scan    |

&#x20;                   | ECR Push / Deployment   |

&#x20;                   +-----------+------------+

&#x20;                               |

&#x20;                               v

&#x20;                        Amazon ECR

&#x20;                               |

&#x20;                               v

&#x20;                      +----------------+

&#x20;                      |   AWS VPC      |

&#x20;                      |                |

&#x20;                      |  Public        |

&#x20;                      |  Subnets       |

&#x20;                      |       |        |

&#x20;                      |      ALB       |

&#x20;                      |       |        |

&#x20;                      |      EC2       |

&#x20;                      |       |        |

&#x20;                      |  Private       |

&#x20;                      |  Subnets       |

&#x20;                      |       |        |

&#x20;                      |      RDS       |

&#x20;                      |   PostgreSQL   |

&#x20;                      +----------------+



Local / Observability Stack

\----------------------------

Application -> Prometheus -> Grafana

&#x20;    |

Docker logs -> Promtail -> Loki -> Grafana

&#x20;    |

PostgreSQL -> PostgreSQL Exporter -> Prometheus

&#x20;    |

Host/Node -> Node Exporter -> Prometheus



Technology Stack



Area                     Technology



Cloud                    AWS

Infrastructure as Code   Terraform

Compute                  Amazon EC2

Database                 Amazon RDS PostgreSQL

Load Balancing           Application Load Balancer

Container Registry       Amazon ECR

Containerization         Docker

Application              Python / Flask

CI/CD                    GitHub Actions

Testing                  Pytest

Container Security       Trivy

Metrics                  Prometheus

Visualization            Grafana

Logging                  Loki + Promtail

Database Metrics         PostgreSQL Exporter

Infrastructure Metrics   Node Exporter

Source Control           Git / GitHub



Part 1 -- Infrastructure Provisioning



Terraform is used to provision and manage the AWS infrastructure.



Provisioned resources



VPC



Public subnets



Private subnets



Internet Gateway



Public route table and associations



Application security group



ALB security group



RDS security group



EC2 instance



Application Load Balancer



ALB listener



Target group and EC2 attachment



Amazon ECR repository



IAM role



IAM instance profile



ECR read-only IAM policy attachment



RDS PostgreSQL instance



RDS DB subnet group



The Terraform state was initialized and used to track the deployed AWS

resources.



Terraform directory



terraform/

├── main.tf

├── alb.tf

├── variables.tf

├── terraform.tfstate

└── .terraform.lock.hcl



Validate Terraform



cd terraform

terraform init

terraform validate

terraform plan



To provision/update the infrastructure:



terraform apply



Review the plan before confirming the apply operation.



Useful Terraform commands



terraform state list

terraform output

terraform show

terraform plan

terraform validate



Key outputs



Terraform exposes important deployment information such as:



EC2 public IP



Application URL



ECR repository URL



RDS endpoint



RDS port



Part 2 -- Deployment Automation



GitHub Actions



The project contains GitHub Actions workflows under:



.github/workflows/

├── tests.yml

└── deploy.yml



CI workflow



The test workflow is responsible for validating application changes.



The project includes:



Unit tests



Integration tests



Automated execution through GitHub Actions



Tests can also be executed locally:



python -m pip install -r app/requirements.txt

python -m pip install pytest

python -m pytest tests



Docker Build



The application is containerized using the root Dockerfile.



Build locally:



docker build --no-cache -t 8byte-devops-app:1.0 .



Run locally:



docker run -d `

&#x20; --name 8byte-devops-app `

&#x20; -p 5000:5000 `

&#x20; 8byte-devops-app:1.0



Verify:



Invoke-WebRequest http://localhost:5000/ -UseBasicParsing



Expected response:



8Byte DevOps Assignment Application



Amazon ECR



The Terraform configuration creates:



8byte-devops-app



The EC2 instance is associated with an IAM instance profile that has ECR

read-only access, allowing the instance to authenticate and pull the

application image from ECR.



ECR image scanning is also enabled on push.



Vulnerability Scanning



Trivy is used to scan Docker images for security vulnerabilities.



Example:



trivy image --scanners vuln --severity HIGH,CRITICAL --ignore-unfixed 8byte-devops-app:1.0



The final image was rebuilt and checked during the security-hardening

process.



Part 3 -- Monitoring and Logging



The observability stack consists of:



Prometheus

Grafana

Loki

Promtail

Node Exporter

PostgreSQL Exporter



Application Metrics



The Flask application exposes metrics through:



/metrics



Prometheus periodically scrapes the application metrics endpoint.



Application monitoring covers metrics such as:



Request rate



Request count



Request latency



HTTP status/error information



Infrastructure Metrics



Node Exporter provides infrastructure metrics to Prometheus.



The monitoring stack can be used to observe:



CPU utilization



Memory-related metrics



Disk/filesystem metrics



Host availability



Database Metrics



PostgreSQL Exporter exposes PostgreSQL metrics to Prometheus.



This provides visibility into database health and PostgreSQL-related

statistics.



Centralized Logging



Docker container logs are collected by Promtail and forwarded to Loki.



Docker containers

&#x20;      |

&#x20;      v

&#x20;  Promtail

&#x20;      |

&#x20;      v

&#x20;     Loki

&#x20;      |

&#x20;      v

&#x20;   Grafana



Promtail is configured to read Docker JSON log files and send them to:



http://8byte-loki:3100/loki/api/v1/push



Loki was verified as healthy through:



Invoke-WebRequest http://localhost:3100/ready



Promtail readiness was verified through:



Invoke-WebRequest http://localhost:9080/ready -UseBasicParsing



Loki labels were also verified through its API, confirming Docker log

data was being ingested.



Grafana Dashboards



At least two meaningful dashboards were created for the assignment.



Dashboard 1 -- Application / Infrastructure Monitoring



This dashboard provides visibility into application and infrastructure

health, including metrics such as:



Application request activity



HTTP errors



Request latency



CPU utilization



Memory / system metrics



Host-level performance



Dashboard 2 -- Database / Logging Observability



This dashboard provides visibility into:



PostgreSQL metrics



Database activity



Centralized Docker logs



Log severity/volume



Application and container log messages



Grafana Explore was also used to query Loki directly and verify

centralized logs.



Local Monitoring Stack



The local Docker network used by the observability stack is:



8byte-network



The monitoring containers include:



8byte-prometheus

8byte-grafana

8byte-loki

8byte-promtail

8byte-node-exporter

8byte-postgres-exporter



The application and PostgreSQL containers are also connected to the same

Docker network.



Important local ports



Service                 Port



Application             5000

Prometheus              9090

Grafana                 3000

Loki                    3100

Promtail                9080

PostgreSQL              5432

PostgreSQL Exporter     9187



Running the Application Locally



Build:



docker build -t 8byte-devops-app:1.0 .



Run:



docker run -d `

&#x20; --name 8byte-devops-app `

&#x20; --network 8byte-network `

&#x20; -p 5000:5000 `

&#x20; 8byte-devops-app:1.0



Verify:



Invoke-WebRequest http://localhost:5000/ -UseBasicParsing



Metrics:



Invoke-WebRequest http://localhost:5000/metrics -UseBasicParsing



Running the Monitoring Components



Check all containers:



docker ps



Expected monitoring components include:



8byte-prometheus

8byte-grafana

8byte-loki

8byte-promtail

8byte-node-exporter

8byte-postgres-exporter



Prometheus



Open:



http://localhost:9090



Verify targets from the Prometheus Targets page.



Grafana



Open:



http://localhost:3000



Grafana is configured with Prometheus and Loki data sources.



Loki



Health check:



Invoke-WebRequest http://localhost:3100/ready



Verify labels:



Invoke-WebRequest "http://localhost:3100/loki/api/v1/labels" -UseBasicParsing



Example result confirms labels such as:



filename

job

service\_name



Promtail



Health check:



Invoke-WebRequest http://localhost:9080/ready -UseBasicParsing



Promtail reads Docker JSON logs and forwards them to Loki.



Security Considerations



The project applies several security controls:



RDS is configured as not publicly accessible.



RDS is placed in private subnets.



Separate security groups are used for ALB, application, and RDS.



EC2 uses an IAM instance profile for ECR access instead of embedding

AWS credentials in the application container.



ECR image scanning is enabled on push.



Trivy is used for container vulnerability scanning.



Docker images are built from a slim Python base image.



The application container can be run using a non-root application

user in the hardened Docker image.



AWS credentials used by CI/CD are intended to be supplied through

CI/CD credential/secrets mechanisms rather than committed to source

control.



Terraform state and sensitive local configuration should not be

committed to a public repository.



Important production hardening



For a production deployment, database credentials should be moved from

Terraform configuration into a proper secret-management service such as

AWS Secrets Manager or SSM Parameter Store. Security group rules should

also remain as restrictive as possible.



Backup Strategy



RDS PostgreSQL is configured with automated backup retention.



The current Terraform configuration uses:



backup\_retention\_period = 1



This provides a basic automated backup strategy appropriate for the

assignment environment.



For production, the retention period should be increased according to

the organization's recovery requirements, and deletion protection/final

snapshots should be enabled where appropriate.



Cost Optimization



The assignment uses relatively small instance classes suitable for a

development/demo environment.



Examples include:



EC2 small instance sizing



RDS db.t3.micro



20 GB initial RDS storage



Limited RDS backup retention for the assignment environment



Lightweight Python base image



Local Docker-based monitoring stack rather than deploying a separate

managed observability platform



For production, sizing should be based on measured workload rather than

fixed assumptions.



Project Structure



8byte-devops-assignment/

│

├── .github/

│   └── workflows/

│       ├── deploy.yml

│       └── tests.yml

│

├── app/

│   ├── app.py

│   ├── requirements.txt

│   └── \_\_init\_\_.py

│

├── monitoring/

│   ├── loki/

│   │   ├── loki-config.yml

│   │   └── local-config.yaml

│   │

│   ├── prometheus/

│   │   └── prometheus.yml

│   │

│   └── promtail/

│       └── promtail-config.yml

│

├── terraform/

│   ├── main.tf

│   ├── alb.tf

│   ├── variables.tf

│   ├── .terraform.lock.hcl

│   └── terraform.tfstate

│

├── tests/

│   ├── test\_app.py

│   └── test\_integration.py

│

├── Dockerfile

├── Jenkinsfile

├── github-actions-policy.json

├── github-trust-policy.json

├── .gitignore

└── README.md



Jenkinsfile Note



The repository contains a Jenkinsfile as an additional pipeline

definition/alternative implementation.



The primary CI/CD implementation for this assignment is the GitHub

Actions workflow under:



.github/workflows/



Therefore, Jenkins is not required to reproduce the current GitHub

Actions-based workflow.



Validation Performed



The implementation was verified progressively from infrastructure

through observability.



Terraform



terraform validate



Result:



Success! The configuration is valid.



terraform plan was also executed successfully and used to review the

current infrastructure state.



Application



Invoke-WebRequest http://localhost:5000/ -UseBasicParsing



Application returned HTTP 200.



Application Metrics



The application /metrics endpoint was successfully scraped by

Prometheus.



Loki



Invoke-WebRequest http://localhost:3100/ready



Returned:



ready



Promtail



Invoke-WebRequest http://localhost:9080/ready -UseBasicParsing



Returned:



Ready



Loki Log Ingestion



Loki API queries confirmed Docker log labels and log data were

available.



Docker Network



The monitoring and application containers were verified on:



8byte-network



Containers



The following services were verified as running:



8byte-devops-app

8byte-postgres

8byte-prometheus

8byte-grafana

8byte-loki

8byte-promtail

8byte-node-exporter

8byte-postgres-exporter



Challenges Faced and Resolutions



1\. Loki container failed to start



The initial Loki container exited because the command-line configuration

flag was incompatible with the image command being used.



Resolution



The container was recreated with the correct Loki configuration

argument:



\-config.file=/etc/loki/loki-config.yml



After correction, Loki started successfully and /ready returned HTTP

200\.



2\. Promtail container failed to start



Promtail initially showed:



flag provided but not defined: -config



Resolution



The container command was corrected to use the supported

configuration-file argument.



Promtail subsequently started successfully and returned:



Ready



3\. Loki readiness initially reported a startup delay



Immediately after startup, Loki returned:



Ingester not ready: waiting for 15s after being ready



Resolution



The service was allowed to complete its startup period and the readiness

endpoint was checked again. It subsequently returned:



ready



4\. Container image security findings



Container vulnerability scans identified dependency-related findings

during earlier image builds.



Resolution



The Docker image was rebuilt and Python packaging dependencies were

reviewed/upgraded as part of the hardening process. Trivy was repeatedly

used to validate the resulting image.



Cleanup



When the temporary AWS infrastructure is no longer required, destroy it

through Terraform:



cd terraform

terraform destroy



Review the resources carefully before confirming.



For local Docker cleanup, stop/remove containers as required:



docker ps

docker stop <container-name>

docker rm <container-name>



Submission Checklist



Before submitting the repository, verify:



Terraform infrastructure files committed



variables.tf included



Terraform state management configured



AWS VPC and subnets provisioned



EC2 application hosting provisioned



RDS PostgreSQL provisioned



Security groups configured



Application Load Balancer configured



Dockerfile included



GitHub Actions workflows included



Unit and integration tests included



Docker image build implemented



ECR image handling implemented



Container vulnerability scanning implemented



Prometheus monitoring configured



Grafana configured



Loki centralized logging configured



Promtail configured



PostgreSQL exporter configured



Node exporter configured



Two meaningful Grafana dashboards created



RDS backup retention configured



README documentation completed



Conclusion



This project demonstrates an end-to-end DevOps workflow starting from

Infrastructure as Code and continuing through application

containerization, CI/CD, security scanning, deployment, monitoring,

centralized logging, and operational verification.



The implementation was validated step-by-step from Terraform

infrastructure through the application, Prometheus metrics, Grafana

dashboards, Loki log storage, and Promtail log collection.

