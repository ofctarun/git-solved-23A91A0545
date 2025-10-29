#!/bin/bash
# Unified Deployment Script (Production + Development)
# Version: 2.0.0

set -e

echo "====================================="
echo "DevOps Simulator - Unified Deployment"
echo "====================================="

# ---------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------
# Default environment is production. Override using: ./scripts/deploy.sh dev
DEPLOY_ENV=${1:-production}

if [ "$DEPLOY_ENV" = "production" ]; then
  DEPLOY_REGION="us-east-1"
  APP_PORT=8080
  echo "Environment: $DEPLOY_ENV"
  echo "Region: $DEPLOY_REGION"
  echo "Port: $APP_PORT"

  echo "Running pre-deployment checks..."
  if [ ! -f "config/app-config.yaml" ]; then
      echo "Error: Configuration file not found!"
      exit 1
  fi

  echo "Starting production deployment..."
  echo "Pulling latest Docker images..."
  # docker pull devops-simulator:latest

  echo "Rolling update strategy initiated..."
  # kubectl rolling-update devops-simulator

  echo "Deployment completed successfully!"
  echo "Application available at: https://app.example.com"

else
  DEPLOY_MODE="docker-compose"
  APP_PORT=3000
  ENABLE_DEBUG=true
  echo "Environment: $DEPLOY_ENV"
  echo "Mode: $DEPLOY_MODE"
  echo "Port: $APP_PORT"
  echo "Debug: $ENABLE_DEBUG"

  echo "Running pre-deployment checks..."
  if [ ! -f "config/app-config.yaml" ]; then
      echo "Error: Configuration file not found!"
      exit 1
  fi

  echo "Installing dependencies..."
  npm install

  echo "Running tests..."
  npm test

  echo "Starting development deployment..."
  echo "Using Docker Compose..."
  docker-compose up -d

  echo "Waiting for application to be ready..."
  sleep 5

  echo "Performing health check..."
  curl -f http://localhost:$APP_PORT/health || exit 1

  echo "Deployment completed successfully!"
  echo "Application available at: http://localhost:$APP_PORT"
  echo "Hot reload enabled - code changes will auto-refresh"
fi
