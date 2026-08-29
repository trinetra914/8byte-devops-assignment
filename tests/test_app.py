import unittest

from app.app import app


class TestApplication(unittest.TestCase):

    def setUp(self):
        self.client = app.test_client()

    def test_home(self):
        response = self.client.get("/")
        self.assertEqual(response.status_code, 200)
        self.assertEqual(
            response.get_data(as_text=True),
            "8Byte DevOps Assignment Application"
        )

    def test_health(self):
        response = self.client.get("/health")
        self.assertEqual(response.status_code, 200)

        data = response.get_json()
        self.assertEqual(data["status"], "healthy")

    def test_version(self):
        response = self.client.get("/version")
        self.assertEqual(response.status_code, 200)

        data = response.get_json()
        self.assertEqual(data["version"], "1.0.0")


if __name__ == "__main__":
    unittest.main()