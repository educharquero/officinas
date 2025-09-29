# 🐧 Módulo ﻿103.1 AULA 02

### HISTÓRICO DOS COMANDOS

É possível acessar o histórico de comandos dados no terminal, clicando no direcional do teclado, para cima ou para baixo.

Podemos usar o comando `history`, aliado ao comando `less`, para ver o conteúdo do _cache_:

```
history
```

```
history | less
```

Se usar dois `!!`, ele retorna o último comando dado no Terminal:

```
!!
```

Posso aliar um `!`, mais o número do comando que eu quero repetir:

```
!37
```

Quem armazena esse _cache_ é o arquivo `.bash_history`:

```
cat ~/.bash_history
```

Que pode ser esvaziado com a opção `-c`:

```
history -c
```

A variável de ambiente que aponta para esse arquivo é a `HISTFILE`:

```
set | grep HISTFILE
```

```
HISTFILE=/home/usuario/.bash_history
HISTFILESIZE=20000
_=HISTFILE
```

Assim como a que aponta o tamanho do _cache_, `HISTSIZE`, em número de linhas:

```
echo $HISTSIZE
```

```
1000
```

Uma opção poderosa na busca de histórico de comandos, é a associação entre `ctrl+r` e alguma parte do comando, ao dar `ENTER`, ele roda o comando:

```
ctrl + r dist
```

```
sudo apt update && sudo apt dist-upgrade
```

Outro detalhe interessante, na busca pelo histórico de comandos, é o uso da tecla `<TAB>`, que clicada 2x, vai tentando autocompletar, com opções, o comando que estou digitando:

```
histor + 2X<TAB>
```

### COMANDOS SEQUENCIAIS

Podemos usar comandos sequenciais com alguns direcionadores, como o `;`, o `&&` e o `||`.

O `;` executa sempre, sequencialmente os comandos:

```
clear; date; ls
```

Enquanto o `&&` só dá sequência ao próximo comando se obtiver sucesso no comando anterior. se este falhar, ele não prossegue ao próximo:

```
ls /tmp/naoexiste && echo linux

ls: não foi possível acessar '/tmp/teste': Arquivo ou diretório inexistente
```

```
ls /tmp/ && echo linux
```

```
kdocs_asrfirjc
MozillaUpdateLock-6AFDA46A1A8AD48
ssh-W8FSwzdY1DB2
systemd-private-881a6f50d3544de58d23489a38c4214c-bluetooth.service-qpAL6j
systemd-private-881a6f50d3544de58d23489a38c4214c-colord.service-DB6QUM
systemd-private-881a6f50d3544de58d23489a38c4214c-ModemManager.service-aG3Y6H
systemd-private-881a6f50d3544de58d23489a38c4214c-switcheroo-control.service-67zwcx
systemd-private-881a6f50d3544de58d23489a38c4214c-systemd-logind.service-M8ORHo
systemd-private-881a6f50d3544de58d23489a38c4214c-systemd-timesyncd.service-qN7VXN
systemd-private-881a6f50d3544de58d23489a38c4214c-upower.service-O1RZMk
vmware-root
linux
```

Já o outro direcionador, o `||`, só prossegue para o próximo comando se der erro no primeiro:

```
ls /tmp || echo linux

ls /tmp/naoexiste || echo linux
```

THAT’S ALL FOLKS!!
