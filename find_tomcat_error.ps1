#find the file by filter (-fi) name, contaning stderr
$Logfolder = "C:\Temp\Tocmat"
$err = gci $LogFolder -fi *stderr*
if ($err -eq $null) {Echo "Arquivo n�o encontrado"} else {

#get last modifying date
echo "Arquivo encontrado:" ; $err.LastwriteTime
#Checa se o arquivo foi modificado nas ultimas 24h
if ($err.LastWriteTime -gt (Get-Date).AddHours(-12)) {echo "**ATEN��O** Arquivo de erro alterado nas ultimas 12h! Verifique"} else {echo "Sem eventos de erro nas �ltimas 12h :)"}

}