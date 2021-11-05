$services = get-service | where {$_.displayName -like "hyper*"} #busca os servicos com display name comecando com hyper e atribui o resultado a $services
$menu = @{} #cria uma matriz vazia
for ($i=1; $i -le $services.count; $i++) { #Como um For/foreach normal, sendo -le = less or equal (<=)
    Write-Host "$i. $($services[$i-1].displayName) - $($services[$i-1].status)" #Escreve o número($i), o display name e o status do servico
    $menu.Add($i,($services[$i-1].displayName)) #Adiciona o item a matriz $menu
    $number = $menu.Count #armazena a qtde de itens do menu para ser utilizada no do/until
}

#Exibe "Enter selection" enquanto um valor menor ou igual a qtde de itens do menu nao for digitado
do{
    [int]$ans = Read-Host 'Enter selection'
}
until($ans -le $number)


$selection = $menu.Item($ans) #Pega o item do menu escolhido e joga em $selection

Get-Service $selection | format-list * #busca as informacoes do servico selecionado