# ------------------------------------------------------------------------------
# Stage 1: Build & Dependency Installation
# ------------------------------------------------------------------------------
FROM python:3.13-slim AS builder

WORKDIR /build

COPY app/requirements.txt .

# Install dependencies into an isolated destination directory (/install)
RUN python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir --prefix=/install -r requirements.txt

# ------------------------------------------------------------------------------
# Stage 2: Minimal Production Runtime
# ------------------------------------------------------------------------------
FROM python:3.13-slim AS runner

WORKDIR /app

# 1. Patch OS security packages
# 2. Remove leftover system Python dist-packages to prevent Trivy false-positives
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /usr/lib/python3/dist-packages/*

# Copy only clean, upgraded dependencies from builder stage
COPY --from=builder /install /usr/local

# Copy application files
COPY app/ .

# Non-root user for security best practices
RUN useradd -m appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]