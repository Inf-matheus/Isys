#Script para restart do serviço LoginCCW nos servidores Santander do Rio de Janeiro
#Criado por Matheus Santoro 
#Isys - Nov/2016
#v1.0


########################################################################################################################################################
#Digitar entre aspas a senha a ser armazenada em caracteres seguros
#Esse comando gera arquivo com senha salva em caracteres seguros - Executar essa linha manualmente no PowerShell, e depois comenta-la no script
#"PASSWORD ENTRE ASPAS" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\jarLoginCCW\Scripts\Password_CCW_RJ.txt"

########################################################################################################################################################

# Definicao das variaveis
#Alterar o nome do usuario que sera usado para o acesso remoto, lembrando de manter o 'contax-br antes do usuario, e tudo entre aspas simples
$user = 'contax-br\627837'
$userSP = 'Administrator'

#Definicao da variavel com nome do serviço (LoginCCW, entre aspas duplas) 
$name = "Themes"

#Definicao da variavel com as senhas de acesso aos servidores de SP 
"Todo@2012" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\jarLoginCCW\Scripts\Password_CCW_SP5.txt"
"123456" | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | Out-File "C:\jarLoginCCW\Scripts\Password_CCW_SP7.txt"

#Converte senha salva em credenciais para acesso remoto
$password = cat C:\jarLoginCCW\Scripts\Password_CCW_RJ.txt | convertto-securestring
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
	
	#Get Status
	$service = Get-WmiObject -computername 10.10.19.72 win32_service -filter "name = '$name'" -Credential $credRJ 
    #Stop service em 10.10.19.72
	$service.stopservice() | Out-Null ; if ($service.state = "Running") {"Servico $name em 10.10.19.72 sendo parado..."} else {"Servico $name nao esta iniciado"}
	Clear-Variable -name "service"

	#Get Status
	$service = Get-WmiObject -computername 10.10.19.72 win32_service -filter "name = '$name'" -Credential $credRJ
	#StartService
	$service.startservice() | Out-Null ; if ($service.state = "Stopped") {"Servico $name em 10.10.19.72 sendo iniciado..."}
	Clear-Variable -name "service"

#Restart servico em 10.10.19.73
	
	#Get Status
	$service = Get-WmiObject -computername 10.10.19.73 win32_service -filter "name = '$name'" -Credential $credRJ
	#Stop service
	$service.stopservice() | Out-Null ; if ($service.state = "Running") {"Servico $name em 10.10.19.73 sendo parado..."} else {"Servico $name nao esta iniciado"}
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername 10.10.19.73 win32_service -filter "name = '$name'" -Credential $credRJ
	#StartService
	$service.startservice() | Out-Null ; if ($service.state = "Stopped") {"Servico $name em 10.10.19.73 sendo iniciado..."}
	Clear-Variable -name "service"
}
    
########################################################################################################################    
if ($SP -eq "s"){
#Restart servico em 10.42.101.5

	#Get Status
	$service = Get-WmiObject -computername 10.42.101.5 win32_service -filter "name = '$name'"
	#Stop service
	$service.stopservice() | Out-Null ; if ($service.state = "Running") {"Servico $name em 10.42.101.5 sendo parado..."} else {"Servico $name nao esta iniciado"}
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername 10.42.101.5 win32_service -filter "name = '$name'"
	#StartService
	$service.startservice() | Out-Null ; if ($service.state = "Stopped") {"Servico $name em 10.42.101.5 sendo iniciado..."}
	Clear-Variable -name "service"
	
	
#Restart servico em 10.42.101.7 
	
	#Get Status	
	$service = Get-WmiObject -computername 10.42.101.7 win32_service -filter "name = '$name'" -Credential $credSP7
	#Stop service
	$service.stopservice() | Out-Null ; if ($service.state = "Running") {"Servico $name em 10.42.101.7 sendo parado..."} else {"Servico $name nao esta iniciado"}
	Clear-Variable -name "service"
	
	#Get Status
	$service = Get-WmiObject -computername 10.42.101.7 win32_service -filter "name = '$name'" -Credential $credSP7
	#StartService
	$service.startservice() | Out-Null ; if ($service.state = "Stopped") {"Servico $name em 10.42.101.7 sendo iniciado..."}
    Clear-Variable -name "service"
}

write-host "Press any key to continue..."
[void][System.Console]::ReadKey($true)
