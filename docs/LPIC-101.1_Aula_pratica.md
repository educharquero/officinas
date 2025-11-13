# 🐧 Aula Prática – LPI 101.1: Arquitetura do Sistema (Detecção de Hardware)

## 🎯 Objetivo Geral

Proporcionar uma experiência prática para compreender como o **Linux detecta, identifica e gerencia dispositivos de hardware**, conectando os conceitos de **kernel**, **drivers**, **udev** e **device nodes (/dev)** com a prática real em terminal.

---

## 📚 Contexto no LPI 101.1

Esta aula cobre diretamente o tópico **“Determinar e configurar componentes de hardware”**, do exame **LPI 101**, abordando:

- O papel do kernel na detecção de hardware
- O uso do `dmesg`, `/proc`, `/sys`, `udev` e ferramentas de listagem
- Identificação e gerenciamento de dispositivos (USB, PCI, blocos, etc.)

---

## 🧩 Requisitos

- Distribuição Linux (Ubuntu, Debian, Fedora, etc.)
- Acesso `sudo` ou root
- Um pendrive USB (ou outro dispositivo USB removível)
- Dois terminais abertos lado a lado
- Ideal: projetar o terminal para a turma ver em tempo real

---

# 🕐 Duração Total: ~20 minutos

---

## 🧠 1. Introdução Teórica (3 min)

**Objetivo:** contextualizar o papel do kernel e do udev.

📖 **Pontos de fala:**

- O *kernel* detecta hardware e carrega módulos/drivers.
- O *udev* é responsável por criar/remover os arquivos em `/dev/`.
- `/proc` e `/sys` são interfaces virtuais para consultar o estado do sistema.
- Podemos observar o processo de detecção em tempo real.

💡 **Dica para o instrutor:**
Mostre rapidamente o conteúdo de `/dev` e explique que os “arquivos” ali representam dispositivos reais.

```bash
ls /dev | less
```

---

## 🔍 2. Observando o Kernel em Tempo Real (5 min)

### Comando:

```bash
sudo dmesg -w
```

### O que explicar:

- `dmesg` mostra mensagens do **kernel ring buffer**.
- O `-w` mantém a saída sendo atualizada continuamente.

👩‍🏫 **Demonstração:**

1. Execute o comando no terminal.
2. Peça a um aluno para **plugar o pendrive**.
3. Mostre as mensagens aparecendo, como:

```
[ 1234.567890] usb 1-1: new high-speed USB device number 7 using xhci_hcd
[ 1234.678901] usb-storage 1-1:1.0: USB Mass Storage device detected
[ 1234.679123] scsi host6: usb-storage 1-1:1.0
[ 1235.001234] sdb: sdb1
```

4. Agora, **desplugue o pendrive** e observe as mensagens de remoção.

🧭 **Perguntas para reflexão:**

- Qual driver o kernel carregou? (`usb-storage`)
- Qual dispositivo foi criado? (`/dev/sdb` ou `/dev/sdb1`)
- Por que o kernel precisa de um driver?

---

## ⚙️ 3. Monitorando Eventos com `udev` (5 min)

### Comando:

```bash
sudo udevadm monitor
```

### O que mostrar:

- Eventos **KERNEL** → disparados pelo kernel.
- Eventos **UDEV** → processados pelo sistema udev.

👩‍🏫 **Demonstração:**

1. Deixe o comando rodando.
2. Conecte o pendrive novamente.
3. Mostre saídas como:

```
KERNEL[1234.567890] add /devices/pci0000:00/.../usb1/1-1 (usb)
UDEV  [1234.678901] add /devices/.../sdb (block)
UDEV  [1234.789012] add /devices/.../sdb1 (block)
KERNEL[1238.901234] remove /devices/.../sdb1 (block)
```

💡 **Dica:**
Use a opção `--property` para mostrar atributos:

```bash
sudo udevadm monitor --udev --property
```

🎓 **Discussão rápida:**

- O que o *udev* faz após detectar o dispositivo?
- Quem cria o `/dev/sdb1`?
- Como o *udev* poderia ser configurado para executar uma ação (ex: montar o dispositivo)?

---

## 📊 4. Visualizando os Dispositivos de Bloco (3 min)

### Comando:

```bash
watch -n1 lsblk -f
```

### Explicação:

- O `watch` executa o comando periodicamente (a cada 1 segundo).
- O `lsblk` mostra os dispositivos de **bloco** e suas partições.

👩‍🏫 **Demonstração:**

1. Deixe o comando rodando.
2. Conecte o pendrive.
3. Veja o novo dispositivo (`/dev/sdb`, `/dev/sdb1`) aparecer.
4. Desconecte — observe desaparecer.

📌 **Ponto didático:**
Mostra visualmente a criação/remoção do *device node*.

---

## 🧰 5. Ferramentas Complementares (3 min)

### Comandos úteis:

```bash
lsusb                # Lista dispositivos USB
lspci                # Lista dispositivos PCI
sudo lshw -short     # Lista hardware resumido
sudo fdisk -l        # Mostra discos e partições detectados
cat /proc/partitions # Lista partições conhecidas pelo kernel
```

👩‍🏫 **Sugestão:** peça aos alunos para identificar o pendrive em cada uma dessas saídas.

---

## 🧩 6. Explorando o sysfs (2 min)

### Comando:

```bash
ls /sys/class/block/
```

### Explicação:

- `/sys` é um sistema de arquivos virtual gerenciado pelo kernel.
- Mostra detalhes de dispositivos, drivers e subsistemas.

👩‍🏫 **Atividade:**

1. Liste os dispositivos antes de plugar o pendrive.
2. Plugue o pendrive e veja novos diretórios (`sdb`, `sdb1`).

---

## 💬 7. Discussão e Conclusão (4 min)

### Questões para a turma:

1. Qual é o papel do `udev` no gerenciamento de dispositivos?
2. O que acontece se o kernel detecta um dispositivo, mas não há driver?
3. Onde ficam armazenadas as mensagens do kernel?
4. Qual é a diferença entre `/proc` e `/sys`?
5. Como o Linux cria o arquivo `/dev/sdb1`?

📚 **Resumo:**

- O kernel detecta o hardware e dispara eventos.
- O udev processa esses eventos e cria/remover os nós em `/dev`.
- Podemos monitorar tudo isso em tempo real com `dmesg` e `udevadm`.
- Ferramentas como `lsusb`, `lsblk` e `lspci` ajudam na inspeção.

---

## 🧾 Referências

- [Documentação oficial do LPI 101.1](https://learning.lpi.org/pt/learning-materials/101-500/101-1/)
- `man dmesg`
- `man udevadm`
- `man lsblk`
- `/proc` e `/sys` — documentação em `/usr/src/linux/Documentation/`

---

## 🧭 Sugestão Extra (para continuar em casa)

Peça aos alunos que:

1. Testem outros dispositivos (mouse, teclado, HD externo).
2. Observem como diferentes drivers são carregados.
3. Criem uma regra simples do `udev` que registra o evento em um log quando um pendrive é conectado.

---

✳️ **Tempo total:** ~20 minutos
✳️ **Objetivo didático atingido:** alunos entendem o fluxo **hardware → kernel → udev → /dev** de forma prática e visual.


THAT'S ALL FOLKS
