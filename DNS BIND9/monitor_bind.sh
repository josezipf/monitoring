#!/bin/bash
#
# Descrição: Este script realiza diversas operações para validação e monitoramento da resolução de DNS na rede.
# Ele verifica a funcionalidade do DNS, coleta informações de estatísticas e consultas, e gera relatórios
# temporários em arquivos. O script utiliza ferramentas como `dig`, `curl`, e `xml2` para realizar suas
# funções.
#
# Autor: Evandro José Zipf
# https://nototi.com.br
# Versão: 1.0
#
# Requisitos:
# - `dnsutils`: Para o comando `dig`, utilizado para verificar a resolução de DNS.
# - `curl`: Para baixar dados do servidor DNS.
# - `xml2`: Para converter o XML em formato legível e processável.
#
# Para instalar os requisitos, use o comando:
# sudo apt install dnsutils xml2 curl
#
# Uso:
# O script aceita as seguintes opções:
#
# -valida              Verifica se a resolução de DNS está funcionando.
#                      Exemplo: ./monitor_bind.sh -valida 172.17.0.2 google.com.br
# -executa             Coleta informações do servidor DNS e gera um arquivo temporário em /tmp.
#                      Exemplo: ./monitor_bind.sh -executa 172.17.0.2 8053
# -bind_queries_in     Coleta informações de entrada de consultas DNS.
#                      Exemplo: ./monitor_bind.sh -bind_queries_in 172.17.0.2 A
# -bind_queries_out    Coleta informações de saída de consultas DNS.
#                      Exemplo: ./monitor_bind.sh -bind_queries_out 172.17.0.2 A
# -bind_queries_query  Coleta informações sobre o status das resoluções (Sucesso, Falha, etc.).
#                      Exemplo: ./monitor_bind.sh -bind_queries_query 172.17.0.2 A
# -V                   Mostra a versão do script.
# -h                   Mostra a ajuda com informações de uso.
#
# Exemplos de uso:
# ./monitor_bind.sh -valida 172.17.0.2 google.com.br
# ./monitor_bind.sh -executa 172.17.0.2 8053
# ./monitor_bind.sh -bind_queries_in 172.17.0.2 A
# ./monitor_bind.sh -bind_queries_out 172.17.0.2 A
# ./monitor_bind.sh -bind_queries_query 172.17.0.2 A
#
# Notas:
# - O script assume que o servidor DNS está acessível no endereço e porta fornecidos.
# - Os arquivos temporários são criados no diretório /tmp e têm prefixo "bind.temp.stats." e "bind.stats.".
# - O script requer exatamente 3 parâmetros para funcionar corretamente, dependendo da opção selecionada.
#
# Licença:
#
# Este script é fornecido sob a licença MIT License. Você pode usar, copiar, modificar
# e distribuir este script de acordo com os termos da licença MIT.
#
# Nota: Antes de usar este script, certifique-se de que os pacotes dnsutils, curl, e xml2 estejam instalados em seu sistema.
# Se esses pacotes não estiverem instalados, você pode instalá-los com o comando:



# Inicia as chaves desativadas
valida=0
executa=0
bind_queries_in=0
bind_queries_out=0
bind_queries_query=0

    MENSAGEM_USO="
    Uso: $(basename "$0")[-valida|-executa|-bind_queries_in|-bind_queries_out|-bind_queries_query|-V|-h]

     -valida              Verifica se a resolução de DNS está funcionando
     -executa             Busca as informações no DNS para coletas do monitoramento egera um arquivo temp em /tmp
     -bind_queries_in     Coleta informações de entrada de consultas DNS
     -bind_queries_out    Coleta informações de saída de consultas DNS
     -bind_queries_query  Coleta informações por status das resoluções Sucess, Failure e etc..
     -V                   Mostra versão do script
     -h                   Mostra ajuda

     Ex: ./monitor_bind.sh -valida  172.17.0.2 google.com.br
         ./monitor_bind.sh -executa  172.17.0.2 8053
         ./monitor_bind.sh -bind_queries_in 172.17.0.2 A
         ./monitor_bind.sh -bind_queries_out 172.17.0.2 A
     "

    # Verifica se está instalado o dig e curl
    if ! command -v dig > /dev/null && ! command -v curl > /dev/null
    then
        echo "Comando dig ou curl não instalado, instale o pacote dnsutils e curl no sistema
              Veja os requisitos
              "
        exit 0;
    fi

    # Verifica se foi os 3 parâmetros necessários
    [ $# -ne 3 ] && {

      	echo "Informe os 3 parâmetros necessários
      	      $MENSAGEM_USO"
	      exit 0;
    }


    case "$1" in

        # Opções de ligam e desligam chaves

        -valida) valida=1 ;;

        -executa) executa=1 ;;

        -bind_queries_in) bind_queries_in=1;;

	      -bind_queries_out) bind_queries_out=1;;

 	      -bind_queries_query) bind_queries_query=1;;

        -h|--help)
            echo $MENSAGEM_USO
            exit 0
        ;;

        -V|--version)
            echo -n $(basename "$0")
            # Extrai a versão diretamente dos cabeçalhos do programa
            grep '^# Versão' "$0"| tail -1| cut -d: -f1 |tr -d \#
            exit 0

        ;;

         *)  # opção inválida
            if test -n "$1"
            then
                echo Opção invalida: $1
                exit 1
            fi
        ;;
    esac


    # Valida a resolução de DNS
    test "$valida" = 1 && { dig +time=1 +tries=2 @$2 $3 | grep NOERROR >/dev/null && echo 1 || echo 0;}

    # Conectar no DNS para trazer as informações de estatísticas e envia para arquivo com o nome do host DNS
    test "$executa" = 1 && { curl -s http://$2:$3/ | xml2 > /tmp/bind.temp.stats.$2 && cp /tmp/bind.temp.stats.$2 /tmp/bind.stats.$2 && echo 1 || echo 0; }

    # Consulta de Query in
    test "$bind_queries_in" = 1 && { in=$(grep -A1 "/statistics/server/counters/counter/@name=$3$" /tmp/bind.stats.$2) && in=$(echo "$in" | tail -1 | cut -d= -f2) || in=0; echo "$in"; }

    # Consulta de Query Out
    test "$bind_queries_out" = 1 && { out=$(grep -A1 "/statistics/views/view/counters/counter/@name=$3$" /tmp/bind.stats.$2) && out=$(echo "$out" | tail -1 | cut -d= -f2) || out=0; echo "$out"; }

    # Consulta de Query de Status
    test "$bind_queries_query" = 1 && { query=$(grep -A1 "/statistics/server/counters/counter/@name=Qry$3$" /tmp/bind.stats.$2) && query=$(echo "$query" | tail -1 | cut -d= -f2) || query=0; echo "$query"; }
