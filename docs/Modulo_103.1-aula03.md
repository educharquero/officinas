# 🐧 Módulo ﻿103.1 AULA 03

# COMANDO alias, which, uname e quoting

### CRIANDO UM BACKUP DE QUALQUER ARQUIVO ANTES DE EDIÇÃO!

***FAÇA BACKUP DE ARQUIVOS (SEMPRE!!)***

Exemplo:

```
$ > arquivo-teste
```

```
$ cp arquivo-teste arquivo-teste.orig
```

Ou

```
$ cp arquivo-teste{,.orig}
```

```
$ cp /home/usuario/.bashrc /home/usuario/.bashrc.orig
```

Ou

```
$ cp .bashrc{,.orig}
```

```
$ cp /etc/network/interfaces /etc/network/interfaces.orig
```

Ou

```
$ cp /etc/network/interfaces{,.orig}
```

### O CONCEITO DE _ALIAS_

O `alias` é como um apelido:

```
$ cat .bashrc
```

NOTE as linhas comentadas:

```
#alias ll
#alias la
#alias l
```

ENTÃO para que esses _aliases_ rodem, eu preciso descomentar, removendo o '#':

```
alias ll
alias la
alias l
```

E releio o arquivo:

```
$ source .bashrc
```

Ou posso seguir a orientação do próprio `.bashrc` e crio outro arquivo, o `.bash_aliases`

```
vim .bash_aliases
```

```
alias ll
alias la
alias l
```

Releio o arquivo:

```
$ source .bash_aliases
```

AGORA os comandos de aliases `ll`, `la` e `l`, vão rodar sob o `ls -l`, `ls -A` e `ls -CF`

Veja as opções que podem ser encontradas no _manual_ do `ls`:

```
$ man ls
```

O comando `alias`, apresenta na tela todos os aliases criados no `Shell`

```
$ alias
```

Para criar um alias TEMPORÁRIO, eu posso simplesmente criar do modo como eu crio uma variável

Exemplo:

```
$ alias lt='ls /tmp'
$ alias
$ lt
```

Para que esse _alias_ fique definitivo, preciso adicioná-lo ao `.bashrc` OU ao `.bash_aliases`

### O COMANDO `which`

O comando `which` varre o `PATH` em busca de _binários_ (programas) dentro desses caminhos

```
$ echo $PATH
$ which echo
```

Ele lembra o comando `whereis`

```
$ whereis echo
$ whereis ls
```

### O COMANDO `uname`

O comando `uname` mostra a versão do `Kernel`, usada pelo Sistema Operacional:

```
$ uname
```

```
$ uname -r
```

```
$ uname -ra
```

```
$ uname --help
```

### O COMANDO `quoting` (aspas duplas "", aspas simples '', e a barra invertida \)

A primeira coisa que o `Shell` faz, é interpretar os caracteres especias e depois executar os comandos associados a eles. 

Os comandos de `quoting`, servem pra proteger os _CARACTERES ESPECIAS_, contra a interpretação do `Shell`, imprimindo não seu valor associado, mas ele próprio.

Exemplo:

```
$ echo *
```

!=

```
$ echo \*
```

A barra invertida, ou barra de escape, `\`, protege APENAS o próximo caracter, imediato a ela mesma, e não os próximos caracteres subsequentes a ela.

Exemplo:

```
$ echo \& \*
```

!=

```
$ echo & *
```

!=

```
$ echo \& \$ *
```

Outro exemplo de uso da barra invertida:

```
$ echo "Curso de Linux"
```

!=

```
$ echo Curso      de      Linux
```

!=

```
$ echo Curso\ \ \ de\ \ \ Linux
```

E qual é a diferença, entre as _ASPAS DUPLAS_ `""`, e as _ASPAS SIMPLES_ `''`?

As aspas duplas `""`, protegem TODOS os caracteres especiais, EXCETO o cifrão `$`, a cráse '`'`', e a própria barra de scape `\`.

Ou seja, um echo `$\` NÃO FUNCIONA para proteção desses _Caracteres Especiais_

Já as aspas simples `''`, protegem TODOS os caracteres especiais, INCLUSIVE estes `$`, '`'`' e `\` que as aspas duplas não protegem.

### CRIANDO UMA VARIÁVEL

```
$ CIFRAO=CARACTER
```

Ao expendir com `echo` protegendo, teremos:

```
$ echo $CIFRAO
```

!=

```
$ echo '$CIFRAO'
```

NOTE que SE eu protegesse com ASPAS DUPLAS, não seria efetivo:

```
$ echo "$CIFRAO"
```

THAT’S ALL FOLKS!!

```

```
