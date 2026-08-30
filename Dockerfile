FROM python:3.13-slim

WORKDIR /app

COPY app/requirements.txt .

RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt \
    && find /usr/lib/python3* -name "*msgpack*" -o -name "*setuptools*" | xargs rm -rf \
    && find /usr/local/lib/python3*/site-packages -name "setuptools-70*" -o -name "msgpack-1.1*" | xargs rm -rf

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]