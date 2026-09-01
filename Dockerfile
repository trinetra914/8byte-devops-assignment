# ------------------------------------------------------------------------------
# Stage 1: Build & Dependency Installation
# ------------------------------------------------------------------------------
FROM python:3.13-slim AS builder

WORKDIR /build

COPY app/requirements.txt .

# Install dependencies into an isolated directory.
# pip and setuptools are only needed during the build stage.
RUN python -m pip install --no-cache-dir --upgrade pip setuptools \
    && python -m pip install --no-cache-dir --prefix=/install -r requirements.txt

# ------------------------------------------------------------------------------
# Stage 2: Minimal Production Runtime
# ------------------------------------------------------------------------------
FROM python:3.13-slim AS runner

WORKDIR /app

# Patch OS security packages and remove unnecessary system Python packages.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
              /usr/lib/python3/dist-packages/* \
              /usr/local/lib/python3.13/site-packages/pip \
              /usr/local/lib/python3.13/site-packages/pip-*.dist-info

# Copy only application dependencies from the builder.
COPY --from=builder /install /usr/local

# Copy application package.
COPY app/ /app/app/

# Copy tests for CI/integration testing.
COPY tests/ /app/tests/

# Run as non-root user.
RUN useradd -m appuser \
    && chown -R appuser:appuser /app

USER appuser

EXPOSE 5000

CMD ["python", "app/app.py"]