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
   ```bash
   git clone https://github.com/josezipf/monitoring.git
   ```
3. Copie o script para o diretório de scripts externos do Zabbix:
   ```bash
   sudo cp monitoring/monitor_bind.sh /usr/lib/zabbix/externalscripts/
   ```

5. Defina as permissões apropriadas:
   ```bash
   sudo chmod +x /usr/lib/zabbix/externalscripts/monitor_bind.sh
   sudo chown zabbix.zabbix /usr/lib/zabbix/externalscripts/monitor_bind.sh
   ```
   
## Configuração do Bind 9

Para permitir que o script acesse as estatísticas do Bind 9, é necessário configurar o arquivo `named.conf.options`. Siga as instruções abaixo:

1. Abra o arquivo de configuração do Bind com o editor de texto de sua preferência:

    ```bash
    sudo vim /etc/bind/named.conf.options
    ```

2. Adicione o seguinte bloco de configuração para habilitar o canal de estatísticas na porta `8053` e
3. permitir acesso aos IPs `172.17.0.1` e `127.0.0.1`. Certifique-se de ajustar os IPs conforme sua configuração de rede:

    ```bash
    statistics-channels {
        inet 0.0.0.0 port 8053 allow { 172.17.0.1; 127.0.0.1; };
    };
    ```

4. Salve e saia do editor (`Esc` + `:wq` no `vim`).

5. Recarregue o serviço Bind para aplicar as alterações:

    ```bash
    sudo service named reload
    ```

Após isso, o Bind 9 estará configurado para permitir que o script monitore as estatísticas. Verifique se o script está funcionando conforme esperado.


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

