Clear-Host
$svc = Read-Host "`nInforme o nome do serviço"

#busca os servicos com display name comecando com hyper e atribui o resultado a $services
$services = get-service | Where-Object {$_.displayName -like "$svc*"} 

#----------------------------------------------------------------------------------------------

#Monta o MENU 1
function menu1{
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
    
    #Pega o item do menu escolhido e joga em $selected_svc
    return $menu.Item($sel) 
}

#----------------------------------------------------------------------------------------------



function details($selected_svc){
    #Exibe os detalhes do servico escolhido (name, displayname, description, state)
    Get-WmiObject win32_service -Filter "name='$($selected_svc)'" | format-list Name, Displayname, Description, State
}

#----------------------------------------------------------------------------------------------

function menu2{
    #Executa o "do" até que um valor valido seja escolhido
    do{
        #Exibe o menu de opcoes
        Write-Host "1 - Parar o serviço`n2 - Iniciar o serviço`n3 - Trocar o NAME do serviço`n4 - Trocar o DISPLAYNAME do serviço`n5 - Alterar a DESCRIPTION do serviço`n6 - Voltar`n"
        #Aguarda a entrada de dados do usuario
        [int]$opt = Read-Host 'Escolha a opção'
    }
    until($opt -le 5)
    return $opt
}

#----------------------------------------------------------------------------------------------

#Clear-Host
$serv = menu1
details($serv)
$action = menu2

#----------------------------------------------------------------------------------------------

function stopService($svcName){
    stop-service -Name $svcName -force
}

function startService($svcName){
    start-service $svcName
}

switch ($action){
    1 { stopService($serv); break }
    2 { startService($serv); break }
    3 {}
    4 {}
    5 {}
    6 {}
}

Start-Sleep -seconds 10
details($serv)






