# 02 · Topología y direccionamiento

[← Inicio](../README.md) · [AD DS y NPS](03-active-directory-nps.md) · [Cisco AAA](04-cisco-aaa.md)

![Topología del laboratorio](../diagramas/topologia.svg)

## Infraestructura implementada

El laboratorio se ejecutó sobre **Proxmox HomeLab**. La VM **100** aloja GNS3 Controller y la VM **150** el servidor **Windows Server 2019**, nombre `SRV-AD-NPS`, con AD DS, DNS y NPS. GNS3 presenta dos dispositivos Cisco: **R1 (IOSv)** y **SW1 (IOSvL2)**, conectados al cloud del segmento AAA.

| Nodo | Dirección / interfaz | Rol |
|:--|:--|:--|
| R1 | `10.25.13.1/24` · `GigabitEthernet0/0` | Cliente RADIUS y equipo SSH |
| SW1 | `10.25.13.2/24` · `Vlan13` | Cliente RADIUS, SVI de administración |
| SRV-AD-NPS | `10.25.13.31/24` | Active Directory, DNS, Network Policy Server |
| Proxmox `vmbr50` | `10.25.13.254/24` | Bridge de la red AAA |
| GNS3 Controller | VM 100, NIC `net4` conectada a `vmbr50` | Orquestación del laboratorio |

**Cableado lógico:** R1 Gi0/0 → SW1 Gi0/0 (acceso VLAN 13) → SW1 Gi0/1 (acceso VLAN 13) → Cloud-AAA → GNS3 net4 → vmbr50 → servidor NPS.

En SW1 se configuró `ip default-gateway 10.25.13.1`, aunque R1 y NPS se comunican en el mismo segmento /24. El servidor utiliza `empresa.test` como dominio de pruebas.

## Puertos relevantes

| Protocolo | Origen → destino | Función |
|:--|:--|:--|
| SSH TCP/22 | Dispositivos del laboratorio → R1/SW1 | Administración remota |
| RADIUS UDP/1812 | R1 y SW1 → `10.25.13.31` | Autenticación |
| RADIUS UDP/1813 | R1 y SW1 → `10.25.13.31` | Accounting |
| DNS TCP/UDP 53 | Clientes de dominio → Windows DNS | Resolución de dominio |
| RDP TCP/3389 | Administrador autorizado → Windows | Administración del servidor; restringir origen |

Los clientes RADIUS de NPS se registraron como **R1-CISCO** (`10.25.13.1`) y **SW1-CISCO** (`10.25.13.2`). Los registros NPS y los contadores de Cisco demuestran intercambios RADIUS reales. Algunas comprobaciones ICMP dieron resultados distintos; una pérdida de ping no sustituye el diagnóstico del servicio RADIUS.

## Evidencia visual

[Topología GNS3](../evidencias/01-topologia/01-topologia-gns3.png) · [IP del router](../evidencias/04-conectividad/12-ip-r1-gigabit-00.png) · [VLAN 13](../evidencias/04-conectividad/13-vlan13-sw1-conectividad.png)

> **Histórico de diseño:** las direcciones `192.168.50.x` documentadas al comienzo de la [bitácora](08-estado-real.md) corresponden a etapas anteriores, no al direccionamiento validado al cierre.
