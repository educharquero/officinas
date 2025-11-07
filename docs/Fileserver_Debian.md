# 📁 FileServer Debian 13 — Integrado ao Domínio

## 🎯 O Objetivo é instalar, configurar e integrar o Samba4 em um servidor Debian 13, criando compartilhamentos de rede autenticados via Controlador de Domínio Samba4 (AD).

## 🌐 1. Configurações de rede - IPs e nomes:

```bash
FileServer: 192.168.70.252

Controlador de Domínio (SRVDC01): 192.168.70.253

Gateway/Firewall: 192.168.70.254

Domínio AD: OFFICINAS.EDU

Workgroup: OFFICINAS

Hostname do servidor: srvarquivos
```

## 📘 Editar o arquivo de interfaces:

```bash
sudo vim /etc/network/interfaces
```
```bash
allow-hotplug enp1s0
iface enp1s0 inet static
    address 192.168.70.252/24
    gateway 192.168.70.254
    dns-nameservers 192.168.70.253
    dns-search officinas.edu
```

## 📘 Editar o /etc/hosts:

```bash
127.0.0.1   localhost
127.0.1.1   srvarquivos
192.168.70.252 srvarquivos.officinas.edu srvarquivos
192.168.70.253 srvdc01.officinas.edu srvdc01
```

## 📘 Editar o /etc/resolv.conf:

```bash
nameserver 192.168.70.253
search officinas.edu
```

## 📘 Definir hostname:

```bash
sudo hostnamectl set-hostname srvarquivos
```

## 🔄 2. Atualizando o sistema:

```bash
sudo apt update && sudo apt full-upgrade -y
sudo reboot
```

## 📦 3. Instalando os pacotes necessários

```bash
sudo apt install samba samba-common-bin winbind libnss-winbind libpam-winbind krb5-user -y
```

## Durante a instalação, configure o REALM como:

```bash
OFFICINAS.EDU
```

## 🔐 4. Configurando o Kerberos

```bash
[libdefaults]
    default_realm = OFFICINAS.EDU
    dns_lookup_realm = false
    dns_lookup_ksrvdc01 = true
    ticket_lifetime = 24h
    renew_lifetime = 7d
    forwardable = true

[realms]
    OFFICINAS.EDU = {
        ksrvdc01 = 192.168.70.253
        admin_server = 192.168.70.253
    }

[domain_realm]
    .officinas.edu = OFFICINAS.EDU
    officinas.edu = OFFICINAS.EDU
```

## Teste o Kerberos:

```bash
kinit administrador@OFFICINAS.EDU
```

```bash
klist
```

## Você deve ver um ticket válido.


## 🖥️ 5. Backup da configuração padrão do Samba

```bash
sudo mv /etc/samba/smb.conf{,.orig}
```

## ⚙️ 6. Criar nova configuração /etc/samba/smb.conf

```bash
sudo vim /etc/samba/smb.conf
```

```bash
[global]
   workgroup = OFFICINAS
   realm = OFFICINAS.EDU
   netbios name = SRVARQUIVOS
   server string = Servidor de Arquivos OFFICINAS
   security = ADS

   # Autenticação via domínio
   dedicated keytab file = /etc/krb5.keytab
   kerberos method = secrets and keytab

   # IDMAP – mapeamento de IDs de domínio
   idmap config * : backend = tdb
   idmap config * : range = 3000-7999
   idmap config OFFICINAS : backend = rid
   idmap config OFFICINAS : range = 10000-999999

   # Winbind – integração de usuários/grupos
   winbind use default domain = yes
   winbind enum users = yes
   winbind enum groups = yes
   template shell = /bin/bash
   template homedir = /home/%D/%U

   # Acesso geral e logs
   map to guest = Bad User
   dns proxy = no
   server role = member server
   log file = /var/log/samba/%m.log
   max log size = 1000

# Compartilhamentos

[diretoria]
   comment = Diretoria
   path = /srv/samba/arquivos/diretoria
   browseable = yes
   writable = yes
   guest ok = no
   valid users = @"OFFICINAS\gdiretoria"
   write list = @"OFFICINAS\gdiretoria"
   create mask = 0660
   directory mask = 2770

[financeiro]
   comment = Financeiro
   path = /srv/samba/arquivos/financeiro
   browseable = no
   writable = yes
   guest ok = no
   valid users = @"OFFICINAS\gfinanceiro"
   write list = @"OFFICINAS\gfinanceiro"
   create mask = 0660
   directory mask = 2770

[publica]
   comment = Pasta Pública
   path = /srv/samba/arquivos/publica
   browseable = yes
   writable = yes
   guest ok = yes
   force group = "OFFICINAS\Domain Users"
   create mask = 0664
   directory mask = 2775
```

## 🧱 7. Criar diretórios e permissões

```bash
sudo mkdir -p /srv/samba/arquivos/{diretoria,financeiro,publica}
```
```bash
sudo chmod 2770 -R /srv/samba/arquivos/diretoria
sudo chmod 2770 -R /srv/samba/arquivos/financeiro
sudo chmod 2775 -R /srv/samba/arquivos/publica
```

```bash
sudo chown -R root:"OFFICINAS\gdiretoria" /srv/samba/arquivos/diretoria
sudo chown -R root:"OFFICINAS\gfinanceiro" /srv/samba/arquivos/financeiro
sudo chown -R root:"OFFICINAS\Domain Users" /srv/samba/arquivos/publica
```

## 🔗 8. Ingressando o servidor no domínio

```bash
sudo net ads join -U administrador
```

## Teste:

```bash
net ads testjoin
wbinfo -u
wbinfo -g
```

## Se retornar listas de usuários e grupos do domínio → integração OK ✅

## 🔄 9. Ativar e reiniciar os serviços

```bash
sudo systemctl enable smbd nmbd winbind
sudo systemctl restart smbd nmbd winbind
```

## Verificar status:

```bash
sudo systemctl status winbind
```

## 🧩 10. Validar o arquivo de configuração

```bash
testparm
```

## 🧱 11. Acessar os compartilhamentos de rede

## 🪟 No Windows:

```bash
\\SRVARQUIVOS\diretoria
\\SRVARQUIVOS\financeiro
\\SRVARQUIVOS\publica
```

## 🐧 No Linux:

```bash
smb://srvarquivos.officinas.edu/
```

## 📖 Dicas e notas

* security = ADS → necessário quando o servidor é membro de domínio AD (Samba4 ou Windows).

* winbind → mapeia usuários e grupos do AD para o sistema Linux.

* kinit e net ads join → testam e integram o Kerberos.

* Os grupos gdiretoria, gfinanceiro devem existir no domínio (criados no SRVDC01 Samba4).


## ✅ Conclusão

Este servidor agora:

* Autentica usuários diretamente no Controlador de Domínio Samba4 (192.168.70.253);

* Gerencia permissões por grupos de domínio;

* Oferece compartilhamentos com controle centralizado pelo AD.


THAT'S ALL FOLKS


