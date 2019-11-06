$HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress # get local ipv4

Clear # clear shell

$fileName = "log-$((Get-Date -Format u).Replace(":", ".")).txt" # create log file based on date
Start-Transcript -Path "$fileName"  # start transcript 

if($HostIP -ne $null) { # check if network is not null
    $IPParts = $HostIP.Split(".") # split up ip
    $StartIP = $IPParts[0] + "." + $IPParts[1] + "." + $IPParts[2] + ".0" # create start ip
    $EndIP = $IPParts[0] + "." + $IPParts[1] + "." + $IPParts[2] + ".255" # create end ip
    $NMapIP = $StartIP + "/24" # create address for nmap to use

    Write-Host "[INFO] Start IP: $StartIP" # log them
    Write-Host "[INFO] End IP: $EndIP" 
    Write-Host "[INFO] NMap IP: $NMapIP"

    Write-Host "[INFO] Starting device scan."
    nmap -T4 $NMapIP # run nmap
} else {
    Write-Host "[ERROR] Network disconnected, exiting." # log if no network found
}

Stop-Transcript