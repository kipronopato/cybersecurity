# Use official Python image
FROM python:3.10-slim

# Prevent Python from writing .pyc files & enable unbuffered output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies (for psycopg2 and other libs)
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy requirement files
COPY requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy entire project
COPY . /app/

# Create staticfiles directory (Django will use this for collectstatic)
RUN mkdir -p /app/staticfiles

# Expose port 8000
EXPOSE 8000

# Start Django using Gunicorn
CMD ["gunicorn", "cybersecurity.wsgi:application", "--bind", "0.0.0.0:8000"]
