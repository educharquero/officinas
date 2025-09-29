# 📁 Gerenciamento de Usuários e Grupos no Linux - Segunda parte.


## Como devemos proceder para adicionar um usuário a um grupo no sistema operacional Linux? 

Tornar um usuário membro de um grupo é uma tarefa simples, que pode ser realizada com o uso dos comandos useradd, adduser, gpasswd ou usermod no terminal.

Os comandos useradd e adduser (que é um script na verdade) permitem criar um novo usuário no sistema, e além disso também permitem adicionar um usuário já existente a um grupo determinado. Já o comando usermod permite modificar a conta de um usuário, e isso inclui torná-lo membro de grupos existentes no sistema. Também vamos mostrar o comando gpasswd, que entre outras coisas permite gerenciar os grupos do sistema.

## Grupos primários e grupos secundários:

* Grupo Primário – É o grupo criado juntamente com o usuário. Normalmente é igual ao seu nome de login.

* Grupos Secundários – Os usuários também podem ser membros de outros grupos no sistema Linux. São muito úteis para realizar compartilhamento de arquivos, diretórios, dar permissões e outros elementos.

As informações sobre os grupos do sistema e usuários membros ficam armazenadas no arquivo /etc/group, o qual possui um lista dos grupos e seus respectivos membros.

## Exemplos de comandos para adicionar um usuário a um grupo:

1. Vamos adicionar o usuário monica ao grupo marketing:

```bash
adduser monica marketing
```

2. Também podemos adicionar um usuário a um grupo usando o comando gpasswd:

```bash
gpasswd -a usuário grupo
```

Por exemplo, adicionando monica ao grupo rh:

```bash
gpasswd -a monica rh
```

3. Podemos definir um novo grupo primário para o usuário com o comando usermod seguido da opção -g. Por exemplo, vamos trocar o grupo primário da monica (que é “monica”) para grupo engenheiros:

```bash
usermod -g engenheiros monica
```

4. Ainda com o comando usermod, podemos tornar o usuário membro de vários grupos secundários (suplementares) especificados ao mesmo tempo. Vamos alterar a lista de grupos secundários e tornar a usuária monica membro dos grupos planilhas e memorandos:

```bash
usermod -G planilhas,memorandos monica
```

5. Note que no exemplo anterior o nosso usuário foi adicionado aos grupos planilhas e memorandos, porém foi retirado dos outros grupos secundários dos quais era membro,como o grupo rh.

Para que o usuário continue sendo membro dos grupos e seja acrescentado a novos grupos, sem deixar de ser membro dos anteriores, acrescente a opção -a ao comando anterior:

```bash
usermod -aG planilhas,memorandos monica
```     

## Verificando

Verifique se o usuário foi adicionado a um grupo usando o comando groups seguido do nome do usuário:

```bash
groups monica
```

Os grupos dos quais o usuário é membro aparecem listados em sequência, sendo que o primeiro grupo é o grupo primário do usuário e os demais são os grupos secundários.

## Removendo usuários de um grupo no Linux

E se quisermos remover um usuário de um grupo? Podemos para isso usar o comando deluser, com a sintaxe a seguir:

```bash
deluser usuário grupo
```

Por exemplo, vamos excluir a monica do grupo de memorandos:

```bash
deluser monica memorandos
```

Tome cuidado para não esquecer de incluir o nome do grupo ao executar esse comando,pois você pode acabar excluindo a conta do usuário do sistema em vez de apenas retirá-lo de um grupo!

Uma forma mais segura de excluir um usuário de um grupo é por meio do comando gpasswd, como segue a sintaxe:

```bash
gpasswd -d usuário grupo
```

## Remover o usuário monica do grupo planilhas:

```bash
gpasswd -d monica planilhas
```
     
