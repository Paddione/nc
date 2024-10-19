#!/bin/bash

# Create main project directory
mkdir -p nextcloud-traefik-project
cd nextcloud-traefik-project

# Create directories for Traefik
mkdir -p letsencrypt
mkdir -p traefik

# Create directories for Nextcloud
mkdir -p nextcloud/db
mkdir -p nextcloud/app
mkdir -p nextcloud/data

# Create a placeholder Traefik configuration file
touch traefik/traefik.yml

# Create a placeholder Dockerfile for Nextcloud
touch nextcloud/Dockerfile

echo "Directory structure created successfully!"