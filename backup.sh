#!/bin/bash

# Load environment variables
source .env

# Timestamp
TIMESTAMP=$(date +"%Y-%m-%d-%H%M")

# Backup filename
BACKUP_FILE="backup-$TIMESTAMP.sql"

# Run mysqldump inside MySQL container
docker exec wordpress-db \
mysqldump -u root -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE > $BACKUP_FILE

# Upload to S3 bucket
aws s3 cp $BACKUP_FILE s3://wordpress-backup-fawzee-2026/

# Confirmation
echo "Backup uploaded to S3:"
echo "s3://wordpress-backup-fawzee-2026/$BACKUP_FILE"
