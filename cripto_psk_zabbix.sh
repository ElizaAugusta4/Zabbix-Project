#!/bin/bash

# Variáveis
PSK_DIR="/home/zabbix"
PSK_FILE="$PSK_DIR/secret.psk"
PSK_IDENTITY="zabbix-psk-id"  
ZABBIX_USER="zabbix"

# Criar diretório
echo "[*] Criando diretório $PSK_DIR..."
mkdir -p "$PSK_DIR"

# Gerar PSK
echo "[*] Gerando chave PSK..."
openssl rand -hex 32 > "$PSK_FILE"

# Definir permissões
echo "[*] Aplicando permissões..."
chown $ZABBIX_USER:$ZABBIX_USER "$PSK_FILE"
chmod 640 "$PSK_FILE"

# Detectar versão do agente
if [ -f /etc/zabbix/zabbix_agent2.conf ]; then
  AGENT_CONF="/etc/zabbix/zabbix_agent2.conf"
  AGENT_SERVICE="zabbix-agent2"
elif [ -f /etc/zabbix/zabbix_agentd.conf ]; then
  AGENT_CONF="/etc/zabbix/zabbix_agentd.conf"
  AGENT_SERVICE="zabbix-agent"
else
  echo "[ERRO] Nenhuma configuração do agente Zabbix encontrada!"
  exit 1
fi

# Inserir ou atualizar configurações no arquivo de configuração
echo "[*] Configurando $AGENT_CONF..."
sed -i '/^TLSConnect=/d' "$AGENT_CONF"
sed -i '/^TLSAccept=/d' "$AGENT_CONF"
sed -i '/^TLSPSKFile=/d' "$AGENT_CONF"
sed -i '/^TLSPSKIdentity=/d' "$AGENT_CONF"

echo "TLSConnect=psk" >> "$AGENT_CONF"
echo "TLSAccept=psk" >> "$AGENT_CONF"
echo "TLSPSKFile=$PSK_FILE" >> "$AGENT_CONF"
echo "TLSPSKIdentity=$PSK_IDENTITY" >> "$AGENT_CONF"

# Reiniciar o agente
echo "[*] Reiniciando serviço $AGENT_SERVICE..."
systemctl restart "$AGENT_SERVICE"

# Verificar status
echo "[*] Status do agente:"
systemctl status "$AGENT_SERVICE" --no-pager

# Exibir chave e identidade para configuração no frontend
echo
echo "⚠️  Adicione essas informações na interface do Zabbix Server:"
echo "PSK Identity  : $PSK_IDENTITY"
echo "PSK (hex)     : $(cat "$PSK_FILE")"
