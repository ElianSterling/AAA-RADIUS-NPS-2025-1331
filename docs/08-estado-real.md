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

## Clientes RADIUS en NPS — verificados en captura

La lista de clientes RADIUS de NPS muestra **R1-CISCO** (10.25.13.1) y **SW1-CISCO** (10.25.13.2), fabricante Cisco, ambos en estado **Enabled**. Captura proporcionada por el estudiante, pendiente de guardarse como `evidencias/08-nps-clientes-radius.png` en el repositorio. Esta evidencia demuestra configuración NPS, **no** conexión ni autenticación exitosa de dispositivos IOS. Siguen pendientes la comprobación de registro del servidor en RAS and IAS Servers, las Network Policies por grupo, el firewall RADIUS y las pruebas reales desde GNS3.

## Tres Network Policies NPS creadas y habilitadas — verificación visual (21 oct 2026)

La pantalla `Network Policies` de NPS muestra **AAA_NIVEL_10** (orden 1), **AAA_NIVEL_5** (orden 2) y **AAA_NIVEL_0** (orden 3), todas **Enabled** con **Grant Access**. Las políticas predeterminadas quedan por debajo con órdenes 999998 y 999999. Las pantallas de resumen previas muestran grupos AD individuales, PAP, Service-Type Login, timeout 15 min y Cisco-AV-Pair `shell:priv-lvl=10`, `shell:priv-lvl=5`, `shell:priv-lvl=0` (aún sin prueba Cisco). Evidencia visual proporcionada por el estudiante; archivo PNG pendiente de incorporación como `evidencias/12-nps-tres-politicas.png`. PENDIENTE: verificar el registro NPS en AD, firewall UDP 1812/1813, accounting, topología GNS3, AAA/SSH y logs reales. La captura no prueba autenticación efectiva.

## NPS registrado en AD y puertos observados (captura del estudiante, 21 oct 2026)

La consulta a `RAS and IAS Servers` devolvió el objeto de equipo `SRV-AD-NPS$`. Servicio `IAS`: **Running**. `Get-NetUDPEndpoint -LocalPort 1812,1813` mostró ambos puertos en escucha en `10.25.13.31` y también en las interfaces `192.168.1.53` y `192.168.50.10` (por lo que se debe revisar exposición y limpiar IP antigua con cuidado). La consulta de reglas activas mostró excepciones NPS para RADIUS y protocolos adicionales, todas **Allow**, sin verificar todavía la restricción por dirección origen. Captura real enviada y pendiente de incorporar como `evidencias/13-nps-registro-puertos-firewall.png`. **No hay aún pruebas de autenticación de clientes Cisco.**

## Firewall RADIUS restringido — verificación PowerShell (21 de octubre de 2026)

El estudiante ejecutó satisfactoriamente `netsh advfirewall export "C:\Windows\Temp\firewall-pre-radius.wfw"`, y la consola respondió **Ok.** El respaldo queda exclusivamente en Windows Server y **no debe subirse al repositorio**.

Posteriormente restringió las reglas integradas NPS:

| Regla | Estado | Puerto UDP | IP local | IP remota |
|---|---|---|---|---|
| Legacy RADIUS Authentication | Disabled | 1645 | Any | Any |
| Legacy RADIUS Accounting | Disabled | 1646 | Any | Any |
| RADIUS Authentication | Enabled | 1812 | 10.25.13.31 | 10.25.13.1, 10.25.13.2 |
| RADIUS Accounting | Enabled | 1813 | 10.25.13.31 | 10.25.13.1, 10.25.13.2 |

El resultado procede de la salida real de PowerShell proporcionada por el estudiante. Evidencia gráfica pendiente: `evidencias/14-nps-firewall-radius-restringido.png`. **Alcance comprobado:** estas cuatro reglas. Sigue pendiente auditar cualquier otra regla que pueda permitir UDP 1812/1813. Continúan pendientes los registros efectivos de solicitudes/accounting y las pruebas auténticas desde Cisco en GNS3.

## NPS Accounting: configuración de registro revisada (capturas 21 oct 2026)

En `Accounting > Log File Properties`, se observó en la pestaña **Log File**: directorio `%SystemRoot%\System32\LogFiles`, formato **DTS Compliant**, rotación **Daily** y opción de borrar logs antiguos si el disco se llena. En **Settings**, estaban activadas las cuatro casillas: `Accounting requests`, `Authentication requests`, `Periodic accounting status`, `Periodic authentication status`. Además, aparecía activada `If logging fails, discard connection requests` (política *fail-closed*). El estudiante debe pulsar OK y verificar la persistencia antes de considerar esto finalizado. La opción fail-closed es aceptable para esta práctica, con la advertencia de que fallos en registro o disco pueden bloquear autenticaciones. Capturas reales pendientes de cargar al repositorio como `evidencias/15-nps-accounting.png` y una de la pestaña Log File. Pendiente comprobación `sc.exe qsidtype IAS` y autenticación RADIUS real desde GNS3.

## Ajuste IAS Service SID — diagnóstico (captura 21/oct/2026)

En Windows Server 2019, se ejecutó `sc.exe qsidtype IAS` y devolvió `[SC] QueryServiceConfig SUCCESS`, `SERVICE_NAME: IAS` y `SERVICE_SID_TYPE: NONE`. **Ajuste pendiente de ejecución:** `sc.exe sidtype IAS unrestricted`, verificación mediante `sc.exe qsidtype IAS` y reinicio controlado de la VM 150 (no de Proxmox). Microsoft documenta este ajuste para las excepciones de Firewall NPS en Windows Server 2019: https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-firewalls-configure . Conservar evidencia de los resultados y confirmar `Get-Service IAS` tras reinicio; la configuración todavía no constituye prueba de autenticación RADIUS exitosa.

## Servicios tras reinicio y recuperación de IAS — comprobado en captura (24 oct 2026)

La consulta inicial `Get-Service NTDS,DNS,IAS` mostró **DNS Running, IAS Stopped, NTDS Running**. Se ejecutó `Start-Service IAS` sin error y una nueva consulta confirmó **DNS Running, IAS Running, NTDS Running**. `Get-CimInstance Win32_Service -Filter "Name='IAS'" | Select-Object Name,State,StartMode` mostró `IAS Running Auto`. El inicio de IAS fue **manual en esta ocasión** aunque tiene arranque automático configurado; su correcto arranque tras reinicios posteriores aún debe comprobarse y, en caso de repetir el fallo, consultar Event Viewer/System y dependencias. Captura genuina proporcionada, pendiente de subida al repositorio como `evidencias/17-nps-servicios-operativos.png`. Próxima fase: inventario de dispositivos Cisco instalados en GNS3 VM 100 y diseño de conexiones hacia vmbr50.

## GNS3: inventario de plantillas verificado en capturas de Fedora (24 oct 2026)

En `Edit > Preferences` el cliente GNS3 está conectado al servidor remoto `gns3`. `Dynamips > IOS routers` y `IOS on UNIX > IOU Devices` aparecen sin plantillas. `QEMU > Qemu VMs` muestra las plantillas **Cisco IOSv 15.9(3)M9** (QEMU, e1000, 4 adaptadores, 512 MiB, servidor `gns3`) y **Cisco IOSvL2 20200929**. Se utilizarán como R1 y SW1 respectivamente. Imágenes reales aportadas en conversación, todavía no incorporadas al repositorio. Siguiente hito: crear proyecto en GNS3 y vincular un Cloud a la NIC que corresponda a `net4`/`vmbr50` de la VM 100; mapear por MAC antes de conectarlo. Esta elección evita instalar otras imágenes y mantiene Windows NPS en la VM 150.

## GNS3: proyecto creado y dispositivos colocados (captura del 24 oct 2026)

En el cliente GNS3 de Fedora, el proyecto **AAA-RADIUS-NPS-2025-1331** está abierto y aparecen tres nodos en el lienzo: un Cisco IOSv 15.9(3)M9, un Cisco IOSvL2 20200929 y `Cloud1`. Los dos nodos Cisco aparecen detenidos y Cloud está disponible. **Pendiente:** renombrarlos R1, SW1, CLOUD-AAA; confirmar que Cloud reside en el servidor GNS3 remoto y mapear por MAC su adaptador con `net4`/`vmbr50` de Proxmox ANTES de crear enlaces. No se ha verificado aún ningún cable ni configuración IP. Evidencia: captura original proporcionada por el estudiante; pendiente de publicación en `evidencias/18-gns3-topologia-inicial.png`.

## Mapeo de NIC del laboratorio confirmado — GNS3 Ubuntu VM 100 (24 oct 2026)

En la VM Ubuntu que ejecuta GNS3, el estudiante identificó mediante lectura de `/sys/class/net/*/address` que **enp6s22 = bc:24:11:bc:fa:00**, coincidente con la NIC Proxmox **net4 = vmbr50** de VM 100. `ip -br link` mostró `enp6s22 DOWN` (sin `UP`). El paso siguiente será habilitar **solo esa interfaz**, sin IP ni rutas, mediante `sudo ip link set dev enp6s22 up`, inspeccionar su estado y configurar el Cloud remoto de GNS3 con `enp6s22`. No se han conectado enlaces todavía. Captura pendiente: `evidencias/19-gns3-interfaz-vmbr50.png`.

## GNS3: topología cableada en el proyecto (captura del 24 oct 2026)

La imagen de GNS3 muestra el proyecto `AAA-RADIUS-NPS-2025-1331` con nodos renombrados `R1`, `SW1` y `CLOUD-AAA`. Enlaces creados visualmente: **R1 `e0` → SW1 `e0`** y **SW1 `e1` → CLOUD-AAA `enp6s22`**. En la lista de nodos, **R1 y SW1 aparecen apagados (rojo)** y Cloud activo (verde). Aún no se han validado las interfaces concretas vistas desde Cisco IOS, IPs, VLAN, ni ping a NPS; no declarar conectividad hasta probarla. Conservar captura como `evidencias/20-gns3-topologia-conectada.png` (todavía pendiente de subir el archivo gráfico). Siguiente paso: iniciar R1 y SW1 por GNS3, mostrar `show ip interface brief` en ambos; en SW1 comprobar además `show vlan brief` y `show interfaces status` para escoger las interfaces IOS correctas antes de cambiar configuración.

## Cisco R1 arrancado — consola IOSv verificada (24 oct 2026)

Captura de consola de R1 evidencia IOSv **15.9(3)M9** con `show ip interface brief`, cuatro interfaces `GigabitEthernet0/0` a `GigabitEthernet0/3`, todas **unassigned** y **administratively down/down** antes de configurar. La consola `enable` funciona. Para conectar el puerto e0 en GNS3, la interfaz propuesta es `GigabitEthernet0/0`. **Pendiente ejecutar y verificar** hostname R1, IP `10.25.13.1/24` sobre Gi0/0, `no shutdown`, guardar running-config, y realizar pruebas ping con NPS al habilitar SW1. Pendiente confirmar mapa de puertos y VLAN en IOSvL2 con comandos de inspección. La captura del estudiante es real; aún no incorporada como archivo PNG al repositorio.
