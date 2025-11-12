# ⚙️ Aula Prática – LPI 101.3: Runlevels, Targets e Gerenciamento de Inicialização

## 🎯 Objetivo da Aula
Compreender e praticar o uso de **runlevels (SysVinit)** e **targets (systemd)**, além dos comandos para **inicializar, desligar e reiniciar** o sistema.

---

## 📚 Conteúdo da LPI 101.3
- Identificar e alterar **runlevels / targets**.
- Entender as diferenças entre **SysVinit** e **systemd**.
- Usar comandos de **shutdown**, **reboot**, **halt** e **poweroff**.
- Controlar o **estado do sistema** com `systemctl`.

---

## 🧩 Parte 1 – Identificando o sistema de inicialização

Antes de tudo, descubra qual sistema seu Linux usa:

```bash
ps -p 1 -o comm=
```

📘 Saída possível:
- `systemd` → sistema moderno (Ubuntu 16+, RHEL7+, Debian 8+)
- `init` → sistema clássico SysVinit

---

## 🧭 Parte 2 – Verificando o nível de execução atual (runlevel ou target)

### 🧮 No SysVinit:
```bash
runlevel
```

Saída típica:
```
N 5
```
> Isso significa que o sistema está no **runlevel 5 (gráfico)**.

### ⚙️ No systemd:
```bash
systemctl get-default
```

Saída:
```
graphical.target
```

🧠 **Equivalência prática:**

| Runlevel (SysVinit) | systemd Target | Descrição |
|----------------------|----------------|------------|
| 0 | `poweroff.target` | Desligar |
| 1 | `rescue.target` | Modo de recuperação (single-user) |
| 3 | `multi-user.target` | Modo texto, rede ativa |
| 5 | `graphical.target` | Modo gráfico |
| 6 | `reboot.target` | Reiniciar |

---

## 🔄 Parte 3 – Mudando de runlevel / target

### 📉 SysVinit:
Para mudar temporariamente:
```bash
init 3
```

Para mudar permanentemente:
```bash
sudo nano /etc/inittab
# Modifique a linha:
id:5:initdefault:
```

### 🆙 systemd:
Mudar temporariamente (não afeta reinicialização):
```bash
sudo systemctl isolate multi-user.target
```

Mudar permanentemente:
```bash
sudo systemctl set-default multi-user.target
```

---

## 💡 Demonstração prática (systemd)

1. Descubra o target atual:
   ```bash
   systemctl get-default
   ```

2. Troque para modo texto:
   ```bash
   sudo systemctl isolate multi-user.target
   ```

3. Volte ao modo gráfico:
   ```bash
   sudo systemctl isolate graphical.target
   ```

4. Defina o modo gráfico como padrão:
   ```bash
   sudo systemctl set-default graphical.target
   ```

💬 Dica:  
Após trocar de target, observe o comportamento do ambiente gráfico — ele se encerrará ou voltará conforme o target escolhido.

---

## 🧯 Parte 4 – Modos de Resgate e Emergência

O **systemd** permite inicializar em modos de recuperação:

```bash
sudo systemctl isolate rescue.target
```

Ou em modo **emergência** (shell mínima, sem serviços):
```bash
sudo systemctl isolate emergency.target
```

Para voltar:
```bash
sudo systemctl default
```

---

## ⚡ Parte 5 – Desligando e Reiniciando o Sistema

Comandos clássicos:
```bash
shutdown -h now     # Desligar imediatamente
shutdown -r +5 "Reiniciando em 5 minutos"
halt
poweroff
reboot
```

🧠 Todos esses comandos chamam internamente o **systemctl**:

```bash
systemctl poweroff
systemctl reboot
```

---

## 🧪 Parte 6 – Verificando logs de desligamento e boot

Veja o histórico dos boots:
```bash
last -x | grep reboot
```

Ou examine o log de inicialização:
```bash
journalctl -b
```

📘 Use `journalctl -b -1` para ver o log do boot anterior.

---

## 🧰 Parte 7 – Serviços e targets com `systemctl`

### 🔍 Listar todos os targets:
```bash
systemctl list-units --type=target
```

### 🧩 Ver dependências de um target:
```bash
systemctl list-dependencies graphical.target
```

### 🚀 Ver serviços iniciados:
```bash
systemctl list-units --type=service
```

---

## 💬 Atividade prática em sala

> Simule cenários de administração real:

1. Altere o target padrão para modo texto.  
2. Reinicie o sistema e confirme o modo.  
3. Troque para modo gráfico sem reiniciar.  
4. Liste os serviços que iniciam no modo multi-user.  
5. Veja os logs de boot e identifique o tempo total de inicialização (`systemd-analyze`).

---

## 🧠 Comparativo SysVinit vs systemd

| Conceito | SysVinit | systemd |
|-----------|-----------|----------|
| Arquivo de configuração | `/etc/inittab` | `/etc/systemd/system/default.target` |
| Runlevel | Numérico (0–6) | Nomeado (targets) |
| Scripts de inicialização | `/etc/rc.d/rc*.d/` | Unidades (`*.service`, `*.target`) |
| Comando de troca | `init` | `systemctl isolate` |
| Controle de serviços | `service` | `systemctl` |

---

## 🧾 Referências

- `man systemctl`
- `man systemd.target`
- `man shutdown`
- [LPI Learning 101.3 – Change runlevels / boot targets and shutdown or reboot system](https://learning.lpi.org/en/learning-materials/101-500/101-3/)
- `/lib/systemd/system/`
- `/etc/systemd/system/`

---

## ✅ Resumo

| Ação | Comando |
|------|----------|
| Ver target atual | `systemctl get-default` |
| Mudar target temporariamente | `systemctl isolate nome.target` |
| Mudar target padrão | `systemctl set-default nome.target` |
| Ver serviços e targets | `systemctl list-units` |
| Desligar sistema | `systemctl poweroff` ou `shutdown -h now` |
| Reiniciar sistema | `systemctl reboot` |
| Entrar em modo de resgate | `systemctl isolate rescue.target` |

---

✳️ **Em resumo:**  
Esta prática permite ao aluno **compreender e experimentar os estados de inicialização do Linux**, tanto no modelo clássico **SysVinit** quanto no **systemd** moderno, dominando comandos críticos para administração de servidores e sistemas.
