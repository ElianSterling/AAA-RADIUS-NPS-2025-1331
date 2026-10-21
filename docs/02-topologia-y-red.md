# Topología lógica y direccionamiento

## Componentes
- Proxmox HomeLab: GNS3 VM 100 y Windows Server 2019 VM 150.
- R1 y SW1 dentro de GNS3 mediante imágenes IOS con soporte AAA/RADIUS/SSH. El switch Ethernet genérico de GNS3 no cumple.
- Adaptador net4 de GNS3 en bridge vmbr50 (MAC BC:24:11:BC:FA:00), puente aislado sin IP de administración en el host.
- Windows net0 en vmbr50. Windows net1 en vmbr0 **temporalmente** para RDP; retirar o rediseñar antes de convertirlo en DC/DNS para evitar múltiples registros DNS.

## Direccionamiento propuesto de matrícula 2025-1331

| Nodo | IPv4 /24 | Propósito |
|---|---|---|
| R1 | 10.25.13.1 | RADIUS client, administración SSH |
| SW1 | 10.25.13.2 | RADIUS client, administración SSH |
| Windows SRV-AD-NPS | 10.25.13.31 | AD DS, DNS y NPS |
| Ubuntu opcional | 10.25.13.20 | Cliente SSH |
| vmbr50 | Sin IP | Segmento L2 aislado |

Esta es una **convención propuesta** derivada de 2025-1331, no una fórmula confirmada por el profesor. La red real inicial de Windows es 192.168.50.10/24. Migrar todos los nodos coordinadamente, sin desconectar la administración antes de disponer de acceso alternativo.

## Conexión

R1 (Ethernet) → SW1 (puerto de acceso) → Cloud GNS3 (NIC net4) → vmbr50 → Windows Server.

No configurar un gateway inexistente en vmbr50. El switch debe tener el puerto en la VLAN de administración operativa; la SVI debe estar up/up.

| Origen | Destino | Puerto |
|---|---|---|
| Cisco R1 y SW1 | SRV-AD-NPS | UDP 1812 autenticación RADIUS |
| Cisco R1 y SW1 | SRV-AD-NPS | UDP 1813 accounting RADIUS |
| Cliente SSH | R1/SW1 | TCP 22 |
| Administrador autorizado | Windows | TCP 3389 solo desde origen permitido |
| Equipos que utilicen DNS | Windows DNS | TCP/UDP 53 |

RADIUS clásico no constituye un canal seguro para Internet público. Mantenerlo en segmento aislado.
