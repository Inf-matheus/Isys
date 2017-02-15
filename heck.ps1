#Checking services that Should be Started
$GenServices = Get-Service -Name ConfigServerST_1,DBServer_1,GDA,LCA,TSrvAvayaTSAPI_3

foreach ($serv in $GenServices) {
			if ($serv.status -ne "Running") {
				write-host $serv.Name erro
							} 
			
			}

#Checking services that Should be Stopped
$GenServices = Get-Service -Name TSrvAvayaTSAPI_1,TSrvAvayaTSAPI,DBServer,ConfigServerST

foreach ($serv in $GenServices) {
			if ($serv.status -ne "Stopped") {
				write-host $serv.Name erro
							} 
			
			}