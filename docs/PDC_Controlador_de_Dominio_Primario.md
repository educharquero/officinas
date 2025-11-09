# 📁 SRVDC01 - Instalação do Controlador de Domínio Primário com Samba4 no Debian 13

## 🧭 Neste guia, configuraremos um **Controlador de Domínio Primário (PDC)** utilizando o **Debian 13 (Trixie)** e o **Samba 4.22** como **Active Directory**. Usaremos pacotes binários oficiais do Debian e uma configuração limpa, ideal para laboratórios de estudos.

---

🌐 1. Topologia da rede - Função, endereçamento ip e nomes:

Firewall:                   SRVFIREWALL       192.168.70.254

Controlador de Domínio:     SRVDC01           192.168.70.253

FileServer:                 SRVARQUIVOS       192.168.70.252

Domínio AD:                 OFFICINAS.EDU

Workgroup:                  OFFICINAS

---

## 🕐 1. A sincronização de horário essencial para que o PDC e as máquinas de rede conversem, pois o Kerberos é extremamente sensível a diferenças de tempo

## Então começe desativando o gerenciamento do `systemd-timesyncd` para evitar conflitos com o Chrony, que preferiremos instalar.

```bash
sudo systemctl stop systemd-timesyncd
```

```bash
sudo systemctl disable systemd-timesyncd
```

## Instale o pacote do chrony.

```bash
sudo apt install chrony -y
```

## Edite o arquivo do chrony.conf.

```bash
sudo vim /etc/chrony/chrony.conf
```

## Adicione ou ajuste as linhas para apontar para repositórios de horário no BR e liberar a consulta da rede interna.

```bash
driftfile /var/lib/chrony/chrony.drift

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

## Habilite e reinicie o serviço de sincronização de horário.

```bash
sudo systemctl enable chronyd
```

```bash
sudo systemctl restart chronyd
```

```bash
chronyc sources -v
```

## 📦 2. Sincronize os repositórios do Debian e atualize o sistema.

```bash
sudo apt update && sudo apt full-upgrade -y
```

## 🌐 3. Configuração de rede (modo estático)

## Edite o arquivo interfaces e sete o ip fixo.

```bash
sudo vim /etc/network/interfaces
```

```bash
allow-hotplug enp1s0
iface enp1s0 inet static
  address 192.168.70.250
  netmask 255.255.255.0
  gateway 192.168.70.254
```

## Reinicie a interface para subir o novo endereço.

```bash
sudo ifdown enp1s0 && sudo ifup enp1s0
```

## 🌍 4. Configuração de DNS temporário

## Antes de o domínio estar ativo, aponte o DNS para o firewall.

```bash
sudo vim /etc/resolv.conf
```

```bash
nameserver 192.168.70.254
```

## 🧩 5. Hostname e resolução local

## Defina o hostname do Servidor.

```bash
sudo hostnamectl set-hostname srvdc01
```

## Edite o arquivo de hosts para atrelando ip/domínio.

```bash
sudo vim /etc/hosts
```

```bash
127.0.0.1 localhost
127.0.1.1 srvdc01.officinas.edu srvdc01
192.168.70.250 srvdc01.officinas.edu srvdc01
```

## 🔐 6. Instalação dos pacotes necessários

```bash
sudo apt install samba samba-dsdb-modules samba-vfs-modules smbclient \
krb5-user krb5-config winbind libnss-winbind libpam-winbind \
ldb-tools dnsutils chrony python3-cryptography net-tools -y
```

## Durante a configuração do Kerberos (krb5-user), insira.

```bash
Default realm: OFFICINAS.EDU

KDC: srvdc01.officinas.edu

Admin server: srvdc01.officinas.edu
```

## Se errar, poderá refazer.

```bash
sudo dpkg-reconfigure krb5-config
```

## ⚙️ 7. Configuração manual do /etc/krb5.conf 

## SE precisar de referência, use esse modelo.

```bash
sudo vim /etc/krb5.conf
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
        kdc = srvdc01.officinas.edu
        admin_server = srvdc01.officinas.edu
        default_domain = officinas.edu
    }

[domain_realm]
    .officinas.edu = OFFICINAS.EDU
    officinas.edu = OFFICINAS.EDU
```

## 🔍 8. Ajuste no NSS (para Winbind)

## Edite o arquivo nsswitch.conf e adicione winbind na lista de busca por usuários.

```bash
passwd:       files systemd winbind
group:        files systemd winbind
```

## 🧰 9. Parar serviços concorrentes ao samba-ad-dc.service, antes do provisionamento

```bash
sudo systemctl stop smbd nmbd winbind
```

```bash
sudo systemctl disable smbd nmbd winbind
```

## 🏗️ 10. Provisionamento do domínio

## faça um backup do arquivo smb.conf original, pois o provisionamento criará outro.

```bash
sudo mv /etc/samba/smb.conf{,.orig}
```

## Execute o provisionamento.

```bash
sudo samba-tool domain provision \
  --realm=OFFICINAS.EDU \
  --use-rfc2307 \
  --domain=OFFICINAS \
  --dns-backend=SAMBA_INTERNAL \
  --adminpass='P@ssw0rd' \
  --server-role=dc \
  --function-level=2016
```

## Responda às perguntas conforme necessário.

```bash
Realm: OFFICINAS.EDU

Domain: OFFICINAS

Server Role: dc

DNS Backend: SAMBA_INTERNAL

DNS Forwarder: 192.168.70.254
```

## 🚀 11. Habilitar o serviço principal, samba-ad-dc.service

```bash
sudo systemctl unmask samba-ad-dc.service
```

```bash
sudo systemctl enable samba-ad-dc.service
```

```bash
sudo systemctl start samba-ad-dc.service
```

```bash
sudo systemctl status samba-ad-dc.service
```

## Valide os logs.

```bash
sudo journalctl -u samba-ad-dc -f
```

## 🌐 12. Reapontar DNS para o próprio servidor, já que agora comporta a função de DNS_INTERNAL definido no provisionamento:

```bash
sudo vim /etc/resolv.conf
```

```bash
nameserver 127.0.0.1
```

## Proteja o arquivo do resolv.conf contra edição automática:

```bash
sudo chattr +i /etc/resolv.conf
```

## 📄 13. Configuração do arquivo smb.conf

## Após o provisionamento, revise e valide.

```bash
sudo vim /etc/samba/smb.conf
```

```bash
[global]
    dns forwarder = 192.168.70.254
    netbios name = SRVDC01
    realm = OFFICINAS.EDU
    server role = active directory domain controller
    workgroup = OFFICINAS
    idmap_ldb:use rfc2307 = yes

[sysvol]
    path = /var/lib/samba/sysvol
    read only = No

[netlogon]
    path = /var/lib/samba/sysvol/officinas.edu/scripts
    read only = No

# SE for usar compartilhamento no SRVDC01 (NÃO indicado):

[ARQUIVOS]
    path = /srv/samba/arquivos
    comment = Compartilhamentos da Rede
    browsable = yes
    writable = yes
    read only = no
```

## 📁 14. Criação do diretório compartilhado SE optou por compartilhar arquivos junto com o Controlador de Domínio (Não indiciado).

```bash
sudo mkdir -p /srv/samba/arquivos
```

```bash
sudo chmod -R 0770 /srv/samba/arquivos
```

```bash
sudo chown -R root:"domain users" /srv/samba/arquivos
```

## 👥 15. Validações básicas de usuários e grupos (locais e de domínio)

## Note que usuários/grupos locais

```bash
cat /etc/passwd
```

## Não são os mesmos que usuários/grupos do domínio:

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

## Teste SMB:

```bash
smbclient -L localhost -UAdministrator
```

## 🔒 16. Desativando complexidade de senha (somente para laboratório!)

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

## 🔁 17. Recarga de configuração no SAMBA4.

```bash
smbcontrol all reload-config
```

## 🎟️ 18. Validação no Kerberos

```bash
kinit Administrator@OFFICINAS.EDU
```

```bash
klist
```

## 🔎 19. Testes de DNS e SRV

```bash
host -t A officinas.edu
```

```bash
host -t SRV _kerberos._tcp.OFFICINAS.EDU
```

```bash
host -t SRV _ldap._tcp.OFFICINAS.EDU
```

```bash
dig OFFICINAS.EDU
```

## 🧱 20. Validações no SAMBA4

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

## 🧰 21. Habilitando o Logrotate (opcional)

## Crie /etc/logrotate.d/samba para conter os logs.

```bash
/var/log/samba/*.log {
    weekly
    rotate 4
    compress
    delaycompress
    missingok
    notifempty
}
```

## 🪟 22. Administração via RSAT (Windows)

## Após o domínio estar funcional, instale o RSAT (Remote Server Administration Tools) em uma máquina Windows e adicione-a ao domínio OFFICINAS.EDU para gerenciar usuários, grupos e GPOs.

## 🎉 23. Conclusão. Parabéns! 🎊 Seu Controlador de Domínio Samba4 (SRVDC01) no Debian 13 está configurado e operacional.


THAT’S ALL FOLKS!!
