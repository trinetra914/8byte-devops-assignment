FROM python:3.13-slim

WORKDIR /app

COPY app/requirements.txt .

# Force reinstallation to break cached vulnerable packages
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir --upgrade --force-reinstall pip setuptools>=78.1.1 msgpack>=1.2.1 \
    && pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]