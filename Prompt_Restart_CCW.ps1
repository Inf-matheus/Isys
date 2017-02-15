#Script para restart do serviço LoginCCW nos servidores Santander do Rio de Janeiro e Sao Paulo
#Criado por Matheus Santoro 
#Isys - Nov/2016
#v1.0

# ********* AJUSTAR AS VARIAVEIS $name = "LoginCCW" E $process = "srunner.exe"    *******
# Caso ocorra erro de access denied para acesso dos servidores, verifique se o usuario utilizado na variavel $user possui acesso aos servidores RJ, e execute o comando contido na linha 13


########################################################################################################################################################
#Digitar entre aspas a senha a ser armazenada em caracteres seguros
#Esse comando gera arquivo com senha salva em caracteres seguros - Executar essa linha manualmente no PowerShell, e depois comenta-la no script
#"PASSWORD ENTRE ASPAS" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\jarLoginCCW\Scripts\Password_CCW_RJ.txt"

########################################################################################################################################################

Write-Host "*** ATENCAO - ESSE SCRIPT REINICIA OS SERVIÇOS CCW NO AMBIENTE SANTANDER SP E RJ ***" -foregroundcolor "red" -backgroundcolor "white"
Write-Host ""
Write-Host "*** Somente continue se tiver certeza do que está executando. *********" -foregroundcolor "red" -backgroundcolor "white"
Write-Host ""
Write-Host "*** A execução desncessária pode causar sérias indisponibilidades no ambiente Santander. ***" -foregroundcolor "red"  -backgroundcolor "white"
Write-Host ""
$confirmation = Read-Host "Tem certeza de que deseja continuar? [y/n]"
while($confirmation -ne "y")
{
    if ($confirmation -eq 'n') {exit}
    $confirmation = Read-Host "Tem certeza que deseja continuar? [y/n]"
}

# Definicao das variaveis
#Alterar o nome do usuario que sera usado para o acesso remoto, lembrando de manter o 'contax-br antes do usuario, e tudo entre aspas simples
$usercontax = Read-Host "Digite o usuário Contax para conexao aos servidores RJ (Apenas numeros)"

$user = "contax-br\$usercontax"
$userSP = 'Administrator'
Clear-Variable -name "usercontax"

#Definicao da variavel com nome do serviço (LoginCCW, entre aspas duplas) 
$name = "Themes"
#Definição da variavel com o nome do processo para monitoração da aplicação
$process = "svchost.exe"

#Definicao da variavel com as senhas de acesso aos servidores de SP 
"Todo@2012" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\jarLoginCCW\Scripts\Password_CCW_SP5.txt"
"123456" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\jarLoginCCW\Scripts\Password_CCW_SP7.txt"

#Converte senha salva em credenciais para acesso remoto
$secure_password = read-host "Enter a Password:" -assecurestring
$password = $secure_password | ConvertFrom-SecureString | convertto-securestring

#$password = $SecureStringAsPlainText
$credRJ = new-object -typename System.Management.Automation.PSCredential -argumentlist $user, $password
Clear-Variable -name "Password"

$password = cat C:\jarLoginCCW\Scripts\Password_CCW_SP5.txt | convertto-securestring
$credSP5 = new-object -typename System.Management.Automation.PSCredential -argumentlist $userSP, $password
Clear-Variable -name "Password"

$password = cat C:\jarLoginCCW\Scripts\Password_CCW_SP7.txt | convertto-securestring
$credSP7 = new-object -typename System.Management.Automation.PSCredential -argumentlist $userSP, $password
Clear-Variable -name "Password"



###########################################################################################
#Definicao da variavel para receber confirmacao de restart do serviço CCW em RIO DE JANEIRO
$title = "Restart CCW - RIO DE JANEIRO"
$message = "Tem certeza que deseja reinicar o serviço $name nos servidores RIO DE JANEIRO?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Reinicia o serviço $name."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Não reinicia o serviço $name."	
	
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 1) 

switch ($result)
    {
        0 {$RJ = "s"}
        1 {$RJ = "n"}
    }



###########################################################################################
#Definicao da variavel para receber confirmacao de restart do serviço CCW em SAO PAULO
$title = "Restart CCW - SAO PAULO"
$message = "Tem certeza que deseja reinicar o serviço $name nos servidores SAO PAULO?"

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
    "Reinicia o serviço $name."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
    "Não reinicia o serviço $name."	
	
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)

$result = $host.ui.PromptForChoice($title, $message, $options, 1) 

switch ($result)
    {
        0 {$SP = "s"}
        1 {$SP = "n"}
    }

###########################################################################################

# Restart dos serviços, de acordo com o ambiente escolhido
if ($RJ -eq "s"){
#Restart servico em 10.10.19.72
$server = "10.10.19.72"
	
#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" -Credential $credRJ
	#Stop service
	if ($service.state = "Running") {
	"Servico $name em $server sendo parado..." ; $service.stopservice() | Out-Null 
									}
	else {
	"Servico $name nao esta iniciado"
		 }
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" -Credential $credRJ
	#StartService
	if ($service.state = "Stopped") {
	"Servico $name em $server sendo iniciado..." ; 	$service.startservice() | Out-Null 
									}
	else {
	"Servico $name nao esta parado"
		 }
    Clear-Variable -name "service"
	
	#Get Service UPTIME
	"Serviço $name Iniciado às:"
	Get-WmiObject Win32_Process -computerName $server -Filter "Name like '$process'"  -Credential $credRJ | Foreach-Object{

    [System.Management.ManagementDateTimeconverter]::ToDateTime($_.CreationDate)

																														}
	Clear-Variable -name "server"
	
#Restart servico em 10.10.19.73
$server = "10.10.19.73"

	#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" -Credential $credRJ
	#Stop service
	if ($service.state = "Running") {
	"Servico $name em $server sendo parado..." ; $service.stopservice() | Out-Null 
									}
	else {
	"Servico $name nao esta iniciado"
		 }
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" -Credential $credRJ
	#StartService
	if ($service.state = "Stopped") {
	"Servico $name em $server sendo iniciado..." ; 	$service.startservice() | Out-Null 
									}
	else {
	"Servico $name nao esta parado"
		 }
    Clear-Variable -name "service"
	
	#Get Service UPTIME
	"Serviço $name Iniciado às:"
	Get-WmiObject Win32_Process -computerName $server -Filter "Name like '$process'"  -Credential $credRJ | Foreach-Object{

    [System.Management.ManagementDateTimeconverter]::ToDateTime($_.CreationDate)

																														}
	Clear-Variable -name "server"
}
########################################################################################################################    
if ($SP -eq "s"){
#Restart servico em 10.42.101.5
$server = "10.42.101.5"

	#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'"
	#Stop service
	if ($service.state = "Running") {
	"Servico $name em $server sendo parado..." ; $service.stopservice() | Out-Null 
									}
	else {
	"Servico $name nao esta iniciado"
		 }
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" 
	#StartService
	if ($service.state = "Stopped") {
	"Servico $name em $server sendo iniciado..." ; 	$service.startservice() | Out-Null 
									}
	else {
	"Servico $name nao esta parado"
		 }
    Clear-Variable -name "service"
	
	#Get Service UPTIME
	"Serviço $name Iniciado às:"
	Get-WmiObject Win32_Process -computerName $server -Filter "Name like '$process'"  | Foreach-Object{

    [System.Management.ManagementDateTimeconverter]::ToDateTime($_.CreationDate)

																									}
	Clear-Variable -name "server"
#Restart servico em 10.42.101.7 
$server = "10.42.101.7"	
	
	#Get Status	
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" -Credential $credSP7
	#Stop service
	if ($service.state = "Running") {
	"Servico $name em $server sendo parado..." ; $service.stopservice() | Out-Null 
									}
	else {
	"Servico $name nao esta iniciado"
		 }
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername $server win32_service -filter "name = '$name'" -Credential $credSP7
	#StartService
	if ($service.state = "Stopped") {
	"Servico $name em $server sendo iniciado..." ; 	$service.startservice() | Out-Null 
									}
	else {
	"Servico $name nao esta parado"
		 }
    Clear-Variable -name "service"
	
	
	#Get Service UPTIME
	"Serviço $name Iniciado às:"
	Get-WmiObject Win32_Process -computerName $server -Filter "Name like '$process'"  -Credential $credSP7 | Foreach-Object{

    [System.Management.ManagementDateTimeconverter]::ToDateTime($_.CreationDate)
	
	Clear-Variable -name "server"																													}
}

#Pause
write-host "Press any key to continue..."
[void][System.Console]::ReadKey($true)