# 🔥 Firewall Server - Debian 13 com Iptables

## 🎯 Objetivo

## Criar um servidor de **firewall stateful**, que entende o contexto e o estado das conexões,  com roteamento entre duas redes, utilizando **iptables** no **Debian 13**

## Com ele, você pode bloquear novas conexões vindas da Internet (NEW), mas permitir o retorno das conexões iniciadas de dentro (ESTABLISHED,RELATED)

---

🌐 1. Topologia da rede - Função, endereçamento ip e nomes:

Firewall:                   SRVFIREWALL       192.168.70.254

Controlador de Domínio:     SRVDC01           192.168.70.253

FileServer:                 SRVARQUIVOS       192.168.70.252

Domínio AD:                 OFFICINAS.EDU

Workgroup:                  OFFICINAS

---

## 🧩 Configuração das interfaces de rede

## Edite o arquivo de interfaces:

```bash
vim /etc/network/interfaces

# Interface externa (WAN)
allow-hotplug enp1s0
iface enp1s0 inet static
    address 192.168.0.254
    netmask 255.255.255.0
    gateway 192.168.0.1
    dns-nameservers 192.168.0.1

# Interface interna (LAN)
allow-hotplug enp7s0
iface enp7s0 inet static
    address 192.168.70.254
    netmask 255.255.255.0
```

## Aplique as alterações:

```bash
systemctl restart networking
```

## Verifique se as interfaces subiram corretamente:

```bash
ip addr show
```

## 🧭 Resolvedor de nomes

## Edite o arquivo resolv.conf apontando o resolvedor interno ou externo:

```bash
vim /etc/resolv.conf
```

```bash
domain officinas.edu
search officinas.edu
nameserver 192.168.0.1
```

## 🔄 Habilitar roteamento no kernel, bem como proteção anti-spoofing

## Edite o arquivo de configuração do sysctl:

```bash
vim /etc/sysctl.d/99-sysctl.conf
```

```bash
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
```

## Ative a configuração imediatamente:

```bash
sysctl -p /etc/sysctl.d/99-sysctl.conf
```

## 🧱 Instalar o iptables

## Substitua o nftables (padrão do Debian 13) pelo iptables clássico:

```bash
apt remove -y nftables
```

```bash
apt install -y iptables iptables-persistent
```

## 🔧 Criar o script do firewall

## Crie o arquivo /usr/local/bin/firewall:

```bash
vim /usr/local/bin/firewall
```

```bash
#!/usr/bin/env bash
###########################################
##        FIREWALL - Projeto Officinas   ##
##        eduardo.charquero@gmail.com    ##
##        Versão: 11.2025                ##
##        Licença: GPLv3                 ##
###########################################

# Interfaces
WAN="enp1s0"
LAN="enp7s0"

# Carregar módulos do kernel
modprobe iptable_nat
modprobe iptable_filter
modprobe iptable_mangle

# Limpar regras existentes
iptables -F
iptables -t nat -F
iptables -t mangle -F
iptables -X

# Políticas padrão (bloqueio total)
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Permitir tráfego de loopback
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Permitir pacotes relacionados e estabelecidos
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# Habilitar NAT (mascaramento da rede interna)
iptables -t nat -A POSTROUTING -s 192.168.70.0/24 -o $WAN -j MASQUERADE

# Acesso SSH ao firewall (porta 22254) somente pela lan
iptables -A INPUT -p tcp -s 192.168.70.0/24 --dport 22254 -m conntrack --ctstate NEW -j ACCEPT

# Permitir ping com limite de taxa
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 10 -j ACCEPT

# Permitir acesso HTTP/HTTPS/DNS/NTP para o firewall
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT

# Permitir saída da LAN para Internet (HTTP/HTTPS/DNS)
iptables -A FORWARD -s 192.168.70.0/24 -p tcp --dport 80 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.70.0/24 -p tcp --dport 443 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.70.0/24 -p tcp --dport 53 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -s 192.168.70.0/24 -p udp --dport 53 -m conntrack --ctstate NEW -j ACCEPT

# Redirecionar conexões externas para o Firewall
iptables -t nat -A PREROUTING -i $WAN -p tcp --dport 22253 -j DNAT --to-destination 192.168.70.254:22253
iptables -A FORWARD -p tcp -d 192.168.70.254 --dport 22253 -m conntrack --ctstate NEW -j ACCEPT

# Redirecionar conexões externas para o servidor de arquivos
iptables -t nat -A PREROUTING -i $WAN -p tcp --dport 22252 -j DNAT --to-destination 192.168.70.252:22252
iptables -A FORWARD -p tcp -d 192.168.70.252 --dport 22252 -m conntrack --ctstate NEW -j ACCEPT

# Liberar o RDP para estação de trabalho Windows
iptables -t nat -A PREROUTING -i $WAN -p tcp --dport 3389 -j DNAT --to-destination 192.168.70.171:3389
iptables -A FORWARD -p tcp -d 192.168.70.171 --dport 3389 -m conntrack --ctstate NEW -j ACCEPT

# Log básico (opcional)
iptables -A INPUT -m limit --limit 2/s -j LOG --log-prefix "FIREWALL_DROP: "

echo "......................................Firewall carregado com sucesso!"
```

## ⚙️  A opção -m conntrack

* A flag -m significa “usar módulo de correspondência”, ativando o módulo de rastreamento de conexões no iptables. Isso habilita o uso do parâmetro --ctstate, que filtra pacotes com base no estado da conexão.

## 🔄 O parâmetro --ctstate

* A opção --ctstate permite definir quais estados de conexão a regra deve corresponder.

## Os principais estados são:

- NEW	Pacote que inicia uma nova conexão (ex: primeiro SYN em TCP).
- ESTABLISHED	Pacote que faz parte de uma conexão já estabelecida.
- RELATED	Pacote que pertence a uma conexão relacionada a outra já existente (ex: FTP data após controle).
- INVALID	Pacote sem estado reconhecível (corrompido ou fora de contexto).
- UNTRACKED	Pacote que não está sendo rastreado pelo conntrack.

## 💡 O que faz --ctstate NEW

* O estado NEW indica que o pacote está tentando iniciar uma nova conexão.

## Por exemplo:

* O primeiro pacote TCP (SYN)

* Um primeiro pacote UDP (sem conexão prévia)

* Uma requisição ICMP de eco (ping) ainda não rastreada

## ⚙️  Após esse rápido alinhamento, vamos aplicar as configurações e salvar o firewall

## Torne o script executável:

```bash
chmod +x /usr/local/bin/firewall
```

## Rode o script para subir as regras:

```bash
/usr/local/bin/firewall
```

## Salve as regras ativas:

```bash
iptables-save > /etc/iptables/rules.v4
```

## 🧠 Tornar o firewall persistente no boot

## Habilite o serviço:

```bash
systemctl enable netfilter-persistent.service
```

```bash
systemctl restart netfilter-persistent.service
```

```bash
systemctl status netfilter-persistent.service
```

## Verifique se as regras estão sendo aplicadas após o reboot:

```bash
iptables -L -v -n
```

```bash
iptables -t nat -L -v -n
```

## ✅ Testes rápidos

## Conexão com internet:

```bash
ping -c 3 8.8.8.8
```

## Conexão com a rede lan:

```bash
ping -c 3 192.168.70.253
```

## Validando NAT e DNS:

```bash
curl https://google.com
```

THAT'S ALL FOLKS!
