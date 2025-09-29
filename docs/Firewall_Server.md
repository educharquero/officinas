# 📁 Firewall Server

# Criando um Servidor de Firewall

## Esta máquina está equipada com 2 placas de rede (enp1s0 e enp7s0):

## Editando as placas de redes e setando ip fixo:

```bash
vim /etc/network/interfaces
```

```bash
# The primary network interface
allow-hotplug enp1s0
iface enp1s0 inet static
address 192.168.122.254
network 192.168.122.0
netmask 255.255.255.0
gateway 192.168.122.1
dns-nameserver 192.168.122.1

# The secundary network interface
allow-hotplug enp7s0
iface enp7s0 inet static
address 192.168.70.254
network 192.168.70.0
netmask 255.255.255.0
```

## Editando o resolvedor de nomes:

```bash
vim /etc/resolv.conf
```

```bash
domain esharknet.edu
search esharknet.edu.
nameserver 192.168.122.1 #(Roteador)
```

## Habilitando o roteamento através do Kernel:

```
vim /etc/sysctl.d/sysctl.conf
```

```
net.ipv4.ip_forward=1
```

```
sysctl -p /etc/sysctl.d/sysctl.conf
```

```
/etc/init.d/procps restart
```

## Instalação do pacote do iptables:

```bash
apt remove nftables && apt-get install iptables
```

## Criando o arquivo com as regras:
```
vim /usr/local/bin/firewall
```

```bash
###########################################
##       Firewall Projeto Officinas      ##
##       eduardo.charquero@gmail.com     ##
##       versão 05.2025                  ##
##       Licença GPL3                    ##
###########################################


#!/usr/bin/env bash

# enp0s8 = PLACA EXTERNA
# enp0s3 = PLACA INTERNA


# CARREGANDO MÓDULOS DO KERNEL:
modprobe iptable_nat
modprobe iptable_mangle
modprobe iptable_filter


# LIMPANDO AS CADEIAS DO NETFILTER:
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -t filter -F


# PERMITE RETORNO DE CONEXÕES JÁ ENCAMINHADAS:
iptables -A INPUT -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED,NEW -j ACCEPT


# BLOQUEANDO ACESSO AO FIREWALL:
iptables -P INPUT DROP
# BLOQUEANDO SAÍDA DO FIREWALL:
iptables -P OUTPUT DROP
# BLOQUEANDO PASSAGENS PELO FIREWALL:
iptables -P FORWARD DROP


# ATIVANDO MASCARAMENTO DA REDE INTERNA:
iptables -t nat -A POSTROUTING -s 192.168.70.0/24 -o enp0s3 -j MASQUERADE


# LIBERANDO ACESSO POR SSH NO FIREWALL:
iptables -I INPUT -p tcp -d 192.168.70.254 -s 192.168.70.0/24 --dport 22254 -j ACCEPT
# TESTES DE REJECT E DROP
# iptables -I INPUT -p tcp -d 192.168.70.254 -s 192.168.70.0/24 --dport 22254 -j REJECT
# iptables -I INPUT -p tcp -d 192.168.70.254 -s 192.168.70.0/24 --dport 22254 -j DROP


# LIBERANDO O PING PARA O FIREWALL:
iptables -A INPUT -p icmp --icmp-type ping -j ACCEPT
# TESTES DE REJECT E DROP
# iptables -A INPUT -p icmp --icmp-type ping -j REJECT
# iptables -A INPUT -p icmp --icmp-type ping -j DROP


# LIBERANDO INTERNET PARA O FIREWALL:
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT


# LIBERANDO INTERNET PARA PASSAGEM DA REDE:
iptables -A FORWARD -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -j ACCEPT


# REDIRECT SSH PARA DCMASTER:
iptables -t nat -A PREROUTING -p tcp -s 0/0 -d 192.168.0.254 --dport 22250 -j DNAT --to 192.168.70.250:22250
iptables -t filter -A FORWARD -p tcp -s 0/0 -d 192.168.70.250 --dport 22250 -j ACCEPT


# REDIRECT SSH PARA ARQUIVOS:
iptables -t nat -A PREROUTING -p tcp -s 0/0 -d 192.168.0.254 --dport 22200 -j DNAT --to 192.168.70.200:22200
iptables -t filter -A FORWARD -p tcp -s 0/0 -d 192.168.70.200 --dport 22200 -j ACCEPT


# Liberando RDP:
iptables -A FORWARD -p tcp --dport 3389 -j ACCEPT
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 3389 -j DNAT --to 192.168.70.171:3389


# Redirect da rede interna pra porta do Squid:
#iptables -A FORWARD -p tcp --dport 80 -j DROP
#iptables -A FORWARD -p tcp --dport 443 -j DROP
#iptables -t nat -A PREROUTING -i enp7s0 -p tcp --dport 80 -j REDIRECT --to-port 3128
```

## Setando permissão de execução ao Shell-script e executando:
```bash
chmod +x /usr/local/bin/firewall
```

```bash
sh /usr/local/bin/firewall
```

## Salvando as regras do iptables:

```bash
apt-get install iptables-persistent
```

```bash
iptables-save > /etc/iptables/rules.v4
```

```bash
/etc/init.d/netfilter-persistent restart
```

```bash
systemctl is-enabled netfilter-persistent.service
```

```bash
systemctl enable netfilter-persistent.service
```

```bash
systemctl status netfilter-persistent.service
```

that's all folks!

