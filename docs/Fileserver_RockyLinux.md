# 📁 FileServer RockyLinux


## INSTALAÇÃO DO SAMBA4

```
dnf install samba samba-client
```

## HABILITANDO O SERVIÇO

```
systemctl start smb.service 
systemctl start nmb.service 
systemctl enable smb.service 
systemctl enable nmb.service
```

```
smbd --version
```

## EDITANDO O smb.conf

```
mv /etc/samba/smb.conf{,.orig}

vim /etc/samba/smb.conf
```

```
[global]
    workgroup = ESHARKNET
    #hosts allow = 127. 192.168.0
    server string = Servidor de Arquivos %v
    netbios name = servidor
    security = user
    map to guest = bad user
    dns proxy = no
    ntlm auth = true

    passdb backend = tdbsam

    printing = cups
    printcap name = cups
    load printers = yes
    cups options = raw

[home]
    comment = Diretorio Home
    valid users = %S, %D%w%S
    browseable = No
    read only = No
    inherit acls = Yes

[printers]
    comment = All Printers
    path = /var/tmp
    printable = Yes
    create mask = 0600
    browseable = No

[print$]
    comment = Printer Drivers
    path = /var/lib/samba/drivers
    write list = @printadmin root
    force group = @printadmin
    create mask = 0664
    directory mask = 0775

[ARQUIVOS]
    comment = Compartilhamentos de Rede
    path = /srv/samba/ARQUIVOS
    browseable = Yes
    writeable = Yes
    guest ok = Yes

[Diretoria]
    path = /srv/samba/Diretoria
    valid users = @diretoria
    guest ok = no
    writable = no
    browsable = yes

[Financeiro]
    path = /srv/samba/Financeiro
    valid users = @financeiro
    guest ok = no
    writable = no
    browsable = yes

[Rh]
    path = /srv/samba/Rh
    valid users = @rh
    guest ok = no
    writable = no
    browsable = yes

[Comercial]
    path = /srv/samba/Comercial
    valid users = @comercial
    guest ok = no
    writable = no
    browsable = yes

[Tecnicos]
    path = /srv/samba/Tecnicos
    valid users = @tecnicos
    guest ok = no
    writable = no
    browsable = yes
```

## VALIDANDO AS CONFIGURAÇÕES

```
testparm
```

## CRIANDO GRUPOS DE ACESSO

```
groupadd diretoria
groupadd financeiro
groupadd rh
groupadd comercial
groupadd tecnicos
```

## CRIANDO USUÁRIO DE ACESSO E INSERINDO NOS GRUPOS

```
useradd Eduardo
smbpasswd -a Eduardo
usermod -g diretoria Eduardo
```

```
useradd Keila
smbpasswd -a Keila
usermod -g financeiro Keila
```

```
useradd Marcelo
smbpasswd -a Marcelo
usermod -g rh Marcelo
```

```
useradd Kaua
smbpasswd -a kaua
usermod -g comercial kaua
```

```
useradd Marcia
smbpasswd -a Marcia
usermod -g tecnicos Marcia
```

## VALIDANDO USUÁRIOS

```
pdbedit -L
pdbedit -v -L
```

## CRIANDO DIRETÓRIO ESPECÍFICO COM POLÍTICAS DE ACESSO

```
mkdir -p /srv/samba/Diretoria
chmod -R 770 /srv/samba/Diretoria
chown -R root:diretoria /srv/samba/Diretoria
```

```
mkdir -p /srv/samba/financeiro
chmod -R 770 /srv/samba/financeiro
chown -R root:financeiro /srv/samba/Financeiro
```

```
mkdir -p /srv/samba/Rh
chmod -R 770 /srv/samba/Rh
chown -R root:rh /srv/samba/Rh
```

```
mkdir -p /srv/samba/Tecnicos
chmod -R 770 /srv/samba/Tecnicos
chown -R root:tecnicos /srv/samba/Tecnicos
```

```
mkdir -p /srv/samba/Comercial
chmod -R 770 /srv/samba/Comercial
chown -R root:comercial /srv/samba/Comercial
```

## Restartando os serviços

```
systemctl restart smbd
systemctl restart nmbd
```

## Acesse o diretório Geral e logue com seu usuário e senha

No Explorer do Windows ou do Linux:

smb://192.168.0.250/

No Terminal do Linux:

```
smbclient ´\\192.168.0.250´ -U eduardo
```

```
smbclient //192.168.0.250 -U Eduardo
```

```
smbstatus
```

## Pesquisar:

```
setfacl -R -m "g:financeiro:rwx" /srv/samba/Financeiro
```
