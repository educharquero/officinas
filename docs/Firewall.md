# 🔥 Firewall Server com Debian 13 rodando Iptables e integrado ao Domínio

## 🎯 O Objetivo nesse tutorial é criar um servidor de **firewall stateful**, que entende o contexto e o estado das conexões, com roteamento entre duas redes, utilizando **iptables** no **Debian 13**. Com ele, você pode bloquear novas conexões vindas da Internet (NEW), mas permitir o retorno das conexões iniciadas de dentro (ESTABLISHED,RELATED). Ele será integrado ao domínio utilizando winbind e kerberos, possibilitando autenticação e controle de usuários de rede.

---

## 🌐 Topologia da rede:

- Domínio: OFFICINAS.EDU

- SRVFIREWALL 192.168.70.254/24

- SRVDC01 192.168.70.253/24

- SRVARQUIVOS 192.168.70.252/24

---

## 🧩 Configuração das interfaces de rede (WAN apontando pro Roteador da operadora e LAN apontando pra Rede interna)

```bash
vim /etc/network/interfaces

# Interface externa (WAN)
allow-hotplug ens18
iface enp1s0 inet static
    address 192.168.0.254
    netmask 255.255.255.0
    gateway 192.168.0.1
    dns-nameservers 192.168.0.1

# Interface interna (LAN)
allow-hotplug ens19
iface enp7s0 inet static
    address 192.168.70.254
    netmask 255.255.255.0
```

## Aplique as alterações

```bash
systemctl restart networking
```

## Verifique se as interfaces subiram corretamente

```bash
ip addr show
```

## 🧭 Resolvedor de nomes

## Edite o arquivo resolv.conf apontando o resolvedor interno SRVDC01

```bash
vim /etc/resolv.conf
```

```bash
domain officinas.edu
nameserver 192.168.70.253
```

## Bloqueie a edição automática do arquivo

```bash
chattr +i /etc/resolv.conf
```

## A **1º Parte** se referirá á integração ao domínio

## ⚙️ Instalar pacotes de integração AD

```bash
apt install samba winbind krb5-user samba-common-bin samba-common samba-client libnss-winbind libpam-winbind curl
```

## ✅ Sincronização de hora (crítica para Kerberos):


```bash
apt install chrony
```

```bash
vim /etc/chrony/chrony.conf
```

## Adicione o srvdc01 ao chrony:

```bash
server 192.168.70.253 prefer iburst
```

## Habilite e reinicie o serviço de sincronização de horário.

```bash
systemctl enable --now chrony
```

```bash
sudo systemctl restart chrony
```

```bash
chronyc sources -v
```

```bash
chronyc tracking
```

## 🔑 Configurar o Kerberos após fazer o backup do arquivo original

```bash
mv /etc/krb5.conf{,.orig}
```

```bash
vim /etc/krb5.conf
```

```bash
[libdefaults]
    default_realm = OFFICINAS.EDU
    dns_lookup_realm = false
    dns_lookup_kdc = true
    ticket_lifetime = 24h
    renew_lifetime = 7d
    forwardable = true

[realms]
    OFFICINAS.EDU = {
        kdc = 192.168.70.253
        admin_server = 192.168.70.253
    }

[domain_realm]
    .officinas.edu = OFFICINAS.EDU
    officinas.edu = OFFICINAS.EDU
```

## ⚙️ Configurar o arquivo do Samba após fazer o backup do arquivo original

```bash
mv /etc/samba/smb.conf{,.orig}
```

```bash
vim /etc/samba/smb.conf
```

```bash
[global]
   workgroup = OFFICINAS
   realm = OFFICINAS.EDU
   security = ADS
   password server = 192.168.70.253
   kerberos method = secrets and keytab

   # Winbind e IDMAP
   winbind use default domain = yes
   winbind offline logon = yes
   winbind enum users = yes
   winbind enum groups = yes
   template shell = /bin/bash
   template homedir = /home/%D/%U

   idmap config * : backend = tdb
   idmap config * : range = 10000-20000

   client signing = yes
   server signing = auto
   client use spnego = yes
   dedicated keytab file = /etc/krb5.keytab

   # Performance
   dns proxy = no
   restrict anonymous = 2
```

## 🧠 Configurar apontamento do winbind na validação de nomes e contas do Sistema

```
vim /etc/nsswitch
```

```bash
passwd: files systemd winbind
group:  files systemd winbind
shadow: files
```

## 🧩 Ingressar no domínio

```bash
net ads join -U administrador
```

## Saída esperada:

```bash
Joined 'SRVFIREWALL' to realm 'OFFICINAS.EDU'
```

## Valide:

```bash
net ads testjoin
```

```bash
net ads info
```

## 🔄 Restarte os serviços de smbd, nmbd e winbind e habilite-os no boot

```bash
systemctl restart smbd nmbd winbind
```

```bash
systemctl enable winbind
```

```bash
systemctl status winbind
```

```bash
wbinfo -t
```

```bash
wbinfo -u | head
```

```bash
wbinfo -g | head
```

## Teste o ticket:

```bash
kinit administrador@OFFICINAS.EDU
```

```bash
klist
```

## ✅ Testar autenticação AD

```bash
wbinfo -u | head
```

```bash
getent passwd "Administrator"
```

## ⚙️ Verificar DNS e NAT

```bash
ping -c 3 8.8.8.8
```

```bash
ping -c 3 srvdc01.officinas.edu
```

```bash
curl https://google.com
```

## A **2º Parte** se referirá ao serviço de Firewall, propriamente dito

## 🔄 Habilitar roteamento no kernel, bem como proteção anti-spoofing

## Crie o arquivo de configuração do sysctl.conf

```bash
vim /etc/sysctl.conf
```

```bash
net.ipv4.ip_forward = 1
net.ipv4.conf.all.rp_filter=1
net.ipv4.conf.default.rp_filter=1
```

## Ative a configuração imediatamente

```bash
sysctl -p /etc/sysctl.conf
```

## 🧱 Instalar o iptables

## Substitua o nftables (padrão do Debian 13) pelo iptables clássico

```bash
apt remove nftables
```

```bash
apt install iptables iptables-persistent
```

## 🔧 Criar o script do firewall

## Crie o arquivo /usr/local/bin/firewall

```bash
vim /usr/local/bin/firewall
```

```bash
#!/usr/bin/env bash
##############################################
##        FIREWALL - Projeto Officinas      ##
##        eduardo.charquero@gmail.com       ##
##        Versão: 11.2025                   ##
##        Licença: GPLv3                    ##
##############################################
#!/bin/bash

# Interfaces
WAN="ens18"
LAN="ens19"

# Rede interna e IP do Firewall
LAN_NET="192.168.70.0/24"
FW_IP="192.168.70.254"

echo "[+] Limpando regras antigas..."
iptables -F
iptables -t nat -F
iptables -X

echo "[+] Definindo políticas padrão..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

echo "[+] Permitindo loopback e conexões já estabelecidas..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "[+] Permitindo acesso SSH interno (porta 22254)"
iptables -A INPUT -i $LAN -p tcp --dport 22254 -s $LAN_NET -j ACCEPT

echo "[+] Permitindo acesso SSH externo (porta 22254 - redirecionado no NAT externo)"
iptables -A INPUT -i $WAN -p tcp --dport 22254 -j ACCEPT

# ================================
# 🧱 3️⃣ REGRAS DE DNS (BIND9)
# ================================
echo "[+] Liberando tráfego DNS (UDP/TCP 53) da rede interna e do próprio firewall..."
iptables -A INPUT -i $LAN -p udp --dport 53 -s $LAN_NET -j ACCEPT
iptables -A INPUT -i $LAN -p tcp --dport 53 -s $LAN_NET -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --sport 53 -m conntrack --ctstate ESTABLISHED -j ACCEPT

# ================================
# 🧱 4️⃣ COMUNICAÇÃO COM O CONTROLADOR DE DOMÍNIO
# ================================
echo "[+] Permitindo comunicação com o SRVDC01 (AD + Kerberos)..."
iptables -A OUTPUT -p tcp -m multiport --dports 88,135,137,138,139,389,445,636 -d 192.168.70.253 -j ACCEPT
iptables -A OUTPUT -p udp -m multiport --dports 88,137,138,389 -d 192.168.70.253 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --sports 88,135,137,138,139,389,445,636 -s 192.168.70.253 -j ACCEPT
iptables -A INPUT -p udp -m multiport --sports 88,137,138,389 -s 192.168.70.253 -j ACCEPT

# ================================
# 🌐 NAT e roteamento básico
# ================================
echo "[+] Habilitando NAT e roteamento..."
iptables -t nat -A POSTROUTING -o $WAN -s $LAN_NET -j MASQUERADE
iptables -A FORWARD -i $LAN -o $WAN -j ACCEPT
iptables -A FORWARD -i $WAN -o $LAN -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ================================
# 🔒 Finalização
# ================================
echo "[+] Aplicando regras..."
iptables-save > /etc/iptables/rules.v4
echo 1 > /proc/sys/net/ipv4/ip_forward
echo "[✓] Firewall ativo e integrado ao domínio."
```

## Algumas explicações importantes

## ⚙️  A opção -m conntrack

* A flag -m significa “usar módulo de correspondência”, ativando o módulo de rastreamento de conexões no iptables. Isso habilita o uso do parâmetro --ctstate, que filtra pacotes com base no estado da conexão.

## 🔄 O parâmetro --ctstate

* A opção --ctstate permite definir quais estados de conexão a regra deve corresponder.

## Os principais estados são

- NEW	Pacote que inicia uma nova conexão (ex: primeiro SYN em TCP).
- ESTABLISHED	Pacote que faz parte de uma conexão já estabelecida.
- RELATED	Pacote que pertence a uma conexão relacionada a outra já existente (ex: FTP data após controle).
- INVALID	Pacote sem estado reconhecível (corrompido ou fora de contexto).
- UNTRACKED	Pacote que não está sendo rastreado pelo conntrack.

## 💡 O que faz --ctstate NEW

* O estado NEW indica que o pacote está tentando iniciar uma nova conexão.

## Por exemplo

* O primeiro pacote TCP (SYN)

* Um primeiro pacote UDP (sem conexão prévia)

* Uma requisição ICMP de eco (ping) ainda não rastreada

## ⚙️  Após esse rápido alinhamento, vamos aplicar as configurações e salvar o firewall

## Torne o script executável

```bash
chmod +x /usr/local/bin/firewall
```

## Rode o script para subir as regras

```bash
/usr/local/bin/firewall
```

## Salve as regras ativas

```bash
iptables-save > /etc/iptables/rules.v4
```

## 🧠 Tornar o firewall persistente no boot

## Habilite o serviço

```bash
systemctl enable netfilter-persistent.service
```

```bash
systemctl restart netfilter-persistent.service
```

```bash
systemctl status netfilter-persistent.service
```

## Verifique se as regras estão sendo aplicadas após o reboot

```bash
iptables -L -v -n
```

```bash
iptables -t nat -L -v -n
```

## ✅ Testes rápidos

## Conexão com internet

```bash
ping -c 3 8.8.8.8
```

## Conexão com a rede lan

```bash
ping -c 3 192.168.70.253
```

## Validando NAT e DNS

```bash
curl https://google.com
```

## 🏁 Resultado Final

- ✔ Firewall stateful operando com NAT e DNS funcional
- ✔ Comunicação direta com o SRVDC01 (AD) via Kerberos + Winbind
- ✔ Servidor autenticado no domínio OFFICINAS.EDU
- ✔ Pronto para receber o Squid + e2guardian, com controle de usuários centralizado.


THAT'S ALL FOLKS!

