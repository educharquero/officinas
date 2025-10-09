# LPIC-101.1 - Identificação e Configuração de Hardware

## BIOS - Basic Input/Output System

Ao iniciar um computador, antes mesmo do sistema operacional ser carregado, ocorre uma etapa crucial conhecida como POST (Power-on Self-Test). Durante o POST, os componentes de hardware essenciais, como memória, CPU, teclado, mouse e outras configurações básicas, são verificados e inicializados para assegurar seu funcionamento adequado. Historicamente, até meados dos anos 2000, essa função era desempenhada pelo **BIOS (Basic Input/Output System)**.

A partir do final da primeira década dos anos 2000, sistemas baseados na arquitetura x86 começaram a adotar o **UEFI (Unified Extensible Firmware Interface)** como substituto do BIOS. O UEFI oferece uma implementação mais moderna e robusta, com recursos avançados para identificação, teste, configuração e atualização de firmware. Apesar das diferenças tecnológicas, tanto o BIOS quanto o UEFI cumprem o propósito fundamental de preparar o hardware para a inicialização do sistema operacional.

## IRQ - Interrupt Request

Um **IRQ (Interrupt Request)** é um sinal eletrônico enviado por um dispositivo de hardware à CPU, indicando a necessidade de atenção imediata. Imagine, por exemplo, um modem que precisa processar dados; ele envia um IRQ para a CPU, solicitando que o processador pause sua tarefa atual para atender à requisição do modem. Esse mecanismo é análogo ao *time slice* em sistemas operacionais, mas aplicado a interações entre a CPU e dispositivos físicos, e não apenas a processos lógicos.

Em arquiteturas compatíveis com IBM, os IRQs são numerados de 0 a 15 e possuem prioridades específicas, garantindo que dispositivos mais críticos sejam atendidos primeiro. Atualmente, a maioria dos usuários não precisa se preocupar com a configuração manual de IRQs, pois a tecnologia *Plug and Play* automatiza esse processo. É possível visualizar os IRQs em uso no sistema através do arquivo `/proc/interrupts`. Abaixo, um exemplo de sua saída:

```bash
$ cat /proc/interrupts 
```

```bash
            CPU0       CPU1       CPU2       CPU3       CPU4       CPU5       CPU6       CPU7       
   1:          0          0          0          0          0          0          0      25151 IR-IO-APIC    1-edge      i8042
   8:          0          0          0          0          0          0          0          0 IR-IO-APIC    8-edge      rtc0
   9:     200001          0          0          0          0          0          0          0 IR-IO-APIC    9-fasteoi   acpi
  14:          0          0          0          0          0          0          0          0 IR-IO-APIC   14-fasteoi   INT3455:00
  16:          0          8          0          0          0          0          0          0 IR-IO-APIC   16-fasteoi   i801_smbus, idma64.0, i2c_designware.0
  17:          0          0      28778          0          0          0          0          0 IR-IO-APIC   17-fasteoi   idma64.1, i2c_designware.1
  48:          0          0          0          0          0        464          0          0 IR-IO-APIC   48-fasteoi   SYNA2B61:00
 120:          0          0          0          0          0          0          0          0 DMAR-MSI 1024-edge      dmar0-prq
 121:          0          0          0          0          0          0          0          0 DMAR-MSI    0-edge      dmar0
 122:          0          0          0          0          0          0          0          0 DMAR-MSI    1-edge      dmar1
 123:          0          0          0          0          0          0          0          0 IR-PCI-MSI-0000:00:1d.0    0-edge      PCIe PME, pciehp, PCIe bwctrl
 124:          0          0          0          0          0          0          1          0 IR-PCI-MSI-0000:00:1d.4    0-edge      PCIe PME, PCIe bwctrl
 125:          0          0          0     260700          0          0          0          0 IR-PCI-MSI-0000:00:14.0    0-edge      xhci_hcd
 133:          0          0          0        385          0          0          0          0 IR-PCI-MSIX-0000:06:00.0    0-edge      nvme0q0
 134:          0          0          0          0          0          0          0          0 IR-PCI-MSI-0000:00:17.0    0-edge      ahci[0000:00:17.0]
 135:      53610          0          0          0          0          0          0          0 IR-PCI-MSIX-0000:06:00.0    1-edge      nvme0q1
 136:          0      63442          0          0          0          0          0          0 IR-PCI-MSIX-0000:06:00.0    2-edge      nvme0q2
 137:          0          0      71369          0          0          0          0          0 IR-PCI-MSIX-0000:06:00.0    3-edge      nvme0q3
 138:          0          0          0      59887          0          0          0          0 IR-PCI-MSIX-0000:06:00.0    4-edge      nvme0q4
 139:          0          0          0          0      60997          0          0          0 IR-PCI-MSIX-0000:06:00.0    5-edge      nvme0q5
 140:          0          0          0          0          0      54037          0          0 IR-PCI-MSIX-0000:06:00.0    6-edge      nvme0q6
 141:          0          0          0          0          0          0      63748          0 IR-PCI-MSIX-0000:06:00.0    7-edge      nvme0q7
 142:          0          0          0          0          0          0          0      54660 IR-PCI-MSIX-0000:06:00.0    8-edge      nvme0q8
 143:          0          0          0          0          0        403          0          0    dummy    0  i2c_hid_acpi
 144:          0          0          0          0          0          0          0          0     rmi4    0  rmi4-00.fn34
 145:          0          0          0          0          0          0          0          0     rmi4    1  rmi4-00.fn01
 146:          0          0          0          0          0          0        403          0     rmi4    2  rmi4-00.fn11
 147:          0          0          0          0          0          0          0          0     rmi4    3  rmi4-00.fn11
 148:          0          0          0          0          0          0          0          0     rmi4    4  rmi4-00.fn30
 149:          0          0          0          0          0          0    3764032          0 IR-PCI-MSI-0000:00:02.0    0-edge      i915
 150:          0          0          0          0          0          0          0         79 IR-PCI-MSI-0000:00:16.0    0-edge      mei_me
 151:     740517          0          0          0          0          0          0          0 IR-PCI-MSIX-0000:00:14.3    0-edge      iwlwifi:default_queue
 152:     164836          0          0          0          0          0          0          0 IR-PCI-MSIX-0000:00:14.3    1-edge      iwlwifi:queue_1
 153:          0      14022          0          0          0          0          0          0 IR-PCI-MSIX-0000:00:14.3    2-edge      iwlwifi:queue_2
 154:          0          0      17084          0          0          0          0          0 IR-PCI-MSIX-0000:00:14.3    3-edge      iwlwifi:queue_3
 155:          0          0          0      29655          0          0          0          0 IR-PCI-MSIX-0000:00:14.3    4-edge      iwlwifi:queue_4
 156:          0          0          0          0      35689          0          0          0 IR-PCI-MSIX-0000:00:14.3    5-edge      iwlwifi:queue_5
 157:          0          0          0          0          0     114867          0          0 IR-PCI-MSIX-0000:00:14.3    6-edge      iwlwifi:queue_6
 158:          0          0          0          0          0          0     123114          0 IR-PCI-MSIX-0000:00:14.3    7-edge      iwlwifi:queue_7
 159:          0          0          0          0          0          0          0      69265 IR-PCI-MSIX-0000:00:14.3    8-edge      iwlwifi:queue_8
 160:          0          5          0          0          0          0          0          0 IR-PCI-MSIX-0000:00:14.3    9-edge      iwlwifi:exception
 161:          0          0       7639          0          0          0          0          0 IR-PCI-MSI-0000:00:1f.3    0-edge      snd_hda_intel:card0
 NMI:        299        298        317        302        295        295        260        293   Non-maskable interrupts
 LOC:    6373377    6356794    6408473    6512646    6183443    6435111    6669812    6335419   Local timer interrupts
 SPU:          0          0          0          0          0          0          0          0   Spurious interrupts
 PMI:        299        298        317        302        295        295        260        293   Performance monitoring interrupts
 IWI:      66133      77969      69382      62111      65037      69388    2079035      70050   IRQ work interrupts
 RTR:          6          0          0          0          0          0          0          0   APIC ICR read retries
 RES:      18148      66032      89094      68718      58053      37537      33077      68564   Rescheduling interrupts
 CAL:     789866     689049     570784     547644     500765     482624     481394     507027   Function call interrupts
 TLB:     234091     271370     242552     251695     236393     224611     235211     261823   TLB shootdowns
 TRM:        578        578        578        578        578        578        578        578   Thermal event interrupts
 THR:          0          0          0          0          0          0          0          0   Threshold APIC interrupts
 DFR:          0          0          0          0          0          0          0          0   Deferred Error APIC interrupts
 MCE:          0          0          0          0          0          0          0          0   Machine check exceptions
 MCP:        169        170        170        170        170        170        170        170   Machine check polls
 ERR:          0
 MIS:          0
 PIN:        811        749        658        763        777        905        698        588   Posted-interrupt notification event
 NPI:          0          0          0          0          0          0          0          0   Nested posted-interrupt event
 PIW:          0          0          0          0          0          0          0          0   Posted-interrupt wakeup event
```

Neste exemplo, a primeira coluna indica o número do IRQ. As colunas subsequentes (`CPU0` a `CPU7`) mostram quantas vezes cada CPU processou a interrupção para aquele IRQ específico. Por exemplo, o IRQ 48 foi processado 464 vezes pela `CPU5`, enquanto o IRQ 133 foi processado 385 vezes pela `CPU3`.

## Endereços de Entrada e Saída (I/O)

As portas de Entrada/Saída (I/O) são regiões de memória dedicadas no microprocessador que permitem a comunicação entre a CPU e os dispositivos periféricos. Esses endereços servem como um canal simplificado para a troca de dados, facilitando a interação do processador com o hardware conectado.

É comum que dispositivos utilizem uma única porta ou uma faixa de endereços para suas operações. Por exemplo, um Teclado padrão pode empregar as portas 0060-0060, 0064-0064 e uma saída de vídeo, a porta 03c0-03df. É crucial que cada dispositivo possua um endereço de porta exclusivo para evitar conflitos. Os endereços de I/O atualmente em uso no sistema podem ser consultados através do comando `cat /proc/ioports`.

**Importante:** Para acessar as informações completas dos endereços de I/O, é necessário executar o comando com privilégios de superusuário (`sudo`).

```bash
$ sudo cat /proc/ioports
```

```bash
0000-0cf7 : PCI Bus 0000:00
  0000-001f : dma1
  0020-0021 : pic1
  0040-0043 : timer0
  0050-0053 : timer1
  0060-0060 : keyboard
  0062-0062 : PNP0C09:00
    0062-0062 : EC data
  0064-0064 : keyboard
  0066-0066 : PNP0C09:00
    0066-0066 : EC cmd
  0070-0071 : rtc_cmos
    0070-0071 : rtc0
  0080-008f : dma page reg
  00a0-00a1 : pic2
  00c0-00df : dma2
  00f0-00ff : fpu
  03c0-03df : vga+
  0400-041f : iTCO_wdt
    0400-041f : iTCO_wdt
  0680-069f : pnp 00:00
0cf8-0cff : PCI conf1
0d00-ffff : PCI Bus 0000:00
  164e-164f : pnp 00:00
  1800-1803 : ACPI PM1a_EVT_BLK
  1804-1805 : ACPI PM1a_CNT_BLK
  1808-180b : ACPI PM_TMR
  1810-1815 : ACPI CPU throttle
  1850-1850 : ACPI PM2_CNT_BLK
  1854-1857 : INT3F0D:00
  1860-187f : ACPI GPE0_BLK
  2000-20fe : pnp 00:04
  3000-3fff : PCI Bus 0000:06
  4000-4fff : PCI Bus 0000:01
  5000-503f : 0000:00:02.0
  5040-505f : 0000:00:1f.4
  5060-507f : 0000:00:17.0
    5060-507f : ahci
  5080-5087 : 0000:00:17.0
    5080-5087 : ahci
  5088-508b : 0000:00:17.0
    5088-508b : ahci
```

## Resumo da informação obtida acima

Endereço(s), Dispositivo Identificado e Descrição da Função:

```bash
0000-001f
	
dma1
	
Controlador de Acesso Direto à Memória 1, para transferências de dados sem usar a CPU.
0020-0021
	
pic1
	
Controlador de Interrupção Programável 1, gerencia as interrupções de hardware.
0040-0043
	
timer0
	
Timer do sistema, usado para tarefas de temporização do kernel.
0060-0060, 0064-0064
	
keyboard
	
Controlador do teclado.
0070-0071
	
rtc0 / rtc_cmos
	
Relógio de Tempo Real (Real-Time Clock), mantém a data e a hora do sistema.
00a0-00a1
	
pic2
	
Controlador de Interrupção Programável 2 (em cascata com o pic1).
00c0-00df
	
dma2
	
Controlador de Acesso Direto à Memória 2.
00f0-00ff
	
fpu
	
Unidade de Ponto Flutuante (Floating-Point Unit), parte do processador para cálculos matemáticos.
03c0-03df
	
vga+
	
Controlador de vídeo compatível com o padrão VGA, responsável pela saída de vídeo.
0400-041f
	
iTCO_wdt
	
Intel TCO Watchdog Timer, um mecanismo de segurança que reinicia o sistema se ele travar.
1800-187f
	
ACPI
	
Vários blocos relacionados ao ACPI (Advanced Configuration and Power Interface), que gerencia a energia do sistema (suspensão, hibernação, etc.).
0cf8-0cff
	
PCI conf1
	
Mecanismo de configuração para o barramento PCI.
5060-508b
	
ahci
	
Controlador AHCI (Advanced Host Controller Interface), responsável pela comunicação com dispositivos de armazenamento SATA (HDs, SSDs).
```

## Acesso Direto à Memória (DMA - Direct Memory Access)

O **DMA (Direct Memory Access)** é uma funcionalidade que permite a transferência de dados diretamente entre dispositivos de hardware e a memória principal do sistema, sem a necessidade de intervenção constante da CPU. Isso otimiza o desempenho, liberando o processador para outras tarefas enquanto as transferências de dados ocorrem em segundo plano. As transferências são realizadas através de canais DMA dedicados.

A maioria dos computadores possui controladores DMA que gerenciam esses canais. Tradicionalmente, existem dois controladores, um para os canais 0 a 3 e outro para os canais 4 a 7, totalizando oito canais. Esse sistema de acesso direto à memória contribui significativamente para a alta taxa de transferência de dados em operações de I/O.

Para verificar os canais DMA em uso no sistema, pode-se consultar o arquivo `/proc/dma`:

```bash
$ cat /proc/dma
```

```bash
 4: cascade
```

## Partições Virtuais

As partições virtuais no Linux não armazenam dados de arquivos ou diretórios no sentido tradicional, mas sim informações dinâmicas sobre o estado atual de funcionamento do sistema. Elas são montadas automaticamente a cada inicialização do sistema e fornecem interfaces para o kernel e para o espaço do usuário acessarem dados internos. As principais partições virtuais são:

- **/proc**: Contém informações detalhadas sobre processos ativos, recursos de hardware e configurações do kernel. É uma interface para estruturas de dados internas do kernel.

- **/sys**: Fornece uma interface para o sistema de arquivos `sysfs`, que expõe informações sobre dispositivos de hardware conectados ao sistema. Por exemplo, detalhes sobre dispositivos de rede podem ser encontrados em `/sys/class/net/`, e informações sobre dispositivos Bluetooth em `/sys/class/bluetooth/`.

- **/dev**: Contém referências (arquivos de dispositivo) para todos os dispositivos de hardware do sistema, incluindo dispositivos de armazenamento. O gerenciamento dinâmico desses arquivos é feito pelo `udev`.
  
  - **udev**: O `udev` (Device Manager) é o subsistema do kernel Linux responsável por gerenciar dinamicamente os dispositivos. Ele detecta a conexão e desconexão de hardware (como dispositivos USB ou discos rígidos) e cria ou remove os arquivos de dispositivo correspondentes em `/dev`.
  
  - **dbus (atual) / hald (antigo)**: São sistemas de comunicação entre processos que informam aos aplicativos sobre o estado e eventos dos dispositivos de hardware. O `dbus` é a implementação moderna para essa comunicação.

### Recuperação de Sistema: Montando Partições Virtuais

Em cenários de recuperação de sistema, pode ser necessário montar manualmente essas partições virtuais para acessar informações ou realizar reparos. Os comandos para montá-las são:

- Para montar `/proc`:
  
  ```bash
  sudo mount -t proc none /proc
  ```

- Para montar `/sys` (sysfs):
  
  ```bash
  sudo mount -t sysfs none /sys
  ```

- Para montar `/dev` (udev):
  
  ```bash
  sudo mount -t devtmpfs -o bind /dev /dev
  ```

## Conteúdo de `/proc`

O diretório `/proc` é um sistema de arquivos virtual que fornece uma interface para as estruturas de dados internas do kernel. Ele não contém arquivos reais no disco, mas sim informações dinâmicas sobre o estado do sistema e dos processos em execução. Abaixo, exploramos alguns de seus arquivos mais relevantes:

### `/proc/cmdline`

Este arquivo exibe os parâmetros que o *bootloader* (como GRUB) passou para o kernel Linux durante a inicialização do sistema. Esses parâmetros podem incluir a localização da partição raiz, opções de inicialização e outras configurações importantes. Por exemplo:

```bash
$ cat /proc/cmdline 
BOOT_IMAGE=/vmlinuz-6.16.8+deb14-amd64 root=UUID=ebda8b09-bd9f-4ff9-8f77-917471c36c72 ro quiet
```

### `/proc/filesystems`

Este arquivo lista todos os sistemas de arquivos que o kernel Linux suporta atualmente. Ele indica quais tipos de *filesystems* podem ser montados e utilizados no sistema. A coluna `nodev` indica sistemas de arquivos que não estão associados a um dispositivo físico.

```bash
$ cat /proc/filesystems
```

```bash
nodev	sysfs
nodev	tmpfs
nodev	bdev
nodev	proc
nodev	cgroup
nodev	cgroup2
nodev	devtmpfs
nodev	debugfs
nodev	tracefs
nodev	securityfs
nodev	sockfs
nodev	bpf
nodev	pipefs
nodev	ramfs
nodev	hugetlbfs
nodev	devpts
	fuseblk
nodev	fuse
nodev	fusectl
nodev	virtiofs
nodev	mqueue
nodev	pstore
	ext3
	ext2
	ext4
nodev	autofs
nodev	configfs
nodev	binfmt_misc
nodev	rpc_pipefs
nodev	nfsd
nodev	overlay
```

### `/proc/mounts`

Este arquivo fornece uma lista detalhada de todos os sistemas de arquivos e partições que estão montados no sistema, incluindo suas opções de montagem. É uma fonte de informação valiosa para entender como o armazenamento está sendo utilizado.

```bash
$ cat /proc/mounts
```

```bash
sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
udev /dev devtmpfs rw,nosuid,relatime,size=9972552k,nr_inodes=2493138,mode=755,inode64 0 0
devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=5,mode=600,ptmxmode=000 0 0
tmpfs /run tmpfs rw,nosuid,nodev,noexec,relatime,size=2003308k,mode=755,inode64 0 0
/dev/nvme0n1p2 / ext4 rw,relatime,errors=remount-ro 0 0
securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /dev/shm tmpfs rw,nosuid,nodev,inode64 0 0
cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot 0 0
none /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=700 0 0
systemd-1 /proc/sys/fs/binfmt_misc autofs rw,relatime,fd=41,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=1392 0 0
mqueue /dev/mqueue mqueue rw,nosuid,nodev,noexec,relatime 0 0
hugetlbfs /dev/hugepages hugetlbfs rw,nosuid,nodev,relatime,pagesize=2M 0 0
debugfs /sys/kernel/debug debugfs rw,nosuid,nodev,noexec,relatime 0 0
tracefs /sys/kernel/tracing tracefs rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /tmp tmpfs rw,nosuid,nodev,size=10016528k,nr_inodes=1048576,inode64 0 0
fusectl /sys/fs/fuse/connections fusectl rw,nosuid,nodev,noexec,relatime 0 0
tmpfs /run/credentials/systemd-journald.service tmpfs ro,nosuid,nodev,noexec,relatime,nosymfollow,size=1024k,nr_inodes=1024,mode=700,inode64,noswap 0 0
configfs /sys/kernel/config configfs rw,nosuid,nodev,noexec,relatime 0 0
/dev/nvme0n1p1 /boot ext4 rw,relatime 0 0
binfmt_misc /proc/sys/fs/binfmt_misc binfmt_misc rw,nosuid,nodev,noexec,relatime 0 0
sunrpc /run/rpc_pipefs rpc_pipefs rw,relatime 0 0
nfsd /proc/fs/nfsd nfsd rw,relatime 0 0
overlay /var/lib/docker/overlay2/5b151ac374e80432efcb0bfde4e14ed5c238db825767c2d2ff6d4141ab5975c3/merged overlay rw,relatime,lowerdir=/var/lib/docker/overlay2/l/CYS4ELAEKWSKWJ44IYWYIP32ID:/var/lib/docker/overlay2/l/RAY5PXS7WSHVFW4PV6AM6AIJW7:/var/lib/docker/overlay2/l/Q5YREHOL2643IXD5DVPQY2FES3:/var/lib/docker/overlay2/l/2JHQNWXDAXRTHE7G2ZUURCM2MD:/var/lib/docker/overlay2/l/RV2TOVPYR7ULE6MM5RB4DIREY6:/var/lib/docker/overlay2/l/2KYKEEZMA7OATCFO4264ZKDVUT:/var/lib/docker/overlay2/l/F7NZFLSQO3G7F4D4SMF45LFJMR:/var/lib/docker/overlay2/l/UCRKUTNKUGWIWXTZY6YAKMKYCT:/var/lib/docker/overlay2/l/5TBIABCVK52CEFOLUOCLGSKO4B:/var/lib/docker/overlay2/l/7OVEXL6YTCQKH6NLU2U7NHH2SK:/var/lib/docker/overlay2/l/PG4RWL33FJ2RLKJI3PZUFMWXFU:/var/lib/docker/overlay2/l/3ICMVTFWUM5U23KFKUYUBVFXNY:/var/lib/docker/overlay2/l/F6EGGCID6J33Y5EHTKM3FZMJK5:/var/lib/docker/overlay2/l/DJLDIFUAC5RYVCRTKBXGH7VVUQ:/var/lib/docker/overlay2/l/D6345QDXWMPWEOAF32DTWWS2ZO:/var/lib/docker/overlay2/l/ZFPEBAPDFWJV7JDDVNEAGJMHHC,upperdir=/var/lib/docker/overlay2/5b151ac374e80432efcb0bfde4e14ed5c238db825767c2d2ff6d4141ab5975c3/diff,workdir=/var/lib/docker/overlay2/5b151ac374e80432efcb0bfde4e14ed5c238db825767c2d2ff6d4141ab5975c3/work 0 0
nsfs /run/docker/netns/97abc155ca7a nsfs rw 0 0
tmpfs /run/user/1000 tmpfs rw,nosuid,nodev,relatime,size=2003304k,nr_inodes=500826,mode=700,uid=1000,gid=1000,inode64 0 0
gvfsd-fuse /run/user/1000/gvfs fuse.gvfsd-fuse rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
portal /run/user/1000/doc fuse.portal rw,nosuid,nodev,relatime,user_id=1000,group_id=1000 0 0
```

## UDEV

O **udev** é o gerenciador de dispositivos do kernel Linux, encarregado de detectar, nomear e configurar dispositivos de hardware de forma dinâmica, ou seja, à medida que são conectados ou desconectados do sistema. Em sistemas Linux modernos que utilizam o SystemD, o daemon do udev é executado como `systemd-udevd`, o que demonstra sua integração profunda com o gerenciador de serviços do sistema.

O funcionamento do udev baseia-se no conceito de *hotplug*, o que significa que ele reage a eventos de hardware em tempo real. Sempre que um dispositivo é conectado (como um pendrive, disco rígido, teclado ou mouse), o udev intercepta esse evento (conhecido como *uevent*) e aplica um conjunto de regras predefinidas para lidar com o dispositivo. Essas regras determinam aspectos como permissões de acesso, nomes simbólicos, associação a grupos e a execução de scripts específicos.

Após o processamento do evento, o udev cria dinamicamente um arquivo de dispositivo no diretório `/dev/`, permitindo que o kernel e os programas do espaço de usuário interajam com o hardware recém-detectado.

Para interagir com o sistema udev, utiliza-se o comando `udevadm` (embora não seja um tópico diretamente cobrado na certificação LPIC-1). Este comando oferece funcionalidades como monitoramento de eventos em tempo real (`udevadm monitor`), teste de regras, recarregamento de regras e consulta de informações sobre dispositivos.

Por exemplo, para monitorar os eventos do udev em tempo real:

```bash
sudo udevadm monitor
```

Este comando exibirá tanto os *uevents* do kernel quanto os eventos do udev processados à medida que os dispositivos são conectados ou removidos.

As regras do udev, que controlam o comportamento de cada tipo de dispositivo, são definidas em arquivos com a extensão `.rules`. As regras padrão do sistema são armazenadas em `/lib/udev/rules.d/`. Para criar ou modificar regras personalizadas, o diretório `/etc/udev/rules.d/` deve ser utilizado, pois as regras definidas aqui têm prioridade sobre as do sistema e não são sobrescritas por atualizações. Essas regras permitem configurar o comportamento de dispositivos específicos com base em seus atributos, como ID do fabricante, tipo de barramento ou nome.

O udev opera sobre um sistema de arquivos especial chamado `devtmpfs`, que é montado em `/dev`. Este *filesystem* é mantido em memória RAM (similar ao `tmpfs`), o que significa que os arquivos de dispositivo não são persistentes no disco. Eles são criados dinamicamente na inicialização do sistema e removidos ao desligar a máquina, sendo gerenciados em tempo real pelo udev.

## Módulos do Kernel

Para que um sistema operacional funcione de maneira eficiente, o kernel precisa ser capaz de reconhecer e interagir com o hardware conectado. Tradicionalmente, isso exigiria a recompilação do kernel a cada nova adição de hardware, um processo que pode ser complexo e demorado.

O Linux adota o conceito de **modularidade** para contornar essa dificuldade. Isso significa que muitos *drivers* e funcionalidades podem ser compilados como módulos separados, que o sistema pode carregar e descarregar dinamicamente conforme a necessidade. Essa abordagem permite que apenas os módulos essenciais estejam ativos, otimizando o uso de recursos e eliminando a necessidade de recompilar o kernel para cada mudança de hardware.

É importante notar que nem todos os recursos podem ser modularizados. Alguns são compilados diretamente no kernel (conhecidos como *built-in*) e não podem ser removidos ou carregados dinamicamente. Outros são módulos externos, que podem ser inseridos ou removidos em tempo de execução.

Os módulos do kernel são armazenados no diretório `/lib/modules/`, que é organizado em subpastas por versão do kernel. Cada versão possui seu próprio conjunto de módulos, identificados pela extensão `.ko` (Kernel Object).

Para visualizar os módulos atualmente carregados no sistema, pode-se consultar o arquivo `/proc/modules`. O comando `lsmod` lê as informações desse arquivo para gerar sua saída. Para verificar os módulos disponíveis para o kernel ativo, utilize o comando `ls /lib/modules/$(uname -r)/kernel/`.

É possível criar apelidos (aliases) para os módulos do kernel, facilitando seu carregamento. Esses apelidos são configurados em arquivos dentro do diretório `/etc/modprobe.d/`, como no exemplo a seguir, no arquivo `/etc/modprobe.d/alias.conf`:

```bash
# /etc/modprobe.d/alias.conf
alias wireless_driver iwlwifi
alias som onboard snd_hda_intel
```

Com essa configuração, ao executar `modprobe wireless_driver`, o sistema carregará o módulo `iwlwifi`.

## Módulos Internos (Built-In) e Externos

No Linux, os módulos do kernel podem ser classificados em dois tipos principais: **Built-In** e **externos**. Os módulos Built-In são aqueles compilados diretamente no kernel, tornando-se parte integrante dele. Já os módulos externos são compilados separadamente e podem ser carregados ou removidos dinamicamente em tempo de execução.

Para identificar o tipo de um módulo, pode-se inspecionar o arquivo de configuração do kernel (`/boot/config-<versão_do_kernel>`). Módulos marcados com `m` são externos, enquanto os marcados com `y` são Built-In. Veja os exemplos abaixo (testes realizados em uma máquina virtual):

### Verificando um módulo:

```bash
$ cat /boot/config-6.16.8+deb14-amd64
```

Outra maneira de verificar o tipo de módulo é utilizando o comando `modinfo`

```bash
modinfo -h
```

```bash
Usage:
	modinfo [options] <modulename|filename> [args]
Options:
	-a, --author                Print only 'author'
	-d, --description           Print only 'description'
	-l, --license               Print only 'license'
	-p, --parameters            Print only 'parm'
	-n, --filename              Print only 'filename'
	-0, --null                  Use \0 instead of \n
	-m, --modname               Handle argument as module name instead of alias or filename
	-F, --field=FIELD           Print only provided FIELD
	-k, --set-version=VERSION   Use VERSION instead of `uname -r`
	-b, --basedir=DIR           Use DIR as filesystem root for /lib/modules
	-V, --version               Show version
	-h, --help                  Show this help
```

```bash
 modinfo ext4 -d
 ```
 
 ```bash
Fourth Extended Filesystem
root@debian:~#  modinfo ext4 -m
filename:       /lib/modules/6.16.8+deb14-amd64/kernel/fs/ext4/ext4.ko.xz
license:        GPL
description:    Fourth Extended Filesystem
author:         Remy Card, Stephen Tweedie, Andrew Morton, Andreas Dilger, Theodore Ts'o and others
alias:          fs-ext4
alias:          ext3
alias:          fs-ext3
alias:          ext2
alias:          fs-ext2
depends:        jbd2,crc16,mbcache
intree:         Y
name:           ext4
retpoline:      Y
vermagic:       6.16.8+deb14-amd64 SMP preempt mod_unload modversions 
sig_id:         PKCS#7
signer:         Build time autogenerated kernel key
sig_key:        77:EC:43:61:13:91:E5:13:AC:6E:54:40:A7:6B:4B:2F:1F:75:F9:AA
sig_hashalgo:   sha256
signature:      30:64:02:30:64:4A:24:9D:FA:80:AE:AB:C0:98:21:89:79:79:B6:23:
		55:DE:2D:C9:59:B7:91:71:93:F6:05:FA:03:8D:C4:B8:92:3D:3C:80:
		70:82:53:EF:2C:05:54:54:3A:29:6F:86:02:30:54:5C:EC:F0:CC:DA:
		E7:1F:9A:28:73:D5:00:D9:1D:A5:60:A5:16:99:B2:68:33:92:A6:BA:
		9A:1C:DF:AD:DA:87:A8:5C:20:80:D7:D8:3F:D6:A2:4A:6A:1F:1D:B5:
		09:FF

```
## Módulos "em uso" não podem ser descarregados.

```bash
$ sudo modprobe -r ext4
```

```bash
modprobe: FATAL: Module ext4 is in use.
```

Uma forma adicional de identificar módulos é consultando os arquivos `modules` dentro do diretório da versão do kernel:

```bash
$ ls /lib/modules/$(uname -r)/
```

Para mais detalhes, como alias usados no sistema, pode-se usar `cat` neste arquivo:

```bash
$ cat /lib/modules/$(uname -r)/modules.alias
```

## Barramento

O barramento é um sistema de comunicação que permite a transferência de dados entre os componentes de hardware de um computador. Ele é essencial para conectar dispositivos à placa-mãe. Na certificação LPI, os barramentos mais abordados são o **PCI (Peripheral Component Interconnect)** e o **USB (Universal Serial Bus)**.

## LSPCI

O comando `lspci` é utilizado para listar todos os dispositivos conectados ao barramento **PCI (Peripheral Component Interconnect)**. Ele fornece informações detalhadas sobre cada dispositivo, como o tipo de hardware, fabricante e modelo.

### Opções Comuns:

- `-v`: Exibe informações mais detalhadas (pode ser usado como `-vv` ou `-vvv` para níveis crescentes de detalhe).
- `-s <Dominio ou Barramento>:<Dispositivo>.<Função>`: Filtra a saída para mostrar apenas dispositivos em um domínio, barramento, dispositivo e/ou função específicos. Os domínios são numerados de `0` a `ffff`, o barramento de `0` a `ff`, o dispositivo de `0` a `1f` e a função de `0` a `7`.

### Exemplo de Uso:

```bash
$ lspci
```

```bash
00:00.0 Host bridge: Intel Corporation Ice Lake-LP Processor Host Bridge/DRAM Registers (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Iris Plus Graphics G1 (Ice Lake) (rev 07)
00:04.0 Signal processing controller: Intel Corporation Processor Power and Thermal Controller (rev 03)
00:14.0 USB controller: Intel Corporation Ice Lake-LP USB 3.1 xHCI Host Controller (rev 30)
00:14.2 RAM memory: Intel Corporation Ice Lake-LP DRAM Controller (rev 30)
00:14.3 Network controller: Intel Corporation Ice Lake-LP PCH CNVi WiFi (rev 30)
00:15.0 Serial bus controller: Intel Corporation Ice Lake-LP Serial IO I2C Controller #0 (rev 30)
00:15.1 Serial bus controller: Intel Corporation Ice Lake-LP Serial IO I2C Controller #1 (rev 30)
00:16.0 Communication controller: Intel Corporation Ice Lake-LP Management Engine (rev 30)
00:17.0 SATA controller: Intel Corporation Ice Lake-LP SATA Controller [AHCI mode] (rev 30)
00:1d.0 PCI bridge: Intel Corporation Ice Lake-LP PCI Express Root Port #9 (rev 30)
00:1d.4 PCI bridge: Intel Corporation Ice Lake-LP PCIe Port #13 (rev 30)
00:1f.0 ISA bridge: Intel Corporation Ice Lake-LP LPC Controller (rev 30)
00:1f.3 Audio device: Intel Corporation Ice Lake-LP Smart Sound Technology Audio Controller (rev 30)
00:1f.4 SMBus: Intel Corporation Ice Lake-LP SMBus Controller (rev 30)
00:1f.5 Serial bus controller: Intel Corporation Ice Lake-LP SPI Controller (rev 30)
06:00.0 Non-Volatile memory controller: Kingston Technology Company, Inc. NV2 NVMe SSD [SM2267XT] (DRAM-less) (rev 03)
```

## LSUSB

O comando `lsusb` é utilizado para listar os dispositivos conectados ao barramento **USB (Universal Serial Bus)**. Diferente do PCI, o USB não utiliza o conceito de 'função' no mesmo sentido, focando mais no barramento e no número do dispositivo.

### Opções Comuns:

- `-v`: Exibe informações detalhadas sobre os dispositivos (pode ser usado como `-vv` ou `-vvv` para níveis crescentes de detalhe).
- `-s <Barramento>:<Dispositivo>`: Filtra a saída para mostrar apenas um dispositivo específico, identificado pelo número do barramento e do dispositivo.
- `-t`: Apresenta a saída em formato de árvore, mostrando a hierarquia dos dispositivos USB.
- `-d <ID_Vendedor>:<ID_Produto>`: Exibe todos os dispositivos que correspondem a um ID de vendedor e ID de produto específicos.

### Exemplos de Uso:

**Exibindo todos os dispositivos USB:**

```bash
$ lsusb
```

```bash
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 003: ID 04f2:b624 Chicony Electronics Co., Ltd Integrated Camera
Bus 001 Device 005: ID 8087:0aaa Intel Corp. Bluetooth 9460/9560 Jefferson Peak (JfP)
Bus 001 Device 006: ID 3151:3020 YICHIP Wireless Device
Bus 001 Device 013: ID 048d:1234 Integrated Technology Express, Inc. Chipsbank CBM2199 Flash Drive
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
```

**Filtrando por barramento e dispositivo com `-s`:**

```bash
$ lsusb -s 001:006
```

```bash
Bus 005 Device 001: ID 1d6b:006 Linux Foundation 2.0 root hub
```

**Utilizando `-s` e `-v` para detalhes:**

```bash
$ lsusb -s 001:006 -v
```

```bash
Bus 001 Device 006: ID 3151:3020 YICHIP Wireless Device
Couldn't open device, some information will be missing
Negotiated speed: Full Speed (12Mbps)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass            0 [unknown]
  bDeviceSubClass         0 [unknown]
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x3151 YICHIP
  idProduct          0x3020 Wireless Device
  bcdDevice            0.02
  iManufacturer           1 YICHIP
  iProduct                2 Wireless Device
  iSerial                 3 b120300001
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength       0x003b
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              100mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      1 Keyboard
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               2.00
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 (null)
          wDescriptorLength      63
          Report Descriptors: 
            ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               2
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           1
      bInterfaceClass         3 Human Interface Device
      bInterfaceSubClass      1 Boot Interface Subclass
      bInterfaceProtocol      2 Mouse
      iInterface              0 
        HID Device Descriptor:
          bLength                 9
          bDescriptorType        33
          bcdHID               2.00
          bCountryCode            0 Not supported
          bNumDescriptors         1
          bDescriptorType        34 (null)
          wDescriptorLength     163
          Report Descriptors: 
            ** UNAVAILABLE **
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               2               
```

## LSMEM

O comando `lsmem` é uma ferramenta que exibe informações detalhadas sobre a arquitetura de memória do sistema, incluindo a organização e o estado dos blocos de memória. As informações apresentadas por `lsmem` são derivadas do arquivo virtual `/proc/meminfo`, que fornece dados em tempo real sobre o uso da memória pelo kernel.

### Exemplo de Uso:

```bash
$ lsmem
```

```bash
RANGE                                  SIZE   STATE REMOVABLE  BLOCK
0x0000000000000000-0x000000004fffffff  1,3G on-line       sim    0-9
0x0000000100000000-0x000000059fffffff 18,5G on-line       sim 32-179

Tamanho de bloco de memória:     128M
Memória total online:           19,8G
Memória total offline:             0B
```

## Coldplug x Hotplug

No contexto de hardware, os termos **coldplug** e **hotplug** referem-se à capacidade de um dispositivo ser conectado ou desconectado do sistema enquanto ele está ligado ou desligado.

- **Dispositivos Coldplug (Plugagem Fria)**: São aqueles que exigem que o computador esteja completamente desligado para que possam ser conectados ou removidos e reconhecidos corretamente pelo sistema. Exemplos incluem interfaces PS/2, controladoras IDE, placas PCI e ISA.

- **Dispositivos Hotplug (Plugagem Quente)**: São dispositivos que podem ser conectados ou removidos com o sistema em funcionamento, sendo automaticamente detectados e configurados. Exemplos comuns são dispositivos SATA e USB.

## IDE, PATA, SATA e SCSI

Essas siglas representam diferentes interfaces de conexão para dispositivos de armazenamento, como discos rígidos e unidades ópticas, cada uma com suas características e evoluções.

* **(P)ATA - Parallel Advanced Technology Attachment**
  
  Também conhecido como **IDE (Integrated Drive Electronics)**, refere-se a uma interface de conexão paralela. Historicamente, no Linux, esses dispositivos eram mapeados como `hda`, `hdb`, `hdc`, etc. No entanto, em sistemas modernos, independentemente da interface física, muitos dispositivos de armazenamento são mapeados como `sdX` (por exemplo, `sda`, `sdb`), seguindo o padrão de nomenclatura de dispositivos SCSI.
  
  Dispositivos PATA utilizavam um sistema de **Master e Slave**, configurado por *jumpers* no próprio disco rígido, permitindo a conexão de até dois HDs por cabo *flat* (também conhecido como cabo IDE). Um driver de CD/DVD IDE também era referenciado como `hdX`, mas hoje é mais comum vê-lo mapeado como `sr0`.

* **SATA - Serial Advanced Technology Attachment**
  
  O SATA é o sucessor do PATA, oferecendo uma interface serial mais rápida e eficiente. Uma de suas principais vantagens é o suporte a *hot-swap*, que permite a troca de discos com a máquina ligada (uma funcionalidade *hotplug*). Cada cabo SATA conecta apenas um disco, e seu mapeamento no Linux segue o padrão `sda`, `sdb`, `sdc`, etc., alinhando-se com a nomenclatura de dispositivos SCSI.

* **SCSI - Small Computer System Interface**
  
  O SCSI é uma interface de alta performance projetada para transferência rápida de dados, comumente utilizada em servidores e estações de trabalho de alto desempenho. Existem duas variações principais:
  
  * **8 bits**: Permite a conexão de até 7 dispositivos em um único barramento, além de 1 controladora.
  * **16 bits**: Permite a conexão de até 15 dispositivos em um único barramento, além de 1 controladora.
  
  Dispositivos SCSI são identificados por um ID composto por três números: **Canal**, **ID do dispositivo** e **LUN (Logical Unit Number)**. Essas informações podem ser visualizadas com comandos como `lsscsi`, `scsi_info` ou `cat /proc/scsi/scsi`.
  
  * **Canal**: Identifica cada adaptador.
  * **ID**: Identificador único para cada dispositivo.
  * **LUN**: Número lógico da unidade.
  
  O mapeamento de dispositivos SCSI no Linux é similar ao SATA, e informações detalhadas podem ser encontradas em `/proc/scsi/scsi`.

## Outros Dispositivos

Além dos dispositivos de armazenamento mencionados, o Linux atribui nomes específicos a outros tipos de hardware. Alguns exemplos incluem:

- **Disquete (Floppy Disk)**: `/dev/fd0`
- **SCSI CD-Rom**: `/dev/scd0`
- **SCSI DVD**: `/dev/sr0`
- **/dev/dvd**: Geralmente um link simbólico para o dispositivo de DVD real.
- **/dev/cdrom**: Geralmente um link simbólico para o dispositivo de CD-ROM real.

Para verificar os discos que foram conectados ao sistema, é possível consultar os logs do kernel, especificamente o `dmesg`. Este comando exibe as mensagens do *buffer* de mensagens do kernel, que incluem informações sobre a detecção e configuração de hardware durante a inicialização e em tempo de execução.

```bash
sudo dmesg
```

## Módulos no Linux

Os módulos no Linux são componentes de software que podem ser carregados e descarregados do kernel do sistema operacional em tempo de execução, sem a necessidade de reiniciar o sistema. Eles representam uma funcionalidade chave que confere ao kernel Linux sua notável modularidade e flexibilidade.
Conceito e Propósito:
O principal objetivo dos módulos é permitir que o kernel seja mantido o mais compacto possível, carregando apenas o código necessário para o hardware e as funcionalidades em uso. Isso contrasta com um kernel monolítico, onde todo o código para suportar diversos hardwares e recursos é compilado diretamente no kernel, tornando-o maior e menos adaptável. Os módulos são comumente utilizados para:

 -   Drivers de Dispositivo: Suporte a novos hardwares (placas de rede, placas de vídeo, dispositivos USB, etc.) sem recompilar o kernel.
 -   Sistemas de Arquivos: Adicionar suporte a diferentes tipos de sistemas de arquivos (como NTFS, Btrfs, ZFS) conforme a necessidade.
 -   Funcionalidades Específicas: Implementar recursos adicionais do kernel, como criptografia, firewalls (Netfilter) ou virtualização.

Tipos de Módulos:
Existem essencialmente dois tipos:

  -  Módulos Built-In (Internos): Compilados diretamente no kernel. Não podem ser carregados ou descarregados dinamicamente. São essenciais para a inicialização do sistema.
  -  Módulos Externos (Carregáveis): Compilados separadamente e armazenados como arquivos .ko (Kernel Object) em /lib/modules/. Podem ser carregados, descarregados e configurados em tempo de execução.

## LSMOD

O comando `lsmod` é utilizado para listar os módulos do kernel que estão atualmente carregados e ativos no sistema. As informações exibidas por `lsmod` são, na verdade, uma representação formatada do conteúdo encontrado no arquivo virtual `/proc/modules`.

A saída do `lsmod` é organizada em colunas, cada uma fornecendo informações específicas sobre o módulo:

* **Module**: O nome do módulo do kernel.
* **Size**: O tamanho do módulo em bytes.
* **Used by**: Esta coluna indica se o módulo está sendo utilizado por outros módulos e quantas instâncias dele estão ativas. Um valor `0` significa que o módulo está carregado, mas não está em uso por outros módulos. Um valor `-1` pode indicar algum problema. Os nomes listados após o número indicam os módulos que dependem ou estão utilizando o módulo em questão.

## Exemplo de Saída do `lsmod`:

```bash
$ lsmod | sed -n '1p; /i915/p'
```

```bash
Module                  Size  Used by
i915                 4931584  49
drm_buddy              32768  1 i915
ttm                   135168  1 i915
i2c_algo_bit           16384  1 i915
drm_display_helper    299008  1 i915
cec                    77824  2 drm_display_helper,i915
drm_client_lib         12288  1 i915
drm_kms_helper        258048  3 drm_display_helper,drm_client_lib,i915
drm                   835584  24 i2c_hid,drm_kms_helper,drm_display_helper,drm_buddy,drm_client_lib,i915,ttm
video                  81920  2 ideapad_laptop,i915
```

## Analisando os 10 logs do exemplo acima:

1 - i915                 4931584  49

    Este é o módulo principal, que é o driver gráfico da Intel (geralmente para GPUs integradas). Seu tamanho é de aproximadamente 4.9 MB. O número 49 na coluna Used by indica que 49 outros módulos ou processos do kernel estão utilizando o i915. Isso é um número alto, mas esperado para um driver gráfico central, mostrando sua importância e integração com várias partes do sistema gráfico.

2- drm_buddy              32768  1 i915

    O módulo drm_buddy (parte do Direct Rendering Manager) tem 32 KB e está sendo usado por 1 outro módulo, que é o i915. Isso significa que i915 depende de drm_buddy para alguma de suas funcionalidades, provavelmente relacionada ao gerenciamento de memória gráfica.

3 - ttm                   135168  1 i915

    ttm (Translation Table Manager) é um módulo de 135 KB, também usado por 1 outro módulo, o i915. O TTM é crucial para o gerenciamento de memória de vídeo, permitindo que a GPU acesse a memória do sistema de forma eficiente. A dependência de i915 em ttm é fundamental para o desempenho gráfico.


4 - i2c_algo_bit           16384  1 i915

    Este módulo de 16 KB é usado por i915. i2c_algo_bit implementa um algoritmo de software para o barramento I2C (Inter-Integrated Circuit), que é frequentemente usado para comunicação com componentes de hardware de baixo nível, como sensores ou monitores, que podem estar integrados à GPU ou à placa-mãe e são gerenciados pelo driver gráfico.


5 - drm_display_helper    299008  1 i915

    Um módulo de 299 KB, usado por i915. Como o nome sugere, drm_display_helper fornece funções auxiliares para o gerenciamento de displays, o que é uma parte essencial de qualquer driver gráfico.

6 - O módulo cec (Consumer Electronics Control) tem 77 KB e é usado por 2 outros módulos: drm_display_helper e i915. O CEC é um protocolo que permite que dispositivos HDMI se comuniquem entre si. Sua dependência de drm_display_helper e i915 indica que o driver gráfico e seus auxiliares estão envolvidos no controle de dispositivos CEC via HDMI.

7 - drm_client_lib         12288  1 i915

    Uma biblioteca cliente do DRM de 12 KB, usada por i915. Fornece funcionalidades comuns para clientes do DRM
    
8 - drm_kms_helper        258048  3 drm_display_helper,drm_client_lib,i915

    drm_kms_helper (Kernel ModeSetting Helper) é um módulo de 258 KB, usado por 3 outros módulos: drm_display_helper, drm_client_lib e i915. Este módulo é crucial para o Kernel ModeSetting, que permite que o kernel configure e gerencie os modos de exibição diretamente, resultando em uma inicialização gráfica mais suave e rápida.

9 - drm                   835584  24 i2c_hid,drm_kms_helper,drm_display_helper,drm_buddy,drm_client_lib,i915,ttm

    Este é o módulo drm (Direct Rendering Manager) principal, com 835 KB. Ele é usado por 24 outros módulos, incluindo muitos dos que já vimos (drm_kms_helper, drm_display_helper, drm_buddy, drm_client_lib, i915, ttm). O DRM é a base da pilha gráfica moderna do Linux, fornecendo a interface entre os drivers gráficos do kernel e as aplicações de espaço de usuário.

10 - video                  81920  2 ideapad_laptop,i915

    O módulo video (81 KB) é um módulo genérico para controle de vídeo. Ele é usado por 2 outros módulos: ideapad_laptop (provavelmente um módulo específico para laptops Lenovo IdeaPad) e i915. Isso sugere que o driver i915 e o módulo do laptop utilizam as funcionalidades genéricas de vídeo fornecidas por este módulo.
    

Para que módulos sejam carregados automaticamente na inicialização do sistema, eles podem ser adicionados ao arquivo `/etc/modules`, ou arquivos de configuração contendo a lista de módulos podem ser criados em `/etc/modules-load.d/`. Além disso, o diretório `/etc/modprobe.d/` pode ser usado para configurar aliases ou para criar *blacklists* (listas de módulos que não devem ser carregados). É uma boa prática utilizar os diretórios dentro de `/etc/` para configurações personalizadas, pois eles têm prioridade e não são sobrescritos por atualizações do sistema.

## Exemplo de `lsmod` (primeiras linhas):

```bash
$ lsmod | head -15
```

```bash
Module                  Size  Used by
isofs                  61440  0
cdrom                  81920  1 isofs
sg                     45056  0
uas                    32768  0
usb_storage            90112  1 uas
btrfs                2293760  0
blake2b_generic        20480  0
xor                    24576  1 btrfs
raid6_pq              135168  1 btrfs
vhost_net              36864  1
vhost                  69632  1 vhost_net
vhost_iotlb            16384  1 vhost
tap                    32768  1 vhost_net
sd_mod                 90112  0
```

### Conteúdo de `/proc/modules` (primeiras linhas):

```bash
$ head -15 /proc/modules 
```

```bash
isofs 61440 0 - Live 0x0000000000000000
cdrom 81920 1 isofs, Live 0x0000000000000000
sg 45056 0 - Live 0x0000000000000000
uas 32768 0 - Live 0x0000000000000000
usb_storage 90112 1 uas, Live 0x0000000000000000
btrfs 2293760 0 - Live 0x0000000000000000
blake2b_generic 20480 0 - Live 0x0000000000000000
xor 24576 1 btrfs, Live 0x0000000000000000
raid6_pq 135168 1 btrfs, Live 0x0000000000000000
vhost_net 36864 1 - Live 0x0000000000000000
vhost 69632 1 vhost_net, Live 0x0000000000000000
vhost_iotlb 16384 1 vhost, Live 0x0000000000000000
tap 32768 1 vhost_net, Live 0x0000000000000000
sd_mod 90112 0 - Live 0x0000000000000000
snd_seq_dummy 12288 0 - Live 0x0000000000000000
```

### Exibindo módulos que não serão ativados (blacklist):

É possível impedir que certos módulos sejam carregados no sistema utilizando uma *blacklist*. Isso é feito em arquivos de configuração, como o exemplo abaixo, que impede o carregamento do módulo `fbdev`:

(O módulo fbdev escolhido, refere-se a framebuffer devices, que são drivers gráficos genéricos. É comum que esses drivers sejam blacklisted para permitir que drivers gráficos mais modernos e específicos (como i915 para Intel, nouveau para Nvidia ou amdgpu para AMD) assumam o controle da saída de vídeo, oferecendo melhor desempenho e funcionalidades.)

```bash
$ cat /lib/modprobe.d/fbdev-blacklist.conf 
```

```bash
# This file blacklists most old-style PCI framebuffer drivers.
blacklist arkfb
blacklist aty128fb
blacklist atyfb
blacklist radeonfb
blacklist cirrusfb
blacklist cyber2000fb
blacklist kyrofb
blacklist matroxfb_base
blacklist mb862xxfb
blacklist neofb
blacklist pm2fb
blacklist pm3fb
blacklist s3fb
blacklist savagefb
blacklist sisfb
blacklist tdfxfb
blacklist tridentfb
blacklist vt8623fb
```

## MODINFO

O comando `modinfo` é uma ferramenta essencial para obter informações detalhadas sobre um módulo do kernel, independentemente de ele estar carregado ou não. Ele fornece metadados importantes que ajudam a entender a função, dependências e localização de um módulo.

As informações chave fornecidas por `modinfo` incluem:

- `description`: Uma breve explicação sobre a finalidade do módulo.
- `depends`: Lista de outros módulos dos quais este módulo depende para funcionar corretamente.
- `filename`: O caminho completo para o arquivo do módulo no sistema de arquivos.

Além disso, a opção `-n` pode ser usada para exibir apenas o caminho do arquivo do módulo.

### Exemplo de Uso:

Para obter informações sobre o módulo `usb_common`:

```bash
sudo modinfo usb_common
```

```bash
filename:       /lib/modules/6.16.8+deb14-amd64/kernel/drivers/usb/common/usb-common.ko.xz
license:        GPL
description:    Common code for host and device side USB
depends:        
intree:         Y
name:           usb_common
retpoline:      Y
vermagic:       6.16.8+deb14-amd64 SMP preempt mod_unload modversions 
sig_id:         PKCS#7
signer:         Build time autogenerated kernel key
sig_key:        77:EC:43:61:13:91:E5:13:AC:6E:54:40:A7:6B:4B:2F:1F:75:F9:AA
sig_hashalgo:   sha256
signature:      30:66:02:31:00:D8:82:B7:31:DC:46:06:5A:BE:88:5B:75:33:A8:69:
		4C:CE:57:90:71:D2:8C:2D:90:AA:B4:72:86:66:BC:CD:59:36:F3:0C:
		C9:E3:B1:7C:75:F8:80:29:94:AA:76:08:6B:02:31:00:A7:E5:3E:8B:
		F8:D1:A7:00:B4:7C:6D:CD:73:7E:A0:61:E9:57:2E:1F:07:94:E9:A8:
		7E:00:81:EB:84:34:3A:ED:02:D8:57:5F:FA:DE:D3:B3:EB:DA:54:E4:
		21:31:A5:56
```

### Vendo o caminho do módulo com `-n`:

```bash
$ modinfo -n usb_common
```

```bash
/lib/modules/6.16.8+deb14-amd64/kernel/drivers/usb/common/usb-common.ko.xz
```

## RMMOD

O comando `rmmod` é utilizado para descarregar um módulo do kernel que está ativo no sistema. Ao utilizá-lo, é importante omitir a extensão `.ko` do nome do módulo. Embora `rmmod` funcione, a prática recomendada é usar o comando `modprobe -r`, que não só descarrega o módulo especificado, mas também gerencia automaticamente suas dependências, descarregando-as se não estiverem sendo usadas por outros módulos.

### Exemplo de Uso:

Para remover o módulo `psmouse` (disponível em máquinas virtuais para teste):

```bash
lsmod | grep psmouse
```

```bash
$ sudo rmmod psmouse
```

## INSMOD

O comando `insmod` é responsável por carregar um módulo do kernel no sistema. No entanto, ele exige o caminho completo para o arquivo `.ko` do módulo. Assim como no caso do `rmmod`, a recomendação é utilizar o comando `modprobe`, pois ele simplifica o processo ao resolver automaticamente as dependências do módulo, carregando-as conforme necessário.

### Exemplo de Uso:

Antes de usar `insmod`, é preciso saber o caminho completo do módulo. Isso pode ser obtido com `modinfo`:

```bash
$ modinfo psmouse
```

```bash
filename:       /lib/modules/6.16.8+deb14-amd64/kernel/drivers/input/mouse/psmouse.ko.xz
license:        GPL
description:    PS/2 mouse driver
author:         Vojtech Pavlik <vojtech@suse.cz>
alias:          serio:ty05pr*id*ex*
alias:          serio:ty01pr*id*ex*
depends:        
intree:         Y
name:           psmouse
retpoline:      Y
vermagic:       6.16.8+deb14-amd64 SMP preempt mod_unload modversions 
sig_id:         PKCS#7
signer:         Build time autogenerated kernel key
sig_key:        77:EC:43:61:13:91:E5:13:AC:6E:54:40:A7:6B:4B:2F:1F:75:F9:AA
sig_hashalgo:   sha256
signature:      30:64:02:30:73:15:78:4B:F4:F2:A4:B3:FB:80:81:64:80:D2:DB:F6:
		57:62:C1:4F:B3:FF:FF:F8:C7:8A:D0:3F:6C:E4:EC:8B:91:B4:8A:81:
		13:C5:D6:A0:FE:79:8C:A4:D6:10:66:C6:02:30:4F:D9:58:84:80:82:
		7B:E0:D5:C5:0F:40:46:60:A8:38:62:48:D6:8B:7F:42:78:CC:37:ED:
		C6:6D:97:55:4D:11:7D:37:F6:86:47:6A:CA:10:BA:CF:82:06:4C:5B:
		E3:F6
parm:           elantech_smbus:Use a secondary bus for the Elantech device. (int)
parm:           synaptics_intertouch:Use a secondary bus for the Synaptics device. (int)
parm:           proto:Highest protocol extension to probe (bare, imps, exps, any). Useful for KVM switches. (proto_abbrev)
parm:           resolution:Resolution, in dpi. (uint)
parm:           rate:Report rate, in reports per second. (uint)
parm:           smartscroll:Logitech Smartscroll autorepeat, 1 = enabled (default), 0 = disabled. (bool)
parm:           a4tech_workaround:A4Tech second scroll wheel workaround, 1 = enabled, 0 = disabled (default). (bool)
parm:           resetafter:Reset device after so many bad packets (0 = never). (uint)
parm:           resync_time:How long can mouse stay idle before forcing resync (in seconds, 0 = never). (uint)
```

Com o caminho do módulo (`/lib/modules/6.16.8+deb14-amd64/kernel/drivers/input/mouse/psmouse.ko.xz`), pode-se carregá-lo com `insmod`:

```bash
sudo insmod /lib/modules/5.4.0-65-generic/kernel/drivers/input/mouse/psmouse.ko.xz
```

## MODPROBE

O comando `modprobe` é uma ferramenta essencial para gerenciar módulos do kernel Linux.
Sua principal função é adicionar (modprobe <módulo>) ou remover (modprobe -r <módulo>) módulos do kernel em tempo de execução.
Ao contrário de insmod e rmmod, o modprobe resolve automaticamente as dependências de módulos, carregando ou descarregando-as conforme necessário.
Ele consulta arquivos de configuração em /etc/modprobe.d/ e /lib/modprobe.d/.
Isso inclui o uso de apelidos (aliases) para módulos e o respeito a blacklists, que impedem o carregamento de módulos específicos.
modprobe simplifica a interação com o kernel, garantindo que os módulos corretos sejam carregados com suas dependências.
É a forma recomendada para manipular módulos, oferecendo robustez e evitando erros de dependência.
Em suma, é a interface padrão para o gerenciamento dinâmico e inteligente de funcionalidades do kernel.

Modo de operação:

## Carregar um módulo
```bash
modprobe <nome_do_módulo>
```

## Remover um módulo
```bash
modprobe -r <nome_do_módulo>
```

## Mostrar os módulos que serão carregados como dependência
```
modprobe --show-depends módulo
```

## Exemplo de uso

Removendo o módulo 'psmouse' (mouse PS/2):

```bash
$ sudo modprobe -r psmouse
```

Carregando o módulo novamente:

```
$ sudo modprobe psmouse
```

Verificando as dependências do módulo 'btrfs':

```bash
$ sudo modprobe --show-depends btrfs
```
```bash
insmod /lib/modules/6.16.8+deb14-amd64/kernel/lib/raid6/raid6_pq.ko.xz 
insmod /lib/modules/6.16.8+deb14-amd64/kernel/crypto/xor.ko.xz 
insmod /lib/modules/6.16.8+deb14-amd64/kernel/crypto/blake2b_generic.ko.xz 
insmod /lib/modules/6.16.8+deb14-amd64/kernel/fs/btrfs/btrfs.ko.xz
```

## Carregamento automágico de módulos

Pode-se adicionar módulos para que carreguem automaticamente quando o Sistema Operacional subir, adicionando-os ao arquivo /etc/modules:

```bash
vim /etc/modules
```

```bash
psmouse
btrfs
```

Uma alternativa seria o /etc/modules-load.d/psmouse.conf

```bash
echo psmouse > /etc/modules-load.d/psmouse.conf
```

Naturalmente, pode-se impedir o carregamento de um módulo, no boot do Sistema Operacional, adicionando-os ao arquivo /etc/modprobe.d/

```bash
blacklist <nome_do_módulo>
```

```bash
echo "blacklist psmouse" > /etc/modprobe.d/blacklist-psmouse.conf
```

Esse bloqueio impede que o módulo seja carregado automaticamente, mesmo que outro módulo dependa dele. Porém, ainda será possível carregá-lo manualmente com modprobe, a menos que você adicione uma regra mais forte como:

```bash
# /etc/modprobe.d/deny-psmouse.conf
install psmouse /bin/false
```

Isso substitui qualquer tentativa de carregamento do módulo por um comando falso, bloqueando completamente.

## MODPROBE.D

O diretório /etc/modprobe.d/ é o local onde ficam os arquivos de configuração dos módulos do kernel Linux. Esses arquivos permitem personalizar o comportamento do modprobe, a ferramenta usada para carregar e descarregar módulos de forma dinâmica, resolvendo dependências automaticamente.

Os módulos definidos nos arquivos de configuração em /etc/modprobe.d/ não são carregados automaticamente no boot apenas por estarem definidos ali.

O conteúdo desses arquivos define como o sistema deve lidar com os módulos: bloquear, passar parâmetros, criar aliases ou substituir comportamentos padrão.

Esses arquivos são todos lidos pelo modprobe no momento em que você tenta carregar ou remover um módulo, seja manualmente ou automaticamente (por exemplo, ao conectar um hardware que precisa de driver).

Cada arquivo .conf dentro do /etc/modprobe.d/ pode conter instruções como:

* blacklist

Impede que o módulo seja carregado automaticamente pelo kernel, mas não impede carregamento manual via modprobe:

```bash
blacklist usb_storage
```

* install

Substitui o comportamento padrão do modprobe ao tentar carregar um módulo. Usado, por exemplo, para bloquear completamente o carregamento:

```bash
install psmouse /bin/false
```

* remove

Define o que deve ser feito quando o módulo for removido com modprobe -r.

```bash
remove usb_storage /bin/true
```

* options

Permite passar parâmetros específicos para um módulo no momento do carregamento.

```bash
options iwlwifi power_save=1
```

* alias

Cria apelidos para módulos, permitindo que você os carregue usando nomes mais simples ou personalizados.

```bash
alias placa_wifi_driver iwlwifi
```

O nome dos arquivos dentro de /etc/modprobe.d/ não precisa seguir um padrão rígido, mas é uma boa prática dar nomes descritivos com final .conf, como:

-    blacklist-som.conf
-    iwlwifi.conf
-    custom-modules.conf


Todos os arquivos .conf serão lidos e aplicados, independente do nome, desde que tenham sintaxe válida.

Além de /etc/modprobe.d/, o sistema também pode ler configurações de:

-    /run/modprobe.d/ (configurações temporárias)
-    /lib/modprobe.d/ (configurações padrão do sistema ou da distribuição)


As configurações em /etc/modprobe.d/ têm prioridade sobre as demais, pois são consideradas personalizações feitas pelo administrador.

## DEPMOD

O comando depmod é uma ferramenta fundamental para o gerenciamento de módulos do kernel Linux. Sua principal função é gerar os arquivos que descrevem as relações de dependência entre os módulos, ou seja, ele constrói um "mapa" que indica quais módulos precisam ser carregados antes de outros para que tudo funcione corretamente. O principal arquivo gerado por ele é o /lib/modules/$(uname -r)/modules.dep.

Esse arquivo modules.dep é utilizado pelas ferramentas do sistema (como o modprobe) para saber quais outros módulos devem ser carregados automaticamente junto com o módulo que você solicitou. Por exemplo, se um determinado driver depende de outro módulo, essa relação estará registrada nesse arquivo. Assim, ao tentar carregar o primeiro módulo, o sistema sabe que precisa carregar o segundo também, evitando falhas de execução.

Quando você compila ou instala um novo módulo manualmente, esse novo arquivo .ko (kernel object) é adicionado ao diretório de módulos da versão do kernel atual, mas o sistema ainda não sabe que ele existe nem quais dependências ele possui. O mesmo acontece se, por algum motivo, os arquivos de dependência forem corrompidos ou apagados. Nesse caso, o kernel tentará carregar um módulo sem saber do que ele depende, o que geralmente resulta em erro.

Para resolver isso, você deve rodar o comando depmod. Ele varre todo o conteúdo do diretório /lib/modules/$(uname -r)/, analisa os módulos disponíveis e recria o arquivo modules.dep e outros arquivos auxiliares, como modules.alias, modules.symbols, entre outros. Você pode executá-lo assim:

```bash
sudo depmod
```

Ou, se quiser acompanhar os detalhes do que está sendo feito:

```bash
sudo depmod -v
```

Depois de rodar o depmod, o sistema passa a reconhecer corretamente os módulos novos e suas dependências, permitindo que eles sejam carregados normalmente usando comandos como modprobe.

Portanto, sempre que você adicionar, remover ou recompilar um módulo manualmente, é importante executar o depmod. Sem isso, o kernel pode não conseguir usar o novo módulo, mesmo que ele esteja fisicamente presente no sistema.


That's All Folks
