# Matriz de pruebas y evidencias

No declarar PASÓ sin observar el resultado auténtico. Para cada prueba adjuntar captura y hora.

| Prueba | Evidencia | Estado |
|---|---|---|
| Conectividad R1 → NPS | ping y rutas | PENDIENTE |
| Conectividad SW1 → NPS | ping | PENDIENTE |
| Clientes RADIUS NPS R1 y SW1 | Consola NPS | PENDIENTE |
| Grupos 0, 5, 10 y usuarios AD | ADUC | PENDIENTE |
| SSH R1 con usuario0/5/10 | Terminal + show privilege | PENDIENTE |
| SSH SW1 con usuario0/5/10 | Terminal + show privilege | PENDIENTE |
| Fallo de contraseña | Rechazo y evento 6273 | PENDIENTE |
| Acceso local consola | Inicio con adminlocal | PENDIENTE |
| Acceso local AUX si existe | Inicio con adminlocal | PENDIENTE |
| Solo SSH en VTY | show run line, show ip ssh | PENDIENTE |
| Eventos AAA Cisco | show logging | PENDIENTE |
| Eventos NPS y accounting | Logs, 6272/6273 | PENDIENTE |
| Running-config R1/SW1 | Ficheros saneados | PENDIENTE |

Nombres de captura sugeridos: 01-topologia-gns3.png, 02-ad-grupos.png, 03-clientes-nps.png, 04-politicas-nps.png, 05-ssh-nivel-0.png, 06-ssh-nivel-5.png, 07-ssh-nivel-10.png, 08-logs-nps.png, 09-logs-cisco.png.

Nunca capturar claves compartidas, contraseñas ni tokens. Las capturas deben proceder del equipo real, no ser ilustraciones presentadas como pruebas.
