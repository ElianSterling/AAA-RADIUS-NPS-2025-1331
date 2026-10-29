# 10 · Resultados y conclusiones

[← Inicio](../README.md) · [Matriz de pruebas](05-pruebas-y-evidencias.md) · [Evidencias](09-evidencias-visuales.md)

## Resumen ejecutivo

El laboratorio implementó administración de equipos Cisco con **RADIUS centralizado en Microsoft NPS**, autenticación de identidades de **Active Directory**, autorización de sesión mediante atributos **Cisco-AV-Pair**, acceso remoto por **SSH v2** y registros de **accounting RADIUS**. Se mantuvo un mecanismo de acceso local por consola para la recuperación administrativa.

Los resultados verificados evidencian acceso con niveles 5 y 10 en R1, comandos restringidos para nivel 0, nivel 10 en SW1 y registros START/STOP de ambos clientes Cisco en NPS. Los mensajes RADIUS obtuvieron respuestas del servidor y el servicio `IAS` permaneció operativo durante la validación.

## Hallazgos principales

| Dimensión | Hallazgo |
|:--|:--|
| Autenticación | NPS valida cuentas del dominio y permite sesiones SSH en los dispositivos |
| Autorización | La política de red determina el nivel IOS de la sesión |
| Auditoría | NPS genera eventos de concesión y rechazo y escribe accounting START/STOP |
| Resiliencia operativa | La cuenta local permite administrar las consolas incluso fuera de la ruta SSH/RADIUS |
| Evidencia reproducible | Dos configuraciones Cisco saneadas y 21 fotografías auténticas disponibles en GitHub |

## Lecciones técnicas

**Separación de funciones AAA.** Una autenticación aceptada no basta para demostrar autorización o accounting: cada dimensión requiere sus propias pruebas. En este laboratorio, los atributos de autorización se contrastaron con privilegios reales de sesión, y el accounting se verificó también en los archivos de NPS.

**Seguridad de la evidencia.** Las exportaciones de Cisco y NPS son útiles para auditoría, pero pueden contener secretos. Las copias publicadas deben diferenciarse de los respaldos privados íntegros.

**Gestión del cambio.** Aplicar listas AAA por etapas y mantener una consola de recuperación permitió validar las políticas sin depender exclusivamente de RADIUS durante los ajustes.

## Alcance y limitaciones

- `AUX` aparece configurada con `LAB-LOCAL`, pero no se documentó una conexión auxiliar física.
- El nivel 0 se comprobó por comandos permitidos, no por `show privilege`, que el propio nivel restringe.
- El proyecto no demuestra autorización por comando mediante TACACS+.
- El endurecimiento de VTY adicionales y la administración HTTP/HTTPS del switch serían temas a revisar en un entorno productivo.
- El archivo `NPS-Backup.xml` permanece privado porque incorpora claves RADIUS sin cifrar.

## Conclusión

Se alcanzó el objetivo central de centralizar la autenticación administrativa y registrar el uso de sesiones remotas en un router y un switch Cisco, preservando el acceso local de recuperación. La trazabilidad entre topología, configuraciones, privilegios observados y registros de accounting permite sustentar la entrega mediante evidencias concretas.

**Proyecto:** AAA–RADIUS–NPS · **Asignatura:** Seguridad de Redes · **Matrícula:** 2025-1331 · **Validación:** 29/10/2026.
