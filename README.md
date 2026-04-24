# Email News Digest Agent

An automated news curation and delivery system built with LangGraph, Google Gemini, and Tavily. This agent researches specific company news, analyzes the findings, and delivers a formatted briefing via email.

## Features

- **Automated Research:** Uses the Tavily Search API to find the latest news, specifically configured to filter out social media and Wikipedia for high-quality sources.
- **Intelligent Analysis:** Leverages Google Gemini (Gemini 2.5 Flash) to synthesize raw news into a concise, actionable summary.
- **Agentic Workflow:** Built using LangGraph to manage the state and transitions between research, analysis, and delivery.
- **Email Delivery:** Automatically formats the summary into a professional HTML/Markdown email and sends it via SMTP.
- **Containerized:** Includes a `Dockerfile` for easy deployment to cloud platforms like Google Cloud Run.

## Workflow

1.  **Research Node:** Queries Tavily for news related to "The Wonderful Company" and its brands (FIJI Water, Wonderful Pistachios, etc.).
2.  **Analyst Node:** Processes the search results to identify key business milestones and updates.
3.  **Email Node:** Generates a dual-format (Plain Text & HTML) email and dispatches it through a configured SMTP server.

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

The agent will log its progress through the nodes and print the final email content to the console before attempting to send.

## License

MIT
