# 🔥 SQUID PROXY INTEGRADO AO DOMÍNIO SAMBA4 (OFFICINAS.EDU)

## 🎯 O objetivo nesse tutorial é Configurar um servidor **Squid Proxy** no **Debian 13**, integrado ao domínio **OFFICINAS.EDU**
(Controlador de Domínio: **192.168.70.253**), para autenticar usuários via **Active Directory**
e aplicar políticas de bloqueio contra **redes sociais, conteúdo adulto e ameaças conhecidas**.

---

## 🌐 Topologia da rede:

- Domínio: OFFICINAS.EDU

- SRVFIREWALL 192.168.70.254/24

- SRVDC01 192.168.70.253/24

- SRVARQUIVOS 192.168.70.252/24

---

## 1️⃣ CONFIGURAÇÃO DE REDE

## Arquivo: **/etc/network/interfaces**

```bash
allow-hotplug enp1s0
iface enp1s0 inet static
    address 192.168.70.251
    netmask 255.255.255.0
    gateway 192.168.70.254
```

## Arquivo: /etc/hosts

```bash
127.0.0.1   localhost
127.0.1.1   srvproxy
192.168.70.250 srvproxy.officinas.edu srvproxy
```

## Arquivo: /etc/resolv.conf

```bash
nameserver 192.168.70.253
search officinas.edu
```

## A **1º Parte** se referirá á integração ao domínio

## ⚙️ Instalar pacotes de integração AD

```bash
apt install samba winbind krb5-user samba-common-bin samba-common samba-client libnss-winbind libpam-winbind curl
```

## ✅ Sincronização de hora (crítica para Kerberos):


```bash
apt install chrony
```

```bash
vim /etc/chrony/chrony.conf
```

## Adicione o srvdc01 ao chrony:

```bash
server 192.168.70.253 prefer iburst
```

## Habilite e reinicie o serviço de sincronização de horário.

```bash
systemctl enable --now chrony
```

```bash
sudo systemctl restart chrony
```

```bash
chronyc sources -v
```

```bash
chronyc tracking
```

## 🔑 Configurar o Kerberos após fazer o backup do arquivo original

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
    ticket_lifetime = 24h
    renew_lifetime = 7d
    forwardable = true

[realms]
    OFFICINAS.EDU = {
        kdc = 192.168.70.253
        admin_server = 192.168.70.253
    }

[domain_realm]
    .officinas.edu = OFFICINAS.EDU
    officinas.edu = OFFICINAS.EDU
```

## ⚙️ Configurar o arquivo do Samba após fazer o backup do arquivo original

```bash
mv /etc/samba/smb.conf{,.orig}
```

```bash
vim /etc/samba/smb.conf
```

```bash
[global]
   workgroup = OFFICINAS
   realm = OFFICINAS.EDU
   security = ADS
   password server = 192.168.70.253
   kerberos method = secrets and keytab

   # Winbind e IDMAP
   winbind use default domain = yes
   winbind offline logon = yes
   winbind enum users = yes
   winbind enum groups = yes
   template shell = /bin/bash
   template homedir = /home/%D/%U

   idmap config * : backend = tdb
   idmap config * : range = 10000-20000

   client signing = yes
   server signing = auto
   client use spnego = yes
   dedicated keytab file = /etc/krb5.keytab

   # Performance
   dns proxy = no
   restrict anonymous = 2
```

## 🧠 Configurar apontamento do winbind na validação de nomes e contas do Sistema

```
vim /etc/nsswitch
```

```bash
passwd: files systemd winbind
group:  files systemd winbind
shadow: files
```

## 🧩 Ingressar no domínio

```bash
net ads join -U administrador
```

## Saída esperada:

```bash
Joined 'SRVFIREWALL' to realm 'OFFICINAS.EDU'
```

## 🔄 Restarte os serviços de smbd, nmbd e winbind e habilite-os no boot

```bash
systemctl restart smbd nmbd winbind
```

```bash
systemctl enable winbind
```

```bash
systemctl status winbind
```

## Valide:

```bash
net ads testjoin
```

```bash
net ads info
```

```bash
wbinfo -t
```

```bash
wbinfo -u | head
```

```bash
wbinfo -g | head
```

## Teste o ticket:

```bash
kinit administrador@OFFICINAS.EDU
```

```bash
klist
```

## 🔄 Reiniciar serviços

```bash
systemctl restart smbd nmbd winbind
```

## ✅ Testar autenticação AD

```bash
wbinfo -u | head
```

```bash
getent passwd "Administrator"
```

## ⚙️ Verificar DNS e NAT

```bash
ping -c 3 8.8.8.8
```

```bash
ping -c 3 srvdc01.officinas.edu
```

```bash
curl https://google.com
```

## 5️⃣ **2º Parte** CONFIGURAÇÃO BÁSICA DO SQUID

## Instalação do pacote do squid para filtro de conteúdo e do sarg para logs de acessos

```bash
apt install squid sarg
```

## Após o backup do arquivo original, criamos o definitivo:

```bash
mv /etc/squid/squid.conf{,.orig}
```

```bash
vim /etc/squid.conf
```

```bash
##############################################
# SQUID PROXY - OFFICINAS.EDU
##############################################

# Porta de escuta HTTP
http_port 3128

# Nome do host
visible_hostname srvproxy.officinas.edu

# Autenticação via AD (NTLM + Kerberos)
auth_param negotiate program /usr/lib/squid/negotiate_kerberos_auth -s HTTP/srvproxy.officinas.edu@OFFICINAS.EDU
auth_param negotiate children 10
auth_param negotiate keep_alive on

# Mapeamento de domínio e usuários
acl AD_USERS proxy_auth REQUIRED

# Definições de rede interna
acl rede_local src 192.168.70.0/24

# Horário de operação (opcional)
acl HORARIO_TRABALHO time MTWHF 08:00-18:00

# Listas de bloqueio (criadas em /etc/squid/acl/)
acl bloqueio_redes_sociais dstdomain "/etc/squid/acl/redes_sociais.txt"
acl bloqueio_adulto url_regex -i "/etc/squid/acl/adulto.txt"
acl bloqueio_ameacas url_regex -i "/etc/squid/acl/ameacas.txt"

# Políticas de acesso
http_access deny bloqueio_redes_sociais
http_access deny bloqueio_adulto
http_access deny bloqueio_ameacas
http_access allow AD_USERS rede_local HORARIO_TRABALHO
http_access deny all

# Logs e cache
cache_mem 256 MB
maximum_object_size_in_memory 512 KB
cache_dir ufs /var/spool/squid 1024 16 256
access_log /var/log/squid/access.log
cache_log /var/log/squid/cache.log
cache_store_log /var/log/squid/store.log

# DNS e rede
dns_nameservers 192.168.70.253
forwarded_for off
via off
```

## 6️⃣ CRIAÇÃO DAS LISTAS DE BLOQUEIO

```bash
mkdir -p /etc/squid/acl
```
## Arquivo: /etc/squid/acl/redes_sociais.txt

```bash
.facebook.com
.twitter.com
.instagram.com
.tiktok.com
.snapchat.com
.threads.net
.pinterest.com
```

## Arquivo: /etc/squid/acl/adulto.txt

```bash
xxx
porn
redtube
xvideos
brazzers
xnxx
sex
adult
onlyfans
```

## Arquivo: /etc/squid/acl/ameacas.txt

```
.crack
.keygen
.hack
phishing
malware
virus
```

## 7️⃣ PERMISSÕES E CACHE

```bash
chown -R proxy:proxy /var/spool/squid
```
```bash
chmod -R 750 /var/spool/squid
```
```bash
squid -z
```

## 8️⃣ INICIALIZAR O SERVIÇO

```bash
systemctl enable squid
```

```bash
systemctl start squid
```

```bash
systemctl status squid
```

## 9️⃣ TESTES E VALIDAÇÕES

## Testar autenticação

```bash
kinit usuario@OFFICINAS.EDU
klist
```

## Testar proxy (no cliente)

## Configurar o navegador:

```bash
HTTP Proxy: 192.168.70.250
Porta: 3128
```

## Acessar:

* http://facebook.com -> BLOQUEADO
* http://terra.com.br -> LIBERADO

## Teste via terminal

```bash
curl -v -x 192.168.70.250:3128 http://www.facebook.com
```

## 🔒 10️⃣ SEGURANÇA ADICIONAL

## Bloquear edição do resolv.conf:

```bash
chattr +i /etc/resolv.conf
```

## Limpar logs periodicamente:

```bash
echo "0 3 * * * root truncate -s 0 /var/log/squid/access.log" >> /etc/crontab
```

## 📊 11️⃣ RELATÓRIOS E MONITORAMENTO (SARG + LOGROTATE)

## Instalar o SARG (Squid Analysis Report Generator):

```bash
apt install sarg apache2 -y
```

## Configurar diretório de relatórios:

```bash
mkdir -p /var/www/html/squid-reports
chown -R www-data:www-data /var/www/html/squid-reports
chmod -R 755 /var/www/html/squid-reports
```

## Editar o arquivo /etc/sarg/sarg.conf:

```bash
access_log /var/log/squid/access.log
output_dir /var/www/html/squid-reports
title "Relatórios de Acesso - OFFICINAS.EDU"
user_ip no
resolve_ip yes
topuser_sort_field time
remove_temp_files yes
date_format e
charset UTF-8
```

## Gerar relatório manual:

```bash
sarg
```

## Acessar relatório via navegador:

```bash
http://srvproxy.officinas.edu/squid-reports/
```

## 🔁 Automação diária de relatórios

## Adicionar no crontab:

```bash
echo "0 2 * * * root /usr/bin/sarg > /dev/null 2>&1" >> /etc/crontab
```

## 🔄 Rotacionar logs do Squid automaticamente

## Arquivo: /etc/logrotate.d/squid

```bash
/var/log/squid/*.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 640 proxy proxy
    postrotate
        /usr/sbin/squid -k rotate
    endscript
}
```

## ✅ CONCLUSÃO

## O Squid agora:

✔ Está autenticado diretamente no domínio OFFICINAS.EDU
✔ Controla acesso com base em usuário, grupo e horário
✔ Bloqueia redes sociais, conteúdo adulto e ameaças conhecidas
✔ Mantém logs rotacionados para auditoria
✔ Gera relatórios diários (SARG) acessíveis via web
✔ Atua como um proxy corporativo seguro, integrado e gerenciável


THAT'S ALL FOLKS!





























