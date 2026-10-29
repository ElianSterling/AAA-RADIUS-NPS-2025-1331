# 07 · Publicación segura y trazabilidad

[← Inicio](../README.md) · [Configuraciones Cisco](04-cisco-aaa.md) · [Capturas](09-evidencias-visuales.md)

## Principio de publicación

Este repositorio contiene **documentación técnica, capturas de laboratorio y configuraciones Cisco saneadas**. Las claves RADIUS, los hashes de contraseñas, las contraseñas de administración, certificados privados y volcados completos de servidores se conservan fuera de GitHub.

| Material | Tratamiento |
|:--|:--|
| `configs/R1-running-sanitized.txt` | Publicable, con credenciales reemplazadas por comentarios |
| `configs/SW1-running-sanitized.txt` | Publicable, con credenciales reemplazadas por comentarios |
| `evidencias/` | 21 PNG reales revisados |
| `NPS-Backup.xml` | **Privado: contiene secretos compartidos RADIUS en texto claro** |
| `R1-consola.txt` y `SW1-consola.txt` originales | **Privados: contienen hashes y claves** |
| `*.key`, certificados privados, discos de VM, exportaciones AD | Excluidos del repositorio |

## Controles aplicados

- Copias documentales de configuración separadas de los respaldos privados.
- Tres instrucciones con valores sensibles ocultadas en cada equipo Cisco.
- Eliminación de banners extensos de IOSv en las copias públicas.
- Revisión visual de las 21 capturas seleccionadas; la auditoría automática no sustituye la inspección humana.
- Catalogación de evidencias indicando qué demuestra realmente cada imagen.

La protección mediante `.gitignore` ayuda a evitar subidas accidentales, **pero no elimina secretos que ya hubieran sido confirmados en el historial de Git**. Antes de hacer nuevos commits se deben revisar rutas y contenidos.

## Limitaciones de endurecimiento de producción

Este es un entorno académico. SW1 muestra habilitados `ip http server` e `ip http secure-server`; conviene deshabilitar o limitar los servicios administrativos que no se utilicen en producción. Las VTY 5–15 de SW1 no aplican explícitamente la lista RADIUS. Se verificaron niveles de privilegio de sesión, no una política granular de comandos TACACS+.

## Trazabilidad y ética académica

La bitácora conserva errores y correcciones históricos, y el catálogo identifica las capturas realmente publicadas. No se fabrican resultados ni capturas: cada afirmación sobre RADIUS, SSH y accounting procede de una prueba auténtica o se presenta explícitamente como limitación no demostrada.
