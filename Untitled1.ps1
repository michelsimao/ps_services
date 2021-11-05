#get-service | where {($_.displayname -like "hyper*") -and ($_.status -eq "stopped")} | format-list -property displayname

#Get-ChildItem -Path *.txt | Where-Object {$_.length -gt 100} | Sort-Object -Property length | Format-Table -Property name, length

#get-service | where {$_.displayname -like "hyper*"} | sort-object -property status | format-table -property status, displayname

#$matriz = @(get-service | where {$_.displayname -like "hyper*"} | sort-object -property status | format-table -property status, displayname)

#$matriz = @(get-service | where {$_.displayname -like "hyper*"})

#foreach($item in $matriz){
#    "Item: [$item]"
#}

$matriz.foreach({"Item [$PSItem]"})