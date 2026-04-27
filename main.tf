provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}

# Enable required APIs
resource "google_project_service" "run_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "scheduler_api" {
  service            = "cloudscheduler.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry_api" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# Artifact Registry for the Docker image
resource "google_artifact_registry_repository" "repo" {
  location      = "us-central1"
  repository_id = "email-digest-repo"
  description   = "Docker repository for news agent"
  format        = "DOCKER"
  depends_on    = [google_project_service.artifact_registry_api]
}

# Cloud Run Job
resource "google_cloud_run_v2_job" "news_agent_job" {
  name     = "news-agent-job"
  location = "us-central1"

  template {
    template {
      containers {
        image = "us-central1-docker.pkg.dev/your-project-id/email-digest-repo/news-agent-job:latest"

        env {
          name  = "TAVILY_API_KEY"
          value = "your_tavily_api_key_here"
        }
        env {
          name  = "GOOGLE_API_KEY"
          value = "your_google_api_key_here"
        }
        env {
          name  = "EMAIL_SENDER"
          value = "your-email@gmail.com"
        }
        env {
          name  = "EMAIL_RECEIVER"
          value = "recipient@example.com"
        }
        env {
          name  = "EMAIL_PASSWORD"
          value = "your-app-password"
        }
        env {
          name  = "SMTP_SERVER"
          value = "smtp.gmail.com"
        }
        env {
          name  = "SMTP_PORT"
          value = "465"
        }
      }
    }
  }

  depends_on = [google_project_service.run_api]
}

# Cloud Scheduler to trigger the job every Monday at 6 AM PT
resource "google_cloud_scheduler_job" "scheduler" {
  name             = "trigger-news-agent-job"
  description      = "Trigger the news agent Cloud Run job every Monday at 6 AM PT"
  schedule         = "0 6 * * 1"
  time_zone        = "America/Los_Angeles"
  attempt_deadline = "320s"

  http_target {
    http_method = "POST"
    uri         = "https://us-central1-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/your-project-id/jobs/news-agent-job:run"

    oauth_token {
      service_account_email = "your-project-id-compute@developer.gserviceaccount.com"
    }
  }

  depends_on = [google_project_service.scheduler_api, google_cloud_run_v2_job.news_agent_job]
}
