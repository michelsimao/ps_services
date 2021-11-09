$svcName = Read-Host "Informe o NOME do servico"
$svcDisplayName = Read-Host "Informe o NOME DE EXIBICAO do servico"
$svcDescription = Read-Host "Informe a DESCRICAO do servico"

write-host "Informe o tipo de inicializacao do servico"
$svcStartup = Read-Host "1 - Automatic`n2 - Automatic(delayed)`n3 - Manual`n4 - Disabled"

switch($svcStartup){
    1 { $valStartup = "Automatic"; break }
    2 { $valStartup = "Automatic (Delayed)"; break }
    3 { $valStartup = "Manual"; break }
    4 { $valStartup = "Disabled"; break }
}

write-host = "Escolha o arquivo executavel(.exe) do servico a ser instalado"
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ 
    InitialDirectory = "C:\" 
    Filter = 'Executables (*.exe)|*.exe'
}
$null = $FileBrowser.ShowDialog()

$svcFile = $FileBrowser.FileName

$svcParam = @{
    Name = $svcName
    BinaryPathName = $svcFile
    DisplayName = $svcDisplayName
    StartupType = $valStartup
    Description = $svcDescription
  }
New-Service @svcParam

  
