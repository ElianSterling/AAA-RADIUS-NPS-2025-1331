# Script de diagnóstico de solo lectura (ejecutar en Windows Server)
$ErrorActionPreference = 'Continue'
Write-Output '=== SERVIDOR ==='
Get-ComputerInfo | Select-Object CsName,WindowsProductName,WindowsVersion
Write-Output '=== INTERFACES ==='
Get-NetIPConfiguration
Write-Output '=== ROLES ==='
Get-WindowsFeature AD-Domain-Services,DNS,NPAS | Select-Object Name,InstallState
Write-Output '=== NPS ==='
Get-Service IAS -ErrorAction SilentlyContinue
Write-Output '=== AUDITORIA NPS ==='
auditpol /get /subcategory:'Network Policy Server'
Write-Output '=== EVENTOS 6272 y 6273 (METADATOS) ==='
Get-WinEvent -FilterHashtable @{LogName='Security';Id=6272,6273} -MaxEvents 10 -ErrorAction SilentlyContinue | Select-Object TimeCreated,Id,ProviderName,RecordId
