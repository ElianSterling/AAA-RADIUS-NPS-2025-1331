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

## Switch IOSvL2: puertos identificados (captura del 24 oct 2026)

SW1 arranca correctamente con IOSvL2 15.2 (imagen 20200929). `show ip interface brief` y `show interfaces status` evidencian **Gi0/0 up/up connected** y **Gi0/1 up/up connected**, ambos en **VLAN 1** inicialmente; los demás puertos no conectados están down. `show vlan brief` muestra VLAN 1 activa y VLAN 1002-1005 predeterminadas. Correlación topológica: Gi0/0 se enlaza a R1 y Gi0/1 al Cloud `enp6s22` hacia Proxmox vmbr50. **Siguiente configuración propuesta (aún no verificada)**: crear VLAN 13, poner Gi0/0 y Gi0/1 como access de VLAN 13, crear SVI VLAN 13 `10.25.13.2/24`, y puerta de enlace `10.25.13.1`; luego verificar `show ip interface brief`, `show vlan brief`, y `ping 10.25.13.31`. Sin pruebas RADIUS todavía.

## SW1 VLAN de administración configurada y verificada (captura del 24 oct 2026)

La consola IOSvL2 de `SW1` muestra la creación de VLAN `13` (`AAA-MANAGEMENT`), Gi0/0 y Gi0/1 en modo access sobre VLAN 13, `interface Vlan13` con IP **10.25.13.2/24**, `no shutdown`, e `ip default-gateway 10.25.13.1`. Comandos de verificación confirman **Vlan13 up/up**, **Gi0/0 up/up VLAN 13** (enlace a R1), y **Gi0/1 up/up VLAN 13** (enlace a Cloud enp6s22). **Pendiente:** prueba efectiva `ping 10.25.13.31`, comprobación de que R1 Gi0/0 tenga `10.25.13.1/24` y esté up/up, y guardar running-config. Evidencia suministrada por usuario en la conversación; archivo físico `evidencias/22-switch-sw1-vlan13.png` pendiente de subirse. El estado `up/up` no demuestra por sí solo conectividad IP con NPS.

## Conectividad R1-SW1-NPS demostrada en GNS3 (capturas del 24 de octubre de 2026)

- **R1:** `show ip interface brief` confirma `GigabitEthernet0/0 10.25.13.1 YES manual up up`. Las otras interfaces están `administratively down/down`.
- **SW1:** `Vlan13 10.25.13.2 up/up`; VLAN 13 `AAA-MANAGEMENT` con Gi0/0 hacia R1 y Gi0/1 hacia CLOUD-AAA, ambos conectados.
- Desde SW1 hacia NPS `10.25.13.31` hay dos pings documentados: inicialmente **4/5 (80%)** y luego **5/5 (100%)**.
- Desde SW1 hacia R1 `10.25.13.1`: **4/5 (80%)**.
- En SW1 `copy running-config startup-config` devolvió `[OK]` y un mensaje de escritura exitosa en disco.
- El alcance probado es **conectividad IP/ICMP**; no hay todavía autenticación RADIUS funcional probada (UDP 1812/1813) ni sesión SSH/AAA probada.
- Guardar capturas reales como `evidencias/23-r1-interfaz-ip.png` y `evidencias/24-sw1-pruebas-conectividad.png` (archivos pendientes de incorporarse).

Siguiente hito: guardar startup-config R1, establecer credenciales locales de recuperación en R1 y SW1 **antes** de activar `aaa new-model`, habilitar SSH, configurar clientes RADIUS y verificar autenticación/autorización con registros NPS y niveles IOS reales.

## R1: pings a NPS y SW1 y configuración guardada (captura del 24 oct 2026)

La consola Cisco R1 muestra `GigabitEthernet0/0 10.25.13.1 YES manual up up`; `ping 10.25.13.31` devuelve **80% (4/5)**; `ping 10.25.13.2` devuelve **100% (5/5)**. `copy running-config startup-config` informa `Building configuration... [OK]` y la notificación `%GRUB-5-CONFIG_WRITING: GRUB configuration was written to disk successfully.` R1 está listo a nivel ICMP para iniciar el endurecimiento administrativo. **No se ha comprobado aún acceso RADIUS/SSH/AAA.** Conservar captura del usuario como evidencia real pendiente de carga, `evidencias/25-r1-ping-y-config-guardada.png`. Siguiente hito: establecer usuario administrativo local de recuperación, enable secret, SSHv2 y comprobar CLI antes de habilitar AAA sobre las líneas indicadas por la práctica. Nunca publicar secretos de RADIUS ni contraseñas en capturas/configs del repositorio.

## SSH de R1: RSA pendiente, atención a secretos en captura (24 oct 2026)

En la consola de R1 se introdujo `ip domain-name empresa.test`, un usuario local administrativo `adminrespaldo` con nivel 15, `enable secret`, `ip ssh time-out 60`, `ip ssh authentication-retries 3`, y `line vty 0 4` con `login local`, `transport input ssh`, `exec-timeout 15 0`. IOS mostró el mensaje `Please create RSA keys to enable SSH`; después varios intentos de `crypto key generate rsa ...` **desde el prompt privilegiado `R1#`** respondieron `% Invalid input detected`. Corrección recomendada: ejecutar `crypto key generate rsa` **desde `R1(config)#`** (seguir indicación del módulo para 2048 bits), después `ip ssh version 2` y comprobar `show ip ssh` y la existencia de la clave RSA. 

**Incidencia de seguridad:** la captura contiene contraseñas escritas en texto claro en el historial de consola. No cargar ni publicar esa captura original, ni usar esos secretos en el laboratorio; cambiarlos por valores únicos y robustos y tomar evidencias saneadas sin contraseñas ni hashes. No se han copiado secretos al repositorio. Hasta nueva salida verificada, SSH debe figurar **pendiente**, no como funcional.

## R1: generación RSA completada, SSH aún por verificar (24 oct 2026)

En captura de la consola IOSv 15.9(3)M9 de R1, `crypto key generate rsa` se ejecutó con éxito desde `R1(config)#`: módulo **2048 bits**, salida `[OK]`. También aparece `%SSH-5-ENABLED: SSH 1.99 has been enabled`; se introdujo `ip ssh version 2` mientras la consola estaba en modo global, pero todavía **no se mostró `show ip ssh`** para confirmar operativamente SSH 2.0. Intentos posteriores de `ip ssh version 2` desde `R1#` devolvieron `% Invalid input detected`; esto se debe al contexto CLI, no significa fallo en RSA. Próximo paso: revisar `show ip ssh`, `show crypto key mypubkey rsa` y `show running-config | section line vty`, después ensayar acceso SSH de manera segura con credenciales locales rotadas. No publicar ninguna evidencia que muestre contraseñas o claves privadas; la captura original del historial no debe subirse a GitHub.

## R1 SSHv2 habilitado y guardado — captura del 24/oct/2026

La captura auténtica de `R1#show ip ssh` confirma **`SSH Enabled - version 2.0`**, `Authentication timeout: 60 secs`, `Authentication retries: 3`, material de clave pública RSA 2048 bits de `R1.empresa.test` y la configuración `copy running-config startup-config` terminada en `[OK]`. R1 ha demostrado habilitación del servicio SSHv2, pero **no se ha demostrado todavía un inicio de sesión SSH exitoso**; siguiente hito: desde SW1 ejecutar `ssh -l adminrespaldo 10.25.13.1`, verificar prompt y `show privilege`, y regresar con `exit`. No registrar contraseñas ni publicar capturas de entradas de secretos. A continuación hacer configuración análoga en SW1 y después implementar y probar AAA según las restricciones del enunciado.

## SSH local de SW1 hacia R1: autenticación exitosa (captura 24/oct/2026)

Captura de consola GNS3 SW1 registra `SW1>ssh -l adminrespaldo 10.25.13.1`, solicitud `Password:` y posterior prompt `R1#` con banner IOSv. Por lo tanto **el inicio de sesión SSH desde SW1 hacia R1 con credencial LOCAL funcionó**. El prompt privilegiado indica acceso a EXEC privilegiado, y queda pendiente una comprobación explícita con `show privilege` y `show users` para registrar el nivel efectivo y la sesión. **Esto no constituye aún autenticación con RADIUS/NPS.** Evidencia real suministrada: `evidencias/27-r1-ssh-login-exitoso.png` (pendiente de subir como imagen); no publicar contraseñas. Próximo paso: salir de R1 con `exit`, configurar y probar SSH en SW1, y luego continuar los métodos AAA sobre consola/AUX atendiendo restricciones de la tarea.

## Confirmación del privilegio y sesión SSH R1 (captura 24/oct/2026)

Desde consola SW1 se realizó `ssh -l adminrespaldo 10.25.13.1` y se ingresó a R1 exitosamente. `R1#show privilege` devolvió **`Current privilege level is 15`** y `R1#show users` mostró la sesión remota **vty 0** con origen **10.25.13.2**, además de consola local. `exit` cerró la sesión y retornó al prompt SW1. Esto valida **SSH hacia R1 con autenticación LOCAL**, no prueba de SSH servidor de SW1 ni AAA/RADIUS. Evidencia real en captura del estudiante; aún se debe subir la imagen PNG al repositorio bajo `evidencias/27-r1-ssh-privilegio15.png`. El próximo paso es configurar SSHv2 local en SW1, validar con `show ip ssh` y conectar desde R1 a SW1 antes de AAA. Evitar publicar secretos en capturas o configuraciones.

## Prueba inversa R1 → SW1: SSH conecta pero no autentica (captura 24/oct/2026)

`R1#ssh -l adminrespaldo 10.25.13.2` mostró el banner de IOSvL2 en SW1 y múltiples solicitudes `Password:`; finalizó con `[Connection to 10.25.13.2 closed by foreign host]`, sin alcanzar el prompt del switch. **Conclusión limitada:** la conectividad IP y el servicio SSH están accesibles desde R1, pero la autenticación del usuario en SW1 falló. No declarar inicio de sesión SSH en SW1 exitoso. Antes de modificar AAA/RADIUS, inspeccionar localmente `show ip ssh` y `show running-config | section line vty`, y comprobar existencia de `adminrespaldo` sin publicar hashes; si procede, restablecer el secreto local con un valor nuevo y revisar `login local` en líneas VTY. Luego repetir SSH desde R1, documentar `show privilege` y guardar configuración. Mantener acceso a la consola GNS3 y NO subir capturas que contengan secretos.

## SW1 SSH: verificación adicional del servidor y VTY (captura del 24/oct/2026)

Desde la consola propia de SW1 se ve `show ip ssh` con **SSH Enabled - version 2.0**, clave RSA 2048 y autenticación basada en contraseña disponible. `show running-config | section line vty` confirma tanto **VTY 0-4** como **VTY 5-15** configurados con `login local`, `transport input ssh` y `exec-timeout 15 0`. No obstante, intentos `R1#ssh -l adminrespaldo 10.25.13.2` solicitaron contraseña repetidas veces y terminaron con cierre remoto; **el inicio de sesión SSH en SW1 sigue sin acreditarse**. Próximo paso: verificar **solo localmente** que existe el usuario `adminrespaldo` en SW1, sin publicar su hash, y si es necesario restablecer la contraseña única del switch desde su consola; repetir login desde R1 y ejecutar `show privilege` antes de guardar y avanzar a RADIUS. No modificar AAA/NPS como respuesta a este fallo de credenciales locales.

## SSH R1 → SW1: inicio de sesión local confirmado (captura 24 oct 2026)

Desde R1: `ssh -l adminrespaldo 10.25.13.2`. En la captura se observa acceso a `SW1#`, `show privilege` indica **Current privilege level is 15** y `show users` muestra una sesión **vty 0** procedente de **10.25.13.1**. La conexión se cerró limpiamente con `exit`. Se ha demostrado acceso SSH en ambos sentidos usando usuarios locales; **ninguna autenticación RADIUS ha sido demostrada**. La captura corresponde a evidencia real `28-sw1-ssh-privilegio15.png` que aún debe ser subida por el estudiante. Próximo paso: configurar y verificar cliente RADIUS NPS en R1 sin activar todavía `aaa new-model`. Antes de habilitar AAA global, planificar lista explícita local para VTY y métodos específicos para consola/AUX para conservar acceso administrativo. No subir secretos compartidos a GitHub.

## R1: sintaxis moderna `radius server` rechazada (captura 24/oct/2026, 23:17 hora local)

La captura del prompt `R1(config)#` muestra `% Invalid input detected` ante `radius server NPS-AD`; consecuentemente `address ipv4 10.25.13.31 auth-port 1812 acct-port 1813` también falla, ya que la CLI **no entró** en el submodo de servidor RADIUS. **No está configurado ni comprobado RADIUS en R1 por esas líneas.** Próximo paso propuesto: usar variante clásica **`radius-server host 10.25.13.31 auth-port 1812 acct-port 1813`** en configuración global (verificar el parser `radius-server ?` antes de cambios), configurar clave compartida sin divulgarla y `ip radius source-interface GigabitEthernet0/0`. Verificar sin exponer el secreto; no activar `aaa new-model` antes de preparar recuperación local y listas para consola/AUX/VTY. Documentación Cisco IOS 15.x sobre sintaxis `radius-server host` se consultó para orientar el diagnóstico.

## Recuperación de SW1 tras recreación (captura del 26 oct 2026)

Se reconstruyó un nuevo nodo SW1 en GNS3. Su consola demuestra: `ping 10.25.13.1` **5/5 (100%)**; generación exitosa de RSA de **2048 bits**; `show ip ssh` confirma **SSH Enabled - version 2.0**; `copy running-config startup-config` devolvió **[OK]** y aviso de escritura GRUB exitosa. La comprobación `show startup-config | include ^hostname|ip address|ip ssh version` confirma hostname `SW1`, interfaz con IP **10.25.13.2/24** e `ip ssh version 2` guardados. Es necesario **reverificar** `show vlan brief`, estado de Vlan13, `ping 10.25.13.31` y el inicio de sesión SSH desde R1. No se ha demostrado aún autenticación RADIUS. **Seguridad:** la captura mostraba contraseñas introducidas en texto claro y reutilizadas entre usuario local y `enable`; no se copiaron al repositorio. Deben rotarse a dos valores distintos, privados y robustos, guardar y tomar nuevas capturas saneadas antes de subir evidencias.

## SW1 reconstruido: VLAN 13, SSHv2 y conectividad NPS reverificados (26 oct 2026)

Captura posterior a la recreación del switch muestra `show ip interface brief`: **Gi0/0 up/up**, **Gi0/1 up/up**, **Vlan13 10.25.13.2 up/up**; `show vlan brief`: VLAN **13 AAA-MANAGEMENT**, puertos **Gi0/0, Gi0/1**; `show interfaces status`: Gi0/0 conectado a R1 y Gi0/1 a CLOUD-AAA, ambos VLAN 13. `ping 10.25.13.31` responde **5/5 (100%)**. `show ip ssh` confirma SSH enabled versión 2.0 y claves RSA 2048; `copy running-config startup-config` devolvió `[OK]` y `show startup-config` confirma `hostname SW1`, IP y SSHv2 guardados. **Pendiente**: probar login SSH hacia el nuevo SW1 desde R1 (`ssh -l adminrespaldo 10.25.13.2` + `show privilege`), comprobar rotación de contraseñas expuestas previamente, y conectar clientes RADIUS/AAA. La captura de evidencia del usuario aún no se subió como archivo gráfico; no usar capturas con secretos escritos.
