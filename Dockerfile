FROM python:3.13-slim

WORKDIR /app

COPY app/requirements.txt .

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir --upgrade msgpack setuptools

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]