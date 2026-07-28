# Weekly Email News Digest Agent

An automated weekly news curation and delivery agent built with LangGraph, Google Gemini, and Tavily.

## Deployment to Google Cloud Platform (GCP)

Deploy the agent to GCP as a Cloud Run Job using Google Cloud Shell Editor:

### 1. Copy Files to Cloud Shell

In **Google Cloud Shell Editor**, create a project directory and copy `main.py`, `requirements.txt`, and `Procfile` into it.

### 2. Deploy to Cloud Run Jobs

Open the Cloud Shell terminal in that directory and run:

```bash
gcloud run jobs deploy news-breif-agent \
  --source . \
  --region YOUR_REGION \
  --set-env-vars "TAVILY_API_KEY=your_tavily_api_key,GOOGLE_API_KEY=your_google_api_key,EMAIL_SENDER=your_email@gmail.com,EMAIL_RECEIVER=recipient@example.com,EMAIL_PASSWORD=your_app_password,SMTP_SERVER=smtp.gmail.com,SMTP_PORT=465"
```

Replace `YOUR_REGION` with your target GCP region (e.g. `us-central1`) and set your API keys and email configuration values.

### 3. Execute or Schedule the Job

- **Execute Manually:**
  ```bash
  gcloud run jobs execute news-breif-agent --region YOUR_REGION
  ```

- **Schedule (Optional):** Use GCP Cloud Scheduler to trigger the Cloud Run Job automatically on a recurring schedule (e.g., weekly).
