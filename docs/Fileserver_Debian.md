# 📁 FileServer no Debian com pacotes binários

## Este guia mostra como instalar e configurar o Samba4 em um servidor Debian 13, criando compartilhamentos de rede com permissões de usuários.

## Primeiramente vamos ajustar as configurações padrão de rede no Servidor.

- Ip fixo do Servidor = 192.168.70.250
- Roteador local      = 192.168.70.1
- Gateway             = o roteador
- DNS                 = o roteador

## 1 - Setando ip fixo na placa de rede:

```
vim /etc/network/interfaces
```

```
allow-hotplug en7s0
iface enp7s0 inet static
address 192.168.70.250
netmask 255.255.255.0
gateway 192.168.70.1
```

## 2 - Setando as Configurações de DNS:

```
vim /etc/resolv.conf
```

```
nameserver 192.168.70.1
```

## 3 - Setando as Configurações de hosts:

```
hostnamectl set-hostname smb01
```

```
vim /etc/hosts
```

```
127.0.0.1 localhost 
127.0.1.1 smb01.esharknet.edu smb01
192.168.70.250 smb01.esharknet.edu smb01
```

## 4 - Sincronizando, atualizando os pacotes e o Sistema operacional:

```
sudo apt update && sudo apt full-upgrade
```

## 5 -  Instalando o pacote do SAMBA4:

```bash
    sudo apt install samba -y
```

## 6 - Adicionando ao sistema os usuários que terão acesso aos diretórios DE REDE (sem shell e sem home):

```bash
    sudo useradd -s /bin/false -M kalel
    sudo useradd -s /bin/false -M diana
```
Para liberar um shell em caso de necessidade:
"sudo usermod -s /bin/bash kalel" OU editar o "/etc/passwd"

## 7 - Criando os grupos do sistema aos quais setaremos permissão de acesso aos diretórios:

```bash
    sudo groupadd gdiretoria
```
```bash
    sudo groupadd gfinanceiro
```

Adicionando os usuários aos grupos ao qual terão acesso:

```bash
    sudo usermod -aG gdiretoria kalel
```
```bash
    sudo usermod -aG gfinanceiro diana
```

Adicionando os usuários ao banco de senhas do Samba:

```bash
    sudo smbpasswd -a kalel
    sudo smbpasswd -a diana
```

## 8 - Criando os diretórios para os compartilhamentos de rede:

```bash
    sudo mkdir -p /srv/samba/arquivos/diretoria
```
```bash
    sudo mkdir -p /srv/samba/arquivos/financeiro
```
```bash
    sudo mkdir -p /srv/samba/arquivos/publica
```

## 9 - Definindo as permissões das pastas:

A flag 2 → setgid: faz com que novos arquivos/subdiretórios criados dentro, herdem as permissões do grupo á que pertença o diretório principal.

```bash
    sudo chmod 2770 -R /srv/samba/arquivos/diretoria
```
```bash
    sudo chmod 2770 -R /srv/samba/arquivos/financeiro
```
```bash
    sudo chmod 2775 -R /srv/samba/arquivos/publica
```
    
```bash
    sudo chown -R root:gdiretoria /srv/samba/arquivos/diretoria
```

```bash
   sudo chown -R root:gfinanceiro /srv/samba/arquivos/financeiro
```

```bash
sudo chown -R nobody:nogroup /srv/samba/arquivos/publica
```

## 10 - Antes de editar, faça backup do arquivo principal do SAMBA4:

```bash
    sudo mv /etc/samba/smb.conf{,.orig}
```

## 11 - Criando o arquivo de configuração do SAMBA4:

```bash
    sudo vim /etc/samba/smb.conf
```

Insira o seguinte conteúdo:

```bash
[global]
   workgroup = ESHARKNET
   netbios name = Fileserver
   server string = Servidor de Arquivos
   security = user
   map to guest = bad user
   dns proxy = no

[diretoria]
   comment = Diretório diretoria
   path = /srv/samba/arquivos/diretoria
   browseable = yes
   writable = yes
   guest ok = no
   valid users = @gdiretoria
   write list = @gdiretoria
   create mask = 0660
   directory mask = 2770

[financeiro]
   comment = Diretório financeiro
   path = /srv/samba/arquivos/financeiro
   browseable = no
   writable = yes
   guest ok = no
   valid users = @gfinanceiro
   write list = @gfinanceiro
   create mask = 0660
   directory mask = 2770

[publica]
   comment = Pasta Publica
   path = /srv/samba/arquivos/publica
   browseable = yes
   writable = yes
   guest ok = yes
   create mask = 0664
   directory mask = 2775
```

## 12 - Ativando e reiniciando os serviços do SAMBA4:

```bash
    sudo systemctl enable smbd
    sudo systemctl restart smbd
```

## 13 - Validando se não há erros no smb.conf:

```bash
    testparm
```

## 14 - Acessando os compartilhamentos de rede:

Agora, de outra máquina na mesma rede, você pode acessar:

* No Explorer do Windows:
```bash
    \\IP_DO_SERVIDOR\diretoria
    \\IP_DO_SERVIDOR\financeiro
    \\IP_DO_SERVIDOR\Publico
```
    
* Na barra do gerenciador de arquivos do Linux: 
```bash 
    smb://IP_DO_SERVIDOR
```

Lembre-se de ajustar as configurações de firewall se necessário para permitir o tráfego SMB na sua rede.

--------------------------------------------------------------------------------------------------------------

## SESSÃO DE ANOTAÇÕES:

## Diferença entre VALID USERS e WRITE LIST (quem acessa x quem modifica)

```bash
     valid users
```

- Define quem pode acessar o compartilhamento.

- Se alguém que não está nessa lista tentar montar o compartilhamento, vai levar acesso negado.

Você pode usar:

- Usuários individuais: valid users = kalel diana

- Grupos: valid users = @projetox

```bash
     write list
```

- Define quem pode escrever (alterar, criar, excluir arquivos).

- Se não estiver no write list, o usuário só terá permissão de leitura, mesmo que consiga acessar.

Exemplo:

- write list = @projetox → só membros do grupo podem escrever.

- valid users = @todos → todos acessam, mas só o grupo projetox pode gravar.


-----------------------------------------------------------------------------


## As flags de SETUID, SETGID e STICKY BIT:

Esses parâmetros, no SAMBA4, controlam as permissões de arquivos e pastas DE REDE, recém-criados dentro do compartilhamento, independentemente das permissões LOCAIS do Linux já existentes.

Significado dos valores

DIRETÓRIOS:

```bash
* directory mask = 0775
```

Afeta DIRETÓRIOS novos.

0775 em octal:

0 → bits especiais (setuid/setgid/sticky) desligados

7 → dono: leitura (r), escrita (w), execução (x)

7 → grupo: leitura (r), escrita (w), execução (x)

5 → outros: leitura (r), escrita (x), execução (-)


ARQUIVOS:

```bash
* create mask = 0664
```

Afeta ARQUIVOS novos (arquivos nunca precisam de "execução").

0664 em octal:

0 → bits especiais (setuid/setgid/sticky) desligados

6 → dono: leitura (r), escrita (w), execução (-)

6 → grupo: leitura (r), escrita (w), execução (-)

4 → outros: leitura (r), escrita, (-) execução (-)


## Referências

[1] [Debian Releases](https://www.debian.org/releases/)
[2] [Securing Samba on debian 10 - smb](https://unix.stackexchange.com/questions/678416/securing-samba-on-debian-10)
[3] [Samba Server Security](https://www.samba.org/samba/docs/server_security.html)
[4] [Debian Samba Setup: Complete Configuration Guide for Beginners](https://serverspace.io/support/help/configuring-samba-on-debian/)
[5] [smb.conf - SambaWiki](https://wiki.samba.org/index.php/Samba_Configuration_File)


THAT'S ALL FOLKS
