REM Ajusta as variaveis para exibicao da data no formato YYYYMMDD
set day=%date:~7,2%
set month=%date:~4,2%
set year=%date:~10,4%

rem Identifica o numero de conexoes e gera o arquivo temporario com a informacao
netstat -na | find/c "2020" > %TEMP%\2020.txt

rem Le o o arquivo temporario e define a variavel
FOR /F "tokens=*" %%A in (%TEMP%\2020.txt) do SET VAR=%%A

REM Gera a linha com o numero de conexoes
echo %time:~0,5% - %VAR% >>D:\Porta2020\Conexoes2020_%year%%month%%day%.txt

REM Apaga o arquivo temporario
del %TEMP%\2020.txt

