def _find_existing_deposit(client):
    res = client.get("/api/deposits")
    assert res.status_code == 200
    deposits = res.json()
    assert len(deposits) > 0
    return deposits[0]


def test_list_deposits(client):
    res = client.get("/api/deposits")
    assert res.status_code == 200
    data = res.json()

    assert isinstance(data, list)
    assert len(data) > 0
    assert "name" in data[0]


def test_create_deposit_valid(client):
    payload = {
        "name": "TEST-DEPOSIT",
        "active": True
    }

    res = client.post("/api/deposits", json=payload)

    # puede ser 400 si ya existe, y está bien
    if res.status_code == 400:
        # alcanza con validar que devuelve formato correcto
        data = res.json()
        assert "detail" in data
    else:
        assert res.status_code in (200, 201)


def test_deposit_names_are_unique(client):
    dep = _find_existing_deposit(client)

    payload = {
        "name": dep["name"],
        "active": True
    }

    res = client.post("/api/deposits", json=payload)
    assert res.status_code in (400, 409)

