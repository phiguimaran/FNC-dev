#!/bin/bash
set -euo pipefail

echo ">> Frontend: instalar dependencias y hacer build"
cd /home/adminuser/proyectos/FNC-dev/frontend
npm ci
npm run build

echo ">> Backend: instalar dependencias y reiniciar servicio"
cd /home/adminuser/proyectos/FNC-dev/backend
source .venv/bin/activate
pip install -U pip
pip install -r requirements.txt
deactivate

sudo systemctl restart fnc-backend
sudo systemctl status fnc-backend --no-pager

echo ">> Nginx: probar configuración y recargar"
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl status nginx --no-pager

echo ">> Listo: backend y frontend actualizados y levantados."

