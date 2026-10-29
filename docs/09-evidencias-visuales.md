# 09 · Catálogo de evidencias visuales

[← Inicio](../README.md) · [Pruebas](05-pruebas-y-evidencias.md) · [Conclusiones](10-resultados-y-conclusiones.md)

**Estudiante:** Elian Sterling Severino Mejía · **Matrícula:** 2025-1331 · **Revisión:** 29/10/2026.

Se recibieron **43 archivos PNG** en `Practica 4.zip`; se seleccionaron **21** imágenes originales, sin alteraciones, y se descartaron 22 del conjunto de publicación por redundancia o menor valor probatorio. **Las 21 fotografías originales seleccionadas están publicadas y sus rutas fueron verificadas en GitHub**, bajo las rutas indicadas. El commit de incorporación preservó el contenido binario original de cada PNG. [Ver carpeta de evidencias](../evidencias/).

## Índice de fotografías publicadas

![Topología GNS3](../evidencias/01-topologia/01-topologia-gns3.png)

| Nº | Área | Evidencia publicada | Qué demuestra |
|---:|---|---|---|
| 01 | Topología | [Ver imagen](../evidencias/01-topologia/01-topologia-gns3.png) | Conexiones R1–SW1–CLOUD-AAA, 29/oct |
| 02 | AD DS | [Ver imagen](../evidencias/02-servidor-ad/02-roles-ad-dns-nps.png) | Roles AD DS, DNS y NPAS instalados, 21/oct |
| 03 | AD DS | [Ver imagen](../evidencias/02-servidor-ad/03-validacion-usuarios-grupos-ad.png) | Verificación usuarios y pertenencia a grupos 0/5/10, 21/oct |
| 04 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/04-clientes-radius-nps.png) | Clientes RADIUS en NPS |
| 05 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/05-politicas-nps-listado.png) | Lista de políticas NPS |
| 06 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/06-politica-nivel0-resumen.png) | Resumen de política nivel 0 |
| 07 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/07-politica-nivel5-resumen.png) | Resumen de política nivel 5 |
| 08 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/08-politica-nivel10-resumen.png) | Resumen de política nivel 10 |
| 09 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/09-cisco-avpair-priv0.png) | Cisco-AV-Pair shell:priv-lvl=0 |
| 10 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/10-cisco-avpair-priv5.png) | Cisco-AV-Pair shell:priv-lvl=5 |
| 11 | NPS | [Ver imagen](../evidencias/03-nps-clientes-politicas/11-cisco-avpair-priv10.png) | Cisco-AV-Pair shell:priv-lvl=10 |
| 12 | Conectividad | [Ver imagen](../evidencias/04-conectividad/12-ip-r1-gigabit-00.png) | R1 Gi0/0 = 10.25.13.1, interfaz UP/UP |
| 13 | Conectividad | [Ver imagen](../evidencias/04-conectividad/13-vlan13-sw1-conectividad.png) | SW1 VLAN13/10.25.13.2 y ping (incluye histórico de pérdida) |
| 14 | Conectividad | [Ver imagen](../evidencias/04-conectividad/14-firewall-nps-udp.png) | Reglas de firewall UDP 1812/1813 (captura histórica, alcance Any) |
| 15 | SSH | [Ver imagen](../evidencias/05-ssh-aaa/15-ssh-version2-r1.png) | R1 muestra versión SSH 2 |
| 16 | SSH | [Ver imagen](../evidencias/05-ssh-aaa/16-sesion-ssh-local-historica.png) | Sesión SSH de respaldo anterior a configuración final de RADIUS |
| 17 | SSH | [Ver imagen](../evidencias/05-ssh-aaa/17-ssh-sw1-usuario10-nivel10.png) | Acceso RADIUS usuario10 en SW1, privilegio 10 |
| 18 | Auditoría NPS | [Ver imagen](../evidencias/06-auditoria-nps/18-evento-6272-usuario0.png) | NPS evento 6272, usuario0 |
| 19 | Auditoría NPS | [Ver imagen](../evidencias/06-auditoria-nps/19-evento-6272-usuario5.png) | NPS evento 6272, usuario5 |
| 20 | Auditoría NPS | [Ver imagen](../evidencias/06-auditoria-nps/20-evento-6272-usuario10.png) | NPS evento 6272, usuario10 |
| 21 | Auditoría NPS | [Ver imagen](../evidencias/06-auditoria-nps/21-configuracion-archivo-accounting.png) | NPS Accounting en DTS Compliant y registro diario |

## Resultados técnicos verificados en la práctica

- **R1:** acceso por SSH de `usuario5` con `show privilege` = 5 y `usuario10` = 10; `usuario0` inició sesión con conjunto de comandos limitado, coherente con nivel 0.
- **SW1:** acceso de `usuario10` con nivel 10 demostrado en la captura 17.
- **NPS:** el 29/oct, archivo `IN261029.log` con seis parejas START/STOP para el cliente `10.25.13.1` (R1): `adminrespaldo` dos parejas; `usuario5`, una; `usuario10`, una; y `usuario0`, dos. Para SW1 se verificó en `IN261027.log` una pareja START/STOP de `usuario5`, cliente `10.25.13.2`.
- **NPS Event Viewer:** eventos 6272 de accesos permitidos y 6273 de un intento de `usuario0` rechazado con código 16 (credenciales incorrectas).
- **AAA consola/AUX:** configurado `LAB-LOCAL` en consola y AUX de R1 y SW1; consola comprobada con cuenta local y privilegio 15. AUX no se ha probado físicamente en IOSv.

**Distinción cronológica:** las imágenes del 21–27/oct documentan esas etapas y no sustituyen las pruebas finales del 29/oct, que se verificaron por separado mediante las salidas de Cisco IOS y Windows NPS. Ninguna captura se presenta con una fecha distinta de su origen.

## Material de ampliación documental

1. `show aaa servers` reciente de **R1 y SW1**, con contadores Start/Stop y transacciones exitosas.
2. Tabla PowerShell NPS con `Acct-Status-Type` Start/Stop para los dos clientes Cisco.
3. `show startup-config | section line` de **ambos** dispositivos para demostrar autenticación local en consola/AUX y RADIUS en VTY.
4. `show privilege` desde cuentas de niveles 5 y 10 en **R1**; prueba con `usuario0` y comandos limitados.
5. El video fue **grabado y enlazado**: [demostración en YouTube](https://youtu.be/sHstTWs5tKY). El archivo [TXT de entrega](../Elian_Sterling_Severino_Mejia_2025-1331_P4.txt) contiene ambos enlaces; consulte [video y entrega](06-video-y-entrega.md).

## Seguridad de publicación

Las 21 imágenes seleccionadas se revisaron visualmente sin encontrar contraseñas en claro ni claves RADIUS legibles. Algunas imágenes contienen IP privadas, cuentas de laboratorio, identificadores de auditoría o clave **pública** SSH. No publicar `NPS-Backup.xml` (contiene secretos compartidos sin cifrar), ni `R1-consola.txt`, ni `SW1-consola.txt` con configuraciones completas.

Las configuraciones Cisco documentales ya publicadas están en [R1](../configs/R1-running-sanitized.txt) y [SW1](../configs/SW1-running-sanitized.txt).
