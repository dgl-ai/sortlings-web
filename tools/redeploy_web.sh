# Redespliegue del build web de Sortlings en el VPS tras un push a dgl-ai/sortlings-web
#
# Uso (en el VPS, como root):
#   bash tools/redeploy_web.sh [rama]
#
# Qué hace:
# 1. git pull de https://github.com/dgl-ai/sortlings-web (checkout en /opt/sortlings-web/code)
# 2. reinicia el servicio swarm sortlings-web (nginx sirve los ficheros en caliente)
# 3. verifica con curl que la URL responde 200
#
# Ver documentación completa en Infra/VPS/Servicios.md del vault.

set -euo pipefail
BRANCH="${1:-main}"
CODE_DIR="/opt/sortlings-web/code"

cd "$CODE_DIR"
git fetch origin "$BRANCH"
git reset --hard "origin/$BRANCH"

docker service update --force sortlings-web >/dev/null
sleep 3

echo "--- verificación ---"
curl -sI "https://sortlings.dglabs.cloud/" | head -1
git log --oneline -1
