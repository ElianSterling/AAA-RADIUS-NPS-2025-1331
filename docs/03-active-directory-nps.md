# Implementación Windows Server: AD DS, DNS y NPS

## Preparación
1. Comprobar VM 150 en Proxmox, red y la existencia de backup.
2. Confirmar adaptadores con Get-NetAdapter y Get-NetIPConfiguration.
3. Definir la IP definitiva del laboratorio y evitar interfaces de un DC multihomed. Mantener acceso por consola Proxmox mientras se reconfigura.
4. El host tendrá nombre SRV-AD-NPS y dominio de prueba empresa.test; confirmar configuración antes de promover.

## Instalar roles (PowerShell administrador)

~~~powershell
Install-WindowsFeature AD-Domain-Services,DNS,NPAS -IncludeManagementTools
Install-ADDSForest -DomainName 'empresa.test' -DomainNetbiosName 'EMPRESA' -InstallDNS
~~~

La promoción pide contraseña DSRM y reinicia Windows. No publicar contraseña ni información sensible.

## Tres grupos
Ejecutar scripts/01-crear-grupos-usuarios-ad.ps1 después de la promoción. Crear y demostrar:
- GG_NIVEL_0 → usuario0
- GG_NIVEL_5 → usuario5
- GG_NIVEL_10 → usuario10

## NPS
1. Server Manager → Tools → Network Policy Server.
2. Registrar NPS en Active Directory desde el nodo NPS (Local).
3. RADIUS Clients: añadir R1 (10.25.13.1) y SW1 (10.25.13.2); claves compartidas **distintas**, largas y secretas.
4. Crear políticas de red para los tres grupos. Ordenar de más específica a menos específica, con condiciones de grupo y NAS adecuadas.
5. En la política correspondiente, configurar Cisco Vendor-Specific Attribute: Vendor ID 9, Cisco-AV-Pair (tipo 1) con cadena shell:priv-lvl=0, =5 o =10; esta atribución requiere prueba de compatibilidad de la imagen IOS.
6. Revisar constraints y método de autenticación. Si únicamente PAP es viable en el laboratorio, mantener RADIUS dentro de segmento aislado y documentar el riesgo; no usarlo sobre Internet.
7. Permitir UDP 1812/1813 solamente desde R1 y SW1 en Windows Firewall; revisar Connection Request Policies.

## Auditoría y pruebas
- Event Viewer → Windows Logs → Security. Activar auditoría NPS si fuese necesario.
- Evento 6272: acceso concedido; 6273: denegación.
- NPS Accounting: registros de solicitudes y sesiones, incluidos Access-Request y accounting cuando esté disponible.
- Capturar fecha/hora, nombre de política, identificador del cliente y resultado; ocultar secretos.

Referencias: https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/
