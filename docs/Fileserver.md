# 🔥 Servidor de Arquivos com Debian 13 integrado ao Domínio

## 🎯 O Objetivo é instalar, configurar e integrar o Debian 13 como um Servidor de Arquivos, usando pacotes do repositório, criando compartilhamentos de rede autenticados via Controlador de Domínio Samba4 (AD), previamente configurado e online na rede.

## Toda a criação e gerenciamento de usuários e grupos será feita via RSAT (Ferramentas de Administração Remota do Active Directory) em estações Windows, não diretamente pelo Samba no Linux, de acordo com a proposta e melhor prática do SAMBA4.

---

## 🌐 Topologia da rede:

- Domínio: OFFICINAS.EDU

- SRVFIREWALL 192.168.70.254/24

- SRVDC01 192.168.70.253/24

- SRVARQUIVOS 192.168.70.252/24

---

## 📘 Editar o arquivo de interfaces:

```bash
vim /etc/network/interfaces
```
```bash
allow-hotplug enp1s0
iface enp1s0 inet static
    address 192.168.70.252/24
    gateway 192.168.70.254
```

## 📘 Editar o /etc/hosts:

```bash
127.0.0.1   localhost
127.0.1.1   srvarquivos.officinas.edu srvarquivos
192.168.70.252 srvarquivos.officinas.edu srvarquivos
```

## 📘 Editar o /etc/resolv.conf:

```bash
domain officinas.edu
search officinas.edu
nameserver 192.168.70.253
```

## 📘 Definir hostname:

```bash
hostnamectl set-hostname srvarquivos
```

## 🔄 Atualizando o sistema:

```bash
apt update && apt full-upgrade -y
```

## 📦 Instalando os pacotes necessários

```bash
apt install samba samba-common-bin winbind libnss-winbind libpam-winbind krb5-user acl
```

## 🧱 Resumo dos pacotes

* krb5-user	Autenticação Kerberos (tickets, TGT, TGS)	Comunicação segura com o KDC (srvdc01)
* winbind	Mapeia/traduz usuários/grupos AD → UID/GID locais	Integração com NSS e PAM (NTFS ACLs <--> POSIX GID/UID)
* samba-common-bin	Ferramentas administrativas (net, smbpasswd, etc.)	Operações SMB e ADS
* libnss-winbind / libpam-winbind	Integração com login local (NSS e PAM)

## 🔐 Durante a instalação, configure o REALM **APONTANDO PARA O** Controlador de Domínio:

```bash
REALM: OFFICINAS.EDU
KDC: 192.168.70.253
Admin server: 192.168.70.253
```

## 🖥️ SE precisar de referência, faça backup do arquivo original e use o modelo:

```bash
mv /etc/krb5.conf{,.orig}
```

```bash
vim /etc/krb5.conf
```

```bash
[libdefaults]
    default_realm = OFFICINAS.EDU
    dns_lookup_realm = false
    dns_lookup_kdc = true
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true
    rdns = false
    fcc-mit-ticketflags = true

[realms]
    OFFICINAS.EDU = {
        kdc = 192.168.70.253
        admin_server = 192.168.70.253
        default_domain = officinas.edu
    }

[domain_realm]
    .officinas.edu = OFFICINAS.EDU
    officinas.edu = OFFICINAS.EDU
```

## ✅ Sincronização de hora (crítica para Kerberos):

```bash
apt install chrony
```

```bash
vim /etc/chrony/chrony.conf
```

## Aponte o timesync para o Controlador de Domínio no chrony:

```bash
# Comente a linha do repositório externo
#pool 2.debian.pool.ntp.org iburst
server 192.168.70.253 prefer iburst
```

## 🔄 Ativar e reiniciar os serviços

```bash
systemctl enable --now chrony
```

```bash
systemctl restart chrony
```

## 🔄 Validar a sincronização de horário com o Controlador de domínio

```bash
chronyc sources -v
```

```bash
chronyc tracking
```

## 🖥️ Backup da configuração padrão do Samba

```bash
mv /etc/samba/smb.conf{,.orig}
```

## ⚙️ Criar nova configuração /etc/samba/smb.conf

```bash
vim /etc/samba/smb.conf
```

```bash
[global]
   workgroup = OFFICINAS
   realm = OFFICINAS.EDU
   netbios name = SRVARQUIVOS
   server string = Servidor de Arquivos OFFICINAS
   security = ADS
   server role = member server
   map to guest = Bad User
   dns proxy = no

   # ACLs e atributos
   vfs objects = acl_xattr
   map acl inherit = yes
   store dos attributes = yes

   # Codificação
   unix charset = UTF-8
   dos charset = CP850

   # Integração AD / Kerberos
   dedicated keytab file = /etc/krb5.keytab
   kerberos method = secrets and keytab

   # Winbind
   winbind use default domain = yes
   winbind enum users = yes
   winbind enum groups = yes
   template shell = /bin/bash
   template homedir = /home/%D/%U

   # IDMAP
   idmap config * : backend = tdb
   idmap config * : range = 3000-7999
   idmap config OFFICINAS : backend = rid
   idmap config OFFICINAS : range = 10000-999999

   # Logs
   log file = /var/log/samba/%m.log
   max log size = 1000
   logging = syslog@1 file
   log level = 1

[arquivos]
    comment = Compartilhamentos da Rede
    path = /srv/samba/arquivos
    browseable = yes
    writable = yes
    read only = no
    guest ok = no

    create mask = 0770
    directory mask = 0770

    inherit permissions = yes
    inherit acls = yes
    inherit owner = yes

    vfs objects = acl_xattr full_audit

    valid users = @"OFFICINAS\Domain Users"

    full_audit:prefix = %u|%I|%S
    full_audit:success = connect disconnect open opendir mkdir rmdir rename unlink write
    full_audit:failure = none
    full_audit:facility = LOCAL7
    full_audit:priority = NOTICE
```

## 🧠 Validar liberações de acesso por NSS e PAM

```bash
vim /etc/nsswitch
```

```bash
passwd:         compat winbind
group:          compat winbind
shadow:         compat
```

## 🧰 Parar serviços concorrentes ao samba-ad-dc.service, antes do provisionamento

```bash
systemctl stop smbd nmbd winbind
```

## 🔗 Ingressando o servidor no domínio

```bash
net ads join -U administrator
```

## Testes da integração:

```bash
net ads testjoin
```

```bash
net ads info
```

## 🔄 APÓS o provisionamento, restarte os serviços de smbd, e winbind e habilite-os no boot novamente

```bash
systemctl enable smbd winbind
```

```bash
systemctl start smbd winbind
```

```bash
systemctl status smbd winbind
```

```bash
wbinfo -u
```

```bash
wbinfo -g
```

## Se retornar listas de usuários e grupos do domínio → integração OK ✅

## 🧩 Validar o arquivo de configuração smb.conf

```bash
testparm
```

## Teste a troca de tickets do Kerberos:

```bash
kinit administrator@OFFICINAS.EDU
```

```bash
klist
```

## Você deve ver um ticket válido.

## 📁 Criação do diretório compartilhado SE optou por compartilhar arquivos junto com o Controlador de Domínio (Não indiciado)

```bash
mkdir -p /srv/samba/arquivos
```

```bash
chmod -R 0770 /srv/samba/arquivos
```

```bash
chown -R root:"domain users" /srv/samba/arquivos
```

## 👉 Isso significa:

- Os usuários de Domínio terão permissão inicial. Usaremos o Administrator, via Windows, para criar pastas e definir permissões NTFS granulares por grupos ou usuários do domínio.

## Valide as permissões do path arquivos com o getfacl 

```bash
getfacl /srv/samba/arquivos
```

## Deverá retornar o mapeamento com algo do tipo

```bash
user::rwx
group:OFFICINAS\Domain Admins:rwx
```

## 🧱 Acessar os compartilhamentos de rede

## 🪟 No Windows (usando RSAT) acesse

```bash
\\srvarquivos.officinas.edu\arquivos
```

- Crie as pastas (ex: Financeiro, Diretoria, RH, Publica, etc.)

- Clique com o botão direito → Propriedades → Segurança

- Defina permissões por grupos do AD, como:

- OFFICINAS\gfinanceiro

- OFFICINAS\gdiretoria

- OFFICINAS\Domain Users (somente leitura, se desejar)

- O Samba respeitará totalmente essas ACLs (herdadas pelo vfs objects = acl_xattr e inherit acls = yes).

## 🐧 No Linux:

```bash
smb://srvarquivos.officinas.edu/
```

## 📖 Dicas e notas

* security = ADS → necessário quando o servidor é membro de domínio AD (Samba4 ou Windows).

* winbind → mapeia usuários e grupos do AD para o sistema Linux.

* kinit e net ads join → testam e integram o Kerberos.

* Os grupos gdiretoria, gfinanceiro devem existir no domínio (criados no SRVDC01 Samba4).

* O módulo acl_xattr permite armazenar as permissões no formato NTFS


## ✅ Conclusão

* O Linux só define permissões iniciais amplas.

* O Windows administra toda a hierarquia de subpastas e ACLs, via GUI (RSAT / Explorer).

* A autenticação e controle de acesso continuam centralizados no AD (Samba4).

* Você mantém compatibilidade total com ambientes Windows, incluindo herança de permissões e auditoria.


THAT'S ALL FOLKS


