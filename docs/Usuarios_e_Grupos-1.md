# 📁 Gerenciamento de Usuários e Grupos no Linux - Primeira parte.

#### Este tutorial abrange os comandos essenciais para a criação, modificação e exclusão de usuários e grupos, além de como gerenciar suas permissões no sistema Linux.


1 - Entendendo Usuários e Grupos

#### No Linux, usuários são as entidades que interagem com o sistema, enquanto grupos são coleções de usuários. Eles são usados para organizar usuários e aplicar permissões de forma eficiente.

* Usuário Root: O superusuário com controle total sobre o sistema. Use-o com extrema cautela.

* Usuários Regulares: Usuários com privilégios limitados.

* Usuários do Sistema: Usuários com privilégios específicos de serviços/aplicativos.

* Grupos Primários: O grupo padrão ao qual um usuário pertence no momento da criação.

* Grupos Suplementares: Grupos adicionais aos quais um usuário pode pertencer.


2 - Gerenciando Usuários

#### Criando um Novo Usuário, use o comando useradd.

```Bash
sudo useradd [opções] <nome_do_usuario>
```

#### Opções Comuns:

* -m Cria o diretório home do usuário se ele não existir. (Altamente recomendado)

* -s <shell>: Especifica o shell de login do usuário (ex: /bin/bash, /bin/zsh).

* -g <grupo_primario>: Define o grupo primário do usuário.

* -G <grupo1,grupo2,...>: Adiciona o usuário a grupos suplementares.

* -c "<comentario>": Adiciona um comentário sobre o usuário (ex: nome completo).

#### Exemplo:

```Bash
sudo useradd -m -s /usr/bin/fish -aG www-data,sudo -c "João Silva" joaosilva
```

Atenção
Se a opção -a for omitida no comando usermod acima, o usuário é removido de todos os outros grupos não listados em grupos_adicionais (i.e. o usuário será membro apenas daqueles grupos em grupos_adicionais).

#### Isso cria o usuário joaosilva com um diretório home, bash como shell padrão, e o adiciona aos grupos www-data e sudo.


3 - Definindo a Senha de um Usuário

#### Após criar um usuário, ele está logando sem senha, você precisa definir uma senha para ele usando o comando passwd.

```Bash
sudo passwd <nome_do_usuario>
```

#### O sistema irá pedir para você digitar a nova senha duas vezes.

#### Exemplo:

```Bash
sudo passwd joaosilva
```

4 - Modificando um Usuário Existente

#### O comando usermod é usado para modificar as propriedades de um usuário.

```Bash
sudo usermod [opções] <nome_do_usuario>
```

#### Opções Comuns:

* -l <novo_nome>: Altera o nome de usuário (o diretório home e o grupo primário não são alterados automaticamente).

* -d <novo_diretorio_home>: Altera o diretório home do usuário.

* -m: Move o conteúdo do diretório home antigo para o novo (usado com -d).

* -s <novo_shell>: Altera o shell de login.

* -g <novo_grupo_primario>: Altera o grupo primário.

* -G <grupo1,grupo2,...>: Adiciona o usuário a grupos suplementares (sobrescreve os grupos existentes se não usar -a).

* -aG <grupo1,grupo2,...>: Adiciona o usuário a grupos suplementares sem remover os existentes. (Altamente recomendado)

* -L: Bloqueia a conta do usuário.

* -U: Desbloqueia a conta do usuário.

#### Exemplos:

#### Para adicionar joaosilva ao grupo docker sem remover outros grupos:

```Bash
sudo usermod -aG docker joaosilva
```

#### Para mudar o nome de usuário de joaosilva para jsilva:

```Bash
sudo usermod -l jsilva joaosilva
```

#### Importante: Após renomear um usuário com -l, o diretório home e o grupo primário ainda terão o nome antigo. Você precisará renomeá-los manualmente:

```Bash
sudo mv /home/joaosilva /home/jsilva
sudo groupmod -n jsilva joaosilva
sudo usermod -d /home/jsilva -m jsilva
```

#### Adiconar um usuário á um grupo específico com o comando adduser:

```bash
sudo adduser jsilva tape
```

#### Adiconar um usuário á um grupo específico com o comando gpasswd:

```bash
sudo gpasswd -a jsilva tape
```

5 - Excluindo um Usuário

#### Use o comando userdel para remover um usuário.

```Bash
sudo userdel [opções] <nome_do_usuario>
```

#### Opções Comuns:

* -r: Remove o diretório home do usuário e o mail spool. (Altamente recomendado)

#### Exemplo:

```Bash
sudo userdel -r joaosilva
```

6 - Gerenciando Grupos

#### 3.1. Criando um Novo Grupo

#### Use o comando groupadd para criar um novo grupo.

```Bash
sudo groupadd [opções] <nome_do_grupo>
```

#### Exemplo:

```Bash
sudo groupadd desenvolvedores
```

7 - Modificando um Grupo Existente

#### O comando groupmod é usado para modificar as propriedades de um grupo.

```Bash
sudo groupmod [opções] <nome_do_grupo>
```

#### Opções Comuns:

* -n <novo_nome>: Altera o nome do grupo.

#### Exemplo:

#### Para mudar o nome do grupo desenvolvedores para devs:

```Bash
   sudo groupmod -n devs desenvolvedores
```

8 - Excluindo um Grupo

#### Use o comando groupdel para remover um grupo.

```Bash
sudo groupdel <nome_do_grupo>
```

#### Exemplo:

```Bash
sudo groupdel devs
```

9 - Gerenciando Membros do Grupo

#### Adicionando Usuários a um Grupo

#### Para adicionar um usuário a um grupo existente, a maneira mais comum é usar usermod -aG.

```Bash
sudo usermod -aG <nome_do_grupo> <nome_do_usuario>
```

#### Exemplo:

```Bash
sudo usermod -aG www-data joaosilva
```

10 - Removendo Usuários de um Grupo

#### Para remover um usuário de um grupo, você pode usar gpasswd ou deluser (dependendo da distribuição).

#### Usando gpasswd (mais comum e recomendado):

```Bash
sudo gpasswd -d <nome_do_usuario> <nome_do_grupo>
```

#### Exemplo:

```Bash
sudo gpasswd -d joaosilva www-data
```

#### Usando deluser (disponível em algumas distribuições como Debian/Ubuntu):

```Bash
sudo deluser <nome_do_usuario> <nome_do_grupo>
```

#### Exemplo:

```Bash
sudo deluser joaosilva www-data
```

11 - Visualizando Informações de Usuários e Grupos

#### Listar Usuários

#### As informações dos usuários são armazenadas em /etc/passwd. Você pode visualizá-lo com cat ou less.

```Bash
cat /etc/passwd
```

#### Listar Grupos

#### As informações dos grupos são armazenadas em /etc/group.

```Bash
cat /etc/group
```

#### Visualizar Informações de um Usuário Específico

#### Use o comando id para ver o ID do usuário, grupo primário e grupos suplementares de um usuário.

```Bash
id <nome_do_usuario>
```

#### Exemplo:

```Bash
id joaosilva
```

#### 5.4. Visualizar Membros de um Grupo

```Bash
grep <nome_do_grupo> /etc/group
```

#### Exemplo:

```Bash
grep sudo /etc/group
```

#### Ou, em algumas distribuições, você pode usar members (se instalado).

```Bash
members <nome_do_grupo>
```

12 - Permissões de Arquivos e Diretórios

#### As permissões no Linux são baseadas em usuário, grupo e outros.

* r (leitura): 4

* w (escrita): 2

* x (execução): 1

#### A combinação dessas permissões é um número octal.

#### Exemplo:

* rwx (4+2+1 = 7), rw- (4+2+0 = 6), r-x (4+0+1 = 5).

#### 6.1. Alterando Permissões (chmod)

#### Use chmod para alterar as permissões de um arquivo ou diretório.

```Bash
chmod <permissões_octais> <arquivo/diretório>
```

#### Exemplo:

#### Dar ao proprietário, grupo e outros permissão total (leitura, escrita, execução) para um script:

```Bash
chmod 777 meu_script.sh
```

#### Dar ao proprietário leitura/escrita, ao grupo leitura e a outros nenhuma permissão para um arquivo:

```Bash
    chmod 640 meu_arquivo.txt
```

#### Alterando o Proprietário (chown)

#### Use chown para alterar o proprietário de um arquivo ou diretório.

```Bash
sudo chown <novo_proprietario> <arquivo/diretório>
```

#### Exemplo:

```Bash
sudo chown joaosilva meu_arquivo.txt
```

#### 6.3. Alterando o Grupo Proprietário (chgrp)

#### Use chgrp para alterar o grupo proprietário de um arquivo ou diretório.

```Bash
sudo chgrp <novo_grupo> <arquivo/diretório>
```

#### Exemplo:

```Bash
sudo chgrp devs meu_arquivo.txt
```

#### Você também pode usar chown para alterar o proprietário e o grupo simultaneamente:

```Bash
sudo chown <proprietario>:<grupo> <arquivo/diretório>
```

#### Exemplo:

```Bash
sudo chown joaosilva:devs meu_arquivo.txt
```

## Considerações Finais

* Sempre use sudo: A maioria dos comandos de gerenciamento de usuários e grupos requer privilégios de superusuário.

* Segurança: Evite dar permissões excessivas. Siga o princípio do menor privilégio.

* Documentação: Consulte as páginas man para obter informações detalhadas sobre cada comando (ex: man useradd).

* Backup: Sempre faça backup de arquivos de configuração importantes (como /etc/passwd, /etc/group, /etc/shadow) antes de fazer grandes alterações.

That's all folks
