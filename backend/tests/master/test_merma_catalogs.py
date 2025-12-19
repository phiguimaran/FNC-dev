def test_list_merma_types(client):
    res = client.get("/api/mermas/types")
    assert res.status_code == 200

    data = res.json()
    assert isinstance(data, list)
    assert len(data) > 0
    assert "stage" in data[0]
    assert "code" in data[0]


def test_list_merma_causes(client):
    res = client.get("/api/mermas/causes")
    assert res.status_code == 200

    data = res.json()
    assert isinstance(data, list)
    assert len(data) > 0
    assert "stage" in data[0]
    assert "code" in data[0]

