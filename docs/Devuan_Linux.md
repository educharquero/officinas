# Modo de Operação do Init no Devuan Linux

## Introdução:

O Devuan Linux é uma distribuição derivada do Debian que **removeu o systemd** em favor de alternativas tradicionais. Por padrão, utiliza o **SysVinit** como sistema de inicialização, embora também suporte **OpenRC** e **Ruinit** como opção. Este documento detalha o funcionamento do SysVinit no Devuan.

---

## Arquitetura do SysVinit:

- **`/sbin/init`**: Processo primário (PID 1) gerenciado pelo kernel.
- **`/etc/inittab`**: Arquivo de configuração central que define:
  - Runlevels padrão
  - Comportamento durante inicialização/desligamento
  - Respostas a sinais do sistema (ex: `Ctrl+Alt+Del`)
- **Scripts de inicialização**: Localizados em `/etc/init.d/` e `/etc/rc*.d/`.

---

## Sequência de Inicialização (Boot):

1. **Kernel → Init**:
   
   - O kernel carrega `/sbin/init` (PID 1).
   - O init lê `/etc/inittab` para determinar ações iniciais.

2. **Execução do `rc.sysinit`**:
   
   - Script responsável por:
     - Montar sistemas de arquivos (`/etc/fstab`)
     - Configurar rede
     - Inicializar hardware
     - Definir hostname
   - Localizado em: `/etc/rcS.d/` (links para `/etc/init.d/`).

3. **Runlevel Padrão**:
   
   - Definido em `/etc/inittab` (ex: `id:2:initdefault:`).
   - Executa scripts em `/etc/rc<runlevel>.d/`:
     - **Scripts `S`** (Start): Iniciam serviços (ex: `S01networking`).
     - **Scripts `K`** (Kill): Param serviços (ex: `K01apache2`).

4. **Login**:
   
   - Após serviços, init executa terminais (TTYs) via `/sbin/getty`.

---

## Gerenciamento de Serviços e estrutura de Diretórios:

     /etc/init.d/     → Scripts originais dos serviços
     /etc/rc0.d/      → Runlevel 0 (desligamento)
     /etc/rc1.d/      → Runlevel 1 (monousuário)
     /etc/rc2.d/      → Runlevel 2 (multiusuário padrão)
     ...
     /etc/rc6.d/      → Runlevel 6 (reboot)

## Comandos Essenciais:

| Comando                | Descrição                       | Exemplo                         |
| ---------------------- | ------------------------------- | ------------------------------- |
| `service <srv> start`  | Inicia um serviço               | `service networking start`      |
| `service <srv> stop`   | Para um serviço                 | `service apache2 stop`          |
| `service <srv> status` | Verifica status do serviço      | `service cron status`           |
| `update-rc.d`          | Gerencia links de inicialização | `update-rc.d nginx enable`      |
| `init <runlevel>`      | Muda runlevel atual             | `init 1` (entra em monousuário) |

---

## Runlevels (Níveis de Execução):

| Runlevel | Descrição                          | Uso Típico           |
| -------- | ---------------------------------- | -------------------- |
| 0        | Desligamento do sistema            | `halt`               |
| 1        | Modo monousuário (manutenção)      | Reparos, recuperação |
| 2        | Multiusuário sem rede (padrão)     | Servidores básicos   |
| 3        | Multiusuário com rede              | Servidores com rede  |
| 4        | Não utilizado (personalizável)     | -                    |
| 5        | Multiusuário com interface gráfica | Estações de trabalho |
| 6        | Reinicialização                    | `reboot`             |

---

## Desligamento e Reinicialização:

1. **Sinal recebido** (ex: `shutdown -h now`).
2. **Init executa scripts `/etc/rc0.d/`**:
   - Scripts `K` param serviços em ordem reversa.
3. **Desmontagem de sistemas de arquivos**.
4. **Envio de sinal `SIGTERM`/`SIGKILL`** para processos restantes.
5. **Chamada ao kernel** para desligar/reiniciar.

---

## Diferenças em Relação ao Systemd:

| Característica     | SysVinit (Devuan)                 | Systemd (Outras Distros)       |
| ------------------ | --------------------------------- | ------------------------------ |
| **Filosofia**      | Simplicidade, scripts shell       | Monolítico, binários complexos |
| **Configuração**   | Arquivos textuais (`inittab`)     | Arquivos `.service`            |
| **Dependências**   | Ordem numérica (ex: `S10`, `S20`) | Declaração explícita           |
| **Logs**           | Arquivos textuais (`/var/log/`)   | Journal binário (`journalctl`) |
| **Comandos**       | `service`, `update-rc.d`          | `systemctl`, `journalctl`      |
| **Personalização** | Edição direta de scripts          | Sobrescrita via `drop-ins`     |

---

## Vantagens no Devuan:

- **Previsibilidade**: Comportamento determinístico baseado em scripts.
- **Depuração**: Erros visíveis em arquivos de log textuais.
- **Portabilidade**: Scripts compatíveis com outros sistemas Unix-like.
- **Controle Granular**: Modificação manual da sequência de inicialização.

---

## 8. Personalização e Adicição de Serviços:

1. Crie script em `/etc/init.d/meuservico`:
   
   ```bash
   #!/bin/sh
   case "$1" in
     start) echo "Iniciando serviço";;
     stop) echo "Parando serviço";;
   esac
   ```

2. Torne executável:
   
     chmod +x /etc/init.d/meuservico

3. Instale nos runlevels:
   
     update-rc.d meuservico defaults

Alterando Runlevel Padrão 

Edite /etc/inittab: 

     id:3:initdefault:  # Muda para runlevel 3 (multiusuário com rede)

9. Solução de Problemas 
   Logs Relevantes 
   
     /var/log/boot.log: Saída da inicialização.
     /var/log/syslog: Eventos do sistema.
     /var/log/dmesg: Mensagens do kernel.

## Comandos Úteis:

Verificar runlevel atual
     runlevel

Forçar reinicialização segura
     telinit 6

Listar serviços ativos
     ls /etc/rc2.d/ | grep "

## Conclusão:

O SysVinit no Devuan oferece um modelo tradicional, transparente e personalizável para gerenciamento de inicialização. Sua simplicidade contrasta com abordagens modernas como o systemd, priorizando controle do administrador e compatibilidade com o ecossistema Unix. Para usuários que valorizam estabilidade e previsibilidade, o Devuan com SysVinit é uma alternativa robusta.


THAT'S ALL FOLKS!!
