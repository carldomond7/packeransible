#If Win_RM service has already been configured this variable will not be null
$win_rm = Get-Service -Name "WinRM" -ErrorAction SilentlyContinue

#Checking to see if winrm service is already configured by seeing if the win_rm variable is equal to null or not. 
if ($win_rm -eq $null)
{
    #So in the event that win_rm is not configured do the following
    Write-Host -ForegroundColor Yellow "WinRM has not been configured, installing now"
    #Enabling WinRM service
    Enable-PSRemoting -Force

    Set-Service -Name "WinRM" -StartupType Automatic
    Start-Service -Name "WinRM"

    Write-Host -ForegroundColor Green "WinRM has been succesfully installed"
} elseif ($win_rm.Status -eq "Running") {
    #Winrm is already configured
    Write-Host -ForegroundColor Green "WinRM is already configured and ready to go!"
}
else {
    #WinRM service exists but is not running
    Write-Host -Foreground Color Yellow "WinRM service is present, but not runing. Attempting to start the service..."
    Start-Service -Name "WinRM"
    Write-Host -Foreground Color Green "WinRM has been started!"
}

#Configure the WinRM listener to allow remote connections
Write-Host "Configuring WinRM service to ALLOW connections (Basically allowing WinRM host to allow incoming connections)"
winrm quickconfig -q

#Allow WinRM traffic through Windows Firewall
Write-Host "Allowing WinRM traffic through Windows Firewall..."
Enable-PSRemoting -Force

#Display the current WinRM listener configuration
Write-Host "Current WinRM listener configuration:"
winrm enumerate winrm/config/listener

Write-Host "WinRM is now configured to allow remote management"