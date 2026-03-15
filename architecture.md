* Architecture Document
* Create a short document called architecture.md (1–2 pages) that explains your deployment. This is not a step-by-step guide of what you did. It is an explanation of why you made the choices you made.

This project deploys a two-tier web application consisting of WordPress and MySQL using Docker containers on an Amazon Web Services EC2 instance.

The goal of this architecture is to demonstrate how a containerized web application can be deployed in the cloud with persistent storage and automated backups.

The deployment includes the following AWS services:

Amazon Elastic Compute Cloud (EC2) – hosts the Docker containers

Amazon Elastic Block Store (EBS) – provides persistent storage for the MySQL database

Amazon Simple Storage Service (S3) – stores database backups

The application runs using Docker Compose, which manages the WordPress and MySQL containers and allows them to communicate over an internal Docker network.

* Address the following questions:
* Draw or describe a simple diagram showing how the components connect: User → EC2 instance → Docker → WordPress + MySQL → EBS volume

Application Flow

A user accesses the website using a browser through HTTP (port 80).

The request reaches the EC2 instance.

The request is forwarded to the WordPress container running inside Docker.

WordPress queries the MySQL container for application data.

MySQL stores its database files on the mounted EBS volume (/mnt/mysql-data).

Periodically, a backup script exports the database using mysqldump.

The backup file is uploaded to an S3 bucket for safe storage.

* Why is an EBS volume used for MySQL data instead of letting the container store it internally? What would happen without it?

The MySQL container stores its database files in /var/lib/mysql.
This directory is mapped to /mnt/mysql-data, which is backed by an EBS volume.

Using an EBS volume ensures that:

Database data persists even if containers restart

Data is not lost if Docker is reinstalled

Storage can be detached and attached to another instance if necessary

Without EBS, the database would be stored inside the container filesystem.
If the container were removed or recreated, all data would be permanently lost.

* Which ports did you open in your security group, and why those specific ports? Are there any security risks with your current configuration?

The following ports were opened in the EC2 security group:

Port	Protocol	Purpose
22	SSH	Allows remote administration of the server
80	HTTP	Allows users to access the WordPress website

Opening port 22 to 0.0.0.0/0 allows SSH access from anywhere. While this simplifies access for development purposes, in production environments it is recommended to restrict SSH access to trusted IP addresses.

* What would break if your EC2 instance crashed right now? What data would survive and what would be lost?

If the EC2 instance crashed:

Data that would survive

MySQL database stored on the EBS volume

Backup files stored in S3

Data that would be lost

Running containers

Temporary application state

However, the application could be quickly restored by launching a new EC2 instance and redeploying the Docker containers using the existing EBS volume.

* If this application needed to handle 100x more users, what would you change? (It is perfectly fine to say you do not know yet, but try to think it through.)

If the application needed to support significantly more users, several improvements could be implemented:

Use a load balancer to distribute traffic across multiple WordPress instances

Move the database to managed database services

Use auto-scaling groups for dynamic scaling

Store media files in S3 instead of the web server

Implement content caching and CDN services

These changes would improve reliability, scalability, and performance.
