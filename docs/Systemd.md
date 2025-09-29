
# 📁 Tutorial Completo de systemd

## 📖 Introdução

O **systemd** é um *system and service manager* para sistemas Linux modernos. Ele substitui o **SysVinit** tradicional e provê recursos avançados para gerenciamento de serviços, inicialização do sistema, logging, controle de dependências e gerenciamento de recursos.

## 🛠️ Conceitos Fundamentais

### O que é o systemd?
- **Gerenciador de serviços**: Controla inicialização, interrupção e supervisão de processos.
- **Gerenciador de unidades (units)**: Tudo no systemd é representado como uma *unit*.
- **Inicialização paralela**: Acelera o boot executando serviços em paralelo.
- **Integração com journal**: Sistema de logs centralizado (`journalctl`).

### Tipos de Units
- `.service` → Representa serviços (daemons).
- `.socket` → Define sockets para ativação sob demanda.
- `.target` → Agrupamento lógico de units (substitui *runlevels*).
- `.mount` e `.automount` → Gerenciam pontos de montagem.
- `.timer` → Tarefas agendadas (substitui cron em alguns cenários).
- `.slice` e `.scope` → Gerenciam recursos (CPU, memória).

---

## 🚀 Comandos Essenciais

### Verificar status
```bash
systemctl status nginx.service
```

### Iniciar / Parar / Reiniciar
```bash
systemctl start nginx.service
systemctl stop nginx.service
systemctl restart nginx.service
```

### Habilitar / Desabilitar (no boot)
```bash
systemctl enable nginx.service
systemctl disable nginx.service
```

### Listar serviços ativos
```bash
systemctl list-units --type=service
```

### Recarregar unidades após alterações
```bash
systemctl daemon-reload
```

---

## 🧩 Trabalhando com Units

### Estrutura de uma Unit `.service`
Exemplo: `/etc/systemd/system/meuapp.service`
```ini
[Unit]
Description=Meu Aplicativo Exemplo
After=network.target

[Service]
ExecStart=/usr/bin/python3 /opt/meuapp/app.py
Restart=always
User=meuusuario
WorkingDirectory=/opt/meuapp

[Install]
WantedBy=multi-user.target
```

**Explicação:**

- `Description`: Descrição do serviço.
- `After`: Define dependências de inicialização.
- `ExecStart`: Comando que inicia o processo.
- `Restart`: Política de reinício (ex: always, on-failure).
- `User`: Usuário que executa o processo.
- `WorkingDirectory`: Diretório de trabalho.
- `WantedBy`: Indica em qual *target* o serviço será ativado.

### Ativar novo serviço
```bash
sudo systemctl daemon-reload
sudo systemctl enable meuapp.service
sudo systemctl start meuapp.service
```

---

## ⏱️ Timers (Agendamentos)

Exemplo de *timer* que roda um script diariamente:

Arquivo `/etc/systemd/system/backup.service`
```ini
[Unit]
Description=Backup Diário

[Service]
ExecStart=/usr/local/bin/backup.sh
```

Arquivo `/etc/systemd/system/backup.timer`
```ini
[Unit]
Description=Agendamento de Backup Diário

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Ativar:
```bash
sudo systemctl enable backup.timer
sudo systemctl start backup.timer
```

Ver timers ativos:
```bash
systemctl list-timers
```

---

## 📜 Logs e Diagnóstico

- Ver logs de todo o sistema:
```bash
journalctl
```

- Ver logs de um serviço específico:
```bash
journalctl -u nginx.service
```

- Acompanhar em tempo real:
```bash
journalctl -u meuapp.service -f
```

---

## 🔒 Gerenciamento de Recursos

O systemd integra-se ao **cgroups** do kernel Linux para controlar recursos:

Exemplo: limitar memória de um serviço (`/etc/systemd/system/meuapp.service.d/limites.conf`):
```ini
[Service]
MemoryMax=500M
CPUQuota=50%
```

Aplicar:
```bash
systemctl daemon-reexec
systemctl restart meuapp.service
```

---

## 🔄 Targets e Boot

### Targets comuns
- `graphical.target` → Interface gráfica.
- `multi-user.target` → Multiusuário, sem GUI.
- `rescue.target` → Modo de recuperação.
- `emergency.target` → Modo de emergência.

Ver target atual:
```bash
systemctl get-default
```

Alterar target padrão:
```bash
systemctl set-default multi-user.target
```

Entrar em modo de emergência:
```bash
systemctl isolate emergency.target
```

---

## 🧪 Exemplos Avançados

### Serviço com dependência de banco de dados
```ini
[Unit]
Description=Aplicativo Web
After=network.target mariadb.service
Requires=mariadb.service
```

### Socket Activation
Arquivo `/etc/systemd/system/meuapp.socket`:
```ini
[Unit]
Description=Socket para MeuApp

[Socket]
ListenStream=8080

[Install]
WantedBy=sockets.target
```

Arquivo `/etc/systemd/system/meuapp.service`:
```ini
[Service]
ExecStart=/opt/meuapp/server --socket-activated
```

---

## 📚 Conclusão

O **systemd** é muito mais do que um simples substituto do `init`:  
- Fornece controle detalhado sobre serviços.  
- Possibilita agendamentos com *timers*.  
- Facilita o monitoramento via *journal*.  
- Gerencia recursos de forma integrada.  

É uma ferramenta essencial para administradores de sistemas Linux modernos.  
