#!/bin/bash

ZABBIX_SERVER_IP=""  # IP DO SEU SERVIDOR ZABBIX
HOSTNAME_AGENT="banco"   # NOME DO HOST QUE VAI USAR NA INTERFACE DO ZABBIX


echo "==> Baixando repositório Zabbix 7.0 para Ubuntu 24.04..."
wget -q https://repo.zabbix.com/zabbix/7.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_7.0-1+ubuntu24.04_all.deb

echo "==> Instalando pacote de repositório..."
dpkg -i zabbix-release_7.0-1+ubuntu24.04_all.deb

echo "==> Atualizando pacotes..."
apt update -y

echo "==> Instalando Zabbix Agent..."
apt install -y zabbix-agent

echo "==> Configurando Zabbix Agent..."
sed -i "s/^Server=.*/Server=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^ServerActive=.*/ServerActive=${ZABBIX_SERVER_IP}/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/^Hostname=.*/Hostname=${HOSTNAME_AGENT}/" /etc/zabbix/zabbix_agentd.conf


echo "==> Reiniciando e habilitando o serviço do agente..."
systemctl restart zabbix-agent
systemctl enable zabbix-agent

echo "==> Status do agente:"
systemctl status zabbix-agent --no-pager

echo ""
echo "Instalação e configuração do Zabbix Agent finalizada!"

