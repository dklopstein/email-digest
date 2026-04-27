#!/bin/bash

# Configuration - Update these values
PROJECT_ID=$(gcloud config get-value project)
REGION="us-central1"
REPO_NAME="email-digest-repo"
JOB_NAME="news-agent-job"
IMAGE_NAME="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPO_NAME}/${JOB_NAME}:latest"

echo "Using Project ID: ${PROJECT_ID}"

# 1. Create Artifact Registry repository if it doesn't exist
gcloud artifacts repositories create ${REPO_NAME} \
    --repository-format=docker \
    --location=${REGION} \
    --description="Docker repository for news agent" \
    || echo "Repository already exists"

# 2. Build and push the Docker image using Cloud Build
gcloud builds submit --tag ${IMAGE_NAME} .

# 3. Create the Cloud Run Job
gcloud run jobs create ${JOB_NAME} \
    --image ${IMAGE_NAME} \
    --region ${REGION} \
    --memory 512Mi \
    --task-timeout 10m \
    --set-env-vars "TAVILY_API_KEY=your_tavily_key,GOOGLE_API_KEY=your_google_key" \
    || gcloud run jobs update ${JOB_NAME} --image ${IMAGE_NAME} --region ${REGION}

# 4. Create Cloud Scheduler job to trigger every Monday at 9:00 AM PT
# Note: Cloud Run Jobs require an authenticated HTTP request to the Job Run endpoint
# The URI follows the pattern: https://{REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/{PROJECT_ID}/jobs/{JOB_NAME}:run

SCHEDULE_NAME="trigger-${JOB_NAME}"
gcloud scheduler jobs create http ${SCHEDULE_NAME} \
    --schedule="0 9 * * 1" \
    --time-zone="America/Los_Angeles" \
    --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT_ID}/jobs/${JOB_NAME}:run" \
    --http-method=POST \
    --oauth-service-account-email="${PROJECT_ID}-compute@developer.gserviceaccount.com" \
    || gcloud scheduler jobs update http ${SCHEDULE_NAME} --schedule="0 9 * * 1"

echo "Deployment configuration complete!"
