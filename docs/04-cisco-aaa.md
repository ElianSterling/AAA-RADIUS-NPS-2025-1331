# 04 · Cisco IOS: AAA, SSH y RADIUS

[← Inicio](../README.md) · [Topología](02-topologia-y-red.md) · [Pruebas](05-pruebas-y-evidencias.md)

## Dispositivos

- **R1:** Cisco IOSv 15.9, `GigabitEthernet0/0` `10.25.13.1/24`.
- **SW1:** Cisco IOSvL2 15.2, administración `Vlan13` `10.25.13.2/24`, enlaces de acceso a VLAN 13 por `Gi0/0` y `Gi0/1`.
- **Servidor RADIUS:** `NPS-AD` → `10.25.13.31`, autenticación UDP **1812**, accounting UDP **1813**.

Las configuraciones completas **saneadas** se incluyen en [R1](../configs/R1-running-sanitized.txt) y [SW1](../configs/SW1-running-sanitized.txt). Las copias originales con claves permanecen fuera del repositorio.

## Listas AAA implementadas

El siguiente extracto refleja las líneas comunes verificadas en ambos dispositivos, sin reproducir material sensible:

```cisco
aaa new-model
aaa group server radius NPS-GROUP
 server name NPS-AD
!
aaa authentication login default local
aaa authentication login LAB-RADIUS group NPS-GROUP local
aaa authentication login LAB-LOCAL local
aaa authorization exec LAB-EXEC group NPS-GROUP local
aaa accounting exec LAB-ACCOUNT start-stop group NPS-GROUP
aaa session-id common
!
radius server NPS-AD
 address ipv4 10.25.13.31 auth-port 1812 acct-port 1813
 ! [CLAVE RADIUS OMITIDA]
```

| Lista | Función | Aplicación |
|:--|:--|:--|
| `LAB-RADIUS` | Autenticación mediante NPS; alternativa local cuando RADIUS no responde | VTY 0–4 |
| `LAB-EXEC` | Autorización de sesión EXEC mediante atributos recibidos de NPS | VTY 0–4 |
| `LAB-ACCOUNT` | Mensajes de inicio/cierre de la sesión | VTY 0–4 |
| `LAB-LOCAL` | Inicio de sesión con usuario local del dispositivo | Consola y AUX |

**Nota de disponibilidad:** en la lista `group NPS-GROUP local`, el método local funciona como alternativa cuando el servidor RADIUS **no está disponible**. No significa que una contraseña rechazada por NPS se deba aceptar localmente.

## Líneas de acceso

**Configuración común en R1 y SW1:**

```cisco
line con 0
 login authentication LAB-LOCAL
line aux 0
 login authentication LAB-LOCAL
line vty 0 4
 exec-timeout 15 0
 authorization exec LAB-EXEC
 accounting exec LAB-ACCOUNT
 login authentication LAB-RADIUS
 transport input ssh
```

En SW1 se mantiene adicionalmente:

```cisco
line vty 5 15
 exec-timeout 15 0
 transport input ssh
```

Estas VTY adicionales conservan la autenticación predeterminada **local**, no una lista `LAB-RADIUS` explícita. Se documenta como una diferencia respecto a VTY 0–4, no como prueba de AAA/RADIUS en esas líneas.

## Administración SSH

Ambos dispositivos utilizan **SSH versión 2**. El acceso administrativo por consola GNS3 es independiente del Telnet de acceso remoto: el cliente Fedora se conectó a puertos de **consola virtual GNS3**, mientras que las VTY Cisco solo permiten SSH (`transport input ssh`).

## Verificación de funcionamiento

| Prueba | Resultado |
|:--|:--|
| NPS RADIUS desde R1 y SW1 | Respuestas de autenticación aceptadas |
| R1 → SW1 con `usuario10` | `show privilege` = **10** |
| SW1 → R1 con `usuario5` | `show privilege` = **5** |
| SW1 → R1 con `usuario10` | `show privilege` = **10** |
| SW1 → R1 con `usuario0` | Sesión iniciada; `?` muestra comandos restringidos |
| Accounting de R1 | Mensajes START y STOP confirmados |
| Accounting de SW1 | Mensajes START y STOP confirmados |
| Acceso por consola local | Cuenta `adminrespaldo`, privilegio 15 confirmado |

Comandos de diagnóstico utilizados:

```cisco
show ip interface brief
show ip ssh
show aaa servers
show running-config | include ^aaa
show running-config | section line
show startup-config | include ^aaa
show startup-config | section line
show privilege
```

## Límites y mejoras de endurecimiento

- La **autenticación** AAA en `con 0` y `aux 0` está aplicada; AUX no fue probada con una sesión física virtual.
- Los niveles de sesión provienen del `Cisco-AV-Pair` en RADIUS, no de una política de autorización por cada comando.
- En la exportación de SW1 figuran `ip http server` e `ip http secure-server` activos; en producción debe evaluarse su deshabilitación o restricción.
- La imagen del laboratorio permite comprobar funcionamiento, pero no sustituye una revisión de endurecimiento de dispositivos productivos.

[Ir a la matriz de pruebas →](05-pruebas-y-evidencias.md)
