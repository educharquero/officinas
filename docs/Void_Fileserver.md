# Servidor de Arquivos rodando Samba4 sob Void Linux Server ;D

## 🎯 Objetivo - Subir um Servidor de Arquivos no Void Linux (glibc) compilando o Samba4 a partir do código fonte, integrado ao Controlador de domínio da rede.

### 🔧 ADAPTE o tutorial á SUA realidade, obviamente!

## 📡 Layout de rede local

- Domínio: EDUCATUX.EDU
- Hostname: VOIDARQUIVOS
- Firewall 192.168.70.254 (GW)
- Domain Control 192.168.70.250 (DNS)
- Ip: 192.168.70.251

---

## A instalação padrão do Void Linux não será coberta nesse tutorial.

## Trocar o Shell padrão do Void, pós instalado

```bash
chsh -s /bin/bash
```

## 🧩 Instalar pacotes de dependências para compilar o Samba4 no Void

```bash
xbps-install -S \
 net-tools rsync acl attr attr-devel autoconf automake libtool \
 binutils bison gcc make ccache chrpath curl \
 docbook-xml docbook-xsl flex gdb git htop \
 mit-krb5 mit-krb5-client mit-krb5-devel \
 libarchive-devel avahi avahi-libs libblkid-devel \
 libbsd-devel libcap-devel cups-devel dbus-devel glib-devel \
 gnutls-devel gpgme-devel icu-devel jansson-devel \
 lmdb lmdb-devel libldap-devel ncurses-devel pam-devel perl \
 perl-Text-ParseWords perl-JSON perl-Parse-Yapp \
 libpcap-devel popt-devel readline-devel \
 libtasn1 libtasn1-devel libunwind-devel python3 python3-devel \
 python3-dnspython python3-cryptography \
 python3-matplotlib python3-pexpect python3-pyasn1 \
 tree libuuid-devel wget xfsprogs-devel zlib-devel \
 bind ldns pkg-config
```

## 🖥️ Setar hostname

```bash
echo "voidarquivos" > /etc/hostname
```

## 🏠 /etc/hosts

```bash
vim /etc/hosts
```

## Conteúdo:

```bash
127.0.0.1      localhost
127.0.1.1      voidarquivos.educatux.edu voidarquivos
192.168.70.251 voidarquivos.educatux.edu voidarquivos
```

## 🌐 Configurar IP fixo

### 👉 Usaremos o método padrão do Void, o /etc/dhcpcd.conf

```bash
vim /etc/dhcpcd.conf
```

## Adicionar ip, gateway e dns:

```bash
interface eth0
static ip_address=192.168.70.251/24
static routers=192.168.70.254
static domain_name_servers=192.168.70.250
```

## Reiniciar a interface de rede:

```bash
sv restart dhcpcd
```

## 🌐 Setar o Domain Control como DNS

```bash
echo "nameserver 192.168.70.250" > /etc/resolv.conf
```

## Travar a configuração do resolv.conf

```bash
chattr +i /etc/resolv.conf
```

## 🔍 Validar endereço atribuído á interface de rede

```bash
ip -c addr
```

```bash
ip -br link
```

## 📥 Baixar e descompactar o código fonte do Samba4

```bash
wget https://download.samba.org/pub/samba/samba-4.23.3.tar.gz
```

```bash
tar -xvzf samba-4.23.3.tar.gz
```

## Compilar e instalar o código fonte

```bash
cd samba-4.23.3
```

```bash
./configure --prefix=/opt/samba
```

```bash
make -j$(nproc) && make install
```

## Comentário:

- O Void não interfere na instalação, pois o Samba4 é compilado em /opt/samba.
- O make -j acelera muito a compilação, mesmo assim, vá tomar um café.
- Após instalar, o Samba4 compilado não tem serviços criados no runit.
- Criaremos os serviços manualmente.

## 📁 Adicionar Samba4 ao PATH do Sistema e reler o ambiente

```bash
echo 'export PATH=/opt/samba/bin:/opt/samba/sbin:$PATH' > /etc/profile
```

```bash
source /etc/profile
```

## Testar a inserção do PATH do Samba4 no Sistema Operacional

```bash
samba-tool -V
```

## Resultado:

```bash
4.23.3
```

## ⚠️ ATENÇÃO - NÃO PROVISIONAR o Servidor de Arquivos!!

### Você deverá criar manualmente o arquivo do smb.conf

```bash
vim /opt/samba/etc/smb.conf
```

## conteúdo:

```bash
[global]
   workgroup = EDUCATUX
   security = ads
   realm = EDUCATUX.EDU
   encrypt passwords = yes

   log file = /opt/samba/var/log.%m
   max log size = 50

   winbind use default domain = yes
   winbind enum users = yes
   winbind enum groups = yes
   winbind refresh tickets = yes

   idmap config * : backend = tdb
   idmap config * : range = 3000-7999
   idmap config EDUCATUX : backend = rid
   idmap config EDUCATUX : range = 10000-999999

   template shell = /bin/bash
   template homedir = /home/%U
```

## 📦 Criar os serviços no RUNIT do smbd, nmbd e winbind, para subir o Servidor de Arquivos no boot do Sistema Operacional.

## ✅ Criar a estrutura de paths dos 03 serviços, antes de criar os arquivos de serviços e logs

```bash
mkdir -p /etc/sv/smbd/log
mkdir -p /etc/sv/nmbd/log
mkdir -p /etc/sv/winbindd/log
```

## 1️⃣ SMBD

## ✅ Criar o arquivo do serviço do smbd no runit

```bash
> /etc/sv/smbd/run
```

## Inserir o conteúdo do arquivo de execução

```bash
cat > /etc/sv/smbd/run << 'EOF'
#!/bin/sh
exec 2>&1
exec /opt/samba/sbin/smbd --foreground --no-process-group
EOF
```

## Setar permissão de execução ao serviço

```bash
chmod +x /etc/sv/smbd/run
```

## Criar o arquivo de logs do smbd no runit

```bash
> /etc/sv/smbd/log/run
```

## Inserir o conteúdo no arquivo de logs

```bash
cat > /etc/sv/smbd/log/run << 'EOF'
#!/bin/sh
exec svlogd -tt /var/log/smbd
EOF
```

## Setar permissão de execução ao serviço

```bash
chmod +x /etc/sv/smbd/log/run
```

## Cria o path do smbd no /var/log

```bash
mkdir -p /var/log/smbd
```

3️⃣ WINBIND

## Criar o arquivo do serviço do winbind no runit

```bash
> /etc/sv/winbindd/run
```

## Inserir o conteúdo no arquivo de execução

```bash
cat > /etc/sv/winbindd/run << 'EOF'
#!/bin/sh
exec 2>&1
exec /opt/samba/sbin/winbindd --foreground --no-process-group
EOF
```

## Seta permissão de execução ao serviço

```bash
chmod +x /etc/sv/winbindd/run
```

## Criar o arquivo de logs do serviço do winbind no runit

```bash
> /etc/sv/winbindd/log/run
```

## Insere o conteúdo

```bash
cat > /etc/sv/winbindd/log/run << 'EOF'
#!/bin/sh
exec svlogd -tt /var/log/winbindd
EOF
```

## Seta permissão de execução

```bash
chmod +x /etc/sv/winbindd/log/run
```

## Cria o arquivo de log do winbind no path do /var/log

```bash
mkdir -p /var/log/winbindd
```

## Ativar os serviços no runit para subirem automagicamente no boot

```bash
ln -s /etc/sv/smbd /var/service/
ln -s /etc/sv/nmbd /var/service/
ln -s /etc/sv/winbindd /var/service/
```

## Validar se os serviços subiram corretamente

```bash
sv status smbd
sv status nmbd
sv status winbindd
```

## Deverá ver algo como:

```bash
run: smbd: (pid 1245) 3s
run: nmbd: (pid 1249) 3s
run: winbindd: (pid 1253) 3s
```

## Validar logs em tempo real

```bash
tail -f /var/log/smbd/current
```

## 🕒 NTP / Chrony Server

## O Servidor de Arquivos precisará sincronizar horário com o Controlador de domínio

## Instalar o pacote do Chrony Server

```bash
xbps-install -Syu chrony
```

## Editar o arquivo do cliente e substituir os repositórios de sincronizações de tempo

```bash
vim /etc/chrony.conf
```

### Apontar para o Controlador de domínio da rede

```bash
# Sincroniza exclusivamente com o Controlador de Domínio da rede
server 192.168.70.250 iburst prefer

# Driftfile para correção automática do clock
driftfile /var/lib/chrony/drift

# Armazenar estatísticas
logdir /var/log/chrony

# Quanto mais agressivo, mais rápido corrige clocks fora do tempo
makestep 1.0 3
```

## Adicionar o serviço do chronyd ao start do RUNIT

```bash
ln -s /etc/sv/chronyd/ /var/service
```

## Reiniciar o TimeServer:

```bash
sv restart chronyd
```

## Valide o TimeServer

```bash
chronyc sources -v
```

## Você verá algo como

```bash
MS Name/IP address         Stratum Poll Reach LastRx Last sample
^* 192.168.70.250               4   6   377    2     -12ns[ -43ns] +/- 0.123ms
```

## 👑 Dar poderes de root ao Administrator

```bash
vim /opt/samba/etc/user.map
```

```bash
!root=educatux.edu\Administrator
```

## 🔗 Linkar bibliotecas do Winbind no Sistema

## Validar os paths de libdir:

```bash
smbd -b | grep LIBDIR
```

## Saída esperada:

```bash
LIBDIR: /opt/samba/lib
```

## Criar links entre as bibliotecas. Prefira digitar manualmente ao invés de copiar e colar aqui.

```bash
ln -s /opt/samba/lib/libnss_winbind.so.2 /usr/lib/
```

```bash
ln -s /usr/lib/libnss_winbind.so.2 /usr/lib/libnss_winbind.so
```

## Releia a configuração com as novas bibliotecas linkadas

```bash
ldconfig
```

## Validar efetividade da troca de tickets do kerberos, adicionando winbind ás duas linhas do nsswhitch (passwd e group):

```bash
vim /etc/nsswitch.conf
```

```bash
passwd: files winbind
group:  files winbind
```

## 📝 Modelo correto do /etc/krb5.conf apontando para o Controlador de Domínio (Void Linux + Samba membro AD)

## vim /etc/krb5.conf

```bash
[libdefaults]
    default_realm = EDUCATUX.EDU
    dns_lookup_realm = true
    dns_lookup_kdc = true
    rdns = false
    forwardable = true
    proxiable = true

[realms]
    EDUCATUX.EDU = {
        kdc = 192.168.70.250
        admin_server = 192.168.70.250
        default_domain = educatux.edu
    }

[domain_realm]
    .educatux.edu = EDUCATUX.EDU
    educatux.edu = EDUCATUX.EDU
```

## Testar Kerberos antes do join ao domínio

### ⚠️ ATENÇÃO:  O Samba4 compilado inclui o código do kerberos Heimdal, embutido (KDC interno) por default, mas não inclui clientes Kerberos. Nesse caso o repositório disponibiliza pacotes binários do MIT, que podem ser instalados sem qualquer problema ou interferência no kerberos heimdal default, compilado no Controlador de Domínio ou Servidor de Arquivos. Os pacotes são: mit-krb5 mit-krb5-client mit-krb5-devel. PORÉM você NÃO DEVE em hipótese alguma, instalar por repositório o pacote binário do krb5-server, o que causaria serviço concorrente ao kerberos Heimdal, interno do Samba4!

## Os serviços fornecidos pelos clientes do MIT-krb5, ficam em:

```bash
/usr/bin/kinit
/usr/bin/klist
/usr/bin/kvno
/usr/bin/kdestroy
```

## Instalação dos pacotes binários clientes, do MIT-Krb5

```
xbps-install -S mit-krb5 mit-krb5-client mit-krb5-devel
```

```bash
kinit Administrator@EDUCATUX.EDU
```

```bash
klist
```

## Ver o ticket:

## 🔥 Agora você pode ingressar o Servidor de Arquivos no domínio

```bash
net ads join -U Administrator
```

## Você receberá

```bash
Password for [Administrator@EDUCATUX.EDU]:
Using short domain name -- EDUCATUX
Joined 'VOIDARQUIVOS' to dns domain 'educatux.edu'
```

## 🎉 Pronto!

## Seu Void Linux agora possui um Servidor de Arquivos, Samba4 (Member Server) totalmente funcional, integrado ao AD Samba4, usando Runit corretamente.

---

🎯 THAT'S ALL FOLKS!

👉 Contato: zerolies@disroot.org
👉 https://t.me/z3r0l135
