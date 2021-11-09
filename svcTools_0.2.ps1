# First function to be executed. Asks for the service name to que queried
function entryPoint{
    Clear-Host
    #Request input data
    $svc = Read-Host "`nInforme o nome de exibição do serviço (display name)"
    #Will search for services by DISPLAYNAME beginning with the data inputted
    return get-service -ErrorAction SilentlyContinue | Where-Object {$_.displayName -like "$svc*"} ## VALIDAR!!!!
}

#----------------------------------------------------------------------------------------------

#Assembles MENU1
function menu1($services){
    #Create an empty array
    $menu = @{} 
    #Start a counter from 1 to the returned services quantity
    for ($i=1; $i -le $services.count; $i++) { 
        #Display the item number($i), the service DISPLAYNAME and the service status
        Write-Host "$i. $($services[$i-1].displayName) - $($services[$i-1].status)" 
        #Add the item number and service NAME to the array $menu
        $menu.Add($i,($services[$i-1].Name))
        #Set the total items number to $number variable
        $number = $menu.Count 
    }
    #Execute until a valid number is inputed
    do{
        #Waits the number to be inputted
        [int]$sel = Read-Host "`nEscolha o serviço"
    }
    until($sel -le $number)
    
    #Return the selected item
    return $menu[$sel]
}

#----------------------------------------------------------------------------------------------

#Shows the selected service details (name, displayname, description, state)
function details($selected_svc){
    Get-WmiObject win32_service -Filter "name='$($selected_svc)'" | format-list Name, Displayname, Description, State
}

#----------------------------------------------------------------------------------------------

#Assembles MENU1
function menu2($serv){
    #Executes DO untiu some valid value is inputted
    do{
        #Display the menu
        Write-Host "1 - Parar o serviço`n2 - Iniciar o serviço`n3 - Trocar o NAME do serviço`n4 - Trocar o DISPLAYNAME do serviço`n5 - Alterar a DESCRIPTION do serviço`n6 - Buscar outro serviço`n"
        #Waits for the user input
        [int]$opt = Read-Host 'Escolha a opção'
    }
    until($opt -le 6)

    #Executes the function selected at above menu
    switch ($opt){
        1 { stopService($serv); break }
        2 { startService($serv); break }
        3 {}
        4 { alterDisplayName($serv); break }
        5 { alterDescription($serv); break }
        6 { steps; break }
    }
    #Pauses the script for 5 seconds
    Start-Sleep -seconds 5
    #Show the service details
    details($serv)
    #Wait for some key be pressed 
    Read-Host "`nPressione qualquer tecla para continuar"
    steps
}

#----------------------------------------------------------------------------------------------

#Changes the service description 
function alterDescription($svcName){
    Get-WmiObject win32_service -Filter "name='$($svcName)'" | format-list Description
    $newDesc = Read-Host "Informe a nova descrição"
    Set-Service -Name "$svcName" -Description "$newDesc"
}

#----------------------------------------------------------------------------------------------

#Changes the service Display Name
function alterDisplayName($svcName){
    Get-WmiObject win32_service -Filter "name='$($svcName)'" | format-list Displayname
    $newDisplay = Read-Host "Informe o novo Display Name"
    Set-Service -Name "$svcName" -DisplayName "$newDisplay"
}


#----------------------------------------------------------------------------------------------

#Stops the service
function stopService($svcName){
    stop-service -Name $svcName -force
}

#----------------------------------------------------------------------------------------------

#Starts the service
function startService($svcName){
    start-service $svcName
}

#----------------------------------------------------------------------------------------------

#Script running sequence
function steps{
    $services = entryPoint
    $serv = menu1($services)
    Clear-Host
    details($serv)
    menu2($serv)
}

#----------------------------------------------------------------------------------------------

steps






