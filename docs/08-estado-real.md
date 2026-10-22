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

## Grupos AD validados mediante captura (21 de octubre de 2026)

En Active Directory Users and Computers se observó la OU `LAB-AAA` del dominio `empresa.test`, con los tres grupos de tipo seguridad `GG_NIVEL_0`, `GG_NIVEL_5` y `GG_NIVEL_10`. Su creación queda verificada visualmente. Captura suministrada en la sesión, aún pendiente de subida física al repositorio como `evidencias/05-active-directory-grupos.png`. **Los usuarios, membresías y privilegios RADIUS todavía no han sido verificados.**

## Usuarios AD creados (captura posterior)

En una captura de Active Directory Users and Computers dentro de `empresa.test > LAB-AAA` se observan los usuarios `usuario0`, `usuario5` y `usuario10`, además de los tres grupos `GG_NIVEL_0`, `GG_NIVEL_5` y `GG_NIVEL_10`. **La creación de usuarios queda visualmente confirmada; membresía efectiva de cada usuario en su grupo y estado `Enabled` pendientes de verificación con PowerShell.** Evidencia gráfica del estudiante pendiente de incorporarse como `evidencias/06-active-directory-usuarios.png`.

## Membresías comprobadas (captura del estudiante)

Comando usado: `Get-ADUser -Properties Enabled,MemberOf` y `Get-ADGroup`, comparación de DN del grupo. La tabla de PowerShell mostró `usuario0`, `usuario5`, `usuario10` habilitados (`True`) y con pertenencia correcta (`True`) a `GG_NIVEL_0`, `GG_NIVEL_5` y `GG_NIVEL_10`, respectivamente. Pendiente subir la captura real como `evidencias/06b-verificacion-membresias.png`. **No se han comprobado todavía niveles de autorización Cisco ni autenticaciones RADIUS.**

## NPS: servicio y auditoría comprobados (captura de 21 octubre 2026)

El estudiante ejecutó `Get-Service IAS`, que mostró el servicio **Network Policy Server (IAS) en Running**. `auditpol /set /subcategory:"Network Policy Server" /success:enable /failure:enable` informó ejecución exitosa, y `auditpol /get` mostró **Success and Failure**. Captura auténtica suministrada, todavía pendiente de incorporación en `evidencias/07-nps-servicio-auditoria.png`. **No está comprobado aún** el registro NPS en Active Directory, la configuración de clientes RADIUS ni que se hayan recibido Access-Request; estos pasos siguen pendientes.
