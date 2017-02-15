#Checking services that Should be Started
$GenServices = Get-Service -Name ConfigServerST_1,DBServer_1,GDA,LCA,TSrvAvayaTSAPI_3

foreach ($serv in $GenServices) {
			if ($serv.status -eq "Running") {
				write-host $serv.Name ok
							} 
			else {write-host $serv.name NOK - VERIFIQUE}
			}

#Checking services that Should be Stopped
$GenServices = Get-Service -Name TSrvAvayaTSAPI_1,TSrvAvayaTSAPI,DBServer,ConfigServerST

foreach ($serv in $GenServices) {
			if ($serv.status -eq "Stopped") {
				write-host $serv.Name ok
							} 
			else {write-host $serv.name NOK - VERIFIQUE}
			}