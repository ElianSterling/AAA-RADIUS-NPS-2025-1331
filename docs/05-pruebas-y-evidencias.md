# 05 · Verificación y trazabilidad de pruebas

[← Inicio](../README.md) · [Configuración Cisco](04-cisco-aaa.md) · [Catálogo visual](09-evidencias-visuales.md)

## Criterio de validación

Los resultados aquí incluidos provienen de **salidas observadas de Cisco IOS, PowerShell y Windows NPS** o de capturas auténticas del laboratorio. Se distingue la evidencia del funcionamiento del dispositivo de la **fotografía disponible** en GitHub: no todos los resultados finales del 29/10 aparecen en las 21 imágenes históricas publicadas.

## Matriz de resultados

| ID | Prueba | Evidencia verificada | Resultado |
|:--|:--|:--|:--|
| T-01 | Direccionamiento R1 | `Gi0/0 = 10.25.13.1`, up/up | **Conforme** |
| T-02 | Direccionamiento SW1 | `Vlan13 = 10.25.13.2`, up/up | **Conforme** |
| T-03 | RADIUS en ambos equipos | `show aaa servers` con respuestas aceptadas | **Conforme** |
| T-04 | NPS y grupos AD | Clientes R1-CISCO/SW1-CISCO, tres políticas y atributos | **Conforme** |
| T-05 | SSH a R1 · nivel 5 | Sesión `usuario5` y `show privilege = 5` | **Conforme** |
| T-06 | SSH a R1 · nivel 10 | Sesión `usuario10` y `show privilege = 10` | **Conforme** |
| T-07 | SSH a R1 · nivel 0 | `usuario0` autenticado; `?` sin comandos `show` | **Comportamiento conforme** |
| T-08 | SSH a SW1 · nivel 10 | Sesión `usuario10` y `show privilege = 10` | **Conforme** |
| T-09 | AAA en consola de R1/SW1 | Reingreso local de `adminrespaldo` y privilegio 15 | **Conforme** |
| T-10 | AAA en AUX de R1/SW1 | `login authentication LAB-LOCAL` en running-config | **Configurado; sin sesión AUX probada** |
| T-11 | Accounting R1 | `IN261029.log`: seis parejas START/STOP, cliente 10.25.13.1 | **Conforme** |
| T-12 | Accounting SW1 | `IN261027.log`: una pareja START/STOP, cliente 10.25.13.2 | **Conforme** |
| T-13 | Auditoría de concesión | NPS Security 6272 para cuentas de laboratorio | **Conforme** |
| T-14 | Auditoría de rechazo | NPS Security 6273, `usuario0`, Reason Code 16 | **Conforme** |
| T-15 | Persistencia de AAA | `copy running-config startup-config` y verificaciones de startup | **Conforme según pruebas de consola** |
| T-16 | Exportación saneada | [R1](../configs/R1-running-sanitized.txt) y [SW1](../configs/SW1-running-sanitized.txt) | **Publicada** |

**Autenticación rechazada:** el evento 6273 con código 16 se atribuyó a credenciales incorrectas, y posteriormente se registró una sesión válida de la misma cuenta. No indica caída de NPS.

## Detalle de las sesiones de accounting

| Dispositivo | Archivo de Windows NPS | Usuario | START | STOP |
|:--|:--|:--|--:|--:|
| R1 | `IN261029.log` | `adminrespaldo` | 2 | 2 |
| R1 | `IN261029.log` | `usuario5` | 1 | 1 |
| R1 | `IN261029.log` | `usuario10` | 1 | 1 |
| R1 | `IN261029.log` | `usuario0` | 2 | 2 |
| SW1 | `IN261027.log` | `usuario5` | 1 | 1 |
| **Total** | | | **7** | **7** |

El servidor NPS registró `Acct-Status-Type = 1` (START) y `Acct-Status-Type = 2` (STOP) en eventos DTS Compliant. En Cisco, las solicitudes y respuestas de accounting también se verificaron con `show aaa servers`.

## Capturas disponibles

Se recibieron **43 fotografías**, de las que se seleccionaron y publicaron **21**:

- [Topología](../evidencias/01-topologia/01-topologia-gns3.png).
- [Usuarios y grupos AD](../evidencias/02-servidor-ad/03-validacion-usuarios-grupos-ad.png).
- [Clientes y políticas NPS](../evidencias/03-nps-clientes-politicas/04-clientes-radius-nps.png).
- [Acceso SSH con privilegio 10 en SW1](../evidencias/05-ssh-aaa/17-ssh-sw1-usuario10-nivel10.png).
- [Eventos 6272 de NPS](../evidencias/06-auditoria-nps/20-evento-6272-usuario10.png).

[**Consultar las 21 capturas con descripciones**](09-evidencias-visuales.md).

### Complementos visuales útiles

Las salidas finales de `show startup-config | section line`, las sesiones R1 de niveles 0/5/10 y la tabla PowerShell con accounting START/STOP se verificaron en los registros de trabajo de la práctica, pero **no forman parte de las 21 imágenes seleccionadas**. Si se adjuntan capturas nuevas, deben ser auténticas y preservar la fecha de captura, sin divulgar credenciales.

## Precisión metodológica

- Los intentos fallidos de ping observados en algunas etapas no invalidan las respuestas exitosas de RADIUS.
- Las capturas de fechas anteriores no prueban por sí solas los cambios del 29 de octubre.
- No se demuestra autorización detallada por comando mediante TACACS+, ni conexión AUX física.
- No se recrearon capturas ni se generaron logs sintéticos para presentar evidencias académicas.
