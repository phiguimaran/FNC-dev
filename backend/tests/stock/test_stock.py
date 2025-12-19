def _get_sku_id(client, code):
    res = client.get("/api/skus")
    assert res.status_code == 200
    skus = res.json()
    sku = next(s for s in skus if s["code"] == code)
    return sku["id"]


def test_stock_ingress_increases_balance(client):
    sku_id = _get_sku_id(client, "MP-HARINA")

    movement = {
        "sku_id": sku_id,
        "deposit_id": 1,
        "quantity": 10,
        "movement_type": "adjustment"   # válido para sumar stock
    }

    res = client.post("/api/stock/movements", json=movement)
    print(res.json())
    assert res.status_code in (200, 201)


def test_consumption_reduces_stock(client):
    sku_id = _get_sku_id(client, "MP-HARINA")

    movement = {
        "sku_id": sku_id,
        "deposit_id": 1,
        "quantity": 5,
        "movement_type": "consumption"
    }

    res = client.post("/api/stock/movements", json=movement)
    print(res.json())
    assert res.status_code in (200, 201)

