```markdown
# DNS Monitoring Script for Zabbix

This repository contains a custom Bash script designed for monitoring DNS queries using the Zabbix monitoring platform. The script is specifically developed and tested to work with **Zabbix 6 or higher** and **Bind 9**.

## Features

- Validates DNS resolution in the network.
- Collects detailed DNS query statistics, including input and output queries, and status.
- Easy integration with Zabbix for real-time monitoring and alerting.
- Generates temporary files for efficient data handling and performance.

## Requirements

- **Zabbix 6 or higher**
- **Bind 9**
- **dnsutils** package (for `dig` command)
- **curl** package
- **xml2** package

## Installation

1. Clone this repository to your Zabbix server:
   ```bash
   git clone https://github.com/josezipf/monitoring.git
   ```

2. Copy the script to the Zabbix external scripts directory:
   ```bash
   sudo cp monitoring/monitor_bind.sh /usr/lib/zabbix/externalscripts/
   ```

3. Set the appropriate permissions:
   ```bash
   sudo chmod +x /usr/lib/zabbix/externalscripts/monitor_bind.sh
   sudo chown zabbix.zabbix /usr/lib/zabbix/externalscripts/monitor_bind.sh
   ```

## Configuration

### Bind 9 Configuration

To allow the script to access Bind 9 statistics, add the following configuration to your `/etc/bind/named.conf.options` file:

```bash
statistics-channels {
    inet 0.0.0.0 port 8053 allow { 172.17.0.1; 127.0.0.1; };
};
```

Restart the Bind service to apply the changes:

```bash
sudo service named reload
```

### Zabbix Integration

1. Import the Zabbix template from the `monitoring` directory:
   - Go to **Configuration > Templates** in the Zabbix web interface.
   - Click on **Import** and select the `zabbix_bind_template.xml` file from this repository.

2. Assign the template to your desired host.

3. Ensure that the external script is configured correctly in your Zabbix setup.

## Usage

Run the script with one of the following options:

```bash
./monitor_bind.sh -valida 172.17.0.2 google.com.br
./monitor_bind.sh -executa 172.17.0.2 8053
./monitor_bind.sh -bind_queries_in 172.17.0.2 A
./monitor_bind.sh -bind_queries_out 172.17.0.2 A
./monitor_bind.sh -bind_queries_query 172.17.0.2 Success
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contribution

Feel free to open issues or submit pull requests for enhancements or bug fixes. Contributions are welcome!

## Contact

For any questions or support, please reach out to me via [GitHub Issues](https://github.com/josezipf/monitoring/issues).
```

Pode copiar e colar diretamente no seu repositório do GitHub!
