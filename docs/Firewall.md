# 🔥 Firewall Server - Debian 13

## Objetivo
Criar um servidor de **firewall e roteamento** entre duas redes, utilizando **iptables** no **Debian 13**, com duas interfaces de rede:

- **enp1s0** → Rede externa (WAN)
- **enp7s0** → Rede interna (LAN)

---

## 🧩 Configuração das interfaces de rede

Edite o arquivo de interfaces:

```bash
vim /etc/network/interfaces

# Interface externa (WAN)
allow-hotplug enp1s0
iface enp1s0 inet static
    address 192.168.122.254
    netmask 255.255.255.0
    gateway 192.168.122.1
    dns-nameservers 192.168.122.1

# Interface interna (LAN)
allow-hotplug enp7s0
iface enp7s0 inet static
    address 192.168.70.254
    netmask 255.255.255.0

Aplique as alterações:

systemctl restart networking

Verifique se as interfaces subiram corretamente:

ip addr show

🧭 Resolvedor de nomes

Edite o arquivo /etc/resolv.conf:

vim /etc/resolv.conf

domain officinas.edu
search officinas.edu
nameserver 192.168.122.1  # Roteador ou DNS externo

🔄 Habilitar roteamento no kernel

Edite o arquivo de configuração do sysctl:

vim /etc/sysctl.d/99-sysctl.conf

net.ipv4.ip_forward = 1

Ative a configuração imediatamente:

sysctl -p /etc/sysctl.d/99-sysctl.conf

🧱 Instalar o iptables

Substitua o nftables (padrão do Debian 13) pelo iptables clássico:

apt remove -y nftables
apt install -y iptables iptables-persistent

🔧 Criar o script do firewall

Crie o arquivo /usr/local/bin/firewall:

vim /usr/local/bin/firewall

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

# Acesso SSH ao firewall (porta 22254)
iptables -A INPUT -p tcp -d 192.168.70.254 --dport 22254 -j ACCEPT

# Permitir ping
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Permitir acesso HTTP/HTTPS/DNS para o firewall
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

# Permitir saída da LAN para Internet (HTTP/HTTPS/DNS)
iptables -A FORWARD -s 192.168.70.0/24 -p tcp --dport 80 -j ACCEPT
iptables -A FORWARD -s 192.168.70.0/24 -p tcp --dport 443 -j ACCEPT
iptables -A FORWARD -s 192.168.70.0/24 -p tcp --dport 53 -j ACCEPT
iptables -A FORWARD -s 192.168.70.0/24 -p udp --dport 53 -j ACCEPT

# Redirecionar conexões externas específicas
# Exemplo: SSH para o servidor DCMASTER
iptables -t nat -A PREROUTING -i $WAN -p tcp --dport 22250 -j DNAT --to-destination 192.168.70.250:22
iptables -A FORWARD -p tcp -d 192.168.70.250 --dport 22 -j ACCEPT

# Exemplo: SSH para o servidor de arquivos
iptables -t nat -A PREROUTING -i $WAN -p tcp --dport 22200 -j DNAT --to-destination 192.168.70.200:22
iptables -A FORWARD -p tcp -d 192.168.70.200 --dport 22 -j ACCEPT

# Exemplo: RDP para estação de trabalho
iptables -t nat -A PREROUTING -i $WAN -p tcp --dport 3389 -j DNAT --to-destination 192.168.70.171:3389
iptables -A FORWARD -p tcp -d 192.168.70.171 --dport 3389 -j ACCEPT

# Log básico (opcional)
# iptables -A INPUT -j LOG --log-prefix "FIREWALL_DROP: "

echo "Firewall carregado com sucesso!"
```

⚙️ Aplicar e salvar o firewall

Torne o script executável:

chmod +x /usr/local/bin/firewall

Execute:

/usr/local/bin/firewall

Salve as regras ativas:

iptables-save > /etc/iptables/rules.v4

🧠 Tornar o firewall persistente no boot

Habilite o serviço:

systemctl enable netfilter-persistent.service
systemctl restart netfilter-persistent.service
systemctl status netfilter-persistent.service

Verifique se as regras estão sendo aplicadas após o reboot:

iptables -L -v -n

✅ Testes rápidos

ping -c 3 8.8.8.8              # Testar acesso à Internet
ping -c 3 192.168.70.254       # Testar LAN
curl http://example.com        # Testar saída HTTP


THAT'S ALL FOLKS!



