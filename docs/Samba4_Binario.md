# SAMBA4 por repositórios

## Atualização do Sistema Operacional

```
apt update && apt full-upgrade
```

## Setando o hostname

```
hostnamectl set-hostname dcmaster
```

## Setando as configurações da placa de rede

```
vim /etc/network/interfaces
```

```
iface enp1s0 inet static
address 192.168.0.250
netmask 255.255.255.0
gateway 192.168.0.1
```

## Setando as configurações de DNS

```
vim /etc/resolv.conf
```

```
nameserver 192.168.0.1
```

## Edição do /etc/hosts

```
vim /etc/hosts
```

```
127.0.0.1        localhost
127.0.1.1        dcmaster.officinas.edu dcmaster
192.168.0.250    dcmaster.officinas.edu dcmaster
```

## Instalação dos pacotes necessários

```
apt install samba samba-client krb5-user krb5-config winbind libnss-winbind ldap-utils acl attr net-tools
```

## Nessa etapa vai pedir s configurações do arquivo /etc/krb5.conf

```
Realm Kerberos versão 5 padrão = OFFICINAS.EDU
Servidor Kerberos para seu realm = dcmaster
Servidor Administrativo para seu realm kerberos = dcmaster
```

## SE vc errar nessa parte, pode rodar o reconfigure para o Kerberos, depois

```
dpkg-reconfigure krb5.conf
```

## Modelo de configuração do arquivo de autenticação do Kerberos

```
vim /etc/krb5.conf
```

```
[libdefaults]
    default_realm = OFFICINAS.EDU
    dns_lookup_realm = false
    dns_lookup_kdc = true

# The following krb5.conf variables are only for MIT Kerberos.
    kdc_timesync = 1
    ccache_type = 4
    forwardable = true
    proxiable = true
    rdns = false

# The following libdefaults parameters are only for Heimdal Kerberos.
    fcc-mit-ticketflags = true

[realms]
    officinas.edu = {
        kdc = dcmaster.officinas.edu
        admin_server = dcmaster.officinas.edu
        default_domain = officinas.edu
    }

[domain_realm]
    .officinas.edu = OFFICINAS.EDU
    officinas.edu = OFFICINAS.EDU
```

# Esse arquivo também pode ser linkado de outro PATH (criado somente após provisionar)

```
cat /var/lib/samba/private/krb5.conf
```

```
[libdefaults]
    default_realm = OFFICINAS.EDU
    dns_lookup_realm = false
    dns_lookup_kdc = true

[realms]
    OFFICINAS.EDU = {
    default_domain = officinas.edu
}

[domain_realm]
    dcmaster = OFFICINAS.EDU
```

## Seria

```
ln -s /var/lib/samba/private/krb5.conf /etc
```

## Validando as portas em escuta

```
netstat -pultan
```

## Editando o arquivo de autenticação do /etc/nsswitch.conf

```
vim /etc/nsswitch
```

```
passwd:         files systemd winbind
group:          files systemd winbind
shadow:         files systemd
gshadow:        files systemd
```

## criando um backup do arquivo do SAMBA

```
mv /etc/samba/smb.conf{,.orig}
```

## Parando e desabilitando os serviços do smbd

```
systemctl stop smbd.service
```

```
systemctl disable smbd.service
```

## Provisionando o domínio

```
samba-tool domain provision --use-rfc2307 --interactive 
```

```
Realm [OFFICINAS.EDU]: (nome de seu domínio completo).
dcmaster [officinas]: (nome de seu domínio abreviado).
Server Role (dc, member, standalone) [dc]: (tipo de servidor controlador de domínio).
DNS backend (SAMBA_INTERNAL, BIND9_FLATFILE, BIND9_DLZ, NONE) [SAMBA_INTERNAL]: (tipo de serviço DNS).
DNS forwarder IP address (write ‘none’ to disable forwarding) [192.168.0.1]: (Encaminhador DNS)
```

## Liberando o serviço do SAMBA4 e adicionando ao boot do Sistema

```
systemctl unmask samba-ad-dc.service 
```

```
systemctl enable samba-ad-dc.service
```

```
systemctl start samba-ad-dc.service
```

## Reapontando o Servidor de DNS para o próprio Controlador de domínio

```bash
vim /etc/resolv.conf
```

```
dcmaster officinas.edu
search officinas.edu.
nameserver 127.0.0.1
```

## Travando a edição do resolv.conf

```
chattr +i /etc/resolv.conf
```

## Testando o serviço do SAMBA4

```
testparm
```

```
smbclient -L dcmaster -U Administrator
```

```
Enter Administrator's password:
```

```
Password for [Administrator@OFFICINAS.EDU]:

    Sharename       Type      Comment
    ---------       ----      -------
    sysvol          Disk      
    netlogon        Disk      
    IPC$            IPC       IPC Service (Samba 4.21.4-Debian-4.21.4+dfsg-1)
SMB1 disabled -- no workgroup available
```

## Validando o nível do Controlador de domínio

```
samba-tool domain level show
```

```
dcmaster and forest function level for dcmaster 'DC=officinas,DC=edu'

Forest function level: (Windows) 2008 R2
dcmaster function level: (Windows) 2008 R2
Lowest function level of a DC: (Windows) 2008 R2
```

## Desabilitando a complexidade de senhas (inseguro)

```
samba-tool domain passwordsettings show
samba-tool domain passwordsettings set --complexity=off
samba-tool domain passwordsettings set --history-length=0
samba-tool domain passwordsettings set --min-pwd-length=0
samba-tool domain passwordsettings set --min-pwd-age=0
samba-tool user setexpiry Administrator --noexpiry
```

## Relendo as configurações do SAMBA4

```
smbcontrol all reload-config
```

## Validando serviço do Kerberos

```bash
kinit Administrator@OFFICINAS.EDU
```

```bash
klist
```

```
wbinfo --all-domains
```

```
host -t A officinas.edu
```

```
Using dcmaster server:
Name: officinas.edu
Address: 192.168.0.1#53
Aliases: 

A has no SRV record
```

```
host -t srv _ldap._tcp.officinas.edu
```

```
_ldap._tcp.officinas.edu has SRV record 0 100 389 dcmaster.officinas.edu.
```

```
host -t SRV _kerberos._udp.officinas.edu
```

```
_kerberos._udp.officinas.edu has SRV record 0 100 88 dcmaster.officinas.edu.
```

## Outras validações no domínio:

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
getent group “domain Admins”
```

## Validação de serviços ativos

```
ps aux | grep samba
ps ax | egrep "samba|smbd|nmbd|winbindd"
ps axf
```

that's all folks!
