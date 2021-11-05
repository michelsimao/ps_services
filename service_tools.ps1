#busca os servicos com display name comecando com hyper e atribui o resultado a $services
$services = get-service | Where-Object {$_.displayName -like "hyper*"} 

#cria uma matriz vazia
$menu = @{} 

#Como um For/foreach normal, sendo -le = less or equal (<=)
for ($i=1; $i -le $services.count; $i++) { 
    #Exibe o número($i), o display name e o status do servico
    Write-Host "$i. $($services[$i-1].displayName) - $($services[$i-1].status)" 
    #Adiciona o item a matriz $menu
    $menu.Add($i,($services[$i-1].Name))
    #armazena a qtde de itens do menu para ser utilizada no do/until
    $number = $menu.Count 
}

#Exibe "Enter selection" enquanto um valor menor ou igual a qtde de itens do menu nao for digitado
do{
    #Aguarda a entrada de dados do usuario
    [int]$sel = Read-Host "`nEscolha o serviço"
}
until($sel -le $number)

#Pega o item do menu escolhido e joga em $selection
$selection = $menu.Item($sel) 

#Executa o "do" até que um valor valido seja escolhido
do{
    #Limpa a tela
    Clear-Host
    #Exibe os detalhes do servico escolhido (name, displayname, description, state)
    Get-WmiObject win32_service -Filter "name='$($selection)'" | format-list Name, Displayname, Description, State
    #Exibe o menu de opcoes
    Write-Host "1 - Parar o serviço`n2 - Iniciar o serviço`n3 - Trocar o NAME do serviço`n4 - Trocar o DISPLAYNAME do serviço`n5 - Alterar a DESCRIPTION do serviço`n"
    #Aguarda a entrada de dados do usuario
    [int]$opt = Read-Host 'Escolha a opção'
}
until($opt -le 5)








