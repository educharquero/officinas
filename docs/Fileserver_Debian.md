# 📁 FileServer no Debian com binários

## Tutorial de Configuração do Samba4 como FileServer no Debian 13

## Este guia mostra como instalar e configurar o Samba4 em um servidor Debian 13, criando compartilhamentos de rede com permissões de usuários.

## 0 -  Atualizar o Sistema

```bash
    sudo apt update && sudo apt full-upgrade
```

## 1 -  Instalar o Samba

```bash
    sudo apt install samba -y
```

## 2 - Adicione ao sistema os usuários que terão acesso aos diretórios DE REDE (sem shell e sem home):

```bash
    sudo useradd -s /bin/false -M kalel
    sudo useradd -s /bin/false -M diana
```
Para liberar um shell em caso de necessidade:
"sudo usermod -s /bin/bash kalel" OU editar o "/etc/passwd"

## 3 - Criar os grupos do sistema aos quais setaremos permissão de acesso aos diretórios:

```bash
    sudo groupadd gdiretoria
```
```bash
    sudo groupadd gfinanceiro
```

Adicione os usuários aos grupos ao qual terão acesso:

```bash
    sudo usermod -aG gdiretoria kalel
```
```bash
    sudo usermod -aG gfinanceiro diana
```

Adicione os usuários ao banco de senhas do Samba:

```bash
    sudo smbpasswd -a kalel
    sudo smbpasswd -a diana
```

## 4 -  Criar os diretórios para os compartilhamentos de rede:

```bash
    sudo mkdir -p /srv/samba/arquivos/diretoria
```
```bash
    sudo mkdir -p /srv/samba/arquivos/financeiro
```
```bash
    sudo mkdir -p /srv/samba/arquivos/publica
```

## 5 -  Definir as permissões das pastas:

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

## 6 - Antes de editar, faça backup do arquivo principal do Samba:

```bash
    sudo mv /etc/samba/smb.conf{,.orig}
```

## 7 - Crie o arquivo de configuração do Samba:

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

## 8 - Ativar e reiniciar os serviços do Samba

```bash
    sudo systemctl enable smbd
    sudo systemctl restart smbd
```

## 9 - Testar configuração, verificando se não há erros:

```bash
    testparm
```

## 10 - Acessar os compartilhamentos

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

Esses parâmetros, no Samba, controlam as permissões de arquivos e pastas DE REDE, recém-criados dentro do compartilhamento, independentemente das permissões LOCAIS do Linux já existentes.

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


THAT'S ALL FOLKS
