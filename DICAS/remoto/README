# SSH e WinBox Protocol Handler

Este repositório contém um conjunto de scripts e entradas no Registro do Windows para permitir a execução de comandos de SSH e WinBox diretamente a partir de URLs personalizadas.

## Descrição

- **SSH Protocol Handler**: Permite que você abra conexões SSH utilizando o **PuTTY** através de uma URL personalizada no formato `ssh://<ip>`.
- **WinBox Protocol Handler**: Permite que você abra o **WinBox** diretamente com a URL personalizada `winbox://<ip>`.

Quando configurados corretamente, você poderá usar URLs como `ssh://192.168.0.1` ou `winbox://192.168.0.1` no seu navegador ou em qualquer outro aplicativo que suporte URLs personalizadas, e o script adequado será executado automaticamente para iniciar a conexão.

## Estrutura do Repositório

- **Registro do Windows**: Arquivos de registro que configuram as URLs personalizadas `ssh://` e `winbox://`.
- **Scripts BAT**: Scripts para lidar com as URLs e abrir as aplicações adequadas (PuTTY para SSH e WinBox para WinBox).

## Como Funciona

1. **Registro do Windows**: As entradas no registro associam os protocolos `ssh://` e `winbox://` a comandos específicos, executando os scripts BAT correspondentes.
2. **Scripts BAT**:
   - **open_ssh.bat**: Remove o prefixo `ssh://` e passa o IP para o PuTTY para estabelecer a conexão SSH.
   - **open_winbox.bat**: Remove o prefixo `winbox://` e passa o IP para o WinBox para estabelecer a conexão com o Mikrotik.

## Como Configurar

### Passo 1: Aplicar as Entradas no Registro

Para aplicar as configurações do registro, faça o seguinte:

1. Baixe os arquivos de registro **`ssh.reg`** e **`winbox.reg`**.
2. Clique com o botão direito sobre cada um dos arquivos e selecione **"Merge"** para adicioná-los ao registro do Windows.
   
Isso configurará os protocolos `ssh://` e `winbox://` no seu sistema.

### Passo 2: Preparar os Scripts BAT

1. Coloque os arquivos de script **`open_ssh.bat`** e **`open_winbox.bat`** em uma pasta no seu computador (por exemplo, `C:\remoto`).
2. Certifique-se de que o **PuTTY** e o **WinBox** estejam localizados nas pastas apropriadas e que os caminhos nos scripts BAT estejam corretos.

### Passo 3: Testar as URLs

Após a configuração, você pode testar as URLs personalizadas:

- Abra um navegador ou qualquer outro aplicativo que suporte URLs e insira `ssh://<ip>` ou `winbox://<ip>`.
- O script correspondente será executado, e o PuTTY ou WinBox será aberto com o IP fornecido.

## Dependências

- **PuTTY**: O script para SSH requer o PuTTY instalado em `C:\remoto\putty.exe`.
- **WinBox**: O script para WinBox requer o WinBox instalado em `C:\remoto\winbox64.exe`.

## Contribuições

Se você encontrar algum problema ou tiver sugestões de melhorias, fique à vontade para abrir uma **issue** ou enviar um **pull request**.

## Licença

Este projeto é licenciado sob a [Licença MIT](LICENSE).
