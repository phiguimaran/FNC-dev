import os
import sys
from pathlib import Path

# --- IMPORTANTE: esto va primero ---
os.environ["DATABASE_URL"] = os.getenv(
    "DATABASE_URL",
    "postgresql://postgres:20251212@localhost:5432/fnc_test"
)
os.environ["LOAD_SEED"] = "true"
# -----------------------------------

# Asegura que la carpeta backend esté en PYTHONPATH
BASE_DIR = Path(__file__).resolve().parents[1]
sys.path.append(str(BASE_DIR))

import pytest
from fastapi.testclient import TestClient
from app.main import app
from app.db import init_db


# =======================
# AUTH OVERRIDE PARA TEST
# =======================

try:
    # el nombre puede variar; si falla este import me avisas
    from app.core.auth import get_current_user
except Exception:
    # fallback posible (por si Codex lo puso en otro lado)
    from app.api.dependencies.auth import get_current_user


def override_current_user():
    """
    Usuario fake con rol admin para tests.
    Evita necesidad de login / JWT.
    """
    return {
        "id": 1,
        "username": "test-admin",
        "role": "admin",
    }


app.dependency_overrides[get_current_user] = override_current_user


@pytest.fixture(scope="session", autouse=True)
def setup_database():
    """
    Inicializa la base de datos de test + seeds.
    Se ejecuta una sola vez por sesión de pytest.
    """
    init_db()
    yield


@pytest.fixture()
def client():
    """
    Cliente HTTP para pruebas.
    """
    return TestClient(app)
