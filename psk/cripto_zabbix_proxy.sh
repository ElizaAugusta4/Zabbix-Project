#!/bin/bash

set -e

# Variáveis
PSK_IDENTITY="raspberrypi"
PSK_FILE="/home/zabbix/secret.psk"
ZABBIX_CONF="/etc/zabbix/zabbix_proxy.conf"

echo "[+] Gerando chave PSK..."
openssl rand -hex 32 > secret.psk
echo "[+] PSK gerado: $(cat secret.psk)"

echo "[+] Criando diretório para o usuário zabbix..."
mkdir -p /home/zabbix

echo "[+] Movendo chave para /home/zabbix/"
mv secret.psk /home/zabbix/

echo "[+] Ajustando permissões..."
chown -R zabbix:zabbix /home/zabbix
chmod 600 /home/zabbix/secret.psk

echo "[+] Configurando criptografia PSK no arquivo $ZABBIX_CONF..."
sed -i "s|^#*TLSConnect=.*|TLSConnect=psk|" $ZABBIX_CONF
sed -i "s|^#*TLSAccept=.*|TLSAccept=psk|" $ZABBIX_CONF
sed -i "s|^#*TLSPSKIdentity=.*|TLSPSKIdentity=$PSK_IDENTITY|" $ZABBIX_CONF
sed -i "s|^#*TLSPSKFile=.*|TLSPSKFile=$PSK_FILE|" $ZABBIX_CONF

echo "[+] Reiniciando serviço do Zabbix Proxy..."
systemctl restart zabbix-proxy
systemctl enable zabbix-proxy

echo "[✓] Criptografia PSK ativada com sucesso!"

echo "🚨 IMPORTANTE: Acesse a UI do Zabbix Server e vá em:"
echo "   Administração ⇾ Proxies ⇾ [Seu Proxy] ⇾ Criptografia"
echo "   - Tipo de conexão: PSK"
echo "   - Identidade (PSK Identity): $PSK_IDENTITY"
echo "   - PSK (cole o valor abaixo):"
cat /home/zabbix/secret.psk
echo ""
echo "✅ O nome da identidade e o conteúdo da PSK devem ser IGUAIS ao configurado no Proxy"
