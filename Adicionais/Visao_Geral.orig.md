# 📁 Visão Geral da Certificação LPIC

https://www.lpi.org/pt-br/our-certifications/lpic-1-overview/

## O EXAME PRA CERTIFICAÇÃO LPIC-1 É DIVIDIDO EM DUAS PARTES:

* Preparação para prova do exame 101 – Tópicos de estudos 101 a 104
* Preparação para prova do exame 102 – Tópicos de estudos 105 A 110 

### EXAME 101 (101 A 104)

# TÓPICO 101 - ARQUITETURA DO SISTEMA:

## 101.1 Identificar e editar configurações de hardware

- Principais Áreas de Conhecimento:
  
    Habilitar e desabilitar periféricos integrados.
    Configurar sistemas com ou sem periféricos externos, como teclados por exemplo.
    Diferenciar entre vários tipos de dispositivos de armazenamento.
    Saber a diferença entre dispositivos coldplug e hotplug.
    Determinar os recursos de hardware para os dispositivos.
    Ferramentas e utilitários para a listar várias informações de hardware (por exemplo, lsusb, lspci, etc...).
    Ferramentas e utilitários para manipular dispositivos USB.
    Compreensão conceitual de sysfs, udev, dbus.

## Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /sys/
    /proc/
    /dev/
    modprobe
    lsmod
    lspci
    lsusb

# 101.2 início (boot) de Sistema

- Principais Áreas de Conhecimento:
  
    Fornecer os comandos e opções mais comuns para o gerenciador de inicialização e para o kernel durante a inicialização.
    Demonstrar conhecimento sobre a sequência de inicialização do BIOS.
    Entendimento do SysVinit e do systemd.
    Saber que existe o Upstart.
    Conferir os arquivos de log dos eventos de inicialização.

## Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    dmesg
    BIOS
    bootloader
    kernel
    initramfs
    init
    SysVinit
    systemd

# 101.3 Alternar runlevels/boot targets, desligar e reiniciar o sistema

- Principais Áreas de Conhecimento:
  
    Definir o runlevel padrão e o boot target padrão.
    Alternar entre os runlevels/boot targets incluindo o modo single user.
    Desligar e reiniciar através da linha de comando.
    Alertar os usuários antes de mudar o runlevel/boot target ou outro evento de sistema que acarrete uma mudança significativa.
    Terminar apropriadamente os processos.

## Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/inittab
    shutdown
    init
    /etc/init.d/
    telinit
    systemd
    systemctl
    /etc/systemd/
    /usr/lib/systemd/
    wall

# TÓPICO 102 - INSTALAÇÃO E GERENCIAMENTO DE PACOTES:

## 102.1 Dimensionar partições de disco

- Principais Áreas de Conhecimento:
  
    Distribuir os sistemas de arquivos e o espaço de swap para separar partições ou discos.
    Adaptar o projeto para o uso pretendido do sistema.
    Garantir que a partição /boot esteja em conformidade com os requisitos de arquitetura de hardware para a inicialização.
    Conhecimento das características básicas do LVM.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    / (root) sistema de arquivos raiz
    /var sistema de arquivos
    /home sistema de arquivos
    /boot sistema de arquivos
    espaço de swap
    pontos de montagem
    partições

102.2 Instalar o gerenciador de inicialização

Principais Áreas de Conhecimento:

    Fornecer locais de boot alternativos e backup das opções de boot.
    Instalar e configurar um gerenciador de inicialização como o GRUB Legacy.
    Realizar mudanças na configuração básica do GRUB 2.
    Interagir com o carregador de boot.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    menu.lst, grub.cfg e grub.conf
    grub-install
    grub-mkconfig
    MBR

102.3 Controle de bibliotecas compartilhadas

Principais Áreas de Conhecimento:

    Identificar as bibliotecas compartilhadas.
    Identificar onde geralmente essas bibliotecas se localizam no sistema.
    Carregar as bibliotecas compartilhadas.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    ldd
    ldconfig
    /etc/ld.so.conf
    LD_LIBRARY_PATH

102.4 Utilização do sistema de pacotes do Debian

Principais Áreas de Conhecimento:

    Instalar, atualizar e desinstalar os pacotes binários Debian.
    Encontrar pacotes contendo um arquivo específico ou bibliotecas com as quais pode ou não ser instalado.
    Obter informações sobre pacotes como versão, conteúdo, dependências, integridade do pacote e status da instalação (se o pacote está instalado ou não).

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/apt/sources.list
    dpkg
    dpkg-reconfigure
    apt-get
    apt-cache
    aptitude

102.5 Utilização de pacotes RPM e YUM

Principais Áreas de Conhecimento:

    Instalar, reinstalar, atualizar e remover pacotes usando RPM e YUM.
    
    Obter informações dos pacotes RPM tal como versão, status, dependências, integridade e assinaturas.
    Determinar quais arquivos um pacote fornece, bem como encontrar de qual pacote um arquivo específico vem.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    rpm
    rpm2cpio
    /etc/yum.conf
    /etc/yum.repos.d/
    yum
    yumdownloader

102.6 Linux Virtualizado

Principais Áreas de Conhecimento:

    Entender o conceito geral de máquinas virtuais e contêineres.
    Entender elementos comuns em máquinas virtuais numa nuvem IaaS, como instâncias computacionais, armazenamento em bloco e rede.
    Entender as propriedades exclusivas de um sistema Linux que precisam ser alteradas quando um sistema é clonado ou utilizado como modelo.
    Entender como imagens de sistema são utilizadas para implementar máquinas virtuais, instâncias de nuvem e contêineres.
    Entender as extensões do Linux que integram o Linux com uma solução de virtualização.
    Noções de cloud-init.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    Máquina Virtual
    Contêiner Linux
    Contêiner de Aplicação
    Drivers de convidado
    Chaves SSH do host
    Id de máquina D-Bus

TÓPICO 103 - COMANDOS LINUX:

103.1 TRABALHAR NA LINHA DE COMANDO (4)

Principais Áreas de Conhecimento:

    Usar comandos simples de shell e sequências de comandos de apenas uma linha para executar tarefas básicas na linha de comando.
    Usar e modificar o ambiente de shell incluindo definir, fazer referência e exportar variáveis de ambiente.
    Usar e editar o histórico de comandos.
    Invocar comandos de dentro e de fora do caminho definido.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    bash
    echo
    env
    export
    pwd
    set
    unset
    man
    uname
    history
    .bash_history
    type
    PATH
    Variáveis de ambiente
    Comandos sequenciais
    Uso de aspas
    alias
    which
    Quoting

103.2 PROCESSAR FLUXOS DE TEXTO USANDO FILTROS (2)

Principais Áreas de Conhecimento:

    Enviar arquivos de texto e saídas de fluxo de textos através de filtros para modificar a saída usando comandos padrão UNIX encontrados no pacote 'GNU textutils'.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    bzcat
    cat
    cut
    head
    less
    md5sum
    checksums
    nl
    od
    paste
    sed
    sha256sum
    sha512sum
    sort
    split
    tail
    tr
    uniq
    wc
    xzcat
    zcat
    less

103.3 GERENCIAMENTO BÁSICO DE ARQUIVOS (4)

Principais Áreas de Conhecimento:

    Copiar, mover e remover arquivos e diretórios individualmente.
    Copiar múltiplos arquivos e diretórios recursivamente.
    Remover arquivos e diretórios recursivamente.
    Uso simples e avançado dos caracteres curinga nos comandos.
    Usar o comando find para localizar e tratar arquivos tomando como base o tipo, o tamanho ou a data.
    Uso dos utilitários tar, cpio e dd.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    cd
    ls
    cp
    find
    mkdir
    mv
    rm
    rmdir
    touch
    tar
    cpio
    dd
    file
    gzip
    gunzip
    bzip2
    bunzip2
    xz
    unxz
    File globbing (englobamento de arquivos)
    cpio, dd

103.4 FLUXOS, PIPES (CANALIZAÇÃO) E REDIRECIONAMENTOS DE SAÍDA (4)

Principais Áreas de Conhecimento:

    Redirecionamento da entrada padrão, da saída padrão e dos erros padrão.
    Canalização (piping) da saída de um comando à entrada de outro comando.
    Usar a saída de um comando como argumento para outro comando.
    Enviar a saída de um comando simultaneamente para a saída padrão e um arquivo.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    tee
    xargs
    Redirecionamento in/out/error com pipe
    xargs, subcomandos
    Outros Redirecionadores

103.5 CRIAÇÃO, MONITORAMENTO E FINALIZAÇÃO DE PROCESSOS (4)

Principais Áreas de Conhecimento:

    Executar processos em primeiro e segundo plano.
    Marcar um programa para que continue a rodar depois do logout.
    Monitorar processos ativos.
    Selecionar e ordenar processos para serem exibidos.
    Enviar sinais para os processos.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    &
    bg
    fg
    jobs
    kill
    nohup
    ps
    top
    free
    uptime
    pgrep
    pkill
    killall
    watch
    screen
    tmux
    free

103.6 MODIFICAR PRIORIDADE DE EXECUÇÃO DE PROCESSOS (2)

Principais Áreas de Conhecimento:

    Saber a prioridade padrão de um processo que é criado.
    Executar um programa com maior ou menor prioridade do que o padrão.
    Mudar a prioridade de um processo em execução.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    nice
    ps
    renice
    top

103.7 PROCURAR EM ARQUIVOS DE TEXTO USANDO EXPRESSÕES REGULARES (3)

Principais Áreas de Conhecimento:

    Criar expressões regulares contendo vários elementos.
    Entender a diferença entre expressões regulares básicas e estendidas.
    Entender os conceitos de caracteres especiais, classes de caracteres, quantificadores e âncoras.
    Usar ferramentas de expressão regular para realizar pesquisas pelo sistema de arquivos ou no conteúdo de um arquivo.
    Utilizar expressões regulares para apagar, alterar e substituir texto.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    grep
    egrep
    fgrep
    sed
    regex(7)

103.8 EDIÇÃO BÁSICA DE ARQUIVOS USANDO O VI (3)

Principais Áreas de Conhecimento:

    Navegar pelo documento usando o vi.
    Usar os modos básicos do vi.
    Inserir, editar, deletar, copiar e encontrar texto.
    Noções de Emacs, nano e vim.
    Configurar o editor padrão.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    vi
    /, ?
    h,j,k,l
    i, o, a
    d, p, y, dd, yy
    ZZ, :w!, :q!
    EDITOR
    nano, emacs
    Definindo editor padrão

TÓPICO 104 - DISPOSITIVOS, SISTEMAS DE ARQUIVOS LINUX E PADRÃO FHS:

104.1 CRIAR PARTIÇÕES E SISTEMAS DE ARQUIVOS

Principais Áreas de Conhecimento:

    Gerenciar tabela de partição MBR e GPT
    Usar vários comandos mkfs para criar sistemas de arquivos tais como:
        ext2/ext3/ext4
        XFS
        VFAT
        exFAT
    Conhecimento básico dos recursos do Btrfs, incluindo sistema de arquivos em multidispositivos, compressão e subvolumes.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    fdisk
    gdisk
    parted
    mkfs
    mkswap

104.2 MANUTENÇÃO DA INTEGRIDADE DE SISTEMA DE ARQUIVOS

Principais Áreas de Conhecimento:

    Verificar a integridade dos sistemas de arquivos.
    Monitorar os espaços livres e inodes.
    Reparar problemas simples dos sistemas de arquivos.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    du
    df
    fsck
    e2fsck
    mke2fs
    tune2fs
    xfs_repair
    xfs_fsr
    xfs_db

104.3 CONTROLE DA MONTAGEM E DESMONTAGEM DO SISTEMA DE ARQUIVOS

Principais Áreas de Conhecimento:

    Montar e desmontar manualmente sistemas de arquivos.
    Configurar a montagem dos sistemas de arquivos no início do sistema.
    Configurar sistemas de arquivos removíveis e montáveis pelo usuário.
    Utilização de etiquetas (labels) e UUIDs para identificar e montar sistemas de arquivos.
    Noções de unidades de montagem do systemd.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/fstab
    /media/
    mount
    umount
    blkid
    lsblk

104.4 REMOVIDO

104.5 CONTROLE DE PERMISSÕES E PROPRIEDADE DE ARQUIVOS

Principais Áreas de Conhecimento:

    Gerenciar permissões de acesso a arquivos comuns e especiais, bem como aos diretórios.
    Usar os modos de acesso tais como suid, sgid e o sticky bit (bit de aderência) para manter a segurança.
    Saber como mudar a máscara de criação de arquivo.
    Usar o campo de grupo para conceder acesso para grupos de trabalho.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    chmod
    umask
    chown
    chgrp

104.6 CRIAÇÃO E ALTERAÇÃO DE LINKS SIMBÓLICOS E HARDLINKS

Principais Áreas de Conhecimento:

    Criar links.
    Identificar links simbólicos e/ou hardlinks.
    Copiar arquivos versus criar links de arquivos.
    Usar links para dar suporte a tarefas de administração do sistema.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    ln
    ls

104.7 LOCALIZAÇÃO DE ARQUIVOS DE SISTEMA

Principais Áreas de Conhecimento:

    Entender a localização correta dos arquivos dentro do FHS.
    Encontrar arquivos e comandos em um sistema Linux.
    Conhecer a localização e a finalidade de arquivos e diretórios importantes definidos no FHS.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    find
    locate
    updatedb
    whereis
    which
    type
    /etc/updatedb.conf

##########          EXAME 102 (105 A 110)            ##########

TÓPICO 105 - SHELL E SCRIPTS:

105.1 PERSONALIZAR E TRABALHAR NO AMBIENTE DO SHELL

Principais Áreas de Conhecimento:

    Definir variáveis de ambiente (por exemplo, PATH) no início da sessão ou quando abrir um novo shell.
    Escrever funções Bash para sequências de comandos frequentemente usadas.
    Manter o esqueleto de diretórios (skeleton) para novas contas de usuários.
    Definir os caminhos de busca de comandos para apontar para os diretórios corretos.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    .
    source
    /etc/bash.bashrc
    /etc/profile
    env
    export
    set
    unset
    ~/.bash_profile
    ~/.bash_login
    ~/.profile
    ~/.bashrc
    ~/.bash_logout
    function
    alias

105.2 EDITAR E ESCREVER SCRIPT BÁSICOS

Principais Áreas de Conhecimento:

    Usar a sintaxe padrão sh (repetição, testes).
    Usar a substituição de comandos.
    Valores retornados por um sucesso ou falha de teste ou outra informação fornecida por um comando.
    Executar comandos encadeados.
    Enviar mensagens para o superusuário.
    Selecionar corretamente o interpretador de script através da linha shebang (#!).
    Gerenciar a localização, propriedade, permissão e permissão suid dos scripts.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    for
    while
    test
    if
    read
    seq
    exec
    ||
    &&

TÓPICO 106 INTERFACES DE USUÁRIOS E DESKTOPS:

106.1 INSTALAÇÃO E CONFIGURAÇÃO DO X11

Principais Áreas de Conhecimento:

    Entendimento da arquitetura do X11.
    Entendimento e conhecimento básico do arquivo de configuração do X Window.
    Substituir aspectos específicos da configuração do Xorg, como o layout de teclado.
    Entendimento dos componentes de um ambiente de desktop, como gerenciadores de display e gerenciadores de janelas.
    Controlar o acesso ao servidor X e exibir aplicativos em servidores X remotos.
    Noções do Wayland.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/X11/xorg.conf
    /etc/X11/xorg.conf.d/
    ~/.xsession-errors
    xhost
    xauth
    DISPLAY
    X

106.2 DESKTOPS GRÁFICOS

Principais Áreas de Conhecimento:

    Noções dos principais ambientes de desktop
    Noções dos protocolos utilizados para acessar sessões de desktop remoto.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    KDE
    Gnome
    Xfce
    X11
    XDMCP
    VNC
    Spice
    RDP

106.3 ACESSIBILIDADE

Principais Áreas de Conhecimento:

    Conhecimento básico das configurações visuais e temas.
    Conhecimento básico das tecnologias assistivas.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    Temas de Alto Contraste/Texto Grande.
    Leitor de Tela.
    Display Braille.
    Lente de Aumento.
    Teclado Virtual.
    Teclas de aderência e repetição.
    Teclas de alternância.
    Teclas no mouse.
    Gestos.
    Reconhecimento de fala.

TÓPICO 107 - TAREFAS ADMINISTRATIVAS:

107.1 ADMINISTRAR CONTAS DE USUÁRIOS, GRUPOS E ARQUIOVS DE SISTEMA

Principais Áreas de Conhecimento:

    Adicionar, modificar e remover usuários e grupos.
    Gerenciar informações de usuários/grupos em banco de dados senhas/grupos.
    Criar e administrar contas com propósitos especiais e contas limitadas.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/passwd
    /etc/shadow
    /etc/group
    /etc/skel/
    chage
    getent
    groupadd
    groupdel
    groupmod
    passwd
    useradd
    userdel
    usermod

107.2 AUTOMATIZAR E AGENDAR TAREFAS ADMINISTRATIVAS DE SISTEMA

Principais Áreas de Conhecimento:

    Gerenciar tarefas usando cron e at.
    Configurar o acesso dos usuários a serviços cron e at.
    Entender os unidades temporizadoras (timers) do systemd.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/cron.{d,daily,hourly,monthly,weekly}/
    /etc/at.deny
    /etc/at.allow
    /etc/crontab
    /etc/cron.allow
    /etc/cron.deny
    /var/spool/cron/
    crontab
    at
    atq
    atrm
    systemctl
    systemd-run

107.3 LOCALIZAÇÃO E INYTERNACIONALIZAÇÃO

Principais Áreas de Conhecimento:

    Configurar idioma e variáveis de ambiente.
    Configurar fuso horário e variáveis de ambiente.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/timezone
    /etc/localtime
    /usr/share/zoneinfo/
    LC_*
    LC_ALL
    LANG
    TZ
    /usr/bin/locale
    tzselect
    timedatectl
    date
    iconv
    UTF-8
    ISO-8859
    ASCII
    Unicode

TÓPICO 108 - SERVIÇOS ESSENCIAIS DO SISTEMA:

108.1 MANUTENÇÃO DE HORA E DATA DO SISTEMA

Principais Áreas de Conhecimento:

    Definir a data e a hora do sistema.
    Definir o relógio do hardware com a hora correta em UTC.
    Configurar o fuso horário correto.
    Configuração básica do NTP usando o ntpd e o chrony.
    Conhecimento de como usar o serviço pool.ntp.org.
    Noções do comando ntpq.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /usr/share/zoneinfo/
    /etc/timezone
    /etc/localtime
    /etc/ntp.conf
    /etc/chrony.conf
    date
    hwclock
    timedatectl
    ntpd
    ntpdate
    chronyc
    pool.ntp.org

108.2 LOGS DO SISTEMA

Principais Áreas de Conhecimento:

    Configuração básica do rsyslog.
    Entendimento das facilidades (facilities), prioridades (priorities) e ações padrão.
    Consultar o diário (journal) do systemd.
    Filtrar o diário (journal) do systemd utilizando critérios como data, serviço ou prioridade.
    Apagar informações antigas do diário (journal) do systemd.
    Recuperar as informações do diário (journal) do systemd a partir de um sistema em manutenção ou uma cópia do sistema de arquivos.
    Entender a interação entre o rsyslog e o systemd-journald.
    Configuração do logrotate.
    Noções do syslog e do syslog-ng.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/rsyslog.conf
    /var/log/
    logger
    logrotate
    /etc/logrotate.conf
    /etc/logrotate.d/
    journalctl
    systemd-cat
    /etc/systemd/journald.conf
    /var/log/journal/

108.3 FUNDAMENTOS DE MTA (MAIL TRANSFER AGENT)

Principais Áreas de Conhecimento:

    Criar aliases de e-mail.
    Configurar o redirecionamento de e-mail.
    Conhecimento sobre os programas MTA comumente usados (postfix, sendmail, qmail, exim) (não é cobrada a configuração desses programas)

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    ~/.forward
    Comandos que simulam o sendmail
    newaliases
    mail
    mailq
    postfix
    sendmail
    exim

108.4 CONFIGURAÇÃO DE IMPRESSORA E IMPRESSÃO

Principais Áreas de Conhecimento:

    Configuração básica do CUPS (para impressoras locais e remotas).
    Gerenciar a fila de impressão do usuário.
    Resolução de problemas gerais de impressão.
    Adicionar e remover trabalhos da fila de impressão de impressoras configuradas.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    Arquivos de configuração do CUPS, ferramentas e utilitários
    /etc/cups/
    Interface legada lpd (lpr, lprm, lpq)

TÓPICO 109 FUNDAMENTOS DE REDE:

109.1 FUNDAMENTOS DE PROTOCOLOS DE INTERNET

Principais Áreas de Conhecimento:

    Demonstrar um conhecimento adequado sobre máscaras de rede e a notação CIDR.
    Conhecimento sobre as diferenças entre endereços públicos de IP e reservados para uso de redes privadas (notação "dotted quad").
    Conhecimento sobre as portas e serviços TCP e UDP mais comuns (20, 21, 22, 23, 25, 53, 80, 110, 123, 139, 143, 161, 162, 389, 443, 465, 514, 636, 993, 995).
    Conhecimento sobre as diferenças e principais características dos protocolos UDP, TCP e ICMP.
    Conhecimento das principais diferenças entre IPv4 e IPv6.
    Conhecimento sobre as características básicas do IPv6.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/services
    IPv4, IPv6
    Subredes
    TCP, UDP, ICMP

109.2 CONFIGURAÇÃO PERSISTENTE DE REDE

Principais Áreas de Conhecimento:

Configure ethernet and wi-fi network configuration using NetworkManager Awareness of systemd-networkd

    Configuração básica de um host TCP/IP.
    Configurar a ethernet e a rede wi-fi usando o NetworkManager.
    Noções do systemd-networkd.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/hostname
    /etc/hosts
    /etc/nsswitch.conf
    /etc/resolv.conf
    nmcli
    hostnamectl
    ifup
    ifdown

109.3 SOLUÇÃO DE PROBLEMAS SIMPLES DE REDE

Principais Áreas de Conhecimento:

    Configuração manual de interfaces de rede, incluindo verificar e alterar a configuração de interfaces de rede usando o iproute2.
    Configuração manual de tabelas de roteamento, incluindo verificar e alterar a tabela de rotas e definir a rota padrão usando o iproute2.
    Solucionar problemas associados com a configuração da rede.
    Noções dos comandos legados do net-tools.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    ip
    hostname
    ss
    ping
    ping6
    traceroute
    traceroute6
    tracepath
    tracepath6
    netcat
    ifconfig
    netstat
    route

109.4 CONFIGURAÇÃO DE DNS CLIENT

Principais Áreas de Conhecimento:

    Consultar servidores DNS remotos.
    Configurar a resolução local de nomes e o uso de servidores DNS remotos.
    Modificar a ordem em que a resolução de nomes é feita.
    Identificar erros relacionados à resolução de nomes.
    Noções do systemd-resolved.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/hosts
    /etc/resolv.conf
    /etc/nsswitch.conf
    host
    dig
    getent

TÓPICO 110 SEGURANÇA:

110.1 TAREFAS ADMINISTRATIVAS DE SEGURANÇA

Principais Áreas de Conhecimento:

    Auditar um sistema para encontrar arquivos com os bits suid/sgid ligados.
    Definir ou modificar as senhas dos usuários e as informações de expiração das senhas.
    Ser capaz de usar o nmap e o netstat para descobrir portas abertas em um sistema.
    Definir limites sobre os logins do usuário, processos e uso de memória.
    Determinar quais usuários se conectaram ao sistema ou estão conectados no momento.
    Uso e configuração básica do sudo.

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    find
    passwd
    fuser
    lsof
    nmap
    chage
    netstat
    sudo
    /etc/sudoers
    su
    usermod
    ulimit
    who, w, last

110.2 SEGURANÇA DO HOST

Principais Áreas de Conhecimento:

    Saber que existem senhas sombreadas (shadow) e como elas funcionam.
    Desligar os serviços de rede que não estão em uso.
    Entender a função do TCP wrappers.

## Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    /etc/nologin
    /etc/passwd
    /etc/shadow
    /etc/xinetd.d/
    /etc/xinetd.conf
    systemd.socket
    /etc/inittab
    /etc/init.d/
    /etc/hosts.allow
    /etc/hosts.deny

110.3 PROTEÇÃO DE DADOS COM CRIPTOGRAFIA

Principais Áreas de Conhecimento:

    Fazer uso e realizar a configuração básica do cliente OpenSSH 2.
    Entender a finalidade das chaves de servidor no OpenSSH 2.
    Configuração básica do GnuPG, seu uso e revogação.
    Usar o GPG para criptografar, descriptografar e verificar arquivos.
    Entender os túneis de porta do SSH (incluindo túneis X11).

Segue abaixo uma lista parcial dos arquivos, termos e utilitários usados:

    ssh
    ssh-keygen
    ssh-agent
    ssh-add
    ~/.ssh/id_rsa e id_rsa.pub
    ~/.ssh/id_dsa e id_dsa.pub
    ~/.ssh/id_ecdsa e id_ecdsa.pub
    ~/.ssh/id_ed25519 e id_ed25519.pub
    /etc/ssh/ssh_host_rsa_key e ssh_host_rsa_key.pub
    /etc/ssh/ssh_host_dsa_key e ssh_host_dsa_key.pub
    /etc/ssh/ssh_host_ecdsa_key e ssh_host_ecdsa_key.pub
    /etc/ssh/ssh_host_ed25519_key e ssh_host_ed25519_key.pub
    ~/.ssh/authorized_keys
    ssh_known_hosts
    gpg
    gpg-agent
    ~/.gnupg/
