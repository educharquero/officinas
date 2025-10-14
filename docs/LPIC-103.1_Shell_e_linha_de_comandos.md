# 🐧 Módulo 103.1 AULA 01

## O SHELL

## sh, dash, bash, csh, zsh ...

O shell é uma interface ou ambiente de interação entre o usuário e o _kernel_ (ou núcleo), que por sua vez, interage com o hardware, que o usuário não consegue fazer.

```
HARDWARE <---> KERNEL <---> SHELL <---> USUÁRIO
```

Vamos analizar um comando importante nessa aula, o comando `echo`:

O comando `echo` imprime na tela o que for digitado na tela.

Exemplo:

```
echo linux
```

```
echo "Debian Linux"
```

Podemos consultar informações sobre esse comando com o _manual_ ou com o _help_, do comando:

```
help echo
```

```
man echo
```

## VARIÁVEIS

Variáveis são elementos que recebem e guardam um valor atribuído a elas.

`VARIÁVEIS != CONSTANTES`

Exemplo:

```
senha=123

echo senha

echo $senha
```

```
senhas="123 321"

echo $senhas
```

```
fruta=banana

echo $fruta
```

```
nota=10

echo $nota
```

```
nomes="joao jose maria"

echo $nomes
```

Note que o `Shell` tem suas próprias variáveis de trabalho, que podem ser consultadas através do comando `env` e pelo comando `set`:

```
env
```

```
set
```

Uma variável pode receber a saída de um comando do sistema, desde que esteja entre `$()`:

Exemplo, lembra do comando `whoami`? Vamos testar:

```
QuemSouEu=$(whoami)

echo $QuemSouEu
```

```
Conteudo_Local=$(ls --color)

echo $Conteudo_Local
```

Expandindo o comando na execução:

```
fruta='echo abacaxi'

echo $fruta
```

`!=` de

```
fruta=$(echo abacaxi)

echo $fruta
```

Podemos criar variáveis com:

`LETRAS MAIÚSCULAS` e/ou `MINÚSCULAS` e/ou `NÚMEROS`

O **único** caracter permitido na composição de uma variável é o underline `_`

NÃO podem conter acentos e NÃO podem iniciar com números nem com qualquer outro caractere.

```
cria_pasta=$(mkdir PASTA-DE-FOTOS)

ls
```

NOTE QUE SE EU ENTRAR EM OUTRA SESSÃO DE SHELL ESSAS VARIÁVEIS NÃO CONSTAM:

Exemplo de chamada para outra _sessão_ de terminal:

```
bash
```

```
echo $senhas

echo $fruta

echo $nota

echo $QuemSouEu
```

Fechando essa _sessão_:

```
exit
```

Agora as variáveis que criamos constam novamente:

```
echo $senhas

echo $fruta

echo $nota

echo $QuemSouEu
```

A não ser que vc use o comando `export`, que faz com que a variável que você criou, seja enviada para as variáveis do Sistema:

```
export fruta=kiwi
```

```
env | grep fruta
```

Vai estar visível para essa sessão de bash e seus processos filhos, apenas!

Caso queira "DES-exportar"

```
unset fruta
```

## COMANDO `read` OU LEIA

O comando `read` espera e armazena como variável o valor que você digitar:

```
read "x"

caderno

echo $x
```

A variável é `x`

```
read "variavel14"

vassoura

echo $variavel14
```

A variável é `variavel14`

```
read nota

echo $nota
```

A variável é `nota`

Adicionando a opção `-p` de _prompt_, ele fica interativo (porém vai precisar de uma variável de armazenamento):

```
read -p "fruta"

echo $fruta
```

Interage mas não armazenou nada, pois não criamos uma variável!

Agora vamos ler e armazenar uma variável:

```
read -p "fruta" var

echo $var
```

CUIDADO para não dar um `echo` em `fruta`, e sim em `$var`!

Vamos tentar de novo...

```
read -p "fruta: " x

echo $fruta ou echo $x ??
```

NOTE que deixamos um espaço entre os `:` e `"`

```
unset fruta

read -p "Diga uma fruta: " fruta

echo $fruta
```

Lendo uma variável que armazena um nome:

```
read -p "Digite seu nome: " x

echo $x
```

```
read -p "Digite seu nome: " y

echo $y
```

```
read -p "Digite seu nome: " nome

echo $nome
```

Lendo uma variável que armazena uma nota:

```
read -p "Digite a nota do aluno: " nota

echo $nota
```

## OS _COMANDOS_ _BUILTIN_ (_Comandos_ _Internos_) DO `shell`

Podemos ver quais são os _comandos_ _internos_ ou _builtins_ do shell com o `help`:

```
help

help <2xtab>

help echo

help pwd

help cd
```

NOTE que um `help ls` não retorna nada, pois o `ls` não é um _comando builtin_.

Também podemos comparar os _comandos_ _builtin_ e os _comandos_ _utilitários_ do sistema com o`type`:

```
type cd

type echo

type ls

type apt

type mv
```

Os _comandos_ que NÃO FOREM _`builtin`_, sempre terão sua localização `PATH` apontada. Os _comandos_ _builtin_ não tem esse apontamento.

## AS VARIÁVEIS DE AMBIENTE EM USO PELO SISTEMA OPERACIONAl

As variáveis de ambiente são definidas sempre em _caixa alta_. Sendo mostradas pelos comandos `set` ou `env`:

O _comando_ _utilitário_ `env` MOSTRA APENAS AS VARÁVEIS GLOBAIS E AS EXPORTADAS NA SESSÃO.

O _builtin_ `set` mostra todas as _variáveis_ _internas_ e _globais_, mesmo sem exportar.

```
type env

type set

env | less

set | less
```

```
SHELL=/bin/bash
LANGUAGE=pt_BR
XCURSOR_SIZE=24
LOGNAME=mevorak
HOME=/home/mevorak
USER=mevorak
HOSTNAME=mevorak
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
...
```

Podemos realizar buscas por variáveis específicas:

```
echo $USER 

echo $SHELL

echo $LANGUAGE
```

## O CONCEITO DE `PATH` OU _CAMINHO_

Nos comandos dados ao `bash`, ele valida PRIMEIRO se é um _comando_ _builtin_, DEPOIS ele valida se é um _comando_ _utilitário_ do sistema, da variável `PATH`, DEPOIS ele imprime um erro de `COMMAND NOT FOUND`. bem lógico!

Exemplo::

```
meu_programa

bash: meu_programa: comando não encontrado
```

MAS eu posso criar um arquivo com esse nome e fazer virar um `Shell script`

```
echo "ls" > meu_programa

chmod +x meu_programa

./meuprograma
```

Outros exemplos práticos:

```
echo "echo Olá mundo" > meu_programa

echo mkdir PASTA_D > meu_programa
```

Ou então posso jogar o meu programa no `PATH`do Sistema:

```
sudo mv meu_programa /usr/bin/
```

Agora ele consta nos _comandos_ _internos_ do Sistema e autocompleta com a tecla `TAB`:

```
meu_prog 2x<TAB>
```

## A LINGUAGEM DO `SHELL SCRIPT` (Modo não interativo)

Qual a vantagem de usar _Shell script_? Bom, podemos usar comandos em lote, ao invés de um de cada vez!

Exemplo:

```
whoami

hostname

uptime -p

uname -rms
```

Imagine se tivesse que validar essas informações a cada troca de turno, por exemplo. 

Sendo **MUITO** mais prático, criar um Shell script com todos estes comandos para rodar de uma vez só.

Criando o arquivo:

```
$ > informacoes.sh
```

Inserindo os comandos nele:

```
#! /usr/bin/env bash

 whoami

 hostname

 uptime -p

 uname -rms
```

Setando permissão de execução:

```
chmod +x informacoes.sh
```

Chamando o programa para rodar:

```
./informacoes.sh
```

A linha `#! /usr/bin/env bash` informa ao `Shell` qual interpretador vai rodar o script, no caso, apontamos para o `bash`. Chamamos essa linha _obrigatória_ inicial de `Hashbang`ou de `Shebang`, tanto faz.

Na maioria dos casos o programador vai usar o _caminho_ _absoluto_ `#!/bin/bash`, para criar a `hashbang` ao invés de optar pelo _environment_ (ambiente) `env`.

Vamos criar um arquivo de _Shell script_ que leia, guarde e imprima um nome:

Criamos o arquivo:

```
> seunome.sh
```

Inserimos o conteúdo:

```
#!/usr/bin/env bash

read -p "Digite seu nome: " nome

echo "Olá, $nome!"
```

Setamos a permissão de execução:

```
chmod +x seunome.sh
```

Chamamos á execução:

```
./seunome
```

Criemos outro _Shell script_ que mostre a data e hora, hospedando no `/opt`e usando o editor `vim`:

```
mkdir -p /opt/Meus_Programas/
```

```
vim /opt/Meus_Programa/Data_Hora
```

```
#!/bin/bash

echo "Este é um Script de Teste"

echo " "

date

echo " "

echo "Fim do Script"
```

Este script só roda se eu der permissão e rodar o comando á partir do próprio diretório:

```
chmod +x /opt/Meus_Programas/Data_Hora
```

```
cd /opt/Meus_Programas/
```

```
./Data_Hora #./ aponta diretório atual
```

```
sh Data_Hora
```

Ou

```
bash Data_Hora
```

Opcionalmente posso apontar o `PATH` completo no comando:

```
bash /opt/Meuprograma/Data_Hora
```

Tentar executá-lo á partir de outro diretório será impossível!

## CAMINHO ABSOLUTO X CAMINHO RELATIVO:

_CAMINHO_ _ABSOLUTO_

```
/opt/Meuprograma/Data_Hora
```

_CAMINHO_ _RELATIVO_

```
cd /opt/
```

```
cd Meus_Programas/
```

```
cd Data_Hora
```

## A VARIÁVEL `PATH` ( OU CAMINHO)

Todo _programa_ que roda no Terminal, está armazenado em algum lugar específico.

Geralmente os scripts do Sistema operacional, ficam em `/usr/bin/`, `/usr/sbin`, `/bin`, etc.

Contudo, pra que eu não tenha que ficar digitando o caminho completo, toda vez em que for preciso rodar um programa, como por exemplo o navegador web _Firefox_, foi criada a variável `PATH`, contendo os caminhos de busca, para uso do Sistema operacional.

Temos dois modos de adicionar o caminho do diretório onde salvei meu script, á variável `PATH`, que é onde o Terminal busca os programas, possibilitando com que ele conste, á partir de qualquer diretório onde eu estiver.

1) MODO TRANSITÓRIO

Leio o `PATH`padrão:

```
echo $PATH
```

Adiciono meu próprio caminho á ela:

```
PATH=$PATH:/opt/Meus_Programas
```

Leio novamente e ele está constando nela:

```
echo $PATH
```

2) MODO DEFINITIVO

Leio o `PATH` padrão:

```
echo $PATH
```

Edito o próprio _arquivo_ _global_ do Sistema operacional, adicionando o caminho do meu programa:

```
sudo vim /etc/profile
```

```
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/Meus_Programas"
```

Forço a reconfiguração para efetivar a alteração:

```
sudo source /etc/profile
```

Releio o `PATH` padrão e já consta o `/opt/Meus_Programas`:

```
echo $PATH
```

Inclusive os comandos `which` ou `whereis` tbém já encontram o meu _programa_:

```
whereis Data_Hora

which Data_Hora
```

Respondendo á tecla `TAB` para autocompletar o nome do _programa_: 

```
Data_H 2x<TAB>

Data_Hora
```

Alguns usuários preferem criar seus próprios diretórios pessoais, ignorando a _variável_ _Global_ `/etc/profile`, optando por usar a _variável_ _local_ `.bashrc`, para armazenar seus próprios caminhos.

Exemplo:

Criamos o diretorio `/home/usuario/Programas`:

```
mkdir ~/Programas
```

Editamos a _variável_ _local_ `.bashrc`:

```
sudo vim ~/.bashrc
```

Adicionamos um teste de execução:

```
if [ -d ~/Programas ]
then
   PATH=$PATH:~/Programas
fi
```

Copia um script, como o `seunome.sh` para dentro desse diretório:

```
cp seunome.sh /home/usuario/Programas/
```

Forçamos a releitura da configuração da _variável_ _de_ _sistema_:

```
source .bashrc
```

Procuramos o novo caminho na variável `PATH`:

```
env | grep PATH
```

## CRIANDO UM SCRIPT E SETANDO NO `PATH` DO SISTEMA

Faça os seguintes testes:

```
echo "máquina; hostname
```

```
echo -n máquina; hostname
```

```
echo -n máquina:; hostname
```

ENTÃO

Criamos o script:

```
vim ~/Programas/Informacoes
```

Inserimos os comandos:

```
#! /usr/bin/env bash

# Informações.sh
# Versão 1.0
# Script para capturar informações do Sistema
# 02/25
# Eduardo Charquero

clear

echo ""

echo "VALIDANDO NFORMAÇÕES LOCAIS:"

echo "----------------------------------"

echo -n "Usuário logado : "
whoami

echo -n "Máquina da rede: "
hostname

echo -n "Kernel em uso  : "
uname -rms

echo -n "Tempo ligada   : "
uptime -p

echo "----------------------------------"
echo ""
```

Setamos permissão de execução:

```
chmod +x ~/Programas/Informacoes
```

Mandamos o `TAB`autocompletar e o `ENTER` para rodar:

```
Infor 2x<TAB> ENTER
```

## DICAS

Locais interessantes de usar para repositório de seus scripts pessoais:

```
~/.Programas

/opt

/usr/local/bin
```

## ATENÇÃO!!

NÃO RODE COMANDOS OU SCRIPTS DE TERCEIROS ENCONTRADOS NA WEB, SEM SABER O QUE ELE DE FATO ESTÁ FAZENDO!

CUIDADO COM O USO DE USUÁRIO ROOT OU SUDO!

Você foi avisado!!


THAT’S ALL FOLKS!!
