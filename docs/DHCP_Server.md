# 📁 DHCP Server

## Criando um Servidor de DHCP

A INSTALAÇÃO A SEGUIR SE DARÁ NA MÁQUINA DO PRÓPRIO FIREWALL!

## Vamos a instalação do pacote do DHCP Server:

```bash
apt-get install isc-dhcp-server
```

## Agora vamos definir a interface que vai escutar o servidor de DHCP (enp7s0):

```bash
vim /etc/default/isc-dhcp-server
```

```bash
INTERFACESv4=”enp7s0″
```

## Backup do arquivo original:

```bash
mv /etc/dhcp/dhcpd.conf{,.orig}
```

## Criação do novo arquivo:

```bash
vim /etc/dhcp/dhcpd.conf
```

```bash
# NOME DE DOMÍNIO:
option domain-name "officinas.edu.";

# IP DO SERVIDOR DE DNS DA REDE (Separar por vírgula SEM espaço):
option domain-name-servers 192.168.70.254,1.1.1.1;

# GATEWAY PADRÃO:
option routers 192.168.70.254;

# DEFINIÇÃO DE HORÁRIO DA REDE (18000=BR):
option time-offset -18000;

# TEMPO DE RENOVAÇÃO DOS ENDEREÇOS IPS POR INATIVIDADE (600=10MIN):
default-lease-time 600;

# TEMPO MÁXIMO DE USO DE UM IP EM UMA MÁQUINA DA REDE:
max-lease-time 7200;

# DEFINE SE O DHCPD INSERE DINÂMICAMENTE UM NOVO REGISTRO DE MÁQUINA NO DNS SERVER AO FORNECER UM IP:
ddns-update-style none;

# INDICA QUE O SERVIDOR DE DHCP SERÁ AUTORITATIVO SEMPRE:
authoritative;

# GERENCIAMENTO DE LOGS:
log-facility local7;

# RANGE DE GERENCIAMENTO DE IPS:
subnet 192.168.70.0 netmask 255.255.255.0 {
    range 192.168.70.10 192.168.70.20;
    option routers 192.168.70.254;
}

# IPS FIXOS POR MAC ADDRESS:
host vmwin10 {
    hardware ethernet 52:54:00:C7:85:A9;
    fixed-address 192.168.70.171;
}

host PC_Gerente {
    hardware ethernet 52:54:00:bf:17:be;
    fixed-address 192.168.70.111;
}
```

## Agora vamos reiniciar o serviço:

```bash
systemctl restart isc-dhcp-server
```

## EXTRA: Para trabalhar com múltiplas redes, adicionar ao /etc/default/isc-dhcp-server:

```bash
shared-network rede-almoxarifado {

        subnet 172.16.254.0 netmask 255.255.255.0 {
         range 172.16.254.20 172.16.254.100;
         option routers 172.16.254.1;
         option domain-name-servers 8.8.8.8, 8.8.4.4;
         option broadcast-address 172.16.254.255;
        }

        # Sub-Rede adicional qual entrego apenas ips para os mac x e y:
        subnet 10.0.0.240 netmask 255.255.255.240 {
         option routers 10.0.0.241;
         option domain-name-servers 8.8.8.8, 8.8.4.4;
         option broadcast-address 10.0.0.255;

         host pc1 {
           hardware ethernet 70:71:BC:F1:9F:9E;
           fixed-address 10.0.0.242;
         }
         host pc2 {
           hardware ethernet 70:71:BC:F1:9F:1D;
           fixed-address 10.0.0.243;
         }

         host cel1 {
           hardware ethernet 08:00:27:18:DC:AA;
           fixed-address 10.0.0.244;
         }
        }
}
```

## Instale o pacote ieee-data para buscar o fabricante dos dispositivos (manufacturer) com base no MAC:

```bash
apt install ieee-data
```

## Crie os aliases dos arquivos para os diretórios específios:

```bash
ln -s /usr/share/ieee-data/oui.txt /usr/share/misc/oui.txt
ln -s /usr/share/ieee-data/oui.txt /usr/local/etc/oui.txt
```

## Imprime as concessões DHCP ativas:

```bash
dhcp-lease-list
```

```bash
MAC                IP              hostname       valid until         manufacturer

00:06:14:74:2a:5d  10.0.0.100     -NA-           2020-09-16 13:44:02       Furukawa
```

## Para uma saída legível por máquina com datas completas:

```bash
dhcp-lease-list --parsable
```

## imprime o último MAC:

```bash
dhcp-lease-list --last
```

## imprime todas as entradas, ou seja, mais de um por MAC:

```bash
dhcp-lease-list --all
```

## Validar as locações dhcpd:

```bash
cat /var/lib/dhcp/dhcpd.leases
```

```bash
lease 10.0.0.100 {
  starts 3 2020/09/16 14:06:33;
  ends 3 2020/09/16 14:11:33;
  cltt 3 2020/09/16 14:06:33;
  binding state active;
  next binding state free;
  rewind binding state free;
  hardware ethernet 00:06:14:74:2a:5d;
}
```

that's all folks!
