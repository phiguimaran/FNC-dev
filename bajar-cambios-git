#!/bin/bash
set -euo pipefail

cd /home/adminuser/proyectos/FNC-dev

echo ">> Bajando cambios de origin/main y descartando cambios locales en archivos versionados..."
git fetch origin
git reset --hard origin/main

echo ">> Estado actual:"
git status

