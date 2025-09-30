# 📁 DNS Server

## Criando um Servidor de DNS

A INSTALAÇÃO A SEGUIR SE DARÁ NA MÁQUINA DO PRÓPRIO FIREWALL!

## Instalar os pacotes necessários:

```bash
apt-get install bind9 openssh-server dnsutils
```

## Editar o arquivo /etc/default/named e deixa-lo como no exemplo:

```bash
# run resolvconf?
RESOLVCONF=no

# startup options for the server
OPTIONS="-u bind -4"
```
## O arquivo /etc/bind/named.conf fica sem alteração:

```bash
// This is the primary configuration file for the BIND DNS server named.
//
// Please read /usr/share/doc/bind9/README.Debian.gz for information on the 
// structure of BIND configuration files in Debian, *BEFORE* you customize 
// this configuration file.
//
// If you are just adding zones, please do that in /etc/bind/named.conf.local

include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```

## O arquivo /etc/bind/named.conf.local tbém fica sem alteração:

```bash
//
// Do any local configuration here
//

// Consider adding the 1918 zones here, if they are not used in your
// organization
//include "/etc/bind/zones.rfc1918";
```

## Entrar em /etc/bind:

```bash
cd /etc/bind
```

## Fazer um backup do arquivo original:

```bash
cp named.conf.default-zones{,.orig}
```

## Editar named.conf.default-zones e deixa-lo como no exemplo:

```bash
vim named.conf.default-zones
```

```bash
// prime the server with knowledge of the root servers
zone "." {
    type hint;
    file "/usr/share/dns/root.hints";
};

// be authoritative for the localhost forward and reverse zones, and for
// broadcast zones as per RFC 1912

zone "localhost" {
    type master;
    file "/etc/bind/db.local";
};

zone "127.in-addr.arpa" {
    type master;
    file "/etc/bind/db.127";
};

zone "0.in-addr.arpa" {
    type master;
    file "/etc/bind/db.0";
};

zone "255.in-addr.arpa" {
    type master;
    file "/etc/bind/db.255";
};

zone "officinas.edu" {
      type master;
      file "/etc/bind/zones/db.officinas.edu";
};

zone "70.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.70.168.192";
};
```

## Criar/ editar o Arquivo named.conf.options:


```bash
vim named.conf.options
```

```bash
// CRIANDO REGRAS DE LIBERAÇÃO:
acl interna {
127.0.0.0/8;
192.168.70.0/24;
};

options {
	directory "/var/cache/bind";
	
	// CRIANDO RECURSIVIDADE DA MINHA ACL NA ÁRVORE HIERÁRQUICA:
	recursion yes;
	allow-query { interna; };
	allow-recursion { interna; };
	listen-on port 53 { interna; };
	allow-transfer { none; };
	listen-on-v6 { none; };
	version none;

	// CRIANDO OS FORWARDERS:
	forwarders {
	// Cloudflare Public DNS IPV4
	1.1.1.1;
	1.0.0.1;
	// Google Public DNS IPV4
	8.8.8.8;
	8.8.4.4;
	};	

	dnssec-validation auto;

};
```

## Criar a pasta zones em /etc/bind:

```bash
mkdir -p /etc/bind/zones
```

## Entrar na pasta zones:

```bash
cd /etc/bind/zones
```

## Criar/ editar o Arquivo de zona "db.officinas.edu":

```bash
vim db.officinas.edu
```

```bash
;
; BIND zone file for officinas.edu
;
$TTL 86400
@ IN SOA                          firewall.officinas.edu.  root.officinas.edu. (
29032023                                                 ; Serial
10800                                                    ; Refresh ( 3 hr )
1800                                                     ; Retry ( 30 min )
3600000                                                  ; Expire ( 41 dias )
86400 )                                                  ; Negative Cache TTL (1 dia)
;
@                                 IN              NS      firewall.officinas.edu.
firewall.officinas.edu.           IN              A       192.168.70.254
dcmaster.officinas.edu.           IN              A       192.168.70.200
webserver.officinas.edu.          IN              A       192.168.70.100
arquivos                          IN              CNAME   dcmaster.officinas.edu.
www                               IN              CNAME   webserver.officinas.edu.
```

## ATENÇÃO - Explicação dos Campos zona e zona reversa:

* IN = Internet
* SOA = Start of Autority
* @ = Origem do Dominio e/ou Inicio da Configuracao
* TTL = Tempo de vida
* NS = Name Server
* MX = Mail Exchanger (10/20 numero de prioridade quanto maior o numero menor e a prioridade)
* hostmaster = email do administrador note que e separado por "." e NAO "@"
* A = Apontamento para IPv4 (Address Mapping)
* AAAA = Apontamento para IPv6 (Address Mapping)
* CNAME = Apontamento para Nome Canonico/alias
* PTR = PoinTeR (aponta dominio reverso a partir de um endereço IP)
* TXT = TeXT, permite incluir um texto curto em um hostname. Tecnica usada para implementar o SPF.
* SPF = SenderPolicyFramework.Permite ao administrador de um dominio definir os enderecos das maquinas autorizadas a enviar mensagens neste dominio.
* SRV = SeRVice, permite definir localizacao de servicos disponiveis em um dominio, inclusive seus protocolos e portas.

## Fazer uma copia do arquivo db.127 em /etc/bind para /etc/bind/zones/db.70.168.192:

```bash
cp /etc/bind/db.127 /etc/bind/zones/db.70.168.192
```

## Criar/ editar o Arquivo de zona reversa:

```bash
vim /etc/bind/zones/db.200.168.192
```

```bash
;
; BIND reverse data file for 70.168.192
;
$TTL    86400
@       IN      SOA     firewall.officinas.edu. root.officinas.edu. (
29032023                ; Serial
10800                   ; Refresh ( 3 hr )
1800                    ; Retry ( 30 min )
3600000                 ; Expire ( 41 dias )
86400 )                 ; Negative Cache TTL (1 dia)
;
@            IN      NS      firewall.officinas.edu.
firewall     IN      A       192.168.70.254
254          IN      PTR     firewall.officinas.edu.
200          IN      PTR     dcmaster.officinas.edu.
100          IN      PTR     webserver.officinas.edu.
```

## Restart/ reload no bind9 analisando os logs:

```bash
/etc/init.d/bind9 restart ; tail -f /var/log/syslog
```

## Agora, vamos entregar a resolução ao DNS Server local editando o /etc/resolv.conf:

```bash
vim /etc/resolv.conf
```

```bash
127.0.0.1
```

## Checar se as confs foram aplicadas:

```bash
named-checkzone  officinas.edu /etc/bind/zones/db.officinas.edu
named-checkzone  70.168.192 /etc/bind/zones/db.70.168.192
```

## Testar o DNS utilizando o comando nslookup:

```bash
nslookup www.terra.com.br
nslookup www.proot.com.br
```

## Testar o DNS utilizando o dig:

```bash
dig -t any www.terra.com.br
dig -t any www.proot.com.br
```
## Bloqueia a edição do arquivo /etc/resolv.conf:
```bash
chattr +i /etc/resolv.conf
```


that's all folks!

