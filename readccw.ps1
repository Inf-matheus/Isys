$dir = "C:\temp\logs"
$filter ="*.log"
$latest = Get-ChildItem -Path $dir -Filter $filter | Sort-Object LastAccessTime -Descending | Select-Object -First 1
$latest.fullname
$logjob="C:\temp\checkccw.txt"
#cd $dir

echo "buscando login"
echo "Buscando informação de login" >$logjob
(get-content $latest.fullname | select -First 50 | Select-String -pattern "Login no CCW efetuado com sucesso") >>$logjob

echo "buscando erros <> 0"
echo "Buscando retornos de erro diferentes de 0" >>$logjob
#(get-content $latest.fullname | select -Skip 40 | Select-String -pattern "<erro><cd_retorno>" | Select-String "<erro><cd_retorno>0" -NotMatch) >$errcode
$errcode=(get-content $latest.fullname | Select-String -pattern "<erro><cd_retorno>" | Select-String "<erro><cd_retorno>0" -NotMatch)
# if (!$errcode) {echo 'Sem erros registrados' >>$logjob}
#	rem else {$errcode >>$logjob}
	
if ($errcode) {$errcode |Ft -autosize -property linenumber,line |out-string -width 4096 >>$logjob}
	else {echo "0 erros" >>$logjob}

notepad $logjob
