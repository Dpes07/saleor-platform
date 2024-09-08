FROM ghcr.io/saleor/saleor:3.20 AS saleor-base


# Working directory

WORKDIR /app

# Set environment variables
ENV JAEGER_AGENT_HOST=jaeger
ENV DASHBOARD_URL=http://localhost:9000/
ENV ALLOWED_HOSTS=localhost,api

# Dockerfile for API Service
FROM saleor-base AS api

EXPOSE 8000

# DB URL
ENV DATABASE_URL=postgres://saleor:saleor@postgres:5432/saleor

# Run migrations and runserver
CMD ["sh", "-c", "python manage.py migrate && python manage.py runserver 0.0.0.0:8000"]

# Dockerfile for Worker Service
FROM saleor-base AS worker

# Command to run the Celery worker
CMD ["celery", "-A", "saleor", "worker", "--loglevel=info", "-B"]

# Dockerfile for Saleor Dashboard
FROM ghcr.io/saleor/saleor-dashboard:latest AS dashboard

# Expose the port Saleor Dashboard is running on
EXPOSE 80

# Command to run the Saleor Dashboard
CMD ["nginx", "-g", "daemon off;"]

# Dockerfile for Jaeger
FROM jaegertracing/all-in-one AS jaeger

# Expose the necessary ports
EXPOSE 5775/udp 6831/udp 6832/udp 5778 16686 14268 9411

# Command to run Jaeger
CMD ["jaeger-all-in-one"]

# Dockerfile for Mailpit
FROM axllent/mailpit AS mailpit

# Expose the SMTP and web UI ports
EXPOSE 1025 8025

# Command to run Mailpit
CMD ["mailpit","servce"]





