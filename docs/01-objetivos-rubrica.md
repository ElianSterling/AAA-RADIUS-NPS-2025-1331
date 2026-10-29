# 01 · Objetivos y control de requisitos

[← Inicio](../README.md) · [Pruebas](05-pruebas-y-evidencias.md) · [Evidencias](09-evidencias-visuales.md)

## Objetivo

Implementar y verificar un esquema **AAA** (Authentication, Authorization and Accounting) para la administración de un router y un switch Cisco, respaldado por **Active Directory + Windows NPS (RADIUS)**, con SSH y recuperación por consola local.

## Matriz de cumplimiento — 29/10/2026

| Requisito del laboratorio | Implementación / evidencia | Estado |
|:--|:--|:--|
| Un router Cisco | R1 IOSv, Gi0/0 `10.25.13.1` y topología GNS3 | **Verificado** |
| Un switch Cisco | SW1 IOSvL2, SVI VLAN13 `10.25.13.2` | **Verificado** |
| Windows Server con AD DS y NPS | SRV-AD-NPS `10.25.13.31`; servicio IAS activo | **Verificado** |
| Grupos y usuarios nivel 0, 5, 10 | Tres políticas y grupos asociados en AD/NPS | **Verificado** |
| RADIUS en ambos Cisco | NPS-GROUP, RADIUS UDP 1812/1813, aceptación y accounting | **Verificado** |
| Usuario administrativo local | `adminrespaldo` en consola y AUX mediante LAB-LOCAL | **Consola probada; AUX configurada** |
| Acceso remoto seguro | VTY 0–4 exclusivamente SSH v2, con LAB-RADIUS | **Verificado** |
| Asignación de privilegios | R1: 5 y 10 con `show privilege`; 0 con comandos restringidos; SW1: 10 | **Verificado en pruebas descritas** |
| Contabilidad RADIUS | NPS: R1 seis pares START/STOP; SW1 un par | **Verificado** |
| Registro de aceptación/rechazo | Eventos Security 6272 y 6273 | **Verificado** |
| Respaldo y configuraciones Cisco | Exportaciones privadas y versiones saneadas en `configs/` | **Verificado** |
| Capturas e informe | 21 PNG originales publicados y catálogo técnico | **Publicado** |
| Video de demostración | [Enlace de YouTube proporcionado](https://youtu.be/sHstTWs5tKY) | **Enlazado; contenido audiovisual por revisar** |
| TXT con enlaces para entregar | [Elian_Sterling_Severino_Mejia_2025-1331_P4.txt](../Elian_Sterling_Severino_Mejia_2025-1331_P4.txt) con GitHub y YouTube | **Creado** |

**Precisiones:** el privilegio 0 no permite `show privilege`, y su restricción se comprobó con `?`. En IOSv no se realizó una sesión física de AUX. Una prueba anterior de ICMP fallida no invalida el flujo RADIUS cuyo tráfico y respuestas sí se verificaron.

## Criterios de integridad

Se usan solamente configuraciones, logs y fotografías auténticos de la práctica. Las rutas saneadas permiten verificar sintaxis sin publicar contraseñas, secretos RADIUS, hashes ni certificados privados. Las capturas históricas no se presentan como si fuesen posteriores a los cambios finales.

## Alcance de autorización

La autorización EXEC basada en atributo `shell:priv-lvl` **no constituye** una prueba de autorización individual de cada comando. El proyecto verifica niveles de privilegio de sesión.
