#!/bin/bash
# rel_hosts_csv_optimized_with_agent_version.sh
#
# Script para gerar relatório CSV de hosts monitorados no Zabbix,
# com IP e versão do agente Zabbix.
#
# Requisitos: jq, curl
# Evandro José Zipf / Adaptado em Julho de 2025

# Configuração do Zabbix
API="http://127.0.0.1/zabbix/api_jsonrpc.php"
TOKEN="c3c547bc08af7a75fccbcc0f1465888dcdb01a6d4f043069d701e2f55e0d276d"

OUTPUT_FILE="${1:-rel_hosts.csv}"

if ! command -v jq &>/dev/null; then
    echo "Erro: O comando 'jq' não está instalado. Instale-o e tente novamente."
    exit 1
fi

# Cabeçalho do CSV
echo "\"HostID\",\"Host\",\"IP\",\"AgentVersion\"" > "$OUTPUT_FILE"

# Consulta para obter hosts monitorados e seus IPs
JSON_HOSTS=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "output": ["hostid", "host"],
        "selectInterfaces": ["ip"],
        "monitored_hosts": 1
    },
    "auth": "$TOKEN",
    "id": 1
}
EOF
)

RESPONSE=$(curl -s -X POST -H "Content-Type:application/json" -d "$JSON_HOSTS" "$API")

if [ -z "$RESPONSE" ] || [ "$(echo "$RESPONSE" | jq -r '.error // empty')" ]; then
    echo "Erro: Não foi possível recuperar os dados. Verifique o token ou a URL da API."
    exit 1
fi

# Para cada host, buscamos também a versão do agente
echo "$RESPONSE" | jq -c '.result[]' | while read -r HOST; do
    HOSTID=$(echo "$HOST" | jq -r '.hostid')
    HOSTNAME=$(echo "$HOST" | jq -r '.host')
    IP=$(echo "$HOST" | jq -r '.interfaces[0].ip // "N/A"')

    # Agora vamos buscar o item 'agent.version'
    JSON_ITEM=$(cat <<EOF
{
    "jsonrpc": "2.0",
    "method": "item.get",
    "params": {
        "output": ["lastvalue"],
        "hostids": "$HOSTID",
        "search": {
            "key_": "agent.version"
        },
        "sortfield": "name"
    },
    "auth": "$TOKEN",
    "id": 2
}
EOF
)

    ITEM_RESPONSE=$(curl -s -X POST -H "Content-Type:application/json" -d "$JSON_ITEM" "$API")
    AGENT_VERSION=$(echo "$ITEM_RESPONSE" | jq -r '.result[0].lastvalue // "N/A"')

    # Escreve no CSV
    echo "\"$HOSTID\",\"$HOSTNAME\",\"$IP\",\"$AGENT_VERSION\"" >> "$OUTPUT_FILE"
done

echo "Relatório gerado com sucesso: $OUTPUT_FILE"

