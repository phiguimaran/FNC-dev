def test_health_ok(client):
    res = client.get("/api/health")
    assert res.status_code == 200

    data = res.json()
    assert data["status"] == "ok"
    assert "version" in data
