#!/bin/bash

# ───────────────────────────────
# 📦 Script de instalação do Zabbix 7.0 LTS no Ubuntu 24.04
# Banco de dados: MySQL | Servidor Web: Apache
# ───────────────────────────────

set -e

echo "👉 Verificando permissões..."
if [ "$EUID" -ne 0 ]; then
  echo "❌ Por favor, execute como root ou com sudo"
  exit 1
fi

echo "✅ Permissões OK. Iniciando instalação..."

# 1. Baixar e instalar o repositório Zabbix
echo "🔽 Baixando repositório Zabbix..."
wget https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu24.04_all.deb

echo "📦 Instalando pacote do repositório..."
dpkg -i zabbix-release_7.0-1+ubuntu24.04_all.deb

echo "🔄 Atualizando lista de pacotes..."
apt update

# 2. Verificação opcional de pacotes disponíveis
echo "🔍 Verificando pacotes Zabbix disponíveis (opcional)..."
apt search zabbix | grep zabbix

# 3. Instalar os pacotes principais do Zabbix
echo "🚀 Instalando Zabbix Server, Frontend, Agent e scripts SQL..."
apt install -y zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent

# 4. Verificar o status dos serviços (esperado que estejam "dead" antes de configuração)
echo "📡 Verificando status dos serviços Zabbix..."

echo "🔎 zabbix-server:"
service zabbix-server status || true

echo "🔎 zabbix-agent:"
service zabbix-agent status || true

echo "✅ Instalação básica do Zabbix finalizada com sucesso!"
echo "👉 Próximos passos: configurar banco de dados e iniciar os serviços."
