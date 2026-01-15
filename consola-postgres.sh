#!/bin/bash
set -euo pipefail

echo ">> Abriendo consola psql en la base fnc_db como usuario postgres..."
sudo -u postgres psql -d fnc_db

