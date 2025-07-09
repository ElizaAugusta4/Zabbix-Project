# Zabbix-Project

Repositório com scripts Shell para automação da instalação e configuração de componentes do Zabbix:

- **Zabbix Agent**
- **Zabbix Proxy**
- **Criptografia PSK**
- **Banco de Dados (MySQL)**

Este projeto tem como objetivo simplificar a ambientação de um ambiente de monitoramento completo, ideal para cenários de produção ou testes de infraestrutura.

## 📹 Demonstração

No vídeo de apresentação, explico passo a passo como:

- Criar **itens** personalizados
- Configurar **templates**
- Adicionar e configurar **media types**
- Criar **triggers** eficientes
- Cadastrar e organizar **hosts**

## 📁 Estrutura do Projeto

```

zabbix-project/
├── agent/
│   └── zabbix_agent.sh
├── proxy/
│   └── zabbix_proxy_install.sh
├── psk/
│   └── cripto_psk_zabbix_psk.sh
|   |__ cripto_zabbix_proxy.sh
├── database/
│   └── install_db_Zabbix.sh
└── README.md

````

## 🚀 Como usar

1. Clone o repositório:
   ```bash
   git clone https://github.com/ElizaAugusta4/Zabbix-Project.git
   cd Zabbix-Project
````

2. Dê permissão de execução aos scripts:

   ```bash
   chmod +x */*.sh
   ```

3. Execute os scripts conforme a necessidade

    ```bash
        ./*.sh
    ```

## 🔐 Segurança

A criptografia **PSK (Pre-Shared Key)** é configurada para proteger a comunicação entre Zabbix Server e Proxy, aumentando a segurança da sua infraestrutura.

## 📌 Requisitos

* Distribuição Linux (Ubuntu, Debian, CentOS)
* Acesso root
* Conexão com a internet
* Firewall liberado para as portas padrão do Zabbix

## 🛠 Tecnologias

* Shell Script
* Zabbix (Agent, Proxy, Server)
* MySQL 
* OpenSSL (para geração de PSK)


