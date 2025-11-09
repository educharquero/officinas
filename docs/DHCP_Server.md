🔥 DHCP Server

🎯 O Objetivo nesse tutorial é Configurar um servidor DHCP no Debian 13, com concessões dinâmicas e reservas fixas, integrando-se à rede interna 192.168.70.0/24, apontando o Gateway para o Firewall e o DNS para o Controlador de Domínio, bem como setando um range de distribuição de ips aos clientes da rede.

---

🌐 Topologia da rede - Função, endereçamento ip e nomes:

Firewall: SRVFIREWALL 192.168.70.254

Controlador de Domínio: SRVDC01 192.168.70.253

FileServer: SRVARQUIVOS 192.168.70.252

Domínio AD: OFFICINAS.EDU

Workgroup: OFFICINAS

---

## 📦 Instalação e habilitação do servidor DHCP

```bash
apt install isc-dhcp-server
```

```bash
systemctl enable isc-dhcp-server
```

## ⚙️  Definir a interface de escuta (enp2s0)

```bash
vim /etc/default/isc-dhcp-server
```

```bash
INTERFACESv4="enp1s0"
```

## 📄 Fazer o backup do arquivo dhcpd.conf
```bash
mv /etc/dhcp/dhcpd.conf{,.orig}
```

## 🧩 Criar o novo arquivo de configuração

```bash
vim /etc/dhcp/dhcpd.conf
```

```bash
# Nome de domínio e DNS
option domain-name "officinas.edu";
option domain-name-servers 192.168.70.253;

# Gateway padrão
option routers 192.168.70.254;

# Fuso horário (BR: -3h)
option time-offset -10800;

# Tempo de concessão (em segundos)
# TEMPO DE RENOVAÇÃO DO LEASE (10 minutos):
default-lease-time 600;

# TEMPO MÁXIMO DE LEASE (2 horas):
max-lease-time 7200;

# Desativa atualizações dinâmicas no DNS
ddns-update-style none;

# Define este servidor como autoritativo
authoritative;

# Log padrão
log-facility local7;

# REDE LOCAL PRINCIPAL
subnet 192.168.70.0 netmask 255.255.255.0 {
    range 192.168.70.10 192.168.70.20;
    option routers 192.168.70.254;
    option domain-name "officinas.edu";
    option domain-name-servers 192.168.70.253;
    option broadcast-address 192.168.70.255;
}

# IPs FIXOS POR MAC ADDRESS
host vmwin10 {
    hardware ethernet 52:54:00:C7:85:A9;
    fixed-address 192.168.70.171;
}

host pc_gerente {
    hardware ethernet 52:54:00:BF:17:BE;
    fixed-address 192.168.70.111;
}
```

## 🔄 5. Reiniciar o serviço DHCP

```bash
systemctl restart isc-dhcp-server
```

```bash
systemctl status isc-dhcp-server
```

## 🌐 6. Múltiplas Redes (opcional, servidor multi-homed)

## Em ambientes onde o servidor DHCP atende mais de uma sub-rede (por exemplo, LAN principal e rede de almoxarifado), é necessário configurar:

* Interfaces distintas, cada uma com IP próprio (enp2s0 e enp3s0);

* Sub-redes definidas separadamente no arquivo /etc/dhcp/dhcpd.conf;

* (Opcional) Encaminhamento de pacotes ativado se o DHCP estiver roteando entre redes.

## 🖧 Exemplo de topologia

- Interface	IP do Servidor	Rede/Sub-rede	Descrição

- enp1s0	192.168.70.251	192.168.70.0/24	Rede principal

- enp2s0	172.16.254.1	172.16.254.0/24	Rede almoxarifado

## ⚠️  Definir as duas interfaces de escuta, uma para cada sub-rede agora

```bash
INTERFACESv4="enp1s0 enp2s0"
```

## 📄 Configuração das sub-redes

## No arquivo /etc/dhcp/dhcpd.conf, adicione os blocos de subnet (sem necessidade de shared-network, exceto se as redes estiverem na mesma interface física).

## Abra /etc/dhcp/dhcpd.conf e adicione:

```bash
# 🔹 Rede principal
subnet 192.168.70.0 netmask 255.255.255.0 {
    range 192.168.70.10 192.168.70.50;
    option routers 192.168.70.254;
    option domain-name "officinas.edu";
    option domain-name-servers 192.168.70.253;
    option broadcast-address 192.168.70.255;
    default-lease-time 600;
    max-lease-time 7200;
}

# 🔹 Rede do almoxarifado
subnet 172.16.254.0 netmask 255.255.255.0 {
    range 172.16.254.20 172.16.254.100;
    option routers 172.16.254.1;
    option domain-name "almoxarifado.officinas.edu";
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    option broadcast-address 172.16.254.255;
    default-lease-time 600;
    max-lease-time 3600;
}

# 🔹 Reservas fixas (opcional)
host pc1 {
    hardware ethernet 70:71:BC:F1:9F:9E;
    fixed-address 172.16.254.21;
}

host pc2 {
    hardware ethernet 08:00:27:18:DC:AA;
    fixed-address 172.16.254.22;
}
```

## 🔀 Habilitar roteamento entre redes (opcional)

## SE o servidor DHCP também faz a ponte entre redes (por exemplo, serve ambas via NAT ou roteamento), habilite o encaminhamento de pacotes IPv4:

```bash
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
```

```bash
sysctl -p
```

## 🔍 Validação antes de reiniciar

## Sempre teste a sintaxe antes de reiniciar o serviço:

```bash
dhcpd -t -cf /etc/dhcp/dhcpd.conf
```

## Se não houver erros:

```bash
systemctl restart isc-dhcp-server
```

## 💡 Exemplo de verificação no cliente

## No cliente da rede almoxarifado:

```bash
sudo dhclient -v -r enp2s0 && sudo dhclient -v enp2s0
```

## 🔍 7. Consulta de concessões DHCP

Para ver as concessões ativas:

```bash
dhcp-lease-list
```

## Exemplo de saída esperada:

```bash
MAC                IP              hostname       valid until         manufacturer
52:54:00:C7:85:A9  192.168.70.171  vmwin10        2025-11-07 14:00:00  QEMU
```

## 🧰 7. Ferramentas úteis. Instalar base de fabricantes (para identificar dispositivos pelo MAC):

```bash
apt install -y ieee-data
```

## Crie links simbólicos para compatibilidade:

```bash
ln -s /usr/share/ieee-data/oui.txt /usr/share/misc/oui.txt
```

```bash
ln -s /usr/share/ieee-data/oui.txt /usr/local/etc/oui.txt
```

## Listar concessões DHCP ativas

```bash
dhcp-lease-list
```

```bash
MAC                IP              Hostname       Válido até          Fabricante
00:06:14:74:2a:5d  10.0.0.100      -NA-           2025-11-07 13:44:02   Furukawa
```

## Opções de listagem úteis:

## Saída legível por máquina

```bash
dhcp-lease-list --parsable
```

## Última concessão

```bash
dhcp-lease-list --last
```

```bash Todas as concessões (mesmo as expiradas)

```bash
dhcp-lease-list --all
```

## Ou direto do arquivo:

```bash
cat /var/lib/dhcp/dhcpd.leases
```

## 🧠 Dicas e boas práticas

* ✅ Use subnets separadas por interface física (não misture pools de VLANs).
* ✅ Garanta que o roteamento entre redes esteja ativo (net.ipv4.ip_forward=1).
* ✅ Faça testes de DHCPDISCOVER com dhclient -v -r <iface> no cliente.
* ✅ Não use shared-network a menos que várias sub-redes compartilhem a mesma interface física.
* ✅ Mantenha um gateway válido por sub-rede (o DHCP não roteia pacotes).
* ✅ Evite sobreposição de ranges IP.
* ✅ Use comentários descritivos por rede (documentação viva).
* ✅ Configure o firewall para permitir pacotes UDP 67/68 entre interfaces confiáveis.
* ✅ Está pronto para operar em conjunto com servidores DNS, Firewall e AD/Samba.


THAT'S ALL FOLKS





