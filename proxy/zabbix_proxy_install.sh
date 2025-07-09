#!/bin/bash

set -e

# Variáveis editáveis
ZABBIX_SERVER=""       # IP do servidor Zabbix 
PROXY_HOSTNAME=""       # Nome do proxy (deve ser igual na UI do Zabbix) 
DB_PATH="/tmp/zabbix_proxy.db"      # Caminho do banco SQLite3

# Atualiza pacotes e instala dependências
echo "[+] Atualizando pacotes..."
apt update

# Baixa e instala o repositório Zabbix
echo "[+] Baixando repositório Zabbix..."
wget https://repo.zabbix.com/zabbix/7.0/raspbian/pool/main/z/zabbix-release/zabbix-release_latest+debian12_all.deb
dpkg -i zabbix-release_latest+debian12_all.deb

# Atualiza após adicionar o repositório
apt update

# Instala o Zabbix Proxy com SQLite3
echo "[+] Instalando Zabbix Proxy (SQLite3)..."
apt install -y zabbix-proxy-sqlite3

# Edita o arquivo de configuração do proxy
echo "[+] Configurando zabbix_proxy.conf..."
sed -i "s|^Server=.*|Server=$ZABBIX_SERVER|" /etc/zabbix/zabbix_proxy.conf
sed -i "s|^Hostname=.*|Hostname=$PROXY_HOSTNAME|" /etc/zabbix/zabbix_proxy.conf
sed -i "s|^DBName=.*|DBName=$DB_PATH|" /etc/zabbix/zabbix_proxy.conf

# Garante que o diretório de log existe
mkdir -p /var/log/zabbix
chown zabbix:zabbix /var/log/zabbix

# Inicia e habilita o serviço do proxy
echo "[+] Iniciando serviço do Zabbix Proxy..."
systemctl restart zabbix-proxy
systemctl enable zabbix-proxy

echo "[✓] Instalação e configuração finalizadas!"
echo "👉 Agora acesse a interface do Zabbix e vá em: Administração ⇾ Proxies ⇾ Criar novo"
echo "   - Nome: $PROXY_HOSTNAME"
echo "   - Modo: Ativo"
echo "✅ O nome deve ser IGUAL ao definido na opção Hostname do arquivo de configuração"
