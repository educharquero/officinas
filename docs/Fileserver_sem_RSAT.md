# SAMBA4 - Fileserver sem gerenciamento por RSAT

## Tutorial: Configuração de Compartilhamento SMB no Linux

Este tutorial irá guiá-lo através do processo de configuração de um servidor Samba em um ambiente Linux.

 ## Instalação do Samba

Primeiro, atualize a lista de pacotes e instale o Samba:

```bash
sudo apt update
```

```bash
sudo apt install samba -y
```

## Criando Usuários e Diretórios
   
```bash
sudo adduser suporte
```

Criar diretórios para compartilhamento

```bash
sudo mkdir -p /home/samba/estoque
```

```bash
sudo mkdir -p /home/samba/gestao
```

```bash
sudo mkdir -p /home/samba/publico
```

Ajustar permissões dos diretórios

```bash
sudo chmod -R 770 /home/samba/estoque
```

```bash
sudo chmod -R 770 /home/samba/gestao
```

```bash
sudo chmod -R 777 /home/samba/publico
```

```bash
sudo chown -R root:users /home/samba/estoque
```

```bash
sudo chown -R root:users /home/samba/gestao
```

```bash
sudo chown -R nobody:nogroup /home/samba/publico
```

## Configurando o Samba
  
Fazer backup do arquivo de configuração original
   
```bash
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
```

Editar o arquivo de configuração

```bash
sudo nano /etc/samba/smb.conf
```

Adicione as seguintes configurações ao final do arquivo:

```bash
[global]
   workgroup = WORKGROUP
   server string = Servidor Samba
   security = user
   map to guest = bad user
   dns proxy = no

[Estoque]
   comment = Diretório de Estoque
   path = /home/samba/estoque
   browsable = yes
   writable = yes
   valid users = @users
   create mask = 0770
   directory mask = 0770

[Gestao]
   comment = Diretório de Gestão
   path = /home/samba/gestao
   browsable = yes
   writable = yes
   valid users = @users
   create mask = 0770
   directory mask = 0770

[Publico]
   comment = Diretório Público
   path = /home/samba/publico
   browsable = yes
   writable = yes
   guest ok = yes
   create mask = 0777
   directory mask = 0777
```

## Adicionando Usuários ao Samba

Adicione o usuário criado anteriormente ao Samba:

```bash
sudo smbpasswd -a suporte
```

Você será solicitado a definir uma senha para o acesso Samba.

## Reiniciando e Testando o Serviço
   
```bash
sudo systemctl restart smbd
```
   
```bash
sudo systemctl restart nmbd
```

```bash
sudo systemctl status smbd
```

Testar a configuração

```bash
testparm
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

## Acessando os Compartilhamentos

Agora você pode acessar os compartilhamentos de outros computadores na rede:

* No Windows: Abra o Explorer e digite \\IP_DO_SERVIDOR na barra de endereços
* No Linux: Abra o gerenciador de arquivos e digite smb://IP_DO_SERVIDOR na barra de endereços

(Substitua IP_DO_SERVIDOR pelo endereço IP do seu servidor Linux.)

Conclusão

Você configurou com sucesso um servidor Samba com três compartilhamentos diferentes:

* Estoque: Acessível apenas para usuários autenticados
* Gestao: Acessível apenas para usuários autenticados
* Publico: Acessível para qualquer usuário, incluindo convidados

Lembre-se de ajustar as configurações de firewall se necessário para permitir o tráfego SMB na sua rede.

Thats All Folk's
