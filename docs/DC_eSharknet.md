DC_eSharknet


## Atualizando o Sistema operacional:

```
sudo apt update && sudo apt upgrade
```

## Setando as Configurações e rede:

```
vim /etc/network/interfaces
```

```
iface enp7s0 inet static
address 192.168.70.250
netmask 255.255.255.0
gateway 192.168.70.254
dns-nameserver 192.168.70.254
dns-search esharknet.edu
```

## Setando as Configurações de DNS:

```
vim /etc/resolv.conf
```

```
domain esharknet.edu
search esharknet.edu.
nameserver 192.168.70.254
nameserver 192.168.70.250
```

## Setando as Configurações de hosts:

```
hostnamectl set-hostname dc01
```

```
vim /etc/hosts
```

```
.0.0.1 localhost 
127.0.1.1 dc01.esharknet.edu dc01
192.168.70.250 dc01.esharknet.edu dc01
```

## Instalação dos pacotes necessários:

```
apt install net-tools bind9 samba samba-client krb5-user krb5-config winbind
```

Durante a configuração do krb5-user, você será solicitado a inserir as informações:

    - Default Kerberos version 5 realm: ESHARKNET.EDU
    - KDCs for your realm: 127.0.0.1
    - Administrative server for your Kerberos realm: 127.0.0.1

SE vc errar nessa parte, pode rodar o reconfigure para o Kerberos, depois:

```
dpkg-reconfigure krb5.conf
```

## Validando as portas em escuta:

```
netstat -pultan
```

## Efetivando o _provisionamento_ do domínio:

```
mv /etc/samba/smb.conf{,.orig}
```

```
samba-tool domain provision --use-rfc2307 --interactive
```

Siga as instruções interativas para configurar o domínio ESHARKNET.edu

## Apontamento do arquivo krb5.conf:

```
mv /etc/krb5.conf{,.orig}
```

```
ln -s /var/lib/samba/private/krb5.conf /etc
```

## Parando os serviços `smbd`, `nmbd`, `winbind` e `samba-ad-dc`:

```
systemctl stop smbd nmbd winbind

systemctl disable smbd nmbd winbind
```

## Ativa o serviço do `samba-ad-dc`
```
systemctl unmask samba-ad-dc.service
```

```
systemctl enable samba-ad-dc.service
```

```
systemctl start samba-ad-dc.service
```

## Redefinindo o Servidor de DNS:

```
vim /etc/resolv.conf
```

```
nameserver 127.0.0.1
```

## Travando o arquivo contra alterações automáticas:

```
chattr +i /etc/resolv.conf
```

## Configuração do arquivo `smb.conf`:

```
vim /etc/samba/smb.conf
```

Adicione ou modifique as seguintes seções:

    -[global]
    
    -workgroup = ESHARKNET
    -realm = ESHARKNET.EDU
    -netbios name = dc01
    -server role = active directory domain controller
    -idmap_ldb:use rfc2307 = yes
    -dns forwarder = 192.168.70.254
    -vfs objects = dfs_samba4 acl_xattr recycle
    -vfs objects = dfs_samba4 acl_xattr audit
    -recycle:repository = .recycle
    -recycle:keeptree = yes
    -recycle:versions = yes
    -recycle:touch = no
    -recycle:directory_mode = 0777
    -recycle:subdir_mode = 0700
    -recycle:exclude = *.tmp,*.temp,*.o,*.obj
    -recycle:exclude_dir = /tmp,/temp,/cache
    -template homedir = /home/%U
    -log file = /var/log/samba/%m.log
    -log level = 3
    
    -[sysvol]
    -path = /var/lib/samba/sysvol
    -read only = No
    -browseable = No

    -[netlogon]
    -path = /var/lib/samba/sysvol/ESHARKNET.edu/scripts
    -read only = No
    -browseable = No

    -[ARQUIVOS]
    -path = /srv/samba/arquivos
    -comment = Compartilhamentos da Rede
    -browsable = yes
    -writable = yes
    -read only = no

## Criando o diretório compartilhado:

```
mkdir -p /srv/samba/arquivos
```
## Setando as permissões de acesso:

```
chmod -R 0770 /srv/samba/arquivos
chown -R root:"Domain Users" /srv/samba/arquivos
```

## Revisando usuários e grupos:

```
cat /etc/passwd # ( usuários locais do Linux gerencia do LDAP )
```
```
samba-tool user list # ( usuários de rede gerenciados pelo SAMBA4 )
```

## Outras validações no domínio:
```

wbinfo -u
wbinfo -g
wbinfo --ping-dc
getent group “Domain Admins”
```

## Verificando serviço ativo:

```
ps aux | grep samba
ps ax | egrep "samba|smbd|nmbd|winbindd"
ps axf
```

## Consultando o Servidor:

```
testparm
smbclient --version
smbclient -L localhost -U%
samba-tool domain level show
```

## Desabilitando a complexidade de senhas (INSEGURO!):

```
samba-tool domain passwordsettings show
samba-tool domain passwordsettings set --complexity=off
samba-tool domain passwordsettings set --history-length=0
samba-tool domain passwordsettings set --min-pwd-length=0
samba-tool domain passwordsettings set --min-pwd-age=0
samba-tool user setexpiry Administrator --noexpiry
```

## Relendo as configurações do Samba4:

```
smbcontrol all reload-config
```

## Validando a troca de tickets do Kerberos:

```
kinit Administrator@ESHARKNET.EDU
klist
```

## Consultando serviços do `kerberos` e do `ldap`:

```
host -t srv _kerberos._tcp.ESHARKNET.edu
host -t srv _ldap._tcp.ESHARKNET.edu
dig ESHARKNET.edu
host -t A firewall
```
## Agora é só instalar as ferramentas do `rsat` em uma máquina Windows e gerenciar o Servidor!


THAT’S ALL FOLKS!!
