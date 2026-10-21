# Plantilla idempotente; ejecutar SOLO tras promover empresa.test a DC.
# Revisar el script antes de ejecutarlo en el laboratorio individual.
#Requires -Modules ActiveDirectory
$ErrorActionPreference = 'Stop'
$domain = Get-ADDomain
if ($domain.DNSRoot -ne 'empresa.test') { throw "Dominio inesperado: $($domain.DNSRoot)" }
$base = $domain.DistinguishedName
$ouDn = "OU=LAB-AAA,$base"
if (-not (Get-ADOrganizationalUnit -LDAPFilter '(ou=LAB-AAA)' -SearchBase $base -ErrorAction SilentlyContinue)) {
    New-ADOrganizationalUnit -Name 'LAB-AAA' -Path $base -ProtectedFromAccidentalDeletion $true
}
$password = Read-Host 'Contraseña temporal exclusiva del laboratorio' -AsSecureString
foreach ($level in 0,5,10) {
    $group = "GG_NIVEL_$level"
    $sam = "usuario$level"
    if (-not (Get-ADGroup -Filter "SamAccountName -eq '$group'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $group -SamAccountName $group -GroupScope Global -GroupCategory Security -Path $ouDn
    }
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$sam'" -ErrorAction SilentlyContinue)) {
        New-ADUser -Name $sam -SamAccountName $sam -UserPrincipalName "$sam@$($domain.DNSRoot)" -Path $ouDn -AccountPassword $password -Enabled $true
    }
    Add-ADGroupMember -Identity $group -Members $sam
}
Get-ADGroup -Filter 'Name -like "GG_NIVEL_*"' -SearchBase $ouDn | Select-Object Name, DistinguishedName
