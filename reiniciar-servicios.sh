#!/bin/bash
set -euo pipefail

echo ">> Backend: reiniciar servicio"
sudo systemctl restart fnc-backend
sudo systemctl status fnc-backend --no-pager

echo ">> Nginx (Frontend): probar configuración y recargar"
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl status nginx --no-pager

echo ">> Listo: servicios reiniciados."

