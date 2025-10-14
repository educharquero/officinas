# 101.3 Runlevel, Shutdown e Reboot (LPIC-1)

Este documento apresenta um resumo detalhado do conteúdo abordado na seção "101.3 Runlevel, Shutdown e Reboot" da certificação LPIC-1. O foco principal é o processo de inicialização do Linux, as diferentes implementações do `init`, o gerenciamento de runlevels e targets, e os comandos relacionados a desligamento e reinicialização do sistema.

## 1. O Processo de Inicialização do Linux e o `init`

O processo de inicialização do Linux é iniciado por um processo com **PID 1**, tradicionalmente conhecido como `init`. Este é o primeiro processo no espaço de usuário e serve como o pai de todos os outros processos do sistema. Sua função primordial é gerenciar o estado do sistema e iniciar/parar serviços.

## 2. Implementações do `init`

Ao longo do tempo, diversas implementações do `init` surgiram, cada uma com suas particularidades:

## 2.1. SysV Init

O **SysV Init** é o método tradicional, baseado em scripts localizados em `/etc/init.d/` e links simbólicos em diretórios como `/etc/rcX.d/`, onde `X` representa o runlevel. Embora ainda presente em algumas distribuições, tem sido gradualmente substituído por sistemas mais modernos.

## 2.2. Upstart

Desenvolvido pela Canonical, o **Upstart** foi uma tentativa de modernizar o processo de inicialização, introduzindo suporte a eventos e inicialização paralela. Foi amplamente utilizado em versões anteriores do Ubuntu, mas foi substituído pelo SystemD.

## 2.3. SystemD

Atualmente, o **SystemD** é o padrão na maioria das distribuições Linux modernas (Red Hat, Fedora, Debian, Ubuntu, etc.). Ele transcende o papel de um simples `init`, atuando como um gerenciador completo de sistema e serviços. O SystemD introduz o conceito de **unidades** (units) e **targets**, gerenciados principalmente pelo comando `systemctl`. Ele mantém compatibilidade com scripts SysV para suportar serviços legados.

## 2.4. OpenRC

O **OpenRC** é uma alternativa leve e eficiente, utilizada em distribuições como Alpine Linux e Gentoo. Ele mantém compatibilidade com o estilo SysV, mas oferece suporte a paralelismo e dependências entre serviços.

## 3. O SysV Init em Detalhes

O SysV Init opera com o conceito de **runlevels** (níveis de execução), onde cada runlevel define um conjunto de serviços e programas a serem iniciados ou finalizados. As configurações principais são definidas no arquivo `/etc/inittab`, que especifica o runlevel padrão e mapeia ações para eventos. Os scripts de inicialização estão em `/etc/init.d/` e são organizados por runlevel nos diretórios `/etc/rcX.d/`.

- Scripts com prefixo `S` (Start) são iniciados.
- Scripts com prefixo `K` (Kill) são finalizados.

## 3.1. Códigos de Runlevels

A tabela a seguir descreve os runlevels padrão no SysV Init:

| Código | Descrição |
|---|---|
| 0 | Desligamento |
| 1, s, S ou Single | Single User (modo de manutenção, um único usuário) |
| 2 | MultiUser sem rede |
| 3 | MultiUser com rede |
| 4 | Reservado para uso personalizado |
| 5 | MultiUser com rede e interface gráfica (desktops) |
| 6 | Reinicialização |

## 3.2. Gerenciamento de Runlevels (SysV Init)

- **Verificar runlevel padrão**: Consultar `/etc/inittab`.
- **Verificar runlevel atual e anterior**: Comando `runlevel`.
- **Mudar de runlevel**: `init X` ou `telinit X` (onde `X` é o número do runlevel).
- **Recarregar `/etc/inittab`**: `telinit q` ou `telinit Q`.
- **Reaplicar runlevel atual**: `telinit u` ou `telinit U`.

## 3.3. Estrutura do `/etc/inittab`

Cada linha no `/etc/inittab` segue a estrutura `id:runlevels:action:process`:

- `id`: Identificador da entrada (até quatro caracteres).
- `runlevels`: Runlevels nos quais a ação deve ocorrer (0-6).
- `action`: Comportamento do `init` em relação ao processo.
- `process`: Caminho do comando ou script a ser executado.

Subindo uma distro com esse tipo de gerenciamento (Slackware por exemplo), teríamos essa estrutura:

```bash
# Default runlevel
id:3:initdefault:

# Configuration script executed during boot
si::sysinit:/etc/init.d/rcS

# Action taken on runlevel S (single user)
~:S:wait:/sbin/sulogin

## id:runlevels:action:process
# Configuration for each execution level
l0:0:wait:/etc/init.d/rc 0
l1:1:wait:/etc/init.d/rc 1
l2:2:wait:/etc/init.d/rc 2
l3:3:wait:/etc/init.d/rc 3
l4:4:wait:/etc/init.d/rc 4
l5:5:wait:/etc/init.d/rc 5
l6:6:wait:/etc/init.d/rc 6

# Action taken upon ctrl+alt+del keystroke
ca::ctrlaltdel:/sbin/shutdown -r now

# Enable consoles for runlevels 2 and 3
1:23:respawn:/sbin/getty tty1 VC linux
2:23:respawn:/sbin/getty tty2 VC linux
3:23:respawn:/sbin/getty tty3 VC linux
4:23:respawn:/sbin/getty tty4 VC linux

# For runlevel 3, also enable serial
# terminals ttyS0 and ttyS1 (modem) consoles
S0:3:respawn:/sbin/getty -L 9600 ttyS0 vt320
S1:3:respawn:/sbin/mgetty -x0 -D ttyS1
```

## 3.4. Ações Comuns no `/etc/inittab`

| Ação | Descrição |
|---|---|
| `boot` | Executa o processo uma vez durante a inicialização, ignorando `runlevels`. |
| `bootwait` | Similar a `boot`, mas `init` aguarda a finalização do processo. |
| `sysinit` | Executa durante a inicialização, antes de qualquer runlevel ser ativado. |
| `wait` | Executa nos runlevels especificados e `init` aguarda sua conclusão. |
| `once` | Executa uma única vez ao entrar no runlevel especificado. |
| `respawn` | Reinicia o processo sempre que ele for finalizado (comum para terminais). |
| `ctrlaltdel` | Executa quando o sistema recebe `SIGINT` via Ctrl+Alt+Del. |

Os scripts de inicialização ficam em /etc/init.d:

```bash
ls -l /etc/init.d/
```
```bash
total 156
-rwxr-xr-x 1 root root 3740 Apr  1  2020 apparmor
-rwxr-xr-x 1 root root 2964 Dec  6  2019 apport
-rwxr-xr-x 1 root root 1071 Jul 24  2018 atd
-rwxr-xr-x 1 root root 1232 Mar 27  2020 console-setup.sh
-rwxr-xr-x 1 root root 3059 Feb 11  2020 cron
-rwxr-xr-x 1 root root  937 Feb  4  2020 cryptdisks
-rwxr-xr-x 1 root root  896 Feb  4  2020 cryptdisks-early
-rwxr-xr-x 1 root root 3152 Sep 30  2019 dbus
-rwxr-xr-x 1 root root  985 Feb 12  2021 grub-common
-rwxr-xr-x 1 root root 2363 Jul 17  2017 haveged
-rwxr-xr-x 1 root root 3809 Jul 28  2019 hwclock.sh
-rwxr-xr-x 1 root root 4698 Jun 23  2018 ifplugd
-rwxr-xr-x 1 root root 2638 Dec 13  2019 irqbalance
-rwxr-xr-x 1 root root 1503 May 11  2020 iscsid
-rwxr-xr-x 1 root root 1479 Nov 27  2019 keyboard-setup.sh
-rwxr-xr-x 1 root root 2044 Feb 19  2020 kmod
-rwxr-xr-x 1 root root  695 Jan 28  2020 lvm2
-rwxr-xr-x 1 root root  586 Jan 28  2020 lvm2-lvmpolld
-rwxr-xr-x 1 root root 2827 Jan  9  2020 multipath-tools
-rwxr-xr-x 1 root root 4445 Jan 29  2019 networking
-rwxr-xr-x 1 root root 2503 May 11  2020 open-iscsi
-rwxr-xr-x 1 root root 1846 Mar  9  2020 open-vm-tools
-rwxr-xr-x 1 root root 1366 Mar 23  2020 plymouth
-rwxr-xr-x 1 root root  752 Mar 23  2020 plymouth-log
-rwxr-xr-x 1 root root  924 Feb 13  2020 procps
-rwxr-xr-x 1 root root 3117 Jan 28  2021 qemu-guest-agent
-rwxr-xr-x 1 root root 4417 Oct 15  2019 rsync
-rwxr-xr-x 1 root root 2864 Mar  7  2019 rsyslog
-rwxr-xr-x 1 root root 1222 Apr  2  2017 screen-cleanup
-rwxr-xr-x 1 root root 3939 May 29  2020 ssh
-rwxr-xr-x 1 root root 1582 Dec 23  2019 sysstat
-rwxr-xr-x 1 root root 6872 Apr 22  2020 udev
-rwxr-xr-x 1 root root 2083 Jan 21  2020 ufw
-rwxr-xr-x 1 root root 1391 Apr 13  2020 unattended-upgrades
-rwxr-xr-x 1 root root 1306 Apr  2  2020 uuidd
```

## Validamos o Runlevel atual com o comando:
```bash
$ runlevel 
```
```bash
N 5
```

Para validar os serviços rodando, podemos usar os comandos:

```bash
$ service --status-all
```

# Ver staus do ssh:
```bash
$ sudo service sshd status
```
```bash
openssh-daemon (pid  1392) is running...
```

# Reiniciar um serviço:
```bash
$ sudo service rsyslog restart
```
```bash
Shutting down system logger:                               [  OK  ]
Starting system logger:                                    [  OK  ]
```

# Parar um serviço:
```bash
$ sudo service rsyslog stop
```
```bash
Shutting down system logger:                               [  OK  ]
```

# Iniciar um serviço:
```bash
$ sudo service rsyslog start
```
```bash
Starting system logger:                                    [  OK  ]
```

## Existem ferramentas para gerência da criação/remoção dos links simbólicos, dentro dos diretórios, facilitando a vida do Administrador de Sistemas

* CHKCONFIG - Família RedHat
* UPDATE-RC.D - Família Debian

Vamos avaliar o chkconfig:

```bash
chkconfig --add           - Adiciona um script à inicialização (cria os links nos diretórios rc[0-6].d)
chkconfig --del           - Remove o script da inicialização (remove os links nos diretórios rc[0-6].d)
chkconfig --list          - Lista todos os scripts registrados no chkconfig e seus estados nos runlevels
chkconfig --level <N>     - Define manualmente em quais runlevels o serviço estará 'on' ou 'off'
```

NOTE que um chkconfig sem argumentos, vai trazer TODOS os scripts que estão carregados na iniciaçização do sistema!
Rode um chkconfig --help ou man chkconfig para mais informações.

Vamos avaliar o updaterc.d:

```bash
# Iniciando um script no boot (Para o runlevel 5):
$ sudo update-rc.d cups enable 5
```

```bash
# Desabilitando este script do runlevel 5:
$ sudo update-rc.d cups disable 5
```

- Se omitir o id do runlevel, ele será habilitado ou desabilitado nos runlevels [1-5]

# Remova todos os links para um script:
```bash
$ sudo update-rc.d cups remove
# Apaga ele dos diretórios /etc/rc[1-5].d/
```

# Adicionando um script no mapeamento (Podemos usar ele de novo com o Enable e Disable):
```bash
$ sudo update-rc.d cups defaults
# Adiciona ele dos diretórios /etc/rc[1-5].d/
```

## 4. SystemD em Detalhes

O SystemD substitui o SysV Init com melhorias como paralelização nativa e gerenciamento baseado em eventos. Ele utiliza **units** e **targets** para definir o estado do sistema.

## 4.1. Conceitos Chave (SystemD)

- **Units**: Elementos fundamentais que representam serviços, sockets, dispositivos, pontos de montagem, etc.
- **Targets**: Grupos de units que definem um estado do sistema, funcionando como o equivalente moderno aos runlevels.

## 4.2. Tipos Comuns de Units

- `service`: Daemons (ex: `sshd.service`).
- `socket`: Sockets de sistema ou rede.
- `device`: Dispositivos do kernel.
- `mount`: Pontos de montagem.
- `automount`: Pontos de montagem ativados sob demanda.
- `target`: Agrupa units para configurar estados (ex: `multi-user.target`, `graphical.target`).
- `timer`: Substitui `cron jobs`, ativando serviços em horários específicos.

Os arquivos das units geralmente estão em `/lib/systemd/system/` e seguem o formato `nome.tipo`.

## 4.3. Comandos `systemctl`

O comando `systemctl` é a principal ferramenta para gerenciar o SystemD:

| Comando | Descrição |
|---|---|
| `start <unit>` | Inicia a unit. |
| `stop <unit>` | Interrompe a unit. |
| `restart <unit>` | Reinicia a unit. |
| `status <unit>` | Mostra o estado da unit (em execução, ativa no boot, etc.). |
| `is-active <unit>` | Verifica se a unit está ativa (`active` ou `inactive`). |
| `enable <unit>` | Habilita a unit para iniciar na inicialização do sistema. |
| `disable <unit>` | Desabilita a unit da inicialização. |
| `enable --now <unit>` | Habilita e inicia a unit imediatamente. |
| `is-enabled <unit>` | Verifica se a unit está habilitada para iniciar com o sistema. |
| `isolate <target>` | Muda para um target específico (equivalente a `telinit NUMERO`). |
| `set-default <target>` | Configura um novo target padrão. |
| `get-default` | Exibe o target padrão. |
| `list-unit-files` | Lista todas as units disponíveis e seu status de habilitação. |
| `list-units` | Mostra as units ativas ou que estiveram ativas na sessão atual. |
| `list-units --type=<Unit>` | Filtra units por tipo. |
| `suspend` | Coloca o sistema em modo de baixo consumo (dados na memória). |
| `hibernate` | Copia dados da memória para o disco para recuperação posterior. |
| `poweroff` | Desliga a máquina. |
| `reboot` | Reinicia a máquina. |

## 4.4. Compatibilidade com Runlevels (SystemD)

O SystemD mapeia os antigos runlevels do SysV Init para seus próprios targets:

- `runlevel0.target` -> `poweroff.target`
- `runlevel1.target` -> `rescue.target`
- `runlevel2.target` -> `multi-user.target`
- `runlevel3.target` -> `multi-user.target`
- `runlevel4.target` -> `multi-user.target`
- `runlevel5.target` -> `graphical.target`
- `runlevel6.target` -> `reboot.target`

## 5. Upstart em Detalhes

O Upstart, embora substituído, ainda é relevante para sistemas legados. Ele usa scripts em `/etc/init.d/` para compatibilidade, mas seus arquivos de configuração ficam em `/etc/init/`.

## 5.1. Comandos `initctl` (Upstart)

- `initctl list`: Lista trabalhos e instâncias, exibindo o status.
- `initctl status <SERVIÇO>`: Exibe o status de um serviço.
- `initctl start <SERVIÇO>`: Inicia um serviço.
- `initctl stop <SERVIÇO>`: Para um serviço.

## 6. Shutdown e Restart

Comandos para desligar ou reiniciar o sistema, com a capacidade de enviar mensagens de aviso aos usuários e agendar operações.

## 6.1. Opções Comuns do `shutdown`

- `-P`: Desliga o Linux e a máquina.
- `-h`: Desliga o Linux, mas não a máquina (depende do hardware).
- `-r`: Reinicia.
- `-c`: Cancela um desligamento agendado.

## 6.2. Agendamento de Desligamento/Reinicialização

- `sudo shutdown +N`: Agenda o desligamento para `N` minutos no futuro.
- `sudo shutdown HH:MM`: Agenda o desligamento para um horário específico.
- `sudo shutdown -P now` ou `sudo shutdown -P +0`: Desliga imediatamente.
- `sudo shutdown -r now` ou `sudo shutdown -r +0`: Reinicia imediatamente.
- `sudo shutdown +N 

"Mensagem" &`: Agenda o desligamento com uma mensagem personalizada.

## 6.3. Outros Comandos de Desligamento/Reinicialização

- **Desligar**: `poweroff`, `halt`, `systemctl poweroff`, `systemctl halt`.
- **Reiniciar**: `reboot`, `systemctl reboot`.

## 7. WALL

O comando `wall` é utilizado para enviar uma mensagem para todos os usuários conectados no sistema, ou para um grupo específico de usuários.

## 8. ACPID - Advanced Configuration and Power Interface

O daemon `acpid` é o principal gerenciador de energia do Linux. Ele permite configurar ações personalizadas em resposta a eventos relacionados ao consumo de energia, como fechar a tampa de um laptop, bateria fraca ou níveis de carga da bateria.


That's All Folks

