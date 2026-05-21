import pytest
from app.main import app


@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client


def test_health_returns_200(client):
    response = client.get("/health")
    assert response.status_code == 200


def test_health_returns_healthy_status(client):
    response = client.get("/health")
    data = response.get_json()
    assert data["status"] == "healthy"


def test_hello_returns_200(client):
    response = client.get("/hello")
    assert response.status_code == 200


def test_hello_returns_message(client):
    response = client.get("/hello")
    data = response.get_json()
    assert data["message"] == "Hello, World!"


def test_unknown_route_returns_404(client):
    response = client.get("/nonexistent")
    assert response.status_code == 404
