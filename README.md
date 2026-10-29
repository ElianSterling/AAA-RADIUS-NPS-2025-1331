# 🎥 Video demostrativo — AAA / RADIUS / NPS

**Pendiente:** insertar aquí el enlace real de YouTube al finalizar las pruebas. Duración máxima: **10 minutos**. Deben verse la fecha y la hora, el rostro del estudiante y escucharse su voz. Se mostrarán únicamente demostraciones auténticas.

# Implementación de AAA y RADIUS con Active Directory, NPS y Cisco IOS

**Estudiante:** Elian Sterling Severino Mejía  
**Matrícula:** 2025-1331  
**Institución:** ITLA — Seguridad de Redes  
**Modalidad:** individual  
**Estado (29/10/2026):** AAA/RADIUS/SSH y accounting probados; respaldo NPS y configuraciones Cisco disponibles; evidencias gráficas y video final pendientes

## Objetivo

Implementar autenticación, autorización y registro de accesos administrativos para **un router y un switch Cisco**. Las sesiones **SSH/VTY** utilizarán **RADIUS** mediante **Network Policy Server (NPS)** y **Active Directory**. El acceso local de emergencia estará reservado para **consola y AUX** cuando la imagen Cisco disponga de este último puerto. Se comprobarán tres grupos de AD (nivel 0, 5 y 10) y la compatibilidad real con privilegios IOS.

## Topología implementada

![Diagrama lógico del laboratorio](diagramas/topologia.svg)

| Equipo | Dirección comprobada | Función |
|---|---|---|
| R1 Cisco | 10.25.13.1/24 | Cliente RADIUS y SSH |
| SW1 Cisco | 10.25.13.2/24 | Cliente RADIUS y SSH |
| SRV-AD-NPS | 10.25.13.31/24 | AD DS, DNS y NPS |
| vmbr50 | 10.25.13.254/24 | Bridge AAA del host Proxmox |

**Direccionamiento realmente verificado en el laboratorio.** La SVI administrativa de SW1 es VLAN 13. Pruebas SSH se realizaron de SW1 a R1 y viceversa.

## Requisitos evaluados

- AAA de autenticación y autorización para router y switch.
- RADIUS como cliente en ambos Cisco; NPS como servidor RADIUS.
- Usuario local `adminrespaldo` para recuperación por consola/AUX; VTY 0–4 con SSH y RADIUS en ambos equipos. SW1 también tiene VTY 5–15 con SSH y autenticación local predeterminada, lo que se documenta como particularidad de la práctica.
- Registro de éxitos, rechazos y eventos AAA/RADIUS.
- Tres grupos de seguridad en AD: `GG_NIVEL_0`, `GG_NIVEL_5` y `GG_NIVEL_10`.
- Evidencia de los niveles efectivos con `show privilege` y comandos realmente permitidos.
- Documentación, diagramas, imágenes auténticas, scripts utilizados y running-configs sanitizados.
- Video independiente de esta infraestructura en YouTube y TXT de entrega.

**Nota técnica:** RADIUS puede asignar el nivel de privilegio de sesión mediante atributos de Cisco si el IOS lo admite; la autorización detallada por comando suele requerir TACACS+. Se documentará cualquier límite real, sin simular resultados.

## Documentación

- [Rúbrica y objetivos](docs/01-objetivos-rubrica.md)
- [Topología, redes y conectividad](docs/02-topologia-y-red.md)
- [Implementación AD DS y NPS](docs/03-active-directory-nps.md)
- [Configuración Cisco AAA, SSH y RADIUS](docs/04-cisco-aaa.md)
- [Pruebas y evidencias](docs/05-pruebas-y-evidencias.md)
- [Video y archivo de entrega](docs/06-video-y-entrega.md)
- [Seguridad de la publicación](docs/07-publicacion-y-seguridad.md)

**Carpetas:** `scripts/` (código ejecutado), `cisco/` (plantillas), `configs/` (exportaciones reales saneadas), `evidencias/` (capturas reales), `diagramas/` (topología).


## Estado comprobado (29 de octubre de 2026)

- **R1:** autenticación RADIUS por SSH y asignación de privilegios 5 y 10 confirmadas mediante `show privilege`; `usuario0` accedió con conjunto restringido de comandos coherente con privilegio 0.
- **SW1:** autenticaciones RADIUS exitosas y sesiones SSH documentadas.
- **Accounting R1:** seis pares `START`/`STOP` en `IN261029.log` de Windows NPS para `adminrespaldo`, `usuario5`, `usuario10` y `usuario0`.
- **Accounting SW1:** un par `START`/`STOP` en `IN261027.log`, originado desde `10.25.13.2` para `usuario5`.
- **Consola y AUX:** autenticación AAA con lista `LAB-LOCAL` configurada en ambos equipos. Se validó acceso local por consola con privilegio 15; AUX no dispone de evidencia de conexión física en el entorno virtual.
- **Auditoría NPS:** eventos 6272 de acceso autorizado y evento 6273 de credenciales incorrectas (código 16). El servicio `IAS` estaba en ejecución y `IN261029.log` contenía registros.
- **Respaldo NPS:** se exportó exitosamente `NPS-Backup.xml` de 65,891 bytes, **con secretos en texto claro**. Conservado fuera de GitHub; no publicarlo.
- **Configuraciones Cisco sanitizadas:** [R1](configs/R1-running-sanitized.txt) · [SW1](configs/SW1-running-sanitized.txt). Se eliminaron credenciales y textos extensos de banner; son documentos, no archivos de restauración.

**Aspectos por concluir:** adjuntar capturas y exportaciones de evidencia seleccionadas, verificar que el proyecto GNS3 correcto está guardado, grabar el video de máximo 10 minutos y añadir el enlace de YouTube y TXT requerido. La topología del repositorio debe compararse con la configuración efectivamente implementada.

**Nota de seguridad:** SW1 tiene `ip http server` y `ip http secure-server` habilitados. No son necesarios para esta validación AAA; en un despliegue real corresponde revisar/deshabilitar interfaces de administración que no se utilicen.

## Política de evidencias y seguridad

Todas las capturas, logs y pruebas deben generarse durante la práctica individual. No publicar contraseñas, claves compartidas RADIUS, hashes de tipo secret, tokens, certificados privados ni credenciales de cuentas reales. Conservar originales completos únicamente fuera del repositorio, en almacenamiento seguro. Una configuración saneada debe indicar los valores redactados.

**Referencias:** [Microsoft NPS](https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-top) · [GitHub Docs](https://docs.github.com/)
