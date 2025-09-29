# 📁 Tutorial de Permissões de Arquivos e Diretórios no Linux - Fixação ...

### PERMISSÕES TRATAM DE CRIAÇÃO/ACESSO Á ARQUIVOS/DIRETÓRIOS. SEM ELAS, O USUÁRIO NÃO PODE ACESSAR, EXCLUIR OU EXECUTAR NADA RELATIVO Á ARQUIVOS OU DIRETÓRIOS.

### OBSERVE AS PERMISSÕES DE SEUS ARQUIVOS E DIRETÓRIOS COM O COMANDO ls -l:

```
$ cd ~
```

```
$ ls -l
```

# SENDO QUE:

### DONO => QUEM CRIOU O ARQUIVO/DIRETÓRIO

### GRUPO => PERMITE QUE OUTROS USUÁRIOS TENHAM PERMISSÕES NO ARQUIVO/DIRETÓRIO

### OUTROS => USUÁRIOS QUE NÃO SÃO DONOS NEM PERTENCEM A GRUPOS COM ACESSO/PERMISSÕES

# OS TIPOS DE PERMISSÕES E SEUS SIGNIFICADOS, COM RELAÇÃO Á ARQUIVOS E TBÉM COM RELAÇÃO Á DIRETÓRIOS:

```
r => significa permissão de leitura/acesso (read);
w => significa permissão de gravação (write);
x => significa permissão de execução/acesso (execution);
- => significa permissão desabilitada.
```

```
--- => nenhuma permissão;
r-- => permissão de leitura;
r-x => leitura e execução;
rw- => leitura e gravação;
rwx => leitura, gravação e execução.
```

# OS COMANDOS chmod E chown

### A ALTERAÇÃO DE PERMISSÕES SE DÁ COM OS COMANDOS chmod E chown. SENDO QUE chmod MUDA A PERMISSÃO DE LEITURA/GRAVAÇÃO/EXECUÇÃO, EQTO O chown MODIFICA O USUÁRIO/GRUPO PROPRIETÁRIO DO ARQUIVO/DIRETÓRIO.

### ENTÃO, TEMOS PERMISSÕES POR PROPRIETÁRIO, GRUPO E OUTROS, DIVIDIDOS POR:

```
DONO  GRUPO  OUTROS
rwx   r-x    r-x
```

### O LINUX VALIDA SE O USUÁRIO É O DONO DO ARQUIVO/DIRETÓRIO, E APLICA AS PERMISSÕES DE DONO, DEPOIS ELE VALIDA SE O GRUPO PERTENCE AOS QUE TEM ACESSO AO ARQUIVO/DIRETÓRIO, E DEPOIS APLICA AS PERMISSÕES DE GRUPO, CASO NÃO SEJA DONO E NEM PERTENÇA AOS GRUPOS COM POLÍTICAS DE ACESSO, O SISTEMA VALIDA AS PERMISSÕES DO GRUPO 'OUTROS'.

# MODIFICANDO PERMISSÕES DE ARQUIVOS/DIRETÓRIOS COM O COMANDO chmod:

```
chmod [opções] [permissões] [arquivo/diretório]
```

### O LINUX ENTENDE AS LETRAS INICIAIS u, g E o, como usuario, grupo E outros para setar as permissões, com adição do símbolo de '+' para adicionar e do símbolo de '-' para remover permissão.

### PARA DAR PERMISSÃO DE EXECUÇÃO A UM SCRIPT, PARA O USUÁRIO LOGADO, USAMOS A COMBINAÇÃO:

```
$ chmod +x /home/snarl/aplicativo.sh
$ ls -l
```

### JÁ PARA UMA PERMISSÃO DE ESCRITA PARA GRUPO E OUTROS, FICARIA

```
$ chmod go+w /home/snarl/aplicativo.sh
```

### PARA REMOVER A PERMISSÃO DE ESCRITA PARA GRUPO E LEITURA PARA 'OUTROS', FICARIA:

```
$ chmod o-w, o-r /home/snarl/aplicativo.sh
$ ls -l
```

# OUTRO MODO DE MODIFICAR PERMISSÕES, É USANDO UMA COMBINAÇÃO EM OCTAL, ONDE UM CONJUNTO DE 8 NÚMEROS DEFINE AS PERMISSÕES DE ACESSO

```
Valor Octal    |      Valor Binário

rwx     Caracteres    Significado
0     000     −−−     nenhuma permissão de acesso
1     001     −−x     permissão de execução
2     010     -w-     permissão de gravação
3     011     -wx     permissão de gravação e execução
4     100     r−−     permissão de leitura
5     101     r-x     permissão de leitura e execução
6     110     rw-     permissão de leitura e gravação
7     111     rwx     permissão de leitura, gravação e execução
```

### OU SEJA, PARA REMOVER TODAS AS PERMISSÕES, USAMOS:

```
$ chmod 000 /home/snarl/aplicativo.sh
$ ls -l
```

### ENTÃO SE TEMOS X=1, W=2 E R=4, PODEMOS CRIAR COMBINAÇÕES DE OCTAIS PARA DEFINIR ACESSOS.

### POR EXEMPLO, SE FOSSEMOS DAR PERMISSÃO DE RWX PARA O DONO E DE RX PARA OS GRUPOS E OUTROS, FARÍAMOS AS SEGUINTES COMBINAÇÕES:

```
$ chmod 755 /home/snarl/aplicativo.sh
```

### POIS ACESSO TOTAL CORRESPONDE Á rwx=7 E ACESSO SOMENTE LEITURA E EXECUÇÃO CORRESPONDE Á rx=5

# MODIFICANDO PROPRIETÁRIO DE ARQUIVOS/DIRETÓRIOS COM O COMANDO chown

### O COMANDO chown SERVE PARA MUDAR O 'USUÁRIO DONO' OU O 'GRUPO DONO', DE UM DETERMINADO ARQUIVO/DIRETÓRIO:

```
chown [opçoes] [dono:grupo] [diretório/arquivo]
```

```
$ chown -R snarl:users /home/snarl/aplicativo.sh
```

### Sendo que o -R valida o comando recursivamente, em caso de aplicado á diretórios.
