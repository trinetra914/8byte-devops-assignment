FROM python:3.13-slim

WORKDIR /app

# Update OS packages to patched versions
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

COPY app/requirements.txt .

# Install Python dependencies and update vulnerable packages
RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir --upgrade setuptools msgpack

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]