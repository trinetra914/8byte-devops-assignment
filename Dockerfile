FROM python:3.13-slim

WORKDIR /app

COPY app/requirements.txt .

RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && rm -rf /usr/lib/python3*/dist-packages/*.egg-info \
    && rm -rf /usr/lib/python3*/dist-packages/*.dist-info \
    && rm -rf /usr/local/lib/python3.13/site-packages/setuptools-70*.dist-info \
    && rm -rf /usr/local/lib/python3.13/site-packages/msgpack-1.1*.dist-info

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]