FROM python:3.13-slim

WORKDIR /app

# Clean pre-installed dist-info metadata to clear Trivy detection of legacy versions
RUN rm -rf /usr/local/lib/python3.13/site-packages/setuptools* \
    && rm -rf /usr/local/lib/python3.13/site-packages/msgpack*

COPY app/requirements.txt .

RUN apt-get update && apt-get upgrade -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && python -m pip install --no-cache-dir --upgrade --ignore-installed pip "setuptools>=78.1.1" "msgpack>=1.2.1" \
    && python -m pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 5000

CMD ["python", "app.py"]