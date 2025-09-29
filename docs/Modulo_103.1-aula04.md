# 🐧 Módulo 103.1 AULA 04

# OS COMANDOS `cat`, `head`, `tail`, `sort`, `less` e `wc` NO LINUX

Os comandos `cat`, `head`, `tail`, `sort`, `less` e `wc` são ferramentas essenciais para manipulação e visualização de arquivos de texto no Linux. Cada um desses comandos tem suas próprias funcionalidades e casos de uso específicos. Vamos explorar cada um desses comandos em detalhes.

### O COMANDO `cat`

O comando `cat` é usado para concatenar e exibir o conteúdo de arquivos.

Sintaxe:

```
cat [opções] [arquivo]
```

Opções Comuns:

    -n: Numera todas as linhas de saída.
    -b: Numera apenas as linhas não vazias.
    -s: Suprime linhas em branco repetidas.

Exemplos, exibir o conteúdo de um arquivo:

```
cat arquivo.txt
```

Concatenar e exibir o conteúdo de múltiplos arquivos:

```
cat arquivo1.txt arquivo2.txt
```

Numerar todas as linhas de um arquivo:

```
cat -n arquivo.txt
```

### O COMANDO `head`

O comando `head` é usado para exibir as primeiras linhas de um arquivo.

Sintaxe:

```
head [opções] [arquivo]
```

Opções Comuns:

    -n: Especifica o número de linhas a serem exibidas.

Exemplos: exibir as primeiras 10 linhas de um arquivo:

    head arquivo.txt

Exibir as primeiras 5 linhas de um arquivo:

    head -n 5 arquivo.txt

### O COMANDO `tail`

O comando `tail` é usado para exibir as últimas linhas de um arquivo.

Sintaxe:

    tail [opções] [arquivo]

Opções Comuns:

    -n: Especifica o número de linhas a serem exibidas.
    -f: Exibe as novas linhas adicionadas ao arquivo em tempo real.

Exemplos: Exibir as últimas 10 linhas de um arquivo:

    tail arquivo.txt

Exibir as últimas 5 linhas de um arquivo:

    tail -n 5 arquivo.txt

Monitorar um arquivo em tempo real:

    tail -f arquivo.txt

### O COMANDO `sort`

O comando `sort` é usado para ordenar linhas de arquivos de texto.

Sintaxe:

    sort [opções] [arquivo]

Opções Comuns:

    -r: Ordena em ordem inversa.
    -n: Ordena numericamente.
    -u: Remove linhas duplicadas.

Exemplos, ordenar as linhas de um arquivo:

    sort arquivo.txt

Ordenar numericamente:

    sort -n arquivo.txt

Ordenar em ordem inversa:

    sort -r arquivo.txt

### O COMANDO `less`

O comando `less` é usado para visualizar o conteúdo de arquivos de texto de forma paginada.

Sintaxe:

    less [opções] [arquivo]

Opções Comuns:

    -N: Exibe números de linha.
    -S: Desabilita o wrap de linhas longas.

Exemplos:

Visualizar o conteúdo de um arquivo:

    less arquivo.txt

Visualizar o conteúdo de um arquivo com números de linha:

    less -N arquivo.txt

### O COMANDO `wc`

O comando `wc` é usado para contar linhas, palavras e caracteres em arquivos.

Sintaxe:

    wc [opções] [arquivo]

Opções Comuns:

    -l: Conta o número de linhas.
    -w: Conta o número de palavras.
    -c: Conta o número de bytes.
    -m: Conta o número de caracteres.

Exemplos: Contar o número de linhas, palavras e bytes em um arquivo:

    wc arquivo.txt

Contar apenas o número de linhas:

    wc -l arquivo.txt

Contar apenas o número de palavras:

    wc -w arquivo.txt

### CONCLUSÃO

Os comandos `cat`, `head`, `tail`, `sort`, `less` e `wc` são ferramentas poderosas para manipulação e visualização de arquivos de texto no Linux. 

Eles permitem que você realize uma ampla variedade de operações de edição e visualização de texto de maneira eficiente. 

Praticar com esses comandos ajudará você a se tornar mais eficiente em manipulação de texto no terminal.


THAT’S ALL FOLKS!!
