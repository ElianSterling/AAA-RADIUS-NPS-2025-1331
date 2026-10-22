# Endurecimiento de Windows Firewall para RADIUS — implementación pendiente

## Hallazgo comprobado

En la revisión de PowerShell del 21 de octubre de 2026, las reglas activas de NPS para UDP **1645, 1646, 1812 y 1813** mostraban `LocalAddress=Any` y `RemoteAddress=Any`. Se requiere restringir el acceso antes de poner a funcionar Cisco R1 y SW1. La captura proporcionada por el estudiante aún no se ha subido como imagen real.

## Diseño del laboratorio

- Servidor NPS, interfaz de laboratorio: **10.25.13.31**
- Cliente RADIUS Cisco R1: **10.25.13.1**
- Cliente RADIUS Cisco SW1: **10.25.13.2**
- UDP 1812: autenticación
- UDP 1813: accounting
- UDP 1645/1646: puertos RADIUS legados, no previstos para los clientes de este laboratorio.
- Nunca deshabilitar el firewall global, RDP, ni reglas de Active Directory/DNS.

## Copia de seguridad antes de cambios

Desde PowerShell en Windows Server como administrador:

~~~powershell
netsh advfirewall export "C:\Windows\Temp\firewall-pre-radius.wfw"
~~~

Conservar el respaldo **fuera de GitHub**.

## Cambios propuestos, no ejecutados todavía

~~~powershell
$standard = @(
    'Network Policy Server (RADIUS Authentication - UDP-In)',
    'Network Policy Server (RADIUS Accounting - UDP-In)'
)
foreach ($name in $standard) {
    $rule = Get-NetFirewallRule -DisplayName $name -ErrorAction Stop
    $rule | Get-NetFirewallAddressFilter |
        Set-NetFirewallAddressFilter -LocalAddress '10.25.13.31' -RemoteAddress @('10.25.13.1','10.25.13.2')
}

$legacy = @(
    'Network Policy Server (Legacy RADIUS Authentication - UDP-In)',
    'Network Policy Server (Legacy RADIUS Accounting - UDP-In)'
)
foreach ($name in $legacy) {
    Get-NetFirewallRule -DisplayName $name -ErrorAction Stop | Disable-NetFirewallRule
}
~~~

## Comprobación posterior

~~~powershell
Get-NetFirewallRule -DisplayName 'Network Policy Server (*RADIUS*UDP-In)' |
    ForEach-Object {
        $port = $_ | Get-NetFirewallPortFilter
        $addr = $_ | Get-NetFirewallAddressFilter
        [PSCustomObject]@{
            Rule = $_.DisplayName
            Enabled = $_.Enabled
            Port = $port.LocalPort -join ','
            LocalIP = $addr.LocalAddress -join ','
            RemoteIP = $addr.RemoteAddress -join ','
        }
    } | Format-Table -AutoSize
~~~

Esta verificación muestra el alcance de **esas reglas**, no garantiza que no existan otras reglas coincidentes en el firewall. Antes de declarar «solo R1 y SW1», auditar el conjunto efectivo y realizar pruebas reales.

## Evidencia propuesta

`evidencias/14-nps-firewall-radius-restringido.png`: pantalla del estado posterior de las cuatro reglas. La imagen original debe ser real y cargada al repositorio tras la ejecución.

### Referencias

- [Microsoft: Configure Firewalls for RADIUS Traffic](https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-firewalls-configure)
- [Microsoft: Set-NetFirewallAddressFilter](https://learn.microsoft.com/en-us/powershell/module/netsecurity/set-netfirewalladdressfilter)
