

# Ingressar Linux no Domínio Samba4 com Winbind

Este documento mostra como ingressar o Linux ao domínio Samba4 usando **Winbind** com integração NSS/PAM.

---

## Pré-requisitos

- Samba4 como controlador de domínio (DC)
- Linux com DNS e horário corretos
- Conectividade com o servidor

---

## Etapas

### 1. Instalar pacotes necessários

```bash
sudo apt update && sudo apt install samba winbind libpam-winbind libnss-winbind krb5-user
```

2. Configurar /etc/krb5.conf

```bash
[libdefaults]
    default_realm = EDUCATUX.EDU
    dns_lookup_realm = false
    dns_lookup_kdc = true
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true
    rdns = false
    fcc-mit-ticketflags = true

[realms]
    EDUCATUX.EDU = {
        kdc = 192.168.70.250
        admin_server = 192.168.70.250
        default_domain = officinas.edu
    }

[domain_realm]
    .officinas.edu = EDUCATUX.EDU
    educatux.edu = EDUCATUX.EDU
```

3. Configurar /etc/samba/smb.conf

```bash
[global]
   workgroup = EDUCATUX
   security = ads
   realm = EDUCATUX.EDU

   winbind use default domain = true
   winbind enum users = yes
   winbind enum groups = yes
   winbind refresh tickets = yes
   winbind offline logon = yes

   idmap config * : backend = tdb
   idmap config * : range = 10000-19999

   idmap config EDUCATUX : backend = rid
   idmap config EDUCATUX : range = 20000-999999

   template shell = /bin/bash
   template homedir = /home/%U
```

4. Configurar /etc/nsswitch.conf

```bash
passwd:         compat winbind
group:          compat winbind
shadow:         compat
```

5. Ingressar no domínio

```bash
sudo net ads join -U Administrador
```

6. Reboot do Sistema

```bash
sudo reboot
```

7. Verificações

```bash
sudo net ads testjoin
wbinfo -u
wbinfo -g
getent passwd usuario
```

8. Criar diretórios HOME automaticamente


Edite /etc/pam.d/common-session e adicione:

```bash
session required pam_mkhomedir.so skel=/etc/skel umask=0022
```

9. Reiniciar serviços

```bash
sudo systemctl restart smbd nmbd winbind
sudo systemctl enable winbind
```

10. Sincronização de Hora

```bash
sudo timedatectl set-ntp true
```

THAT'S ALL FOLKS
