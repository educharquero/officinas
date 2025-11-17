# 🔥 Instalação do Controlador de Domínio Primário com SAMBA4 no Debian 13

## 🎯 Neste guia, configuraremos um **Controlador de Domínio Primário (PDC)** utilizando o **Debian 13 (Trixie)** e o **Samba 4.22** como **Active Directory**. Usaremos pacotes binários oficiais do Debian e uma configuração limpa, ideal para laboratórios de estudos

---

## 🌐 No decorrer das configurações vc criará sua própria topologia da rede, vamos combinar que quando precisar setar realm/domínio, usaremos como no modelo: 

* dominio_curto = DOMINIO
* dominio_longo = DOMINIO.INFO

## Adaptado AO SEU domínio, obviamente!!

- REALM: DOMINIO.INFO

- DOMAIN: DOMINIO

- ENDEREÇO IP: SEU_IP

- HOSTNAME: SEU_HOSTNAME

- GATEWAY: IP_FIREWALL

- DNS: IP_FIREWALL

---

## 🕐 A sincronização de horário essencial para que o PDC e as máquinas de rede conversem, pois o Kerberos é extremamente sensível a diferenças de tempo

## Instale o pacote do chrony

```bash
apt install chrony -y
```

## Edite o arquivo do chrony.conf

```bash
vim /etc/chrony/chrony.conf
```

## Comente a linha que aponta pro repositório da America do Norte e insira as linhas para apontar para os repositórios de horário no Brasil, então libere a consulta da rede interna para o seu Servidor

```bash
# Comente a linha do repositório externo
#pool 2.debian.pool.ntp.org iburst

# Servidores externos públicos do Brasil
server 0.br.pool.ntp.org iburst
server 1.br.pool.ntp.org iburst
server 2.br.pool.ntp.org iburst
server 3.br.pool.ntp.org iburst

# Permitir sincronização da rede interna
allow 192.168.70.0/24

# Define este servidor como stratum local
local stratum 10
```

## Habilite e reinicie o serviço de sincronização de horário

```bash
systemctl enable chrony
```

```bash
systemctl restart chrony
```

## Valide o seu timeserver novo no Brasil

```bash
chronyc sources -v
```

## Vai mostrar os repositório de hora Brasileira

```bash
  .-- Source mode  '^' = server, '=' = peer, '#' = local clock.
 / .- Source state '*' = current best, '+' = combined, '-' = not combined,
| /             'x' = may be in error, '~' = too variable, '?' = unusable.
||                                                 .- xxxx [ yyyy ] +/- zzzz
||      Reachability register (octal) -.           |  xxxx = adjusted offset,
||      Log2(Polling interval) --.      |          |  yyyy = measured offset,
||                                \     |          |  zzzz = estimated error.
||                                 |    |           \
MS Name/IP address         Stratum Poll Reach LastRx Last sample               
===============================================================================
^* sa-north-1.clearnet.pw        2   6     7     2    -89us[-1039us] +/-   26ms
^- gru.clearnet.pw               3   6    17     0  +3149us[+3149us] +/-   27ms
^+ gps.nu.ntp.br                 1   6    17     0  +1195us[+1195us] +/- 6544us
^+ lrtest2.ntp.ifsc.usp.br       2   6     7     2  -1325us[-2275us] +/-   13ms
```

## 📦 Sincronize os repositórios do Debian e atualize o sistema

```bash
apt update && apt full-upgrade -y
```

## 🌐 Configuração de rede (modo estático)

## Edite o arquivo interfaces e sete o ip fixo

```bash
vim /etc/network/interfaces
```

```bash
allow-hotplug enp1s0
iface enp1s0 inet static
  address 192.168.70.seu_ip
  netmask 255.255.255.0
  gateway ip_firewall
```

## Reinicie a interface para subir o novo endereço

```bash
systemctl restart networking
```

## 🌍 Configuração de DNS temporário

## ANTES de o domínio estar ativo, aponte o DNS para o firewall, DEPOIS o DNS será o próprio Controlador de domínio

```bash
vim /etc/resolv.conf
```

```bash
nameserver ip_firewall
```

## 🧩 Hostname e resolução local

## Defina o hostname do Servidor

```bash
hostnamectl set-hostname seu_hostname
```

## Edite o arquivo de hosts para atrelando ip/domínio

```bash
vim /etc/hosts
```

```bash
127.0.0.1 localhost
127.0.1.1 seu_hostname.dominio.info  seu_hostname
192.168.70.seu_ip  seu_hostname.dominio.info  seu_hostname
```

## 🔐 Instalação dos pacotes necessários

```bash
apt install samba samba-dsdb-modules samba-vfs-modules smbclient krb5-user krb5-config winbind libnss-winbind libpam-winbind ldb-tools dnsutils chrony python3-cryptography net-tools
```

## Durante a configuração do Kerberos nas 3 perguntas do krb5-user, insira:

```bash
Default realm: DOMINIO.INFO

KDC: 127.0.0.1

Admin server: 127.0.0.1
```

## Se errar, poderá refazer

```bash
dpkg-reconfigure krb5-config
```

## ⚙️ SE precisar de referência para Configuração manual do /etc/krb5.conf, faça um backup do arquivo e use esse modelo. Note que tem caixa alta e caixa baixa, siga o modelo lembrando do ex:realm = DOMINIO, domínio = DOMINIO.INFO)

```bash
sudo mv /etc/krb5.conf{,.orig}
```

```bash
sudo vim /etc/krb5.conf
```

```bash
[libdefaults]
    default_realm = DOMINIO.INFO
    dns_lookup_realm = false
    dns_lookup_kdc = true
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true
    rdns = false
    fcc-mit-ticketflags = true

[realms]
    DOMINIO.INFO = {
        kdc = 127.0.0.1
        admin_server = 127.0.0.1
        default_domain = dominio.info
    }

[domain_realm]
    .dominio.info = DOMINIO.INFO
    dominio.info = DOMINIO.INFO
```

## 🔍 Edite o arquivo nsswitch.conf e verifique se tem o winbind na lista de busca por usuários

```bash
vim /etc/nsswitch
```

```bash
passwd:       files systemd winbind
group:        files systemd winbind
```

## 🧰 Parar serviços concorrentes ao samba-ad-dc.service, antes do provisionamento

```bash
systemctl stop smbd nmbd winbind
```

```bash
systemctl disable smbd nmbd winbind
```

## 🏗️ Provisionamento do domínio

## faça um backup do arquivo smb.conf original, pois o comando de provisionamento criará outro novo automagicamente 😉

```bash
mv /etc/samba/smb.conf{,.orig}
```

## Execute o comando de provisionamento

```bash
samba-tool domain provision --use-rfc2307 --interactive
```

## Responda às perguntas do modo interativo (ex: domínio_curto = OFFICINAS, dominio_longo = OFFICINAS.EDU)

```bash
Realm: DOMINIO.INFO

Domain/NetBios: DOMINIO

Server Role: dc

DNS Backend: SAMBA_INTERNAL

Server role: dc

DNS Forwarder: IP_FIREWALL

Admin password: SUA_SENHA
```

## 🚀 Habilitar o serviço principal, samba-ad-dc.service

```bash
systemctl unmask samba-ad-dc.service
```

```bash
systemctl enable samba-ad-dc.service
```

```bash
systemctl start samba-ad-dc.service
```

```bash
systemctl status samba-ad-dc.service
```

## 🌐 Reapontar a consulta de DNS para o próprio servidor, já que agora comporta a função de DNS_INTERNAL definido no provisionamento

## Remova a proteção do arquivo resolv.conf contra edição automática, pois agora vamos precisar editá-lo

```bash
chattr -i /etc/resolv.conf
```

```bash
vim /etc/resolv.conf
```

```bash
nameserver 127.0.0.1
```

## Proteja o arquivo do resolv.conf, novamente, contra edição automática

```bash
chattr +i /etc/resolv.conf
```

## 📄 Configuração do arquivo smb.conf

## Após o provisionamento, revise e valide o novo arquivo smb.conf criado pelo comando de provisionamento

```bash
sudo vim /etc/samba/smb.conf
```

```bash
[global]
    dns forwarder = IP_FIREWALL
    netbios name = HOSTNAME
    realm = DOMINIO.INFO
    server role = active directory domain controller
    workgroup = DOMINIO
    idmap_ldb:use rfc2307 = yes

[sysvol]
    path = /var/lib/samba/sysvol
    read only = No

[netlogon]
    path = /var/lib/samba/sysvol/dominio.info/scripts
    read only = No

# SE for usar compartilhamento no SRVDC01 (NÃO indicado):

[ARQUIVOS]
    path = /srv/samba/arquivos
    comment = Compartilhamentos da Rede
    browsable = yes
    writable = yes
    read only = no
```

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

## Releia e valide as configurações do SAMBA4

```bash
smbcontrols all relod-config
```

```bash
testparm
```

## 👥 Validações básicas de usuários e grupos (locais e de domínio)

## Note que usuários/grupos locais...

```bash
cat /etc/passwd
```

## Não são os mesmos que usuários/grupos do domínio

```bash
samba-tool user list
```

```bash
wbinfo -u
```

```bash
wbinfo -g
```

```bash
wbinfo --ping-dc
```

## Teste o compartilhamento do SMB

```bash
smbclient -L localhost -UAdministrator
```

## O resultado será

```bash
Password for [DOMINIO\Administrator]:

	Sharename       Type      Comment
	---------       ----      -------
	sysvol          Disk      
	netlogon        Disk      
	ARQUIVOS        Disk      Compartilhamentos da Rede
	IPC$            IPC       IPC Service (Samba 4.22.6-Debian-4.22.6+dfsg-0+deb13u1)
SMB1 disabled -- no workgroup available
```

## 🔒 Desative a complexidade de senha (somente para laboratório!)

```bash
samba-tool domain passwordsettings set --complexity=off
```

```bash
samba-tool domain passwordsettings set --history-length=0
```

```bash
samba-tool domain passwordsettings set --min-pwd-length=0
```

```bash
samba-tool domain passwordsettings set --min-pwd-age=0
```

```bash
samba-tool user setexpiry Administrator --noexpiry
```

## ⚠️ Atenção: Desabilitar complexidade é inseguro!

## 🔁 Comando para recarregar/validar as configurações do SAMBA4 após qualquer alteração

```bash
smbcontrol all reload-config
```

## 🎟️ Validação de troca de tickets do Kerberos

```bash
kinit Administrator@DOMINIO.INFO
```

```bash
klist
```

## 🔎 Testes de DNS e SRV

```bash
host -t A dominio.info
```

```bash
host -t SRV _kerberos._tcp.DOMINIO.INFO
```

```bash
host -t SRV _ldap._tcp.DOMINIO.INFO
```

```bash
dig DOMINIO.INFO
```

## 🧱 Mais validações do SAMBA4

```bash
ps ax | egrep "samba|smbd|nmbd|winbindd"
```

```bash
testparm
```

```bash
smbclient --version
```

```bash
samba-tool domain level show
```

## 🪟 Administração via RSAT (Windows)

## Após o domínio estar funcional, ponha uma máquina Windows no Domínio e instale as ferramentas do RSAT (Remote Server Administration Tools) nela para gerenciar usuários, grupos e GPOs.

## 🎉 Conclusão. 🎊 Seu Controlador de Domínio Samba4 no Debian 13 está configurado e operacional. 👏 Parabéns! 


THAT’S ALL FOLKS!!
