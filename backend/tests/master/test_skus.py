import uuid


def test_list_skus(client):
    res = client.get("/api/skus")
    assert res.status_code == 200
    assert isinstance(res.json(), list)


def test_create_valid_sku(client):
    # Código único para evitar duplicados
    code = f"TEST-{uuid.uuid4().hex[:6]}"

    payload = {
        "code": code,
        "name": "SKU Test",
        "tag": "PT",
        "unit": "unit",
        "active": True
    }

    res = client.post("/api/skus", json=payload)
    print(res.json())
    assert res.status_code in (200, 201)

    data = res.json()
    assert data["code"] == code

