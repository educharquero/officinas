# 🧱 SQUID PROXY INTEGRADO AO DOMÍNIO SAMBA4 (OFFICINAS.EDU)

# Debian 13 Bookworm – Proxy autenticado, filtrando conteúdo indesejado

=========================================================
🎯 OBJETIVO
=========================================================

Configurar um servidor Squid Proxy no Debian 13,
integrado ao domínio "OFFICINAS.EDU" (Controlador de Domínio: 192.168.70.253),
para autenticar usuários via Active Directory e aplicar políticas de bloqueio
contra redes sociais, conteúdo adulto e ameaças conhecidas.

=========================================================
🌐 TOPOLOGIA DE REDE
=========================================================

Firewall/Gateway:   192.168.70.254
Controlador de Domínio (SRVDC01): 192.168.70.253
Servidor de Arquivos (SRVARQUIVOS): 192.168.70.252
Servidor Proxy (SRVPROXY): 192.168.70.250
Domínio: OFFICINAS.EDU
Workgroup: OFFICINAS

=========================================================
1️⃣ CONFIGURAÇÃO DE REDE
=========================================================

Arquivo: /etc/network/interfaces

allow-hotplug enp1s0
iface enp1s0 inet static
    address 192.168.70.250/24
    gateway 192.168.70.254
    dns-nameservers 192.168.70.253
    dns-search officinas.edu

Arquivo: /etc/hosts

127.0.0.1   localhost
127.0.1.1   srvproxy
192.168.70.250 srvproxy.officinas.edu srvproxy
192.168.70.253 srvdc01.officinas.edu srvdc01

Arquivo: /etc/resolv.conf

nameserver 192.168.70.253
search officinas.edu

=========================================================
2️⃣ ATUALIZAÇÃO E INSTALAÇÃO DE PACOTES
=========================================================

apt update && apt full-upgrade -y
apt install squid winbind krb5-user samba-common-bin samba-common libnss-winbind libpam-winbind -y

Durante a configuração:
REALM = OFFICINAS.EDU
KDC = 192.168.70.253
Admin Server = 192.168.70.253

=========================================================
3️⃣ CONFIGURAÇÃO DO KERBEROS
=========================================================

Arquivo: /etc/krb5.conf

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

Testar o Kerberos:
kinit administrador@OFFICINAS.EDU
klist

=========================================================
4️⃣ INGRESSAR O SERVIDOR NO DOMÍNIO
=========================================================

net ads join -U administrador
net ads testjoin
wbinfo -u
wbinfo -g

Se listar usuários e grupos → OK.

=========================================================
5️⃣ CONFIGURAÇÃO BÁSICA DO SQUID
=========================================================

Backup do arquivo original:
mv /etc/squid/squid.conf{,.orig}

Criar novo /etc/squid/squid.conf:

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

# Mapeamento do domínio

acl AD_USERS proxy_auth REQUIRED

# Definir horário de operação (opcional)

acl HORARIO_TRABALHO time MTWHF 08:00-18:00

# Definições de rede interna

acl rede_local src 192.168.70.0/24

# Listas de bloqueio (serão criadas em /etc/squid/acl/)

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

#########################################################

# FIM DO SQUID.CONF

#########################################################

=========================================================
6️⃣ CRIAÇÃO DAS LISTAS DE BLOQUEIO
=========================================================

mkdir -p /etc/squid/acl

Arquivo: /etc/squid/acl/redes_sociais.txt

.facebook.com
.twitter.com
.instagram.com
.tiktok.com
.snapchat.com
.threads.net
.pinterest.com

Arquivo: /etc/squid/acl/adulto.txt

xxx
porn
redtube
xvideos
brazzers
xnxx
sex
adult
onlyfans

Arquivo: /etc/squid/acl/ameacas.txt

.crack
.keygen
.hack
phishing
malware
virus

=========================================================
7️⃣ PERMISSÕES E CACHE
=========================================================

chown -R proxy:proxy /var/spool/squid
chmod -R 750 /var/spool/squid

squid -z

=========================================================
8️⃣ INICIALIZAR O SERVIÇO
=========================================================

systemctl enable squid
systemctl restart squid
systemctl status squid

=========================================================
9️⃣ TESTES E VALIDAÇÕES
=========================================================

# Testar autenticação

kinit usuario@OFFICINAS.EDU
klist

# Testar proxy (no cliente)

Configurar navegador:
HTTP Proxy: 192.168.70.250
Porta: 3128

Acessar:
http://facebook.com → BLOQUEADO
http://terra.com.br → LIBERADO

# Testar pelo terminal

curl -v -x 192.168.70.250:3128 http://www.facebook.com

=========================================================
🔒 10️⃣ SEGURANÇA ADICIONAL
=========================================================

# Bloquear edição do resolv.conf

chattr +i /etc/resolv.conf

# Limpar logs periodicamente

echo "0 3 * * * root truncate -s 0 /var/log/squid/access.log" >> /etc/crontab

=========================================================
✅ CONCLUSÃO
=========================================================

O Squid agora:

✔ Autentica usuários diretamente no AD (OFFICINAS.EDU)
✔ Bloqueia redes sociais, conteúdo adulto e ameaças
✔ Registra logs de navegação para auditoria
✔ Atua como proxy corporativo seguro e gerenciável

=========================================================
📘 REFERÊNCIAS
=========================================================

- https://wiki.samba.org
- https://wiki.debian.org/Squid
- https://wiki.squid-cache.org/ConfigExamples/Authenticate/Ntlm
- https://wiki.squid-cache.org/ConfigExamples/PreventingAccess

---------------------------------------------------------

FIM DO DOCUMENTO
---------------------------------------------------------
