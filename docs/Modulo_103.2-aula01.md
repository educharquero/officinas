# 🐧 Módulo 103.2 AULA 01

filtros

# LEITURA DE ARQUIVOS COM OS COMANDOS `cat`, `tac`, `head`, `tail`, `less`, `nl`, `sort` E `uniq`

### O comando `cat`

    $ cat arquivo.txt

Com a opção `-n` para numeração de linhas:

    $ cat -n arquivo.txt

Com a opção `-b`, somente linhas com informações, ignorando linhas vazias:

    $ cat -b arquivo.txt

Unifica linhas em branco em uma apenas, com a opção `-s`:

    $ cat -s arquivo.txt

Com a opção `-a`, mostra caracteres especiais. todo fim de linha tem um `$`. todo tab ele mostra um `^i`

    $ cat -a arquivo.txt

O help trás ajuda:

    $ cat --help

O man tem o manual completo:

    $ man cat

### FILTROS

### O COMANDO `tac`

O inverso de cat, imprime o arquivo de trás pra frente. na ordem inversa, da última linha pra primeira:

    $ tac arquivo.txt

### O COMANDO `head`

Apresenta o cabeçalho do arquivo. por padrão trás as primeiras 10 linhas do arquivo. (completas ou vazias):

    $ head arquivo.txt

Posso definir a quantidade de linhas com a opção `-n` e mostrar apenas as 2 primeiras linhas:

    $ head -n2 arquivo.txt

Mostrar as 20 primeiras linhas:

    $ head -n20 arquivo.txt

Mostrar apenas os 50 primeiros bytes. (ele não quebra a linha no final do comando mesmo.):

    $ head -c50 arquivo.txt

### O COMANDO `tail`

O comando `tail` mostra o final do arquivo. por padrão as Últimas 10 linhas.

Posso definir a qtidade de linhas com a opção `-n`:

    $ tail arquivo.txt

    $ tail -n4 arquivo

O tail tem uma opção muito interessante, que é a `-f`, onde ele fica aguardando a entrada de informaÇÕes em um arquivo. muito usada pra monitorar eventos.

Exemplo, em um terminal vc fica escutando:

    $ tail -n5 -f arquivo.txt

E em outro terminal digita:

    $ echo “linus torvaldis” >> arquivo.txt

Outro exemplo:

    $ tail -f /var/log/zypper

Abre outro terminal e digita:

    $ sudo zypper dup

Vai mostrar a evolução do processo de atualização no OpenSUSE.

Podemos validar a entrada e saída de acesso a páginas web de um proxy, por exemplo. ou acompanhar qualquer log em tempo real que precisarmos!

### O COMANDO `less`

Usando o ambiente gráfico, vc pode usar a barra de rolagem pra leitura de arquivos no terminal, mas em ambientes modo texto, nem sempre vc tem essa opção.

Então podemos paginar a leitura de um arquivo. ele vai travar a leitura em casa vez que alcançar a linha de baixo (ou de cima), navegando pelo direcional do teclado ou pelo enter. vai travar na próxima página usando o `tab`:

    $ less arquivo.txt

Uma vez aberto , o less possibilita busca por palavras, com o atalho da `/` + a palavra que procuramos:

    /kernel enter

Cada vez que aperto `n`, ele busca uma nova opção, dessa mesma palavra, em outras páginas.

Com `shift` + `n` ele busca para trás.

Se selecionar `ctrl` + `g`, ele mostra o status de onde estou no arquivo, nome, página atual e percentual da leitura.

Pressionado `q`, vc sai do `less`.

O `less`, geralmente, é usado em associação com o `cat` + o `|`:

    $ cat arquivo.txt | less

O pipe pega a saída do primeiro comando e usa de entrada do segundo comando.

#### O COMANDO `wc`

o comando `wc`, imprime na tela, a quantidade de linhas, a quantidade de palavras e a quantidade de caracteres, desse arquivo:

    $ wc arquivo.txt

Se usar a opção `-l`, mostra apenas as linhas.

Se usar a opção `-w`, ele mostra as palavras.

Se usar `-m` ele mostra de caracteres.

A opção `-c` aponta a quantidade de bytes.

Se vc der um `wc *` dentro de um diretório, ele vai apresentar dados sobre a quantidade de linhas, palavras e caracteres de todos os arquivos que estiverem dentro do diretório. trazendo o total no final.

Podemos fazer combinações, tipo de `cat` + `|` + `wc`:

    $ cat arquivo.txt | wc -l

ou `tail` + `|` + `wc`:

    $ tail -n10 arquivo.txt | wc

### O COMANDO `nl`

O `nl` é igual ao `cat -b`, ignorando linhas em branco:

    $ nl arquivo.txt

#### O COMANDO `sort`

O `sort` serve pra ordenar alfabéticamente um arquivo.

Se usar a opção `-r`, ele ordena reversamente, ao contrário do alfabeto.

As demais opções do sort, podem ser estudadas com `sort -h`.

### O COMANDO `uniq`

O `uniq` serve pra mostrar entradas únicas dentro de um arquivo com repetições, ou seja, ele mostra ocorrências únicas, sem as repetições que possam ocorrer no arquivo:

    $ unique arquivo.txt

Se houverem dois eventos de “linux”, ele trás apenas um deles.

Se usar com a opção`-k`, ele ordena pelo _segundo_ campo, tipo nome e sobrenome, ele ordenaria alfabéticamente o sobrenome.


THAT’S ALL FOLKS!!
