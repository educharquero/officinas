# 🌐 Guia de Estudos - Certificação LPIC-1

## Este guia contém os principais tópicos cobrados no exame **LPIC-1**.

<a href="https://www.lpi.org/pt-br/our-certifications/lpic-1-overview/" target="_blank">Visite a página do Linux Professional Institute aqui.</a>

---

## Sumário

  - [Exame 101](#exame-101-topicos-101-a-104)
  - [Tópico 101 - Arquitetura do Sistema](#topico-101-arquitetura-do-sistema)
  - [Tópico 102 - Instalação e Gerenciamento de Pacotes](#topico-102-instalacao-e-gerenciamento-de-pacotes)
  - [Tópico 103 - Comandos Linux](#topico-103-comandos-linux)
  - [Tópico 104 - Dispositivos, Sistemas de Arquivos e FHS](#topico-104-dispositivos-sistemas-de-arquivos-e-fhs)
  - [Exame 102](#exame-102-topicos-105-a-110)
  - [Tópico 105 - Shell e Scripts](#topico-105-shell-e-scripts)
  - [Tópico 106 - Interfaces de Usuários e Desktops](#topico-106-interfaces-de-usuarios-e-desktops)
  - [Tópico 107 - Tarefas Administrativas](#topico-107-tarefas-administrativas)
  - [Tópico 108 - Serviços Essenciais do Sistema](#topico-108-servicos-essenciais-do-sistema)
  - [Tópico 109 - Fundamentos de Rede](#topico-109-fundamentos-de-rede)
  - [Tópico 110 - Segurança](#topico-110-seguranca)

---

## Exame 101 (Tópicos 101 a 104)

## Tópico 101 - Arquitetura do Sistema

## 101.1 - Identificar e editar configurações de hardware

**Áreas de Conhecimento**

1. Habilitar/desabilitar periféricos integrados  
2. Configurar sistemas com periféricos externos (ex.: teclado)  
3. Diferenciar tipos de dispositivos de armazenamento  
4. Coldplug x Hotplug  
5. Determinar recursos de hardware  
6. Utilizar ferramentas de listagem (`lsusb`, `lspci`, etc.)  
7. Manipular dispositivos USB  
8. Conceitos: `sysfs`, `udev`, `dbus`  

**Ferramentas e Arquivos**  

- **Diretórios** → `/sys/`, `/proc/`, `/dev/`  
- **Módulos** → `modprobe`, `lsmod`  
- **Listagem** → `lspci`, `lsusb`  


---

## 101.2 - Início (Boot) de Sistema

**Áreas de Conhecimento**

- Comandos/opções de bootloader e kernel  
- Sequência de inicialização do BIOS  
- Conhecimento do **SysVinit** e **systemd**  
- Noções de **Upstart**  
- Logs de eventos de inicialização  

**Ferramentas e Arquivos**  

- **Logs** → `dmesg`  
- **Firmware** → `BIOS`  
- **Boot** → `bootloader`, `kernel`, `initramfs`  
- **Inicialização** → `init`, `SysVinit`, `systemd`  


---

## 101.3 - Runlevels, Boot Targets, Desligar e Reiniciar

**Áreas de Conhecimento**

- Definir runlevel e boot target padrão  
- Alternar entre runlevels/boot targets (modo single user)  
- Desligar/reiniciar pela linha de comando  
- Avisar usuários antes de alterações críticas  
- Encerrar processos corretamente  

**Ferramentas e Arquivos**  

- **Configuração** → `/etc/inittab`, `/etc/init.d/`, `/etc/systemd/`, `/usr/lib/systemd/`  
- **Gerenciamento** → `shutdown`, `init`, `telinit`  
- **Systemd** → `systemd`, `systemctl`  
- **Comunicação** → `wall`  


---

## Tópico 102 - Instalação e Gerenciamento de Pacotes

## Exemplos de ferramentas por categoria:

| Área | Utilitários |
|------|-------------|
| Partições e sistemas de arquivos | `/`, `/var`, `/home`, `/boot`, swap |
| Bootloader (GRUB) | `menu.lst`, `grub.cfg`, `grub-install`, `grub-mkconfig`, `MBR` |
| Bibliotecas compartilhadas | `ldd`, `ldconfig`, `/etc/ld.so.conf`, `LD_LIBRARY_PATH` |
| Debian | `dpkg`, `apt-get`, `apt-cache`, `aptitude`, `/etc/apt/sources.list` |
| RedHat | `rpm`, `yum`, `/etc/yum.conf`, `/etc/yum.repos.d/` |
| Virtualização | Máquinas Virtuais, Contêineres, `cloud-init`, chaves SSH |

---

## Tópico 103 - Comandos Linux

## Organizados por tema:

- **Linha de Comando** → `bash`, `echo`, `env`, `history`, `alias`, `PATH`  
- **Filtros de Texto** → `cat`, `cut`, `head`, `sed`, `sort`, `uniq`, `wc`  
- **Gerenciamento de Arquivos** → `cp`, `mv`, `rm`, `find`, `tar`, `dd`, `gzip`  
- **Pipes e Redirecionamentos** → `tee`, `xargs`, operadores `>`, `>>`, `2>`  
- **Processos** → `ps`, `top`, `kill`, `jobs`, `nohup`, `screen`, `tmux`  
- **Prioridade de Execução** → `nice`, `renice`  
- **Regex em Arquivos** → `grep`, `egrep`, `sed`, `regex(7)`  
- **Edição de Arquivos** → `vi`, `nano`, `emacs`, variáveis `EDITOR`  

---

## Tópico 104 - Dispositivos, Sistemas de Arquivos e FHS

- **Partições e FS** → `fdisk`, `gdisk`, `parted`, `mkfs`, `mkswap`  
- **Integridade FS** → `fsck`, `tune2fs`, `xfs_repair`  
- **Montagem/Desmontagem** → `mount`, `umount`, `/etc/fstab`, `lsblk`  
- **Permissões e Propriedade** → `chmod`, `umask`, `chown`, `chgrp`  
- **Links** → `ln`, `ls`  
- **Localização de Arquivos** → `find`, `locate`, `updatedb`, `which`, `/etc/updatedb.conf`  

---

## Exame 102 (Tópicos 105 a 110)

## Tópico 105 - Shell e Scripts

- **Ambiente de Shell** → `PATH`, `alias`, `~/.bashrc`, `/etc/profile`  
- **Scripts Básicos** → `for`, `while`, `if`, `read`, `exec`, `&&`, `||`  

---

## Tópico 106 - Interfaces de Usuários e Desktops

- **X11** → `/etc/X11/xorg.conf`, `xhost`, `DISPLAY`  
- **Desktops** → KDE, Gnome, Xfce, VNC, RDP  
- **Acessibilidade** → Leitor de Tela, Alto Contraste, Teclado Virtual  

---

## Tópico 107 - Tarefas Administrativas

- **Usuários/Grupos** → `useradd`, `usermod`, `/etc/passwd`, `/etc/shadow`  
- **Automatização** → `cron`, `at`, `systemd timers`  
- **Internacionalização** → `LANG`, `LC_ALL`, `/etc/localtime`, `timedatectl`  

---

## Tópico 108 - Serviços Essenciais do Sistema

- **Hora/Data** → `date`, `hwclock`, `ntpd`, `chrony`  
- **Logs** → `rsyslog`, `logrotate`, `journalctl`  
- **MTA** → `sendmail`, `postfix`, `mail`  
- **Impressão** → `cups`, `lpq`, `lpr`  

---

## Tópico 109 - Fundamentos de Rede

- **Protocolos** → TCP, UDP, ICMP, IPv4, IPv6, portas comuns  
- **Configuração de Rede** → `/etc/hosts`, `nmcli`, `hostnamectl`  
- **Solução de Problemas** → `ping`, `traceroute`, `ip`, `netstat`  
- **DNS Cliente** → `/etc/resolv.conf`, `host`, `dig`, `getent`  

---

## Tópico 110 - Segurança

- **Administração de Segurança** → `find`, `passwd`, `nmap`, `sudo`, `ulimit`  
- **Segurança de Host** → `/etc/shadow`, `/etc/hosts.allow`, `systemd.socket`  
- **Criptografia** → `ssh`, `ssh-keygen`, `gpg`, `authorized_keys`  

---

##  **Dica Final**: estude os comandos na prática, simulando cenários reais em laboratório.

