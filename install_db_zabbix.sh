#!/bin/bash

set -e

DB_NAME="zabbix"
DB_USER="zabbix"
DB_PASS="password"

echo "### Verificando se MySQL está instalado..."

if ! command -v mysql >/dev/null 2>&1; then
  echo "MySQL não encontrado. Instalando mysql-server..."
  apt update
  apt install -y mysql-server
else
  echo "MySQL já instalado."
fi

echo "### Verificando status do serviço MySQL..."
systemctl enable mysql
systemctl start mysql
systemctl status mysql --no-pager

echo "### Criando banco e usuário Zabbix..."

mysql -u root <<EOF
DROP DATABASE IF EXISTS ${DB_NAME};
CREATE DATABASE ${DB_NAME} CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SET GLOBAL log_bin_trust_function_creators = 1;
EOF

echo "### Importando schema do Zabbix Server..."
zcat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -u${DB_USER} -p${DB_PASS} ${DB_NAME}

echo "### Desabilitando log_bin_trust_function_creators..."
mysql -u root <<EOF
SET GLOBAL log_bin_trust_function_creators = 0;
EOF

echo "### Banco Zabbix criado e schema importado com sucesso!"
echo "### Agora edite /etc/zabbix/zabbix_server.conf e configure:"
echo "DBPassword=${DB_PASS}"

