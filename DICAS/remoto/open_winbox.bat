@echo off
:: Remove o "winbox://" do começo da URL
set URL=%1
set IP=%URL:winbox://=%

:: Remove barras extras (caso existam)
set IP=%IP:/=%

:: Abre o WinBox corretamente
start "" "C:\remoto\winbox64.exe" %IP%