# 📁 DC1 instalação por pacotes compilados

## Controlador de Domínio Primário, Secundário e Fileserver no Debian Linux 13

## Layout de rede usado no laboratório:

```bash
firewall           192.168.70.254   (enp1s0) - 192.168.122.254 (enp7s0) (ssh 22254)
srvdc01            192.168.70.253   (ssh 22253)
srvdc02            192.168.70.252   (ssh 22252)
fileserver         192.168.70.251   (ssh 22251)

; firewall         Roteamento e Controle de pacotes
; srvdc01          Controlador de Domínio primário
; srvdc02          Controlador de Domínio secundário
; fileserver       Servidor de Arquivos
```

## Instalando as dependências para compilação do código fonte  do Samba4:

```bash
export DEBIAN_FRONTEND=noninteractive;apt-get update; apt-get install vim net-tools rsync acl apt-utils attr autoconf bind9-utils binutils bison build-essential ccache chrpath curl debhelper bind9-dnsutils docbook-xml docbook-xsl flex gcc gdb git glusterfs-common gzip heimdal-multidev hostname htop krb5-config krb5-user lcov libacl1-dev libarchive-dev libattr1-dev libavahi-common-dev libblkid-dev libbsd-dev libcap-dev libcephfs-dev libcups2-dev libdbus-1-dev libglib2.0-dev libgnutls28-dev libgpgme-dev libicu-dev libjansson-dev libjs-jquery libjson-perl libkrb5-dev libldap2-dev liblmdb-dev libncurses-dev libpam0g-dev libparse-yapp-perl libpcap-dev libpopt-dev libreadline-dev libsystemd-dev libtasn1-bin libtasn1-6-dev libunwind-dev lmdb-utils locales lsb-release make mawk mingw-w64 patch perl perl-modules-5.40 pkg-config procps psmisc python3 python3-cryptography python3-dbg python3-dev python3-dnspython python3-gpg python3-iso8601 python3-markdown python3-matplotlib python3-pexpect python3-pyasn1 rsync sed  tar tree uuid-dev wget xfslibs-dev xsltproc zlib1g-dev -y
```

## Setando e validando o hostname do srvdc01:

```bash
hostnamectl set-hostname srvdc01
```

## Configurando o arquivo de hosts:

```bash
vim /etc/hosts
```

```bash
127.0.0.1          localhost
127.0.1.1          srvdc01.officinas.edu    srvdc01
192.168.70.254     srvdc01.officinas.edu    srvdc01
```

```bash
hostname -f
```

## Setando ip fixo no servidor srvdc01:

```bash
vim /etc/network/interfaces
```

```bash
iface enp1s0 inet static
address           192.168.70.253
netmask           255.255.255.0
gateway           192.168.70.254
```

## Setando endereço do firewall como resolvedor externo (temporário até provisionar o domínio):

```bash
vim /etc/resolv.conf
```

```bash
nameserver         192.168.70.254 #(firewall)
```

## Validando o ip da placa:

```bash
ip -c addr
```

```bash
ip -br link
```

## Baixando e compilando o código fonte do Samba4:

```bash
wget https://download.samba.org/pub/samba/samba-4.23.2.tar.gz
```

```bash
tar -xvzf samba-4.23.2.tar.gz
```

```bash
cd samba-4.23.2
```

```bash
./configure --prefix=/opt/samba
```

```bash
make -j$(nproc)
```

```bash
make install
```

## Adicionando /opt/Samba ao path padrão do Linux, colando a linha completa ao final do /etc/profile:

## PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/samba/bin:/opt/samba/sbin"

```bash
vim /etc/profile
```

```bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/samba/bin:/opt/samba/sbin"
```

## Relendo o arquivo de profile:

```bash
source /etc/profile
```

## Criando o daemon de inicialização do Samba4 com o sistema:

```bash
vim /etc/systemd/system/samba-ad-dc.service
```

```bash
[Unit]
   Description=Samba4 Active Directory Master Domain Controller
   After=network.target remote-fs.target nss-lookup.target

[Service]
   Type=forking
   ExecStart=/opt/samba/sbin/samba -D
   PIDFile=/opt/samba/var/run/samba.pid

[Install]
   WantedBy=multi-user.target
```

```bash
chmod +x /etc/systemd/system/samba-ad-dc.service
```

## Instalando e editando o serviço de sincronização de horário:

```bash
cp /etc/ntpsec/ntp.conf{,.orig}
```

```bash
vim /etc/ntpsec/ntp.conf
```

```bash
driftfile /var/lib/ntpsec/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
pool a.ntp.org iburst
pool b.ntp.org iburst
pool 2.debian.pool.ntp.org iburst
pool 3.debian.pool.ntp.org iburst
restrict 127.0.0.1
restrict ::1
tinker panic 0 #(Flag usada SOMENTE em VMs)
```

```bash
systemctl restart ntpd
```

```bash
ntpq -p
```

## Provisionando o novo domínio suportado pelo srvdc01:

```bash
samba-tool domain provision --realm=officinas.edu --use-rfc2307 --domain=officinas --dns-backend=SAMBA_INTERNAL --adminpass=P@ssw0rd --server-role=dc --option="ad dc functional level = 2016" --function-level=2016

```


## Habilitando o daemon pra subir no boot do sistema:

```bash
systemctl daemon-reload
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

## Linkando o arquivo krb5.conf do Samba4 ao /etc do sistema:

```bash
mv /etc/krb5.conf{,.orig}
```

```bash
ln -sf /opt/samba/private/krb5.conf /etc/krb5.conf
```

## APÓS o provisionamento da Samba4, precisamos reconfigurar o /etc/resolv.conf e setar o DNS apontando a resolução de nomes para o próprio srvdc01:

```bash
vim /etc/resolv.conf
```

```bash
domain           officinas.edu
search           officinas.edu.
nameserver       127.0.0.1 #(localhost)
```

## Bloqueando alteração do resolv.conf:

```bash
chattr +i /etc/resolv.conf
```

## Validando resolvedor de nomes pelo srvdc01:

```bash
nslookup srvdc01.officinas.edu
```

### Vai validar na tela:

```bash
Server:         127.0.0.1
Address:        127.0.0.1#53

Name:   srvdc01.officinas.edu
Address: 192.168.70.253
```

## Reboot do servidor srvdc01:

```bash
reboot
```

## Validando os serviços do Samba4 no boot do sistema:

```bash
ps aux | grep samba
```

```bash
ps aux | egrep "samba|smbd|nmbd|winbind"
```

```bash
find / -name samba.pid
```

```bash
pgrep samba
```

## Dando poderes de root ao Administrator:

```bash
vim /opt/samba/etc/user.map
```

```bash
!root=officinas.edu\Administrator
```

## Linkando bibliotecas do Samba4 para mapeamento de usuários no sistema Linux (rode esses comandos manualmente sem copiar e colar):

```bash
/opt/samba/sbin/smbd -b | grep LIBDIR
```

```bash
ln -s /opt/samba/lib/libnss_winbind.so.2 /lib/x86-64-linux-gnu
```

```bash
ln -s /lib/x86_64-linux-gnu/libnss_winbind.so.2 /lib/x86_64-linux-gnu/libnss_winbind.so
```

```bash
ldconfig
```

## Validando a autenticação de usuários de rede no sistema Linux mas tbém no winbind:

```bash
vim /etc/nsswitch.conf
```

```bash
passwd: files systemd winbind
group: files systemd winbind
shadow: files
```

## Editando o arquivo smb.conf e adicionando no dns forwarder, quem resolve nomes para consultas externas (o firewall e o google):

```bash
cp /opt/samba/etc/smb.conf{,.orig}
```

```bash
vim /opt/samba/etc/smb.conf
```

```bash
[global]
      bind interfaces only = Yes
      dns forwarder = 192.168.70.254 8.8.8.8 #(firewall + google)
      interfaces = lo enp1s0
      netbios name = DCMASTER
      realm = OFFICINAS.EDU
      server role = active directory domain controller
      workgroup = OFFICINAS
      idmap_ldb:use rfc2307 = yes

[sysvol]
      path = /opt/samba/var/locks/sysvol
      read only = No

[netlogon]
      path = /opt/samba/var/locks/sysvol/officinas.edu/scripts
      read only = No
```

## Relendo a configuração do Samba4:

```bash
smbcontrol all reload-config
```

## Validando usuários da base do ldap local:

```bash
cat /etc/passwd | grep root
```

## Validando usuários de rede do Samba4 (Intermediados pelo winbind):

```bash
samba-tool user show administrator
```

```bash
getent passwd administrator
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

```bash
getent group "Domain Admins"
```

## Validando daemons ativos:

```bash
ps aux | egrep "samba|smbd|nmbd|winbind"
```

```bash
ps axf
```

## Consultando serviços do SAMBA4:

```bash
smbclient --version
```

```bash
smbclient -L dc01 -U Administrator
```

```bash
smbclient //localhost/netlogon -UAdministrator -c "ls"
```

```bash
testparm
```

```bash
samba-tool domain level show
```

## Desabilitando complexidade de senhas (inseguro):

```bash
samba-tool domain passwordsettings show
```

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

## Relendo as configurações do SAMBA4:

```bash
smbcontrol all reload-config
```

## Validando a troca de tickets do Kerberos:

```bash
 kinit Administrator@OFFICINAS.EDU
```

```bash
klist 
```

## Consultando as bases do kerberos, ldap e dns:

```bash
host -t srv _kerberos._tcp.officinas.edu
```

```bash
host -t srv _ldap._tcp.officinas.edu
```

```bash
host -t A srvdc01.officinas.edu.
```

```bash
dig officinas.edu
```

THAT’S ALL FOLKS!!


# O MATERIAL DO CONTROLADOR DE DOMÍNIO SECUNDÁRIO ESTÁ SENDO REVISADO!
# Controlador de Domínio secundário com Samba4 no Debian Linux 13

## Layout de rede usado no laboratório:

```bash
firewall           192.168.70.254 (enp1s0) - 192.168.122.254 (enp7s0) (ssh 22254)
srvdc01           192.168.70.253   (ssh 22253)
mkdocs             192.168.70.222   (ssh 22222)
srvdc02            192.168.70.252   (ssh 22252)
fileserver         192.168.70.251   (ssh 22251)

; firewall         Roteamento por Iptables
; srvdc01         Controlador de Domínio primário
; mkdocs           Servidor de Documentos
; srvdc02          Controlador de Domínio secundário
; fileserver       Servidor de Arquivos
```

## Instalando as dependências para compilação do código fonte do Samba4:

```bash
export DEBIAN_FRONTEND=noninteractive;apt-get update; apt-get install vim net-tools rsync acl apt-utils attr autoconf bind9-utils binutils bison build-essential ccache chrpath curl debhelper bind9-dnsutils docbook-xml docbook-xsl flex gcc gdb git glusterfs-common gzip heimdal-multidev hostname htop krb5-config krb5-user lcov libacl1-dev libarchive-dev libattr1-dev libavahi-common-dev libblkid-dev libbsd-dev libcap-dev libcephfs-dev libcups2-dev libdbus-1-dev libglib2.0-dev libgnutls28-dev libgpgme-dev libicu-dev libjansson-dev libjs-jquery libjson-perl libkrb5-dev libldap2-dev liblmdb-dev libncurses-dev libpam0g-dev libparse-yapp-perl libpcap-dev libpopt-dev libreadline-dev libsystemd-dev libtasn1-bin libtasn1-6-dev libunwind-dev lmdb-utils locales lsb-release make mawk mingw-w64 patch perl perl-modules-5.40 pkg-config procps psmisc python3 python3-cryptography python3-dbg python3-dev python3-dnspython python3-gpg python3-iso8601 python3-markdown python3-matplotlib python3-pexpect python3-pyasn1 rsync sed  tar tree uuid-dev wget xfslibs-dev xsltproc zlib1g-dev -y
```

## Setando e validando o hostname do srvdc02:

```bash
vim /etc/hostname
```

```bash
srvdc02
```

```bash
hostname -f
```

```bash
srvdc02.officinas.edu
```

## Configurando o arquivo de hosts:

```bash
vim /etc/hosts
```

```bash
.0.0.1              localhost
127.0.1.1           srvdc02.officinas.edu       srvdc02
192.168.70.251      fileserver.officinas.edu    fileserver
192.168.70.252      srvdc02.officinas.edu       srvdc02
192.168.70.222      mkdocs.officinas.edu        mkdocs
192.168.70.253      srvdc01.officinas.edu      srvdc01
192.168.70.254      firewall.officinas.edu      firewall
```

## Setando ip fixo no servidor srvdc02:

```bash
vim /etc/network/interfaces
```

```bash
allow-hotplug enp1s0
iface enp1s0 inet static
address           192.168.70.252
netmask           255.255.255.0
gateway           192.168.70.254
```

## Apontando o endereço do resolvedor de nomes principal da rede pro Controlador de domínio primário, srvdc01 (temporário, até provisionar):

```bash
vim /etc/resolv.conf
```

```bash
domain           officinas.edu
search           officinas.edu.
nameserver       192.168.70.253 #(srvdc01)
nameserver       127.0.0.1
```

## Validando a resolução de nomes pelo srvdc01:

```bash
nslookup officinas.edu
```

```bash
Server:         192.168.70.253
Address:        192.168.70.253#53

Name:   officinas.edu
Address: 192.168.70.253
Name:   officinas.edu
Address: 192.168.70.252
```

## Relendo as configurações de rede:

```bash
systemctl restart networking
```

## Validando o ip da placa:

```bash
ip -c addr
```

```bash
ip -br link
```

## Baixando e compilando o código fonte do Samba4:

```bash
wget https://download.samba.org/pub/samba/samba-4.23.2.tar.gz
```

```bash
tar -xvzf samba-4.23.2.tar.gz
```

```bash
cd samba-4.23.2
```

```bash
./configure --prefix=/opt/samba
```

```bash
make -j$(nproc)
```

```bash
make install
```

## Adicionando /opt/Samba ao path padrão do Linux, colando a linha completa ao final do .bashrc:

## PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/samba/bin:/opt/samba/sbin"

```bash
vim ~/.bashrc
```

```bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/samba/bin:/opt/samba/sbin"
```

## Relendo o arquivo de profile:

```bash
source ~/.bashrc
```

## Criando o daemon de inicialização do Samba4 com o sistema:

```bash
vim /etc/systemd/system/samba-ad-dc.service
```

```bash
[Unit]
   Description=Samba4 Active Directory Slave Domain Controller
   After=network.target remote-fs.target nss-lookup.target

[Service]
   Type=forking
   ExecStart=/opt/samba/sbin/samba -D
   PIDFile=/opt/samba/var/run/samba.pid

[Install]
   WantedBy=multi-user.target
```

```bash
chmod +x /etc/systemd/system/samba-ad-dc.service
```

## Configurando o serviço de sincronização de horário, apontando pro Controlador de domínio primário, srvdc01:

```bash
mv /etc/ntpsec/ntp.conf{,.orig}
```

```bash
vim /etc/ntpsec/ntp.conf
```

```bash
driftfile /var/lib/ntpsec/ntp.drift
leapfile /usr/share/zoneinfo/leap-seconds.list
tos minclock 4 minsane 3
pool 192.168.70.253 iburst #(srvdc01)
restrict default kod nomodify nopeer noquery limited
restrict 127.0.0.1
restrict ::1
tinker panic 0 #(Flag usada SOMENTE em VMs)
```

```bash
systemctl restart ntp
```

```bash
ntpq -p
```

```bash
date
```

As máquinas Windows/Linux, membros do domínio, usarão o DC1 que retém a função FSMO emulador PDC como fonte de tempo padrão!

## Provisionando o servidor DCSLAVE:

```bash
samba-tool domain join OFFICINAS.EDU DC -U Administrator --realm=OFFICINAS.EDU --dns-backend=SAMBA_INTERNAL --option="interfaces=lo enp1s0" --option="bind interfaces only=yes" --option="idmap_ldb:use-rfc2307=yes"
```

## Habilitando o daemon pra subir no boot do sistema:

```bash
systemctl daemon reload
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

## Editando o arquivo do kerberos:

```bash
mv /etc/krb5.conf{,.orig}
```

```bash
vim /etc/krb5.conf
```

```bash
[libdefaults] #(sem espaço no canto dessa linha)
    dns_lookup_realm = false
    dns_lookup_kdc = true
    default_realm = OFFICINAS.EDU
```

## Visualizando o arquivo smb.conf:

```bash
cat /opt/samba/etc/smb.conf
```

```bash
# Global parameters
[global]
    bind interfaces only = Yes
    interfaces = lo enp1s0
    netbios name = DCSLAVE
    realm = OFFICINAS.EDU
    server role = active directory domain controller
    workgroup = OFFICINAS
    idmap_ldb:use-rfc2307 = yes

[sysvol]
    path = /opt/samba/var/locks/sysvol
    read only = No

[netlogon]
    path = /opt/samba/var/locks/sysvol/officinas.edu/scripts
    read only = No
```

## Validando as entradas DNS usadas:

```bash
apt install ldb-tools
```

```bash
host -t A officinas.edu.
```

## (SE NECESSÁRIO), SE Necessário, adicione as entradas do srvdc02, manualmente AO DNS do Samba4, no srvdc01:

```bash
samba-tool dns add srvdc01 OFFICINAS.EDU srvdc02 A 192.168.70.252 -U administrator
```

```bash
ldbsearch -H /opt/samba/private/sam.ldb '(invocationId=*)' --cross-ncs objectguid
```

```bash
host -t CNAME df4bdd8c-abc7-4779-b01e-4dd4553ca3e9._msdcs.officinas.edu.
```

## SE não rodar, execute a replicação para todos os DCs:

```bash
samba-tool dns add srvdc01 _msdcs.officinas.edu df4bdd8c-abc7-4779-b01e-4dd4553ca3e9 CNAME srvdc02.officinas.edu -Uadministrator
```

## PASTA SYSVOL

## Replicando a pasta sysvol. Mapeando IDs de grupos e usuários para o srvdc02 (execute estes comando NO DCMASTER):

```bash
tdbbackup -s .bak /opt/samba/private/idmap.ldb
```

```bash
scp -rv -p22252 /opt/samba/private/idmap.ldb.bak root@srvdc02:/root
```

```bash
scp -rv -p22252 /opt/samba/var/locks/sysvol/* root@srvdc02:/opt/samba/var/locks/sysvol
```

## Aplicando o arquivo BD que enviamos do srvdc01 (execute estes comandos NO DCSLAVE):

```bash
mv /root/idmap.ldb.bak /root/idmap.ldb
```

```bash
cp -rfv /root/idmap.ldb /opt/samba/private/
```

```bash
samba-tool ntacl sysvolreset
```

## Agora precisamos pensar que tendo dois DCs na rede, SE cair o primário o secundário assume o controle, e vice versa. Logicamente devemos apontar um pro outro como resolvedor de nomes primário, ou seja, o srvdc01 vai resolver primeiro no srvdc02 e o srvdc02 vai resolver primeiro no srvdc01:

## Edite o /etc/resolv.conf NO DCMASTER e aponte pro srvdc02:

```bash
vim /etc/resolv.conf
```

```bash
domain           officinas.edu
search           officinas.edu.
nameserver       192.168.70.252 #(srvdc02)
nameserver       127.0.0.1
```

## Bloqueando a edição do arquivo resolv.conf:

```bash
chattr +i /etc/resolv.conf
```

## E no reverso, edite o /etc/resolv.conf NO DCSLAVE apontando pro srvdc01:

## Desbloqueando a edição do arquivo resolv.conf:

```bash
chattr -i /etc/resolv.conf
```

```bash
vim /etc/resolv.conf
```

```bash
domain           officinas.edu
search           officinas.edu.
nameserver       192.168.70.253 #(srvdc01)
nameserver       127.0.0.1
```

## Bloqueando a edição do arquivo resolv.conf:

```bash
chattr +i /etc/resolv.conf
```

## Validando a replicação ( execute em todos os DCs):

```bash
samba-tool drs showrepl
```

## Criando um usuário no srvdc01 (execute NO DCMASTER):

```bash
samba-tool user create userteste
```

```bash
samba-tool user list
```

## Validando no srvdc02, se consta o usuário criado no srvdc01 (execute NO DCSLAVE):

```bash
samba-tool user list
```

## Validando o compartilhamento padrão:

```bash
smbclient -L localhost -U%
```

```bash
smbclient //localhost/netlogon -UAdministrator -c 'ls'
```

## Validando o DNS local:

```bash
host -t A officinas.edu localhost
```

## Validando a troca de tickets do kerberos:

```bash
kinit Administrator
```

```bash
klist
```

## Validando configuração de kerberos e ldap:

```bash
host -t srv _kerberos._tcp.officinas.edu
```

```bash
host -t srv _ldap._tcp.officinas.edu
```

```bash
dig officinas.edu
```

```bash
host -t A <máquina do domínio>
```

## Validando informações de servidor qual controla o PDC Emulator:

```bash
samba-tool fsmo show | grep -i pdc
```

```bash
samba-tool fsmo show
```

## Validando a localização do diretório 'sysvol' do srvdc01:

```bash
uname -ra
```

```bash
find /opt/samba -iname sysvol
```

```bash
     /opt/samba/var/locks/sysvol
```

## Validando espaço disponível:

```bash
df -h
```

## Validando a UUID do seu disco:

```bash
blkid /dev/sda2 #(Sete A SUA partição de disco)
```

## Validando suporte ativo no Kernel ás flags de acl e segurança:

```bash
cat /boot/config-6.1.0-17-amd64 | grep _ACL
```

```bash
cat /boot/config-6.1.0-17-amd64 | grep FS_SECURITY
```

## Gerando e enviando as chaves do ssh para sincronização entre o srvdc01 e o srvdc02 (crie as chaves NO DCMASTER e envie a chave pública para o srvdc02):

## (Pode deixar a senha em branco SE preferir)

```bash
ssh-keygen -t rsa -b 1024
```

```bash
ssh-copy-id -p22252 -i ~/.ssh/id_rsa.pub root@srvdc02 #(O MEU srvdc02 usa a porta ssh 22252)
```

## Testando a conexão por ssh sem pedir senha (SE vc deixou em branco):

```bash
ssh -p22252 srvdc02
```

```bash
exit
```

## Agora inverta a ordem e crie as chaves NO DCSLAVE e envie para o srvdc01 (Rode estes comandos NO DCSLAVE):

```bash
ssh-keygen -t rsa -b 1024
```

```bash
ssh-copy-id -p22253 -i ~/.ssh/id_rsa.pub root@srvdc01 #(enviando para o srvdc01, que usa porta ssh 22253)
```

## Testando a conexão por ssh sem pedir senha (SE vc deixou em branco):

```bash
ssh -p22253 srvdc01
```

```bash
exit
```

## Criando script de sincronização com rsync do diretório 'sysvol' DO DCMASTER para envio ao srvdc02 (rode estes comando NO DCMASTER):

```bash
cd /opt
```

```bash
vim rsync-sysvol.sh
```

```bash
#!/bin/bash
# Sincronizando Diretorios do Sysvol do srvdc01 para envio ao srvdc02:
#rsync -Cravz /opt/samba/var/locks/sysvol/*  root@192.168.70.252:/opt/samba/var/locks/sysvol/
# no MEU CASO onde a porta do ssh não á a default. MEU srvdc02 usa 22252:
rsync -Cravz -e "ssh -p 22252" /opt/samba/var/locks/sysvol/*  root@192.168.70.252:/opt/samba/var/locks/sysvol/
```

```bash
chmod +x rsync-sysvol
```

```bash
./rsync-sysvol
```

## Agendando a sincronização no cron do srvdc01:

```bash
crontab -e
```

```bash
*/5 * * * * root  bash /opt/rsync-sysvol.sh --silent
```

## REPITA o processo de replicação do sysvol, agora NO DCSLAVE, INVERTENDO os apontamentos de ip, obviamente!

## Criando script de sincronização do diretório 'sysvol' DO DCSLAVE para envio ao srvdc01 (rode os comando agora NO DCSLAVE):

```bash
cd /opt
```

```bash
vim rsync-sysvol.sh
```

```bash
#!/bin/bash
# Sincronizando Diretorios do Sysvol do srvdc01 para envio ao srvdc02:
#rsync -Cravz /opt/samba/var/locks/sysvol/*  root@192.168.70.253:/opt/samba/var/locks/sysvol/
# no MEU CASO onde a porta do ssh não á a default. MEU srvdc01 usa 22253:
rsync -Cravz -e "ssh -p 22253" /opt/samba/var/locks/sysvol/*  root@192.168.70.253:/opt/samba/var/locks/sysvol/
```

```bash
chmod +x rsync-sysvol
```

```bash
./rsync-sysvol
```

## Agendando a sincronização no cron do srvdc02:

```bash
crontab -e
```

```bash
*/5 * * * * root  bash /opt/rsync-sysvol.sh --silent
```

## As Estações de trabalho, usarão, como DNS primário o PDC Emulator do Domínio, e como DNS secundário o PDC Secundário da rede.

## OSYNC

## Configurando a sincronização da pasta sysvol com osync, que vai espelhar os DCs (rode esses comandos NO DCMASTER, primeiro):

```bash
cd /opt
```

```bash
git clone https://github.com/deajan/osync.git
```

```bash
cd osync
```

```bash
sh ./install.sh
```

## Vai criar o diretório /etc/osync:

## Dentro dele vai ter o arquivo de configuração sync.conf.example. Crie um arquivo sync.conf e cole o conteúdo abaixo:

```bash
vim /etc/osync/sync.conf
```

```bash
#!/usr/bin/env bash

INSTANCE_ID="sysvol_sync"

INITIATOR_SYNC_DIR="/opt/samba/var/locks/sysvol"

TARGET_SYNC_DIR="ssh://root@192.168.70.252:22252//opt/samba/var/locks/sysvol"

SSH_RSA_PRIVATE_KEY="/root/.ssh/id_rsa"

REMOTE_3RD_PARTY_HOSTS=""

PRESERVE_ACL=yes

PRESERVE_XATTR=yes

SOFT_DELETE=yes

DESTINATION_MAILS="roor@localhost"

#REMOTE_RUN_AFTER_CMD="/opt/samba/bin/samba-tool ntacl sysvolreset"
```

## rodando o script de atualização, que está dentro do /opt/osync, apontando pro arquivo /etc/osync/sync.conf:

```bash
./upgrade-v1.0x-v1.2x.sh /etc/osync/sync.conf
```

## Vai ficar semelhante ao modelo abaixo:

```bash
#!/usr/bin/env bash

INSTANCE_ID="sysvol_sync"

INITIATOR_SYNC_DIR="/opt/samba/var/locks/sysvol"

TARGET_SYNC_DIR="ssh://root@192.168.70.252:22252//opt/samba/var/locks/sysvol"

SSH_RSA_PRIVATE_KEY="/root/.ssh/id_rsa"

SSH_PASSWORD_FILE=""

_REMOTE_TOKEN="SomeAlphaNumericToken9"

CREATE_DIRS=false

LOGFILE=""

MINIMUM_SPACE="10240"

BANDWIDTH="0"

SUDO_EXEC=false

RSYNC_EXECUTABLE="rsync"

RSYNC_REMOTE_PATH=""

RSYNC_PATTERN_FIRST="include"

RSYNC_INCLUDE_PATTERN=""

RSYNC_EXCLUDE_PATTERN=""

RSYNC_INCLUDE_FROM=""

RSYNC_EXCLUDE_FROM=""

PATH_SEPARATOR_CHAR=";"

SSH_COMPRESSION=true

SSH_IGNORE_KNOWN_HOSTS=false

SSH_CONTROLMASTER=false

REMOTE_HOST_PING=false
```

## Testando o sincronizmo (ignore o erro de email):

```bash
/usr/local/bin/osync.sh /etc/osync/sync.conf --dry --verbose
```

## Rodar o sincronizmo de fato:

```bash
/usr/local/bin/osync.sh /etc/osync/sync.conf --verbose
```

## Agendar no cron:

```bash
crontab -e
```

```bash
*/5 * * * * root  bash /usr/local/bin/osync.sh /etc/osync/sync.conf --silent
```

## Validando os logs em tempo real, rode o /usr/local/bin/osync.sh, mantendo outro terminal aberto com o comando:

```bash
tail -f /var/log/osync.sysvol_sync.log
```

## INVERTENDO a sincronização com o Osync, vamos refazer tudo, incluíndo o ip e porta ssh, agora NO DCSLAVE:

```bash
cd /opt
```

```bash
git clone https://github.com/deajan/osync.git
```

```bash
cd osync
```

```bash
sh ./install.sh
```

## Vai criar o diretório /etc/osync:

## Dentro dele vai ter o arquivo de configuração sync.conf.example. Crie um arquivo sync.conf e cole o conteúdo abaixo:

```bash
#!/usr/bin/env bash

INSTANCE_ID="sysvol_sync"

INITIATOR_SYNC_DIR="/opt/samba/var/locks/sysvol"

TARGET_SYNC_DIR="ssh://root@192.168.70.253:22253//opt/samba/var/locks/sysvol"

SSH_RSA_PRIVATE_KEY="/root/.ssh/id_rsa"

REMOTE_3RD_PARTY_HOSTS=""

PRESERVE_ACL=yes

PRESERVE_XATTR=yes

SOFT_DELETE=yes

DESTINATION_MAILS="roor@localhost"

#REMOTE_RUN_AFTER_CMD="/opt/samba/bin/samba-tool ntacl sysvolreset"
```

## Vai precisa configurar seu ip e o path pra rodar o script de atualização, apontando pro arquivo sync.conf:

```bash
./upgrade-v1.0x-v1.2x.sh /etc/osync/sync.conf
```

## Vai ficar semelhante ao modelo abaixo:

```bash
#!/usr/bin/env bash

INSTANCE_ID="sysvol_sync"

INITIATOR_SYNC_DIR="/opt/samba/var/locks/sysvol"

TARGET_SYNC_DIR="ssh://root@192.168.70.253:22253//opt/samba/var/locks/sysvol"

SSH_RSA_PRIVATE_KEY="/root/.ssh/id_rsa"

SSH_PASSWORD_FILE=""

_REMOTE_TOKEN="SomeAlphaNumericToken9"

CREATE_DIRS=false

LOGFILE=""

MINIMUM_SPACE="10240"

BANDWIDTH="0"

SUDO_EXEC=false

RSYNC_EXECUTABLE="rsync"

RSYNC_REMOTE_PATH=""

RSYNC_PATTERN_FIRST="include"

RSYNC_INCLUDE_PATTERN=""

RSYNC_EXCLUDE_PATTERN=""

RSYNC_INCLUDE_FROM=""

RSYNC_EXCLUDE_FROM=""

PATH_SEPARATOR_CHAR=";"

SSH_COMPRESSION=true

SSH_IGNORE_KNOWN_HOSTS=false

SSH_CONTROLMASTER=false

REMOTE_HOST_PING=false
```

## Testar o sincronizmo (ignore o erro de email):

```bash
/usr/local/bin/osync.sh /etc/osync/sync.conf --dry --verbose
```

## Rodar o sincronizmo de fato:

```bash
/usr/local/bin/osync.sh /etc/osync/sync.conf --verbose
```

## Agendar no cron:

```bash
crontab -e
```

```bash
*/5 * * * * root  bash /usr/local/bin/osync.sh /etc/osync/sync.conf --silent
```

## Validando os logs em tempo real, rode o /usr/local/bin/osync.sh, mantendo outro terminal aberto com o comando:

```bash
tail -f /var/log/osync.sysvol_sync.log
```

THAT’S ALL FOLKS!!



# FileServer com Samba4 no Debian Linux 13

## Layout de rede usado no laboratório:

```bash
firewall           192.168.70.254   (enp1s0) - 192.168.122.254 (enp7s0) (ssh 22254)
srvdc01            192.168.70.253   (ssh 22253)
srvdc02            192.168.70.252   (ssh 22252)
fileserver         192.168.70.251   (ssh 22251)

; firewall         Roteamento e filtro de pacotes
; srvdc01          Controlador de Domínio primário
; srvdc02          Controlador de Domínio secundário
; fileserver       Servidor de Arquivos
```

## Instalando as dependências para compilação do código fonte do Samba4:

```bash
export DEBIAN_FRONTEND=noninteractive;apt-get update; apt-get install vim net-tools rsync acl apt-utils attr autoconf bind9-utils binutils bison build-essential ccache chrpath curl debhelper bind9-dnsutils docbook-xml docbook-xsl flex gcc gdb git glusterfs-common gzip heimdal-multidev hostname htop krb5-config krb5-user lcov libacl1-dev libarchive-dev libattr1-dev libavahi-common-dev libblkid-dev libbsd-dev libcap-dev libcephfs-dev libcups2-dev libdbus-1-dev libglib2.0-dev libgnutls28-dev libgpgme-dev libicu-dev libjansson-dev libjs-jquery libjson-perl libkrb5-dev libldap2-dev liblmdb-dev libncurses-dev libpam0g-dev libparse-yapp-perl libpcap-dev libpopt-dev libreadline-dev libsystemd-dev libtasn1-bin libtasn1-6-dev libunwind-dev lmdb-utils locales lsb-release make mawk mingw-w64 patch perl perl-modules-5.40 pkg-config procps psmisc python3 python3-cryptography python3-dbg python3-dev python3-dnspython python3-gpg python3-iso8601 python3-markdown python3-matplotlib python3-pexpect python3-pyasn1 rsync sed  tar tree uuid-dev wget xfslibs-dev xsltproc zlib1g-dev -y
```

## Setando e validando o hostname do srvdc02:

```bash
vim /etc/hostname
```

```bash
fileserver
```

```bash
hostname -f
```

```bash
fileserver.officinas.edu
```

## Configurando o arquivo de hosts:

```bash
vim /etc/hosts
```

```bash
.0.0.1              localhost
127.0.1.1           fileserver.officinas.edu    fileserver
192.168.70.251      fileserver.officinas.edu    fileserver
```

## Setando ip fixo no servidor srvdc02:

```bash
vim /etc/network/interfaces
```

```bash
allow-hotplug enp1s0
iface enp1s0 inet static
address           192.168.70.251
netmask           255.255.255.0
gateway           192.168.70.254
```

## Apontando o endereço do resolvedor de nomes principal da rede pro Controlador de domínio primário, srvdc01 (temporário):

```bash
vim /etc/resolv.conf
```

```bash
domain           officinas.edu
search           officinas.edu.
nameserver       192.168.70.253 #(srvdc01)
nameserver       192.168.70.252 #(srvdc02)
```

## Bloqueando alteração do resolv.conf:

```bash
chattr +i /etc/resolv.conf
```

## Validando a resolução de nomes pelo srvdc01:

```bash
nslookup officinas.edu
```

```bash
Server:         192.168.70.253
Address:        192.168.70.253#53

Name:   officinas.edu
Address: 192.168.70.253
Name:   officinas.edu
Address: 192.168.70.252
```

## Relendo as configurações de rede:

```bash
systemctl restart networking
```

## Validando o ip da placa:

```bash
ip -c addr
```

```bash
ip -br link
```

## Baixando e compilando o código fonte do Samba4:

```bash
wget https://download.samba.org/pub/samba/samba-4.23.2.tar.gz
```

```bash
tar -xvzf samba-4.23.2.tar.gz
```

```bash
cd samba-4.23.2
```

```bash
./configure --prefix=/opt/samba --enable-debug --enable-selftest
```

```bash
make -j$(nproc)
```

```bash
 make install
```

## Adicionando /opt/Samba ao path padrão do Linux, colando a linha completa ao final do /etc/profile:

## PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/samba/bin:/opt/samba/sbin"

```bash
vim /etc/profile
```

```bash
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/samba/bin:/opt/samba/sbin"
```

## Relendo o arquivo de profile:

```bash
source /etc/profile
```

## Criando o daemon de inicialização do Samba4 com o sistema:

```bash
vim /etc/systemd/system/samba-ad-dc.service
```

```bash
[Unit]
   Description=Samba4 Active Directory Slave Domain Controller
   After=network.target remote-fs.target nss-lookup.target

[Service]
   Type=forking
   ExecStart=/opt/samba/sbin/samba -D
   PIDFile=/opt/samba/var/run/samba.pid

[Install]
   WantedBy=multi-user.target
```

```bash
chmod +x /etc/systemd/system/samba-ad-dc.service
```

## ATENÇÃO!! NÃO PROVISIONE O SAMBA DO FILESERVER!!


!!! warning "Atenção"

    Não provisione o Fileserver.


## ATENÇÃO!! NÃO PROVISIONE O SAMBA DO FILESERVER!!

## 

## Configurando o /etc/krb5.conf:

```bash
# vim /etc/krb5.conf
```

```bash
[libdefaults] #(sem espaço no canto dessa linha)
   dns_lookup_realm = false
   dns_lookup_kdc = true
   default_realm = OFFICINAS.EDU
```

## Validando mapeamentos:

```bash
getent hosts fileserver
```

## Configurando o smb.conf:

```bash
# vim /opt/samba/etc/smb.conf
```

```bash
# Define as informações do domínio.
   [global]
   workgroup = OFFICINAS
   realm = officinas.edu

# Define que esse servidor não aceita acesso sem autenticação.
    security = ADS

# Defique qual usuário no domínio se equivale ao root.
    username map = /opt/samba/etc/user.map

# Parâmetros para que as permissões se comportem como o Windows.
# Herdando permissões e guardando credenciais de logins bem-sucedidos.
    map acl inherit = yes
    store dos attributes = yes

# Os VFS objects que serão usados.
    vfs objects = acl_xattr acl_tdb

# Arquivo de configuração do kerberos e qual método será usado.
    dedicated keytab file = /etc/krb5.keytab
    kerberos method = secrets and keytab

# Configurações do backend para mapeamento de IDs para compatibilidade com Windows.
    idmap config * : backend = tdb
    idmap config * : range = 3000-7999
    idmap config OFFICINAS: backend = rid
    idmap config OFFICINAS: range = 10000-999999

# Define que o usuário root não precisa ser mapeado.
    min domain uid = 0

# Shell padrão e diretório home padrão.
    template shell = /bin/bash
    template homedir = /home/%U

# Define o comportamento do Winbind.
    winbind refresh tickets = yes
    winbind use default domain = yes
    winbind enum users = yes
    winbind enum groups = yes
    winbind cache time = 7200
    winbind nss info = rfc2307

# Cada escrita  de dados será seguida por um fsync() para garantir que os dados sejam gravados no disco. Usei em ext4 e xfs mas não testei no btrfs.
   sync always = yes
   strict sync = yes

# Onde serão gravados os logs e o nivel de detalhes.
   log file = /var/log/samba/%m.log
   log level = 3

   [FILESERVER]
   path = /home/fileserver
   comment = Compartilhamentos da Rede
   read only = No
   browseable = yes
   vfs objects = acl_xattr acl_tdb full_audit
   full_audit:success = renameat rewinddir unlinkat
   full_audit:prefix = %U|%I|%S
   full_audit:failure = none
   full_audit:facility = local4
   full_audit:priority = alert

# PARÂMETROS USADOS NA AUDITORIA:
# Adiciona todos os vfs objects.
    acl_xattr acl_tdb full_audit
# arquivos renomeados, diretórios renomeados, arquivos deletados.
    renameat rewinddir unlinkat
# usuário, ip, ação.
    %U|%I|%S
```

```bash
 restart.samba
```

o Samba instalado em /opt/samba/ pode não ter permissão para gravar diretamente em /var/log/samba

```
mkdir -p /var/log/samba
chown root:root /var/log/samba
chmod 755 /var/log/samba
```

Ou aponte para um diretório interno, como:

```
log file = /opt/samba/var/logs/%m.log
```

## Auditando arquivos deletados:

```bash
cat /var/log/syslog | grep unlinkat
```

```bash
tail -f /var/log/syslog | grep unlinkat #(Teste em tempo real).
```

## Criando o diretório da rede:

```bash
mkdir /home/fileserver
```

```bash
chmod -R 0770 /home/fileserver
```

```bash
chown -R root:"domain admins" /home/fileserver
```

```bash
getfacl /home/fileserver
```

## EXTRA! SE optar por uso de perfil móvel:

```bash
mkdir /opt/samba/var/lib/samba/profiles
```

```bash
chmod -R 0770 /opt/samba/var/lib/samba/profiles
```

```bash
chown -R root:"domain admins" /opt/samba/var/lib/samba/profiles
```

## Adicionando o path do /opt/samba/etc/smb.conf:

## Linkando as bibliotecas para mapeamento de usuários de sistema local e Samba4:

```bash
/opt/samba/sbin/smbd -b | grep LIBDIR
```

```bash
ln -s /opt/samba/lib/libnss_winbind.so.2 /lib/x86-64-linux-gnu
```

```bash
ln -s /lib/x86_64-linux-gnu/libnss_winbind.so.2 /lib/x86_64-linux-gnu/libnss_winbind.so
```

```bash
ldconfig
```

```bash
vim /etc/nsswitch.conf
```

```bash
   passwd: files winbind
   group: files winbind
   shadow: files
```

## Dando poderes de root ao Administrator:

```bash
nano /opt/samba/etc/user.map
```

```bash
!root=officinas.edu\Administrator
```

## Criando o diretório de logs:

```bash
mkdir /var/log/samba
```

## Validando a troca de tickets do Kerberos:

```bash
kinit Administrator
```

```bash
klist
```

## Ingressando o Fileserver ao domínio:

```bash
net ads join -U Administrator
```

## Subindo os serviços ao boot do Sistema:

```bash
/opt/samba/sbin/smbd && /opt/samba/sbin/nmbd && /opt/samba/sbin/winbindd
```

## Adicionando o smbd ao boot do Linux:

```bash
cd /etc/systemd/system
```

```bash
vim smbd.service
```

```bash
   [Unit]
   Description=Samba SMBD FileServer
   After=network.target remote-fs.target nss-lookup.target
   [Service]
   Type=forking
   ExecStart=/opt/samba/sbin/smbd
   PIDFile=/opt/samba/var/run/smbd.pid
   [Install]
   WantedBy=multi-user.target
```

## Adicionando o nmbd ao boot do Linux:

```bash
cd /etc/systemd/system
```

```bash
vim nmbd.service
```

```bash
   [Unit]
   Description=Samba NMBD FileServer
   After=network.target remote-fs.target nss-lookup.target
   [Service]
   Type=forking
   ExecStart=/opt/samba/sbin/nmbd
   PIDFile=/opt/samba/var/run/nmbd.pid
   [Install]
   WantedBy=multi-user.target
```

## Adicionando o nmbd ao boot do Linux:

```bash
cd /etc/systemd/system
```

```bash
vim winbindd.service
```

```bash
   [Unit]
   Description=Samba WINBIND FileServer
   After=network.target remote-fs.target nss-lookup.target
   [Service]
   Type=forking
   ExecStart=/opt/samba/sbin/winbindd
   PIDFile=/opt/samba/var/run/winbindd.pid
   [Install]
   WantedBy=multi-user.target
```

```bash
systemctl enable smbd.service nmbd.service winbindd.service
```

```bash
pkill smb && pkill nmb && pkill winbind
```

```bash
systemctl start smbd.service nmbd.service winbindd.service
```

```bash
echo "systemctl start smbd.service nmbd.service winbindd.service" > /sbin/start.samba
```

```bash
echo "systemctl stop smbd.service nmbd.service winbindd.service" > /sbin/stop.samba
```

```bash
echo "systemctl restart smbd.service nmbd.service winbindd.service" > /sbin/restart.samba
```

```bash
chmod +x /sbin/*.samba
```

## Facilitando o boot dos serviços:

```bash
echo "systemctl start smbd.service nmbd.service winbindd.service" > /sbin/start.samba
```

```bash
echo "systemctl stop smbd.service nmbd.service winbindd.service" > /sbin/stop.samba
```

```bash
echo "systemctl restart smbd.service nmbd.service winbindd.service" > /sbin/restart.samba
```

```bash
chmod +x /sbin/*.samba
```

## Responde agora com:

```bash
start.samba, restart.samba e stop.samba
```

## Validando wbinfo e getent:

```bash
wbinfo --ping-dc
```

```bash
wbinfo -u
```

```bash
wbinfo -g
```

```bash
getent passwd Administrator
```

```bash
getent group "domain admins"
```

## Criando o script de backup do /home/fileserver:

```bash
mkdir /media/HDEXTERNO
```

```bash
vim /opt/samba/bkpdiario.sh
```

```bash
#!/bin/bash
   INICIO=`date +%d/%m/%Y-%H:%M:%S`
   LOG=/var/log/samba/bkpfileserver_`date +%Y-%m-%d`.txt
   echo " " >> $LOG
   echo " " >> $LOG
   echo "|-----------------------------------------------" >> $LOG
   echo " Sincronizacao iniciada em $INICIO" >> $LOG
   umount /media/HDEXTERNO
   mount /dev/sdb1 /media/HDEXTERNO
   rsync --delete -P -r -z -v /home/fileserver /media/HDEXTERNO/ >> $LOG
   FINAL=`date +%d/%m/%Y-%H:%M:%S`
   umount /media/HDEXTERNO
   echo " Sincronizacao Finalizada em $FINAL" >> $LOG
   echo "|-----------------------------------------------" >> $LOG
   echo " " >> $LOG
   echo " " >> $LOG
```

## Adicionando o script ao crontab:

```bash
vim /etc/crontab
```

```bash
# Rotinas de backup diário do SAMBA4.
# Minuto/Hora/Dia/Mês/Dia_semana/Usuário/Comando
   45 23 * * 1-5 root /opt/samba/bkpdiario.sh  > /dev/null 2>&1
```

## VAI MONTAR O HD EXTERNO, FAZER O BACKUP E DESMONTAR O HD EXTERNO!

THAT’S ALL FOLKS!!
