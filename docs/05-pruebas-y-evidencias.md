# Matriz de pruebas y evidencias

No declarar PASÓ sin observar el resultado auténtico. Para cada prueba adjuntar captura y hora.

| Prueba | Evidencia | Estado |
|---|---|---|
| Conectividad R1 → NPS | ping y rutas | PENDIENTE |
| Conectividad SW1 → NPS | ping | PENDIENTE |
| Clientes RADIUS NPS R1 y SW1 | Consola NPS | PENDIENTE |
| Grupos 0, 5, 10 y usuarios AD | ADUC | PENDIENTE |
| SSH R1 con usuario0/5/10 | Terminal + show privilege | PENDIENTE |
| SSH SW1 con usuario0/5/10 | Terminal + show privilege | PENDIENTE |
| Fallo de contraseña | Rechazo y evento 6273 | PENDIENTE |
| Acceso local consola | Inicio con adminlocal | PENDIENTE |
| Acceso local AUX si existe | Inicio con adminlocal | PENDIENTE |
| Solo SSH en VTY | show run line, show ip ssh | PENDIENTE |
| Eventos AAA Cisco | show logging | PENDIENTE |
| Eventos NPS y accounting | Logs, 6272/6273 | PENDIENTE |
| Running-config R1/SW1 | Ficheros saneados | PENDIENTE |

Nombres de captura sugeridos: 01-topologia-gns3.png, 02-ad-grupos.png, 03-clientes-nps.png, 04-politicas-nps.png, 05-ssh-nivel-0.png, 06-ssh-nivel-5.png, 07-ssh-nivel-10.png, 08-logs-nps.png, 09-logs-cisco.png.

Nunca capturar claves compartidas, contraseñas ni tokens. Las capturas deben proceder del equipo real, no ser ilustraciones presentadas como pruebas.


## Registro de capturas durante la implementación

Guardar cada imagen real apenas se valide el paso, con fecha y hora visible cuando resulte pertinente. Antes de cada cambio importante conservar captura **antes**, y al concluir capturar resultado **después**. Documentar si hubo errores y cómo se solucionaron.

| Archivo sugerido | Pantalla o comando concreto | Criterio |
|---|---|---|
| 01-proxmox-vm150.png | Proxmox VM 150 Hardware y Network | Se ve nombre de VM, recursos y bridge vmbr50 |
| 02-windows-configuracion-ip.png | Get-NetIPAddress / Get-NetIPConfiguration | Se ve IP del laboratorio basada en matrícula, estado Preferred |
| 03-windows-roles-instalados.png | Get-WindowsFeature AD-Domain-Services,DNS,NPAS | InstallState Installed de los tres |
| 04-active-directory-dominio.png | Server Manager y ADUC | Se ve dominio empresa.test |
| 05-active-directory-grupos.png | ADUC | Se ven GG_NIVEL_0, GG_NIVEL_5, GG_NIVEL_10 |
| 06-active-directory-usuarios.png | ADUC Membership | Se ve miembro correcto en cada grupo |
| 07-nps-clientes-radius.png | NPS RADIUS Clients | Clientes R1 y SW1 con IP correcta |
| 08-nps-politicas.png | NPS Network Policies | Grupos y atributos de autorización visibles, sin secretos |
| 09-gns3-topologia.png | GNS3 | R1, SW1, Cloud y conexiones visibles |
| 10-router-aaa.png | Consola IOS / show run AAA | AAA/VTY/SSH y cliente RADIUS |
| 11-switch-aaa.png | Consola IOS / show run AAA | AAA/VTY/SSH y cliente RADIUS |
| 12-pruebas-ssh.png | Sesiones separadas R1 y SW1 | show privilege para niveles 0/5/10 |
| 13-registros-radius.png | NPS eventos 6272/6273 y registros | Aceptación, rechazo y accounting comprobados |

No se deben publicar capturas con contraseñas, secretos RADIUS, hash de usuarios, datos personales ni información innecesaria del sistema. Guardar originales fuera de GitHub cuando contengan secretos; publicar versiones editadas para protección de datos sin alterar los resultados técnicos. Si una pantalla no demuestra una prueba, marcar PENDIENTE en lugar de aprobarla.

## Captura inmediata pendiente

Estamos en fase de Windows Server VM 150. Antes de cambiar más configuraciones:
1. Capturar Proxmox VM 150 con sus NIC y el bridge vmbr50.
2. Capturar la configuración de IP final confirmada desde PowerShell, sin contraseñas.
3. Tras la instalación de roles, capturar Get-WindowsFeature mostrando Installed.
4. Al promover el servidor, capturar que empresa.test existe y que DNS funciona; después registrar grupos/usuarios.

**La documentación de GitHub no sustituye la demostración real ni el video individual.**
