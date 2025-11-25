# Use official Python image
FROM python:3.10-slim

# Prevent Python from writing .pyc files & enabling buffer
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies
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

# Create staticfiles directory before collectstatic
RUN mkdir -p /app/staticfiles

# Collect static files
RUN python manage.py collectstatic --noinput

# Expose port 8000
EXPOSE 8000

# Start Django using Gunicorn
CMD ["gunicorn", "cybersecurity.wsgi:application", "--bind", "0.0.0.0:8000"]
