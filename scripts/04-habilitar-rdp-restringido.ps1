# Guion documentado de la habilitación RDP de la VM 150.
# Antes de usar: sustituir el origen por una IP segura, accesible y comprobada.
# Ejecutar en PowerShell Administrador del servidor (no en Proxmox).
param([Parameter(Mandatory=$true)][string]$AdminSourceIp)
$ErrorActionPreference = "Stop"
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server' -Name fDenyTSConnections -Value 0
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -Name UserAuthentication -Value 1
Set-Service TermService -StartupType Automatic
Start-Service TermService
$old = Get-NetFirewallRule -DisplayName 'RDP-Fedora' -ErrorAction SilentlyContinue
if ($old) { Remove-NetFirewallRule -DisplayName 'RDP-Fedora' }
New-NetFirewallRule -DisplayName 'RDP-Fedora' -Direction Inbound -Action Allow -Protocol TCP -LocalPort 3389 -RemoteAddress $AdminSourceIp -Profile Any
Get-Service TermService
Get-NetTCPConnection -LocalPort 3389 -State Listen
Get-NetFirewallRule -DisplayName 'RDP-Fedora' | Get-NetFirewallAddressFilter
# La configuración NO crea rutas entre redes distintas. Verificar otras reglas RDP preexistentes.
