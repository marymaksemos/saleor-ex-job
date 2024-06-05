# Scalable E-Commerce Platform on GKE with Saleor

## Project Overview
This project involves the design and deployment of a scalable e-commerce platform using the Saleor framework on Google Kubernetes Engine (GKE). The platform integrates Terraform for infrastructure automation and Google Cloud Build for continuous integration, providing a robust, flexible, and cost-effective solution for online retail needs.

## Author
Mary Maksemos

## Supervisor
Tom

## Table of Contents
1. [Introduction](#introduction)
2. [Method and Implementation](#method-and-implementation)
3. [Results](#results)
4. [Discussion](#discussion)
5. [How to Use](#how-to-use)
6. [References](#references)
7. [Appendices](#appendices)
8. [Conclusion](#conclusion)

## Introduction
This implementation leverages essential DevOps tools and practices to enhance operational efficiency and scalability, resulting in significant reductions in setup and maintenance costs.

### Background
The project taps into the rapid growth of the e-commerce sector, employing Google Cloud Platform’s GKE to deploy a scalable, robust technology solution that meets dynamic business needs.

### Purpose
To demonstrate the effectiveness of using GKE in combination with Saleor to establish a scalable e-commerce platform.

### Delimitation
Focuses on the use of GKE and Saleor, excluding other cloud providers and e-commerce solutions to maintain a manageable scope.

## Method and Implementation
- **Saleor Backend**: Deployed on GKE, utilizing its scalable infrastructure.
- **Saleor Dashboard**: Standard dashboard used for efficient management of the platform.
- **Custom Frontend - AlliStore**: Tailored to meet specific branding and functional requirements with extensive modifications for enhanced user experience.

### Tools and Technologies
- **Terraform**: Automates infrastructure setup on GCP.
- **Google Kubernetes Engine (GKE)**: Manages and scales containerized applications.
- **GitHub**: Central code hosting and version control system.
- **Google Cloud Build**: Facilitates continuous integration and delivery.
- **Cloudflare**: Manages DNS and enhances security.
- **Google Cloud Monitoring**: Maintains operational performance through proactive monitoring.

## Results
(Results of the deployment detailing performance metrics and user feedback)

## Discussion
Highlights the challenges faced during the project, such as infrastructure setup and continuous integration, along with the achievements like scalability and efficiency enhancements.

## How to Use
To deploy and use the e-commerce platform, follow these steps:

1. **Clone the Repository**:
   - Clone the project repository from GitHub using `git clone https://github.com/marymaksemos/saleor-ex-job.git`.

2. **Set Up Infrastructure**:
   - Navigate to the project directory and run `terraform init` followed by `terraform apply` to set up the GKE infrastructure.

3. **Deploy Saleor and Custom Frontend**:
   - Deploy the Saleor backend and the custom AlliStore frontend using Kubernetes configurations found in the `deployment` directory.

4. **Configure the Dashboard**:
   - Access the Saleor dashboard to manage products, orders, and customer data by navigating to `https://dashboard.allistore.uk/`.

5. **Monitoring and Maintenance**:
   - Monitor the system's performance and uptime through Google Cloud Monitoring and manage DNS settings via Cloudflare for optimal performance and security.

## References
- [Google Cloud Documentation](https://cloud.google.com/docs)
- [Saleor GitHub](https://github.com/saleor)
- [Kubernetes Documentation](https://kubernetes.io/docs/home)

## Appendices
- [Project GitHub Repository](https://github.com/marymaksemos/saleor-ex-job)
- [AlliStore Default Channel](https://allistore.uk/default-channel)
- [AlliStore Dashboard](https://dashboard.allistore.uk/)
- [AlliStore API](https://api.allistore.uk/)

## Conclusion
The deployment of the Saleor e-commerce platform on GKE proved successful, showcasing a scalable, reliable, and cost-effective solution for e-commerce platforms.


