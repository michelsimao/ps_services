$services = get-service | where {$_.displayName -like "hyper*"} 
$menu = @{} 
for ($i=1; $i -le $services.count; $i++) { 
    Write-Host "$i. $($services[$i-1].displayName) - $($services[$i-1].status)" 
    $menu.Add($i,($services[$i-1].displayName)) 
    $number = $menu.Count 
}

do{
    [int]$ans = Read-Host 'Enter selection'
}
until($ans -le $number)


$selection = $menu.Item($ans) 

$escolhido = Get-Service $selection


stop-service $escolhido.Name -force -confirm

get-service $escolhido.name



