$name = read-host "Nome do servico"

$service = Get-WmiObject -Class Win32_Service -Filter "Name='$name'" 

$del = $service.delete()

if($del.ReturnValue -eq 0){
    write-host "Servico excluido com sucesso"    
}else{
    write-host "Erro ao excluir o servico"
}
