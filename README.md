# Weekly Email News Digest Agent

An automated weekly news curation and delivery system built with LangGraph, Google Gemini, and Tavily. This agent researches specific company news from the past week, analyzes the findings, and delivers a formatted weekly briefing via email every Monday.

## Features

- **Automated Research:** Uses the Tavily Search API to find the latest news from the past week, specifically configured to filter out social media and Wikipedia for high-quality sources.
- **Intelligent Analysis:** Leverages Google Gemini (Gemini 2.5 Flash) to synthesize raw news into a concise, actionable weekly summary.
- **Agentic Workflow:** Built using LangGraph to manage the state and transitions between research, analysis, and delivery.
- **Email Delivery:** Automatically formats the summary into a professional HTML/Markdown weekly email and sends it via SMTP.
- **Cloud Native:** Deployed to Google Cloud Platform using Cloud Run Jobs and Cloud Scheduler for reliable, serverless execution.

## Workflow

1.  **Research Node:** Queries Tavily for news related to "The Wonderful Company" and its brands (FIJI Water, Wonderful Pistachios, etc.) from the past week.
2.  **Analyst Node:** Processes the search results to identify key business milestones and updates for a weekly briefing.
3.  **Email Node:** Generates a dual-format (Plain Text & HTML) weekly email and dispatches it through a configured SMTP server.

## Deployment

The system is hosted on **Google Cloud Platform** and is scheduled to run **every Monday at 6:00 AM PT**.

### Infrastructure (Terraform)

The project includes a `main.tf` file to provision the necessary GCP resources:
- **Artifact Registry:** To store the containerized agent image.
- **Cloud Run Job:** To execute the agentic workflow in a serverless environment.
- **Cloud Scheduler:** To trigger the Cloud Run Job on the weekly schedule.

To deploy using Terraform:
1. Update `main.tf` with your GCP Project ID and desired API keys.
2. Initialize and apply:
   ```bash
   terraform init
   terraform apply
   ```

### Manual Deployment

Alternatively, use the provided `deploy.sh` script to build the image and create the Cloud Run job manually.

## Prerequisites

- Python 3.10+
- [Tavily API Key](https://tavily.com/)
- [Google AI (Gemini) API Key](https://aistudio.google.com/)
- SMTP Credentials (e.g., Gmail App Password)

## Installation

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd email-digest
    ```

2.  **Create and activate a virtual environment:**
    ```bash
    python -m venv .venv
    # On Windows:
    .\.venv\Scripts\activate
    # On macOS/Linux:
    source .venv/bin/activate
    ```

3.  **Install dependencies:**
    ```bash
    pip install -r requirements.txt
    ```

## Configuration

Create a `.env` file in the root directory with the following variables:

```env
# API Keys
TAVILY_API_KEY=your_tavily_key
GOOGLE_API_KEY=your_google_api_key

# Email Settings
EMAIL_SENDER=your-email@gmail.com
EMAIL_RECEIVER=recipient@example.com
EMAIL_PASSWORD=your-app-password
SMTP_SERVER=smtp.gmail.com
SMTP_PORT=465
```

## Usage

Run the agent locally using:

```bash
python main.py
```

The agent will log its progress through the nodes and print the final weekly email content to the console before attempting to send.

## License

MIT
