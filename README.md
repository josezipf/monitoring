DNS Monitoring Script for Zabbix

Este repositório contém um script Bash personalizado projetado para monitorar consultas DNS usando a plataforma de monitoramento Zabbix. 
O script foi desenvolvido e testado para funcionar com o Zabbix 6 ou superior e Bind 9.

Recursos:

- Validação de resolução DNS na rede.
- Coleta de estatísticas detalhadas de consultas DNS, incluindo consultas de entrada e saída e status.
- Integração fácil com o Zabbix para monitoramento e alertas em tempo real.
- Gera arquivos temporários para tratamento eficiente de dados e desempenho.

Requisitos:

- Zabbix 6 ou superior
- Bind 9
- Pacote dnsutils (para o comando dig)
- Pacote curl
- Pacote xml2

Instalação:

1. Clone este repositório no seu servidor Zabbix:
   git clone https://github.com/josezipf/monitoring.git

2. Copie o script para o diretório de scripts externos do Zabbix:
   sudo cp monitoring/monitor_bind.sh /usr/lib/zabbix/externalscripts/

3. Defina as permissões apropriadas:
   sudo chmod +x /usr/lib/zabbix/externalscripts/monitor_bind.sh
   sudo chown zabbix.zabbix /usr/lib/zabbix/externalscripts/monitor_bind.sh

Configuração:

1. Configuração do Bind 9:

Para permitir que o script acesse as estatísticas do Bind 9, adicione a seguinte configuração ao seu arquivo /etc/bind/named.conf.options:

statistics-channels {
    inet 0.0.0.0 port 8053 allow { 172.17.0.1; 127.0.0.1; };
};

Recarregue o serviço Bind para aplicar as alterações:

   sudo service named reload

2. Integração com Zabbix:

- Importe o template do Zabbix a partir do diretório monitoring:
  - Vá para **Configuração > Templates** na interface web do Zabbix.
  - Clique em **Importar** e selecione o arquivo zabbix_bind_template.xml deste repositório.

- Atribua o template ao host desejado.

- Certifique-se de que o script externo esteja configurado corretamente em sua configuração do Zabbix.

Uso:

Execute o script com uma das seguintes opções:

- `./monitor_bind.sh -valida 172.17.0.2 google.com.br`
- `./monitor_bind.sh -executa 172.17.0.2 8053`
- `./monitor_bind.sh -bind_queries_in 172.17.0.2 A`
- `./monitor_bind.sh -bind_queries_out 172.17.0.2 A`
- `./monitor_bind.sh -bind_queries_query 172.17.0.2 Success`


Licença:

Este projeto está licenciado sob a Licença MIT. Consulte o arquivo LICENSE para obter detalhes.

Contribuição:

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests para melhorias ou correções de bugs.

Contato:

Para dúvidas ou suporte, entre em contato por [GitHub Issues](https://github.com/josezipf/monitoring/issues).

