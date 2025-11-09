FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Install dependencies first (better Docker caching)
COPY requirements.txt .

RUN python -m pip install --upgrade pip wheel && \
    pip install -r requirements.txt

# Copy your entire project (not just service/)
COPY . .

# Create non-root user
RUN useradd -m service && \
    chown -R service:service /app

USER service

# Gunicorn expects a module:app format
ENV PORT=8000
EXPOSE 8000

CMD ["gunicorn", "service.routes:app", "--bind", "0.0.0.0:8000"]
