# 🔥 Servidor DNS com BIND9 no Debian 13 (Standalone)

## 🎯 O Objetivo desse tutorial é criar e configurar um **Servidor DNS puro (standalone)** com o **BIND9** no **Debian 13**, para fins de **aprendizado e testes de resolução de nomes**, sem interferir no DNS interno do domínio `OFFICINAS.EDU`, que já opera no `SRVDC01`.

---

## 🌐 Estrutura de Rede e Domínio

|---------------------------------------------------------------------------------------------------------------|
| Função                   | Hostname                    | IP              | Observações                        |
|--------------------------|-----------------------------|-----------------|------------------------------------|
| Gateway/Firewall         | firewall.officinas.edu      | 192.168.70.254  | Roteador e gateway padrão          |
| Controlador de Domínio   | srvdc01.officinas.edu       | 192.168.70.253  | DNS interno (AD)                   |
| Servidor de Arquivos     | srvarquivos.officinas.edu   | 192.168.70.252  | Servidor de Arquivos da rede       |
| Servidor DNS             | dnsserver.officinas.edu     | 192.168.70.251  | Servidor DNS independente (BIND9)  |
| web Server               | webserver.officinas.edu     | 192.168.70.250  | Webserver da rede                  |
|---------------------------------------------------------------------------------------------------------------|

---

## 🧩 1. Instalar os pacotes necessários

```bash
apt install bind9 bind9-utils bind9-doc dnsutils openssh-server
```

## ⚙️  2. Configuração inicial

## Editar /etc/default/named:


```bash
vim /etc/default/named
```

```bash
# run resolvconf?
RESOLVCONF=no

# startup options for the server
OPTIONS='-u bind -4'
```

## 🧱 3. Estrutura de configuração do BIND

## Arquivo principal /etc/bind/named.conf:

```bash
// Configuração principal do BIND
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
include "/etc/bind/named.conf.default-zones";
```

## Arquivo /etc/bind/named.conf.options:

```bash
vim /etc/bind/named.conf.options
```

```bash
// ACLs internas
acl interna {
    127.0.0.0/8;
    192.168.70.0/24;
};

options {
    directory "/var/cache/bind";

    recursion yes;
    allow-query { interna; };
    allow-recursion { interna; };

    listen-on port 53 { 127.0.0.1; 192.168.70.251; };
    listen-on-v6 { none; };
    allow-transfer { none; };
    version none;

    // Encaminhadores externos
    forwarders {
        1.1.1.1;
        1.0.0.1;
        8.8.8.8;
        8.8.4.4;
    };

    dnssec-validation auto;
};
```

## Arquivo /etc/bind/named.conf.local:

```bash
vim /etc/bind/named.conf.local
```

```bash
zone "officinas.edu" {
    type master;
    file "/etc/bind/zones/db.officinas.edu";
};

zone "70.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/zones/db.70.168.192";
};
```

## 📁 4. Criar a pasta de zonas

```bash
mkdir -p /etc/bind/zones
```

## 📘 5. Zona direta — /etc/bind/zones/db.officinas.edu

```bash
vim /etc/bind/zones/db.officinas.edu
```

```bash
;
; Zona direta - officinas.edu
;
$TTL 86400
@ IN SOA dnsserver.officinas.edu. root.officinas.edu. (
    2025110701  ; Serial (AAAAMMDDnn)
    10800       ; Refresh
    1800        ; Retry
    3600000     ; Expire
    86400 )     ; Negative Cache TTL
;
@                       IN NS   dnsserver.officinas.edu.
firewall                IN A    192.168.70.254
srvdc01                 IN A    192.168.70.253
srvarquivos             IN A    192.168.70.252
dnsserver               IN A    192.168.70.251
webserver               IN A    192.168.70.250

arquivos                IN CNAME srvarquivos.officinas.edu.
www                     IN CNAME webserver.officinas.edu.
```

## 🔄 6. Zona reversa — /etc/bind/zones/db.70.168.192

```bash
vim /etc/bind/zones/db.70.168.192
```

```bash
;
; Zona reversa - 192.168.70.0/24
;
$TTL 86400
@ IN SOA dnsserver.officinas.edu. root.officinas.edu. (
    2025110701  ; Serial (AAAAMMDDnn)
    10800       ; Refresh
    1800        ; Retry
    3600000     ; Expire
    86400 )     ; Negative Cache TTL
;
@       IN NS dnsserver.officinas.edu.
254     IN PTR firewall.officinas.edu.
253     IN PTR srvdc01.officinas.edu.
252     IN PTR srvarquivos.officinas.edu.
251     IN PTR dnsserver.officinas.edu.
250     IN PTR webserver.officinas.edu.
```

## 🧠 7. Ajustar o /etc/resolv.conf

```bash
nameserver 127.0.0.1
search officinas.edu
```

```bash
chattr +i /etc/resolv.conf
```

## 🔁 8. Reiniciar e validar o serviço

```bash
systemctl restart bind9
```
```bash
systemctl enable bind9
```
```bash
journalctl -u bind9 -f
```

## 🧪 9. Verificações de configuração

## Validar sintaxe:

```bash
named-checkconf
```

## Validar zonas:

```bash
named-checkzone officinas.edu /etc/bind/zones/db.officinas.edu
```
```bash
named-checkzone 70.168.192.in-addr.arpa /etc/bind/zones/db.70.168.192
```

## 🧰 10. Testes de resolução

## Teste local:

```bash
dig @127.0.0.1 officinas.edu any
```
```bash
dig @127.0.0.1 -x 192.168.70.253
```

## Teste externo:

```bash
nslookup www.terra.com.br
```
```bash
nslookup www.proot.com.br
```

## 📜 11. (Opcional) Logs dedicados

```bash
vim /etc/bind/named.conf.log
```

```bash
logging {
    channel default_debug {
        file "/var/log/named/debug.log" versions 3 size 5m;
        severity dynamic;
        print-category yes;
        print-severity yes;
        print-time yes;
    };
};
```

## E incluir no named.conf:

```bash
include "/etc/bind/named.conf.log";
```

## 🔒 12. Segurança e manutenção

- O serviço roda sob o usuário bind (já seguro por padrão);

- AppArmor no Debian 13 protege automaticamente /etc/bind;

- Sempre incremente o Serial ao editar zonas;

- Teste com dig após qualquer reload.

## ✅ Conclusão

## Este tutorial cria um servidor DNS completo com BIND9, totalmente funcional e isolado do AD, capaz de:

* Resolver nomes locais (officinas.edu) e externos (via forwarders);

* Servir respostas autoritativas para sua rede interna;

* Trabalhar em conjunto com o DNS interno do Samba4 sem conflito;

* Fornecer base prática para testes de DNS e zonas reversas.

## Não iremos criar um DNS Secundário com esse Servidor, pois essa função será atrelada ao Controlador de Domínio Secundário. 



THAT'S ALL FOLKS!














