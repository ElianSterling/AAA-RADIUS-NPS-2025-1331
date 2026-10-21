# 🎥 Video demostrativo — AAA / RADIUS / NPS

**Pendiente:** insertar aquí el enlace real de YouTube al finalizar las pruebas. Duración máxima: **10 minutos**. Deben verse la fecha y la hora, el rostro del estudiante y escucharse su voz. Se mostrarán únicamente demostraciones auténticas.

# Implementación de AAA y RADIUS con Active Directory, NPS y Cisco IOS

**Estudiante:** Elian Sterling Severino Mejía  
**Matrícula:** 2025-1331  
**Institución:** ITLA — Seguridad de Redes  
**Modalidad:** individual  
**Estado:** laboratorio en construcción; pruebas pendientes de validación

## Objetivo

Implementar autenticación, autorización y registro de accesos administrativos para **un router y un switch Cisco**. Las sesiones **SSH/VTY** utilizarán **RADIUS** mediante **Network Policy Server (NPS)** y **Active Directory**. El acceso local de emergencia estará reservado para **consola y AUX** cuando la imagen Cisco disponga de este último puerto. Se comprobarán tres grupos de AD (nivel 0, 5 y 10) y la compatibilidad real con privilegios IOS.

## Topología propuesta

![Diagrama lógico del laboratorio](diagramas/topologia.svg)

| Equipo | Dirección prevista | Función |
|---|---|---|
| R1 Cisco | 10.25.13.1/24 | Cliente RADIUS y SSH |
| SW1 Cisco | 10.25.13.2/24 | Cliente RADIUS y SSH |
| SRV-AD-NPS | 10.25.13.31/24 | AD DS, DNS y NPS |
| Cliente opcional | 10.25.13.20/24 | Pruebas SSH |
| vmbr50 | Sin dirección en el host | Bridge aislado Proxmox/GNS3 |

**Direccionamiento provisional basado en 2025-1331.** Confirmar la regla de conversión con el docente antes de migrar los equipos; la instalación actual de Windows todavía utiliza temporalmente 192.168.50.10 en el segmento de laboratorio. No se presenta la propuesta como configuración ya realizada.

## Requisitos evaluados

- AAA de autenticación y autorización para router y switch.
- RADIUS como cliente en ambos Cisco; NPS como servidor RADIUS.
- Usuario local, utilizado solo en consola y AUX; VTY exclusivamente con SSH y RADIUS.
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

**Carpetas:** `scripts/` (código ejecutado), `cisco/` (plantillas), `running-configs/` (exportaciones reales saneadas), `evidencias/` (capturas reales), `diagramas/` (topología).

## Política de evidencias y seguridad

Todas las capturas, logs y pruebas deben generarse durante la práctica individual. No publicar contraseñas, claves compartidas RADIUS, hashes de tipo secret, tokens, certificados privados ni credenciales de cuentas reales. Conservar originales completos únicamente fuera del repositorio, en almacenamiento seguro. Una configuración saneada debe indicar los valores redactados.

**Referencias:** [Microsoft NPS](https://learn.microsoft.com/en-us/windows-server/networking/technologies/nps/nps-top) · [GitHub Docs](https://docs.github.com/)
