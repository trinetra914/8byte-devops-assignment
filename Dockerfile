FROM python:3.13-slim

WORKDIR /app

# Completely remove default pre-installed dist-info metadata directories
RUN rm -rf /usr/local/lib/python3.13/site-packages/*.dist-info \
    && rm -rf /usr/local/lib/python3.13/site-packages/*.egg-info

COPY app/requirements.txt .

RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]