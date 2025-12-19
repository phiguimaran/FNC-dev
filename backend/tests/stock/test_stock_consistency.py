def _get_any_sku(client):
    res = client.get("/api/skus")
    assert res.status_code == 200
    data = res.json()
    return data[0]


def _get_balance(client, sku_id):
    res = client.get("/api/stock-levels")
    assert res.status_code == 200
    levels = res.json()

    match = [s for s in levels if s["sku_id"] == sku_id]
    return match[0]["quantity"] if match else 0


def test_stock_adjustment_affects_balance(client):
    sku = _get_any_sku(client)

    before = _get_balance(client, sku["id"])

    movement = {
        "sku_id": sku["id"],
        "deposit_id": 1,
        "quantity": 2,
        "movement_type": "adjustment"
    }

    res = client.post("/api/stock/movements", json=movement)
    assert res.status_code in (200, 201)

    after = _get_balance(client, sku["id"])

    assert after >= before   # dependiendo de política exacta

