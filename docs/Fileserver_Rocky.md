# 📁 FileServer Rocky

#  Servidor de Arquivos do AD no Rocky Linux 9


Após a instalação do sistema operacional, seguir com os comandos para a instalação e configuração do samba como membro e servidor de arquivos. 


Atualizar o sistema:
```
yum update -y && yum upgrade -y
```
Instalar os pacotes do samba necessários para samba e servidor de arquivos:
```
yum install samba samba-winbind samba-winbind-clients
```
Habilitar os serviços para iniciar junto ao boot do sistema:
```
systemctl enable smb nmb winbind
```
 Configurar e editar o arquivo **/etc/hosts**:
```
nano /etc/hosts
```
```
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
10.1.1.13   arquivos.esharknet.edu arquivos
::1 localhost localhost.localdomain localhost6 localhost6.localdomain6
```
**Salvar o arquivo**


Configurar e editar **/etc/hostname:**
```
nano /etc/hostname
```
```
arquivos.esharknet.edu
```
**Salvar o Arquivo**


Configurar e editar **/etc/nsswitch.conf**:
```
nano /etc/nsswitch.conf
```

**Mudar a configuração**

De:
```
passwd: sss files systemd
```

#### Para:
```
passwd: files winbind
```

De:
```
group: sss files systemd
```

#### Para:
```
group: files winbind
```
**Salve o arquivo** 


#### Configurar a rede e inserir dados do DNS do AD-DC ou seja, do seu controlador de domínio:
```
nmtui
```

Escolha **Editar uma Conexão**

Digite **Enter**

Com a tela **Tab** vá em **Editar**

Com as **teclas de direção (setas)** mova-se até **Servidores DNS** e troque o **IP para o IP de seu AD DC** (controlador de domínio)

Ainda com as setas de direção, vá até **Domínios de pesquisa** e digite enter para adicionar o **seu.domínio**.
Então, selecione OK **com as setas de direção e digite enter**. 

Com a **tecla Tab**, vá até a opção: **voltar** e digite **enter**. Então, com a tecla **Tab**, selecione a **opção OK** e digite **enter**

Reiniciar o sistema:
```
reboot
```

Editar o arquivo **user.map** no diretório **/etc/samba** com o conteúdo:
```
nano /etc/samba/user.map
```
```
!root = DOMINIO\Administrator
```
**Salve o arquivo**


Fazer um backup do arquivo **/etc/samba/smb.conf**:
```
mv /etc/samba/smb.conf /etc/samba/smb.conf.bkp
```
Fazer um arquivo **smb.conf** para funcionar como membro e servidor de arquivo de modelo (**rid**)
```
nano /etc/samba/smb.conf
```

```
[global]
	bind interfaces only = Yes
	dedicated keytab file = /etc/krb5.keytab
	kerberos method = secrets and keytab
	log file = /var/log/samba/%m.log
	min domain uid = 0
	realm = ESHARKNET.EDU
	security = ADS
	template homedir = /home/%U
	template shell = /bin/bash
	winbind refresh tickets = Yes
	winbind use default domain = Yes
	workgroup = ESHARKNET
	idmap config dominio : range = 10000-999999
	idmap config dominio : backend = rid
	idmap config * : range = 3000-7999
	idmap config * : backend = tdb
	map acl inherit = Yes
	vfs objects = acl_xattr
```

Fazer uma cópia do arquivo **/etc/krb5.conf**

```
mv /etc/krb5.conf /etc/krb5.conf.bkp
```

Editar um novo arquivo krb5.conf

```
nano /etc/krb5.conf
```

```
[libdefaults]
    dns_lookup_realm = false
    dns_lookup_kdc = true
    default_realm = ESHARKNET.EDU
```

**Salvar o arquivo**

Verificar se existe algum erro de sintaxe com o comando:

```
testparm
```

Se não houver erros, executar o comando para recarregar o samba novamente
```
smbcontrol all reload-config
```
Desabilitar o **SELinux:**
```
nano /etc/selinux/config
```
Na linha SELINUX=enforcing trocar para **SELINUX=disabled**

**Salvar o arquivo**

Ajustar o Firewall. Adicionar o serviço do samba e recarregar o Firewall: 
```
firewall-cmd --add-service=samba --permanent
firewall-cmd --reload
```

**Reiniciar o servidor**:
```
reboot
```

Comando para juntar-se ao Domínio Criado:
```
net ads join -U administrator  
Enter administrator's password: senha do provisionamento
```
```
Using short domain name -- ESHARKNET
Joined 'ARQUIVOS' to dns domain 'esharknet.edu'
```

#### Verificar conexão NETLOGON com o AD:

```
wbinfo --ping-dc
```

Como resultado deve aparecer:

```
checking the NETLOGON for domain[ESHARKNET] dc connection to "dcmaster.esharknet.edu" succeeded
```

#### Verificar se o Servidor DC1 (seu controlador de dominio) volta resposta com o comando: nslookup SEU.DOMINIO:

```
nslookup dcmaster.esharknet.edu
```
Um resultado parecido com esse deve aparecer na tela:

```
Server:		192.168.70.250
Address:	192.168.70.250#53

Name:	dcmaster.esharknet.edu
Address: 192.168.70.250
```

#### E também através IP do seu Servidor DCMaster:
```
nslookup 192.168.70.250
```

```
Authoritative answers can be found from:
168.192.IN-ADDR.ARPA
	origin = 168.192.IN-ADDR.ARPA
	mail addr = .
	serial = 0
	refresh = 28800
	retry = 7200
	expire = 604800
	minimum = 86400
```

Antes de prosseguir, conectar seu **DCMaster** e criar um grupo e um usuário. NO DCMASTER faça o comando pra criar o grupo:
```
samba-tool group add 'Linux Domain'
```
E também adicione um usuário:
```
samba-tool user add 'esharkuser'
```

#### Verificar se retorna o GID do Grupo:
```
getent group "ESHARKNET\\Linux Domain"
linux domain:x:3013:
```

#### Garantir privilégio de acesso com o Comando:
```
net rpc rights grant "ESHARKNET\Domain Admins" SeDiskOperatorPrivilege -U "ESHARKNET\Administrator"
Enter ESHARK\Administrator password: senha CRIADA no provisionamento do DCMaster
# Caso tenha criado corretamente o sistema irá dar sucesso do comando

Successfully granted rights.
```
Chegando nesse ponto, está apto a iniciar a configuração da montagem de disco, o diretório escolhido para abrigar seus arquivos bem como, ajustar as permissões de acesso para que seja possível fazer as alterações via RSAT com as devidas permissões.

Exemplo:

Se criou um disco e disponibilizou o diretório **/srv/arquivos** e então, indicou esse caminho em seu **smb.conf** ou seja, após a sessão **global** indicando o nome de seu compartilhamento do servidor de arquivos, caminho, e ajustar as permissões de acesso seguindo o exemplo:

```
vim /etc/samba/smb.conf
```
```
[ARQUIVOS]
   path = /srv/arquivos/
   read only = no
   browseable = yes
```

Salve o arquivo

#### Ajustando as permissões para o Grupo no diretório criado:

```
chown root:"Domain Admins" /srv/arquivos
chmod 775 -R /srv/arquivos
```

#### Recarregar novamente o smbcontrol
```
smbcontrol all reload-config
```

Através do Windows, logue-se com a conta Administrator e através do RSAT inicie suas configurações desejadas.

![ad-win-42a](https://user-images.githubusercontent.com/38897311/232552064-cf5763de-fe67-42d2-ac32-fe2b16138afd.png)

THAT’S ALL FOLKS!!

