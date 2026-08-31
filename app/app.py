import os

import psycopg
from flask import Flask, jsonify

app = Flask(__name__)


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


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)