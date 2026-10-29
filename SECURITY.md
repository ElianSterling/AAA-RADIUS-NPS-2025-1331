# Política de publicación segura

Este repositorio documenta un **laboratorio académico de autenticación AAA/RADIUS/NPS**. No contiene infraestructura productiva ni debe utilizarse como guía de endurecimiento exhaustivo.

## Datos que no se publican

- Contraseñas, claves compartidas RADIUS o hashes de cuentas locales.
- El respaldo `NPS-Backup.xml`, exportado con `exportPSK=YES`, que contiene secretos **sin cifrar**.
- Consolas Cisco completas sin saneamiento, claves privadas, certificados o imágenes de discos de VM.
- Datos personales ajenos al trabajo académico.

## Material disponible

Las configuraciones en `configs/` eliminan líneas sensibles y no son archivos de restauración. Las fotografías en `evidencias/` proceden de la práctica y fueron revisadas antes de su publicación.

## Riesgos conocidos del entorno de pruebas

El switch mantiene HTTP/HTTPS administrativo habilitado y VTY 5–15 con autenticación local predeterminada. El acceso AUX fue configurado, pero no se probó una conexión física en IOSv. No exponer el servicio RADIUS del laboratorio a redes públicas.

## Si se detecta un secreto expuesto

No lo duplique ni lo publique en un issue. Notifique de forma privada al propietario del repositorio para que pueda evaluar la exposición y limpiar los archivos y, si corresponde, el historial de Git. `.gitignore` no protege contenidos ya confirmados en commits.

[Documentación completa de seguridad](docs/07-publicacion-y-seguridad.md).
