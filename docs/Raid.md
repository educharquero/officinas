# 📁 RAID - Redundant Array of Independent Disks:

 Raid é uma tecnologia de armazenamento que envolve a combinação de vários discos rígidos (ou unidades de estado sólido) em uma única unidade lógica para melhorar o desempenho, a redundância ou uma combinação de ambos. RAID é usado principalmente para melhorar a confiabilidade e/ou o desempenho do armazenamento de dados em sistemas de computador.

#### RAID 0 (striping):

```bash
São usados no mínimo 2 discos nessa configuração. A capacidade de 
armazenamento é a soma dos discos utilizados. Não possui nenhum backup 
(redundância), embora melhore de forma significante a performance, dando 
mais velocidade de I/O. Exemplo, RAID 0 com dois discos de 200 GB cada um
totalizando em 400 GB o volume montado no RAID. Se um disco falhar é 
perdido todo o conteúdo. Possui striping, ou seja, os discos executam 
tarefas como leitura e gravação de dados de forma simultânea, entregando 
maior desempenho e liberando a capacidade total dos discos para 
armazenar informações.
```

#### RAID 1 (espelhamento):

```bash
São usados no mínimo 2 discos nessa configuração. A capacidade de 
armazenamento é metade da soma total dos discos. Exemplo, RAID 0 com dois
discos de 200 GB cada um deles, o espaço total no volume montado será de 
200 GB. Se um disco falhar, o conteúdo não é perdido.
```

#### RAID 4:

```bash
São usados no mínimo 3 discos nessa configuração. Um dos discos é 
dedicado à paridade. A capacidade de armazenamento é a soma de todos os 
discos, menos um. Exemplo, 3 discos de 100GB cada um, resulta em um RAID 
4 de 200GB. O próximo nível de RAID, o 5, possui mais vantagens se 
comparado com o RAID 4.
```

#### RAID 5:

```bash
São usados no mínimo 3 discos nessa configuração. Possui paridade e 
striping. Conforme o RAID 4, a capacidade de armazenamento é a soma de 
todos os discos, menos um.
```

#### RAID 6:

```bash
Existe um segundo disco de paridade, diferentemente do RAID 5, que 
possui apenas 1.
```

#### RAID 10:

```bash
combinação do RAID 0 e do RAID 1. Dois ou mais RAID 0 se juntam, formando
um RAID 1, e por consequência, um RAID 10.
```

#### RAID 50 e RAID 60:

```bash
São combinações de RAID 5 e RAID 0 ou RAID 6 e RAID 0, respectivamente. 
Eles oferecem um equilíbrio entre desempenho e redundância, adequados 
para aplicativos de alto desempenho e alta disponibilidade.
```

#### MDADM "md" significa múltiplos dispositivos. O "adm" de mdadm é abreviação para administração:

```bash
sudo apt install mdadm -y
```

#### Estou utilizando uma máquina virtual, com o Debian Linux. Nesta máquina, possuo os seguintes discos:

```bash
    /dev/sda - 50GB (Disco principal)
    /dev/sdb - 2GB
    /dev/sdc - 2GB
    /dev/sdd - 2GB
    /dev/sde - 2GB
```

```bash
sudo -i
```

```bash
mdadm --create /dev/md0 --level=0 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
```

```bash
mdadm: Defaulting to version 4.1 metadata
```

```bash
mdadm: array /dev/md0 started 
```

##### Agora o disco virtual chamado /dev/md0 foi criado em meu sistema. Devemos então atualizar o arquivo de configuração do mdadm, forçando o dispositivo a se chamar /dev/md0. Caso contrário, o udev irá automaticamente renomeá-lo para /dev/md127:

```bash
mdadm --detail --scan /dev/md0 >> /etc/mdadm/mdadm.conf
```

```bash
update-initramfs -u
```

```bash
cat /proc/mdstat
```

```bash
sudo mdadm --detail /dev/md0
```

```bash
 mkfs.ext4 /dev/md0
```

```bash
mkdir /mnt/md0
```

```bash
mount /dev/md0 /mnt/md0
```

```bash
df -h
```

```bash
/dev/md0        7,9G   36M  7,4G   1% /mnt/md0
```

#### Para remover o RAID com o MDADM:

```bash
umount /dev/md0
```

```bash
mdadm --stop /dev/md0
```

```bash
mdadm --zero-superblock /dev/sdb
```

```bash
mdadm --zero-superblock /dev/sdc
```

```bash
mdadm --zero-superblock /dev/sdd
```

```bash
mdadm --zero-superblock /dev/sde
```

```bash
nano /etc/mdadm/mdadm.conf
```

```bash
ARRAY /dev/md0 metadata=1.2 name=debian:0 UUID=5ecf1997:9d6ea966:a3590659:e36f5a88
```

```bash
update-initramfs -u
```


THAT’S ALL FOLKS!!
