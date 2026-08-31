import os
import unittest

import psycopg

from app.app import app


class TestDatabaseIntegration(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.connection = psycopg.connect(
            host=os.getenv("DB_HOST", "localhost"),
            port=os.getenv("DB_PORT", "5432"),
            dbname=os.getenv("DB_NAME", "testdb"),
            user=os.getenv("DB_USER", "testuser"),
            password=os.getenv("DB_PASSWORD", "testpassword"),
        )

    @classmethod
    def tearDownClass(cls):
        cls.connection.close()

    def setUp(self):
        self.client = app.test_client()

    def test_database_connection(self):
        response = self.client.get("/db-health")

        self.assertEqual(response.status_code, 200)

        data = response.get_json()

        self.assertEqual(data["database"], "healthy")


if __name__ == "__main__":
    unittest.main()