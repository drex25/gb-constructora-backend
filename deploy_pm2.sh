#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Strapi PM2 deploy (sin Docker) - amd64"

cd "$(dirname "$0")" || cd .

# 1) Paquetes del sistema (apt o dnf/yum)
PKG_MANAGER=""
if command -v apt-get >/dev/null 2>&1; then
  PKG_MANAGER="apt"
elif command -v dnf >/dev/null 2>&1; then
  PKG_MANAGER="dnf"
elif command -v yum >/dev/null 2>&1; then
  PKG_MANAGER="yum"
fi

echo "🔧 Instalando toolchain de compilación..."
case "$PKG_MANAGER" in
  apt)
    sudo apt-get update -y
    sudo apt-get install -y build-essential python3 g++ make libc6-dev libstdc++6 ca-certificates curl git
    ;;
  dnf)
    sudo dnf install -y @development-tools python3 gcc-c++ make glibc-static libstdc++-static ca-certificates curl git
    ;;
  yum)
    sudo yum groupinstall -y "Development Tools" || true
    sudo yum install -y python3 gcc-c++ make glibc-static libstdc++-static ca-certificates curl git
    ;;
  *)
    echo "⚠️  No se detectó apt/dnf/yum. Instala manualmente build tools y continúa."
    ;;
esac

# 2) Node 20 con nvm
if ! command -v nvm >/dev/null 2>&1; then
  echo "📦 Instalando nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  # shellcheck source=/dev/null
  source "$HOME/.bashrc" || true
  source "$HOME/.profile" || true
fi

if ! command -v nvm >/dev/null 2>&1; then
  # shellcheck source=/dev/null
  [ -s "$HOME/.nvm/nvm.sh" ] && . "$HOME/.nvm/nvm.sh" || true
fi

echo "🔢 Instalando Node 20..."
nvm install 20 >/dev/null
nvm use 20
node -v
npm -v

# 3) Preparar entorno .env
if [ ! -f .env ] && [ -f .env.production ]; then
  cp .env.production .env
  echo "✅ .env creado desde .env.production"
fi

# 4) Variables para SWC fallback y build nativos
export SWC_WASM=1
export npm_config_build_from_source=true

# 5) Instalar dependencias
echo "📦 Instalando dependencias..."
npm cache clean --force >/dev/null 2>&1 || true
rm -rf node_modules .cache dist build .tmp 2>/dev/null || true
npm install --legacy-peer-deps

# 6) Rebuild de binarios nativos
echo "🛠️  Rebuilding nativos (swc/sqlite)..."
npm rebuild @swc/core --verbose || true
npm rebuild better-sqlite3 --verbose || true

# 7) Compilar Strapi (admin + server)
echo "🏗️ Compilando Strapi..."
npx strapi build --debug

# 8) Arrancar con PM2
echo "🟢 Arrancando con PM2 en puerto 1337..."
npm i -g pm2 >/dev/null 2>&1 || sudo npm i -g pm2
pm2 start "npm run start" --name strapi --time
pm2 save
pm2 startup || true

# 9) Salud
echo "🔎 Verificando salud..."
sleep 3
if curl -fsS http://127.0.0.1:1337/_health >/dev/null 2>&1; then
  echo "✅ Strapi saludable en http://127.0.0.1:1337"
else
  echo "⚠️  Aún no responde el _health. Revisa logs: pm2 logs strapi"
fi

echo "✅ Listo. Logs: pm2 logs strapi"