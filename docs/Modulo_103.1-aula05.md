# 🐧 Módulo 103.1 AULA 05

### COMANDOS `tr`, `cut` E `sed` NO LINUX

Os comandos `tr`, `cut` e `sed` são ferramentas poderosas para manipulação de texto no Linux. 

Cada um deles tem suas próprias funcionalidades e casos de uso específicos. 

Vamos explorar cada um desses comandos em detalhes.

### O COMANDO `tr`

O comando `tr` é usado para traduzir ou deletar caracteres. Ele lê a entrada padrão e escreve a saída padrão.

Sintaxe:

    tr [opções] conjunto1 [conjunto2]

Opções Comuns:

    • -d: Deleta caracteres. 
    • -s: Substitui sequências de um caractere repetido por um único caractere. 

Exemplos: Converter letras minúsculas para maiúsculas:

    echo "hello world" | tr 'a-z' 'A-Z'

Saída:

    HELLO WORLD

Deletar todos os dígitos:

    echo "123abc456def" | tr -d '0-9'

Saída:

    abcdef

### O COMANDO `cut`

O comando `cut` é usado para extrair seções de cada linha de arquivos.

Sintaxe:

    cut [opções] [arquivo]

Opções Comuns:

    • -d: Especifica o delimitador. 
    • -f: Seleciona campos específicos. 
    • -c: Seleciona caracteres específicos. 

Exemplos: Extrair o primeiro campo de um arquivo delimitado por vírgulas:

    echo "nome,idade,cidade" | cut -d',' -f1

Saída:

     nome

Extrair os caracteres da 2ª à 5ª posição:

    echo "Hello World" | cut -c2-5

Saída:

    ello

### O COMANDO `sed`

O comando `sed` é um editor de fluxo de texto que pode realizar operações básicas de edição de texto em um arquivo ou entrada.

Sintaxe:

    sed [opções] 'comando' [arquivo]

Opções Comuns:

    • -i: Edita o arquivo no local. 
    • -e: Adiciona um comando de script. 

Exemplos: Substituir todas as ocorrências de "foo" por "bar":

    echo "foo foo foo" | sed 's/foo/bar/g'

Saída:

    • bar bar bar

Deletar linhas que contêm a palavra "error":

    echo -e "line1\nerror line\nline3" | sed '/error/d'

Saída:

    line1
    line3

Posso converter um texto inteiro, e gerar um outro txt:

    cat "Aula01.txt" | tr 'A-Z' 'a-z' > 22.txt



### EXERCÍCIOS

Exercício 1: 

Uso do `tr`

    1. Converta todas as letras maiúsculas para minúsculas na string "Hello World". 
    2. Remova todos os espaços em branco da string "Hello World". 

Exercício 2: Uso do `cut`

    1. Extraia o segundo campo de um arquivo CSV com o conteúdo "nome,idade,cidade". 
    2. Extraia os caracteres da 3ª à 6ª posição da string "Hello World". 

Exercício 3: Uso do `sed`

    1. Substitua todas as ocorrências de "apple" por "orange" na string "apple apple apple".
    2. Remova todas as linhas que contêm a palavra "error" do seguinte texto:
    2. line1
       error line
       line3

### CONCLUSÃO

Os comandos `tr`, `cut` e `sed` são ferramentas essenciais para manipulação de texto no Linux. 

Eles permitem que você realize uma ampla variedade de operações de edição de texto de maneira eficiente. 

Praticar com esses comandos ajudará você a se tornar mais eficiente em manipulação de texto no terminal.


THAT’S ALL FOLKS!!
