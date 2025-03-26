@echo off
:: Remove o "ssh://" do começo da URL
set URL=%1
set IP=%URL:ssh://=%

:: Remove possíveis barras extras (caso existam)
set IP=%IP:/=%

:: Abre o PuTTY com o IP correto
start "" "C:\remoto\putty.exe" -ssh %IP%