# 03 · Windows Server, Active Directory y NPS

[← Inicio](../README.md) · [Topología](02-topologia-y-red.md) · [Auditoría](05-pruebas-y-evidencias.md)

## Servidor de autenticación

| Servicio | Implementación |
|:--|:--|
| Sistema operativo | Windows Server 2019 |
| VM | Proxmox 150 · `SRV-AD-NPS` |
| IP de laboratorio | `10.25.13.31/24` |
| Dominio AD DS | `empresa.test` (NetBIOS `EMPRESA`) |
| Roles | AD DS, DNS y Network Policy Server (NPS) |
| Servicio de NPS | `IAS` — **Running** el 29/10/2026 |

## Identidades y grupos

Los usuarios de laboratorio están asociados a los grupos de seguridad respectivos:

| Grupo AD | Usuario de prueba | Privilegio de sesión |
|:--|:--|:--|
| `GG_NIVEL_0` | `usuario0` | 0 |
| `GG_NIVEL_5` | `usuario5` | 5 |
| `GG_NIVEL_10` | `usuario10` | 10 |

[Ver evidencia de grupos y usuarios](../evidencias/02-servidor-ad/03-validacion-usuarios-grupos-ad.png).

## Clientes y políticas RADIUS

NPS tiene configurados **R1-CISCO** (`10.25.13.1`) y **SW1-CISCO** (`10.25.13.2`) como clientes RADIUS.

| Network Policy | Atributo Cisco VSA | Efecto comprobado |
|:--|:--|:--|
| `AAA_NIVEL_0` | `shell:priv-lvl=0` | Shell con comandos restringidos |
| `AAA_NIVEL_5` | `shell:priv-lvl=5` | `show privilege` = 5 en R1 |
| `AAA_NIVEL_10` | `shell:priv-lvl=10` | `show privilege` = 10 en R1 y SW1 |

Las políticas utilizan autenticación de Windows y respuestas RADIUS con `Service-Type = NAS Prompt` (observado en la configuración y pruebas de atributos de la fase de implementación). Se utilizó PAP en este laboratorio; este método debe mantenerse dentro de un segmento controlado, no expuesto a Internet.

[Clientes RADIUS](../evidencias/03-nps-clientes-politicas/04-clientes-radius-nps.png) · [Políticas NPS](../evidencias/03-nps-clientes-politicas/05-politicas-nps-listado.png) · [Atributos nivel 0](../evidencias/03-nps-clientes-politicas/09-cisco-avpair-priv0.png) / [5](../evidencias/03-nps-clientes-politicas/10-cisco-avpair-priv5.png) / [10](../evidencias/03-nps-clientes-politicas/11-cisco-avpair-priv10.png)

## Registros de autenticación y contabilidad

La pestaña de accounting NPS se configuró para registrar solicitudes de autenticación y accounting en **archivos locales**, formato **DTS Compliant**, con archivo nuevo **diario** en `%SystemRoot%\System32\LogFiles`.

| Registro | Resultado observado |
|:--|:--|
| `IN261029.log` | 25,470 bytes al comprobar el 29/10/2026; seis pares START/STOP de R1 |
| `IN261027.log` | Una sesión `usuario5` de SW1 con START y STOP |
| Event ID **6272** | Concesión de acceso |
| Event ID **6273** | Rechazo de `usuario0`, Reason Code **16**, error de credenciales |

Los eventos NPS del 29/10 muestran autenticaciones autorizadas después del rechazo observado. Las parejas START y STOP de R1 y SW1 se localizaron analizando `Acct-Status-Type` en los archivos NPS.

[Configuración de archivos de accounting](../evidencias/06-auditoria-nps/21-configuracion-archivo-accounting.png) · [Catálogo de auditoría](09-evidencias-visuales.md)

## Respaldo y seguridad

Se realizó la exportación privada `NPS-Backup.xml` mediante `netsh nps export ... exportPSK=YES` y se comprobó un tamaño de **65,891 bytes** el 29/10/2026.

**No publicar este XML**: el comando exporta las claves compartidas RADIUS sin cifrar. La exportación NPS tampoco es un respaldo integral de Active Directory; no debe confundirse con una copia de usuarios y grupos del dominio.

El repositorio contiene referencias y fotografías auténticas, no contraseñas ni el respaldo completo con secretos.

**Referencia:** [Microsoft Learn — Network Policy Server](https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-top).
