# Estado real de implementación (21 de octubre de 2026)

Este archivo separa hechos verificados de configuraciones previstas. Las evidencias fotográficas todavía deberán adjuntarse en evidencias/.

## Confirmado por salidas de consola
- Proxmox VE 8.4.21 en nodo HomeLab.
- GNS3 VM 100 conservada y encendida, con NIC net4 vinculada a vmbr50.
- Linux bridge vmbr50 activo y aislado.
- VM 150 SRV-AD-NPS creada: 4 cores, 6144 MB RAM, SATA 60 GB.
- Windows Server 2019 Evaluation Desktop Experience instalado.
- NIC de laboratorio Ethernet: 192.168.50.10/24 en vmbr50.
- NIC temporal de administración Ethernet 2: 192.168.1.53 con gateway 192.168.1.1.
- RDP TermService Running, 3389 Listening, regla RDP-Fedora habilitada y restringida a la IP indicada por el administrador.

## Pendiente
- Confirmar fórmula de direccionamiento por matrícula y migrar red de laboratorio.
- Eliminar o sustituir la segunda NIC antes de promover a DC para evitar DNS multihomed.
- AD DS y DNS: instalar y configurar dominio de prueba empresa.test.
- NPS: registrar en AD, clientes, políticas, accounting y auditoría.
- Cisco: confirmar imágenes, conectividad Cloud, AAA, SSH, privilegios, logs y running-configs.
- Video propio YouTube, evidencias, comprobación de requisitos y TXT final.

**Nota:** una captura de configuración provisional no prueba que el requisito evaluado esté completado. Toda conclusión final debe basarse en pruebas nuevas y verificables.

## Avance verificado — 21 de octubre de 2026

En la consola de Windows Server de la VM 150 se comprobó con `Get-WindowsFeature AD-Domain-Services,DNS,NPAS | Format-Table Name,InstallState` que los tres roles figuran como **Installed**. El comando de instalación informó `Success: True` y `Restart Needed: No`. Captura real aportada durante la sesión, pendiente de su incorporación a `evidencias/03-windows-roles-instalados.png`. **No significa que exista todavía un dominio AD ni que NPS esté configurado.**

## Validación de Active Directory (evidencia del estudiante, 21 oct 2026)

Comandos ejecutados en SRV-AD-NPS: `Get-ADDomain`, `Get-ADForest`, `Get-Service NTDS,DNS`.

Resultados observados en captura: `DNSRoot=empresa.test`, `NetBIOSName=EMPRESA`, `PDCEmulator=SRV-AD-NPS.empresa.test`, `DomainMode=Windows2016Domain`, `ForestMode=Windows2016Forest`, servicios `DNS` y `NTDS` en estado `Running`. Se confirma que la promoción del dominio fue realizada y que los servicios estaban activos al momento de la captura. La imagen original debe agregarse a `evidencias/04-active-directory-dominio.png` después de revisar información sensible. Los grupos y las políticas NPS siguen pendientes y no se presentan como completados.
