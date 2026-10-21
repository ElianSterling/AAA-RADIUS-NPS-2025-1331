# Cisco AAA: autenticación, autorización y registros

## Requisitos previos
Identificar versiones e interfaces con show version y show ip interface brief. Las configuraciones de cisco/router y cisco/switch son PLANTILLAS; no son running-configs de equipos reales.

## Diseño de seguridad
- aaa new-model en ambos dispositivos.
- Usuarios locales para consola (y AUX si la imagen lo soporta).
- VTY con SSH v2 y autenticación RADIUS; sin línea telnet.
- Autorización de sesión EXEC mediante RADIUS, sujeta a compatibilidad con Cisco-AV-Pair shell:priv-lvl.
- Logging de logins, accounting de inicio/fin de sesión RADIUS, y eventos NPS.
- Mantener la consola abierta hasta verificar SSH y AAA para evitar pérdida de acceso.

**No confundir** niveles de privilegio IOS con autorización de cada comando. Para control granular de comandos, el protocolo habitual es TACACS+. Si la versión IOS no acepta determinada sintaxis AAA, documentar la limitación y cambiar a una imagen compatible.

## Comandos de verificación

~~~text
show version
show ip interface brief
show ip ssh
show aaa servers
show privilege
show users
show running-config | section aaa
show running-config | section radius
show running-config | section line
show logging
~~~

Hacer una sesión real con cada nivel (0, 5, 10), grabar el resultado de show privilege y contrastar los comandos permitidos.

## Running-configs
Capturar la configuración de ambos equipos mediante terminal length 0 y show running-config. Al exportarla, sustituir claves, hashes, secretos RADIUS y datos personales con marcadores [REDACTADO]. Guardar originales solo fuera de GitHub, en almacenamiento protegido.
