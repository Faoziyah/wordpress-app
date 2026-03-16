**Architecture Document**
* Create a short document called architecture.md (1–2 pages) that explains your deployment. This is not a step-by-step guide of what you did. It is an explanation of why you made the choices you made.

In this project, i deployed a two-tier web application consisting of Wordpress and MySQL using Docker containers on and AWS EC2 instance. The goal of this architecture is to demonstrate how a containerized web application can be deployed in the cloud with persistent storage and automated backups.

**The deployment includes the following AWS services:**
* Amazon Elastic Compute Cloud (EC2) which hosts the Docker containers
* Amazon Elastic Block Store (EBS) which provides persistent storage for the MySQL database
* Amazon Simple Storage Service (S3) which stores database backups
 I run the application using Docker Compose, which manages the WordPress and MySQL containers and allows them to communicate over an internal Docker network.



**Address the following questions:**
* Draw or describe a simple diagram showing how the components connect: User → EC2 instance → Docker → WordPress + MySQL → EBS volume

**The Application Flow**

A user accesses the website using a browser through HTTP (port 80) → The request reaches the EC2 instance → The request is forwarded to the WordPress container running inside Docker → WordPress queries the MySQL container for application data → MySQL stores its database files on the mounted EBS volume (/mnt/mysql-data) → Periodically, a backup script exports the database using mysqldump → The backup file is uploaded to an S3 bucket for safe storage.

I've attached the architectural diagram to the screenshots file.




* Why is an EBS volume used for MySQL data instead of letting the container store it internally? What would happen without it?

The MySQL container stores its database files in /var/lib/mysql. This directory is mapped to /mnt/mysql-data, which is backed by an EBS volume. Using an EBS volume ensures that Database data persists even if containers restart, Data is not lost if Docker is reinstalled, also, Storage can be detached and attached to another instance if necessary.

Without EBS, the database would be stored inside the container filesystem. If the container were removed or recreated, all data would be permanently lost.




* Which ports did you open in your security group, and why those specific ports? Are there any security risks with your current configuration?

I opened Port 22 which allows me to remotely access and configure the web-app server. Also, Port 80 to allow users to aaccess the Web-app from the browser.

Opening port 22 to 0.0.0.0/0 allows SSH access from anywhere. While this simplifies access for development purposes, in production environments it is recommended to restrict SSH access to trusted IP addresses. Also in Production, Https - which is the secured version of Http should be used to access the website securely over the browser.




* What would break if your EC2 instance crashed right now? What data would survive and what would be lost?

If the EC2 instance crashed,
Data that would survive include: MySQL database stored on the EBS volume and Backup files stored in S3.

Data that would be lost include: the two running containers and the Temporary application state.z           

However, the application could be quickly restored by launching a new EC2 instance and redeploying the Docker containers using the existing EBS volume.




* If this application needed to handle 100x more users, what would you change? (It is perfectly fine to say you do not know yet, but try to think it through.)

If the application needed to support significantly more users, we can use a load balancer to distribute traffic across multiple WordPress instances and attach the instances to an autosalling groups for dynamic scalling. The Database can also be movedto a managed database service. media files should also be stored in S3 instead of the web server. I believe these changes should improve reliability, scalability, and performance.
