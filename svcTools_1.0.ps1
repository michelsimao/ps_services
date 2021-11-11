function svcRemove($svcName){
    Clear-Host
    Write-Host " **************************************" -ForegroundColor Red
    Write-Host " *           REMOVE SERVICE           *" -ForegroundColor Red
    Write-Host " **************************************" -ForegroundColor Red
    svcDetails($serv)
    do{
        $opt = read-host "The service above will be removed. Are you sure? (y/n)"
    }
    until('y','n' -contains $opt)
    if($opt -eq "y"){
        $del = Get-WmiObject -Class Win32_Service -Filter "Name='$svcName'"
        $res = $del.delete()
        Write-Host
        Write-Host "Removing service..." -ForegroundColor Yellow
        start-sleep -Seconds 5
        if($res['ReturnValue'] -eq 0){ 
            Write-Host
            read-Host "Service successfully removed. Press ENTER" 
        }else{
            Write-Host
            read-Host "The service could not be removed. Press ENTER" 
        }
    }
    scriptStart    
}

#----------------------------------------------------------------------------------------------

function svcDescription($svcName){
    Get-WmiObject win32_service -Filter "name='$($svcName)'" | format-list Description
    $newDesc = Read-Host "Insert the new service description"
    Set-Service -Name "$svcName" -Description "$newDesc"
    write-host "Changing description..." -ForegroundColor Yellow
    Start-Sleep -seconds 5    
}

#----------------------------------------------------------------------------------------------

function svcDisplayName($svcName){
    Get-WmiObject win32_service -Filter "name='$($svcName)'" | format-list Displayname
    $newDisplay = Read-Host "Insert the new service Display Name"
    Set-Service -Name "$svcName" -DisplayName "$newDisplay"
    write-host "Changing Display Name..." -ForegroundColor Yellow
    Start-Sleep -seconds 5
}

#----------------------------------------------------------------------------------------------
function svcDetails($svcName){
    Get-WmiObject win32_service -Filter "name='$($svcName)'" | format-list Name, Displayname, Description, State, PathName
}

#----------------------------------------------------------------------------------------------
function svcStop($svcName){
    stop-service -Name $svcName -force
    Write-Host
    write-host "Stopping service..." -ForegroundColor Yellow
    Start-Sleep -seconds 5
}

#----------------------------------------------------------------------------------------------

function svcStart($svcName){
    start-service $svcName
    Write-Host
    write-host "Starting service..." -ForegroundColor Yellow
    Start-Sleep -seconds 5
}

#----------------------------------------------------------------------------------------------
function svcEditMenu($serv){
    do{
        Clear-Host
        Write-Host " **************************************" -ForegroundColor Green
        Write-Host " *           SERVICE OPTIONS          *" -ForegroundColor Green
        Write-Host " **************************************" -ForegroundColor Green
        svcDetails($serv)
        Write-Host "1 - Start service"
        Write-Host "2 - Stop service"
        Write-Host "3 - "
        Write-Host "4 - Change the service DISPLAYNAME"
        Write-Host "5 - Change the service DESCRIPTION"
        write-Host "6 - Remove the service"
        Write-Host "7 - Back"
        Write-Host 
        [int]$opt = Read-Host 'Make your choice'
    }
    until($opt -le 7)

    switch ($opt){
        1 { svcStart($serv); break }
        2 { svcStop($serv); break }
        3 {}
        4 { svcDisplayName($serv); break }
        5 { svcDescription($serv); break }
        6 { svcRemove($serv); break }
        7 { scriptStart; break }
    }
    Start-Sleep -seconds 5
    svcDetails($serv)
    Read-Host "`nPress ENTER to continue"
    scriptStart
}
#----------------------------------------------------------------------------------------------
function svcList($services){
    $menu = @{} 
    for ($i=1; $i -le $services.count; $i++) { 
        Write-Host "$i. $($services[$i-1].displayName) - $($services[$i-1].status)" 
        $menu.Add($i,($services[$i-1].Name))
        $number = $menu.Count 
    }

    do{
       [int]$sel = Read-Host "`nChoose the service"
    }
    until($sel -le $number)
    svcEditMenu($menu[$sel])
}
#----------------------------------------------------------------------------------------------
function svcInstall{
    Clear-Host
    Write-Host " **************************************" -ForegroundColor Green
    Write-Host " *           SERVICE INSTALL          *" -ForegroundColor Green
    Write-Host " **************************************" -ForegroundColor Green
    Write-Host
    $svcName = Read-Host "Insert the service NAME"
    $svcDisplayName = Read-Host "Insert the service DISPLAY NAME"
    $svcDescription = Read-Host "Insert the service DESCRIPTION"
    write-host "Choose the service STARTUP TYPE"
    $svcStartup = Read-Host "1 - Automatic`n2 - Automatic(delayed)`n3 - Manual`n4 - Disabled`n"
    switch($svcStartup){
        1 { $valStartup = "Automatic"; break }
        2 { $valStartup = "Automatic (Delayed)"; break }
        3 { $valStartup = "Manual"; break }
        4 { $valStartup = "Disabled"; break }
    }
    write-host = "Search the service binary file(.exe) to be installed"
    $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
        InitialDirectory = "C:\" 
        Filter = 'Executables (*.exe)|*.exe'
    }
    $null = $FileBrowser.ShowDialog()

    $svcFile = $FileBrowser.FileName

    Write-Host "`n----------------------------------"
    Write-Host "Name: " $svcName
    Write-Host "Display Name: " $svcDisplayName
    Write-Host "Description: " $svcDescription
    Write-Host "Startup Type: " $svcStartup
    Write-Host "Binary file: " $svcFile
    Write-Host "----------------------------------"    
    do{
        $opt = read-host "`nConfirm service information? (y/n)"
    }
    until('y','n' -contains $opt)
    if($opt -eq "n"){ scriptStart }    

    $svcParam = @{
        Name = $svcName
        BinaryPathName = $svcFile
        DisplayName = $svcDisplayName
        StartupType = $valStartup
        Description = $svcDescription
    }
    New-Service @svcParam

    Write-Host "`nInstalling service..." -ForegroundColor Yellow
    Start-Sleep -seconds 3

    #$result = get-service -ErrorAction SilentlyContinue | Where-Object {$_.Name -eq "$svcName"} 
    $result = get-service | Where-Object {$_.Name -eq "$svcName"} 
    if($result){
        Read-Host "`nService successfully installed. Press ENTER"
    }else{
        write-host "`nService not found. The installation may be failed."
        Read-Host "Press ENTER to continue"
    }
    scriptStart
}
#----------------------------------------------------------------------------------------------
function svcSearch{
    do{
        Clear-Host
        Write-Host " **************************************" -ForegroundColor Green
        Write-Host " *           SERVICE SEARCH           *" -ForegroundColor Green
        Write-Host " **************************************" -ForegroundColor Green
        Write-Host        
        $svc = Read-Host "`nInput the service DISPLAY NAME"
    }
    until($svc)

    $result = get-service -ErrorAction SilentlyContinue | Where-Object {$_.displayName -like "$svc*"} 
    if($result){
        svcList($result)
    }else{
        write-host "`nService not found" -ForegroundColor Yellow
        Write-Host
        Read-Host "Press ENTER to continue"
        scriptStart
    }
}
#----------------------------------------------------------------------------------------------
function mainMenu{
    do{
        Clear-Host
        Write-Host " **************************************" -ForegroundColor Green
        Write-Host " *         WINDOWS SERVICES TOOLS     *" -ForegroundColor Green
        Write-Host " **************************************" -ForegroundColor Green
        Write-Host
        Write-Host " 1) Install a new service"
        Write-Host " 2) Edit or remove an existing service"
        Write-Host " 3) Quit"
        Write-Host
        $opt = Read-Host " Select the option and press ENTER"  
    }
    until ($opt -le 3)
    if($opt -eq 3){ Clear-Host; exit }
    return $opt
}
#----------------------------------------------------------------------------------------------

function scriptStart{
    $a = mainMenu
    if($a -eq 1){
        svcInstall
    }else{
        svcSearch
    }
}

scriptStart