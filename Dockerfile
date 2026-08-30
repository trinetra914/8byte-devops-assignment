FROM python:3.13-slim

WORKDIR /app

COPY app/requirements.txt .

# 1. Update OS packages
# 2. Force-remove system-bundled older setuptools/msgpack via pip
# 3. Upgrade to secure versions and install requirements
RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip uninstall -y setuptools msgpack || true \
    && python -m pip install --no-cache-dir --upgrade pip "setuptools>=78.1.1" "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]