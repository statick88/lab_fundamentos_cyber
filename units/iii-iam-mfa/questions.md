# Preguntas de Evaluación - IAM y MFA

## Pregunta 1: Configuración de control de acceso basado en roles (RBAC)

**Escenario**:
La empresa TechCorp necesita implementar RBAC en sus servidores Linux para los departamentos de desarrollo, operaciones y seguridad. Debes crear grupos de sistema para cada departamento, configurar políticas de contraseñas diferenciadas, y establecer permisos sudo basados en roles. El grupo de seguridad debe tener acceso total, desarrollo acceso limitado, y operaciones acceso intermedio.

**Requisitos**:
- Crear grupos: `dev`, `ops`, `security`
- Configurar políticas de contraseñas diferenciadas por grupo
- Establecer reglas sudoers para cada grupo
- Verificar que los permisos se aplican correctamente

**Restricciones**:
- No crear usuarios sin pertenencia a un grupo
- Las políticas de contraseñas deben cumplir estándares de seguridad
- El acceso sudo debe seguir el principio de mínimo privilegio
- No modificar configuraciones de usuarios existentes sin documentación

**Criterios de Validación**:
- Los grupos están creados y verificables
- Las políticas de contraseñas están configuradas en `/etc/security/pwquality.conf`
- Los archivos sudoers están configurados para cada grupo
- `getent group` muestra los miembros correctos

**Pregunta de Selección Múltiple**:

¿Qué archivo se utiliza para configurar reglas de sudoers de forma segura sin riesgo de sintaxis?

A) `/etc/sudoers`
B) `/etc/sudoers.d/`
C) `/etc/passwd`
D) `/etc/shadow`

**Explicación**:
- Respuesta correcta: B) `/etc/sudoers.d/` — El directorio `/etc/sudoers.d/` permite agregar reglas de sudoers en archivos separados, lo que facilita la gestión y evita errores de sintaxis que podrían bloquear el acceso root. Se usa `visudo -f` para editar de forma segura.
- Distractor A: Editar `/etc/sudoers` directamente es riesgoso; un error de sintaxis puede bloquear el acceso sudo.
- Distractor C: `/etc/passwd` contiene información de usuarios, no reglas de sudoers.
- Distractor D: `/etc/shadow` contiene hashes de contraseñas, no reglas de sudoers.

---

## Pregunta 2: Autenticación multifactor (MFA) con PAM

**Escenario**:
El equipo de seguridad necesita implementar MFA en los servidores Linux usando módulos PAM. Debes configurar la autenticación de dos factores: contraseña + código TOTP. El sistema debe usar Google Authenticator como proveedor TOTP y rechazar accesos sin ambos factores.

**Requisitos**:
- Instalar y configurar `libpam-google-authenticator`
- Configurar PAM para requerir ambos factores
- Generar un secreto TOTP para un usuario de prueba
- Verificar que la autenticación funciona con ambos factores

**Restricciones**:
- No deshabilitar la autenticación por contraseña
- El TOTP debe tener una ventana de ±30 segundos
- Los secretos no deben almacenarse en texto plano en logs
- La configuración debe ser reversible en caso de emergencia

**Criterios de Validación**:
- El módulo PAM está configurado en `/etc/pam.d/sshd`
- `auth required pam_google_authenticator.so` está presente
- Un usuario puede autenticarse con contraseña + TOTP
- El acceso sin TOTP es rechazado

**Pregunta de Selección Múltiple**:

¿Qué protocolo usa Google Authenticator para generar códigos de un solo uso?

A) HMAC-SHA1
B) TOTP (Time-based One-Time Password)
C) HOTP (HMAC-based One-Time Password)
D) RSA SecurID

**Explicación**:
- Respuesta correcta: B) TOTP (Time-based One-Time Password) — TOTP es un algoritmo basado en tiempo que genera códigos de un solo uso cada 30 segundos, derivados de un secreto compartido y la marca temporal. Es el estándar RFC 6238 para autenticación de segundo factor.
- Distractor A: HMAC-SHA1 es la función hash usada internamente por TOTP, no el protocolo completo.
- Distractor C: HOTP es basado en contador, no en tiempo; no expira automáticamente.
- Distractor D: RSA SecurID es una solución propietaria, no un protocolo estándar abierto.
