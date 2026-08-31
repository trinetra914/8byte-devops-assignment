import os
import time

import psycopg
from flask import Flask, jsonify, request
from prometheus_client import Counter, Histogram, generate_latest
from prometheus_client import CONTENT_TYPE_LATEST


app = Flask(__name__)


# ----------------------------------------------------------------------
# Prometheus application metrics
# ----------------------------------------------------------------------

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total number of HTTP requests",
    ["method", "endpoint", "http_status"],
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency in seconds",
    ["method", "endpoint"],
)


@app.before_request
def before_request():
    request.start_time = time.time()


@app.after_request
def after_request(response):
    latency = time.time() - request.start_time

    REQUEST_COUNT.labels(
        method=request.method,
        endpoint=request.path,
        http_status=response.status_code,
    ).inc()

    REQUEST_LATENCY.labels(
        method=request.method,
        endpoint=request.path,
    ).observe(latency)

    return response


# ----------------------------------------------------------------------
# Application routes
# ----------------------------------------------------------------------

@app.route("/")
def home():
    return "8Byte DevOps Assignment Application"


@app.route("/health")
def health():
    return jsonify({"status": "healthy"})


@app.route("/version")
def version():
    return jsonify({"version": "1.0.0"})


@app.route("/db-health")
def db_health():
    try:
        connection = psycopg.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=os.getenv("DB_PORT", "5432"),
            dbname=os.getenv("DB_NAME", "testdb"),
            user=os.getenv("DB_USER", "testuser"),
            password=os.getenv("DB_PASSWORD", "testpassword"),
        )

        connection.close()

        return jsonify({"database": "healthy"}), 200

    except Exception:
        return jsonify({"database": "unhealthy"}), 503


# ----------------------------------------------------------------------
# Prometheus metrics endpoint
# ----------------------------------------------------------------------

@app.route("/metrics")
def metrics():
    return generate_latest(), 200, {
        "Content-Type": CONTENT_TYPE_LATEST
    }


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)