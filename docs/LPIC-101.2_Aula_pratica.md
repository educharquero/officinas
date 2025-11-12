# ⚙️ Aula Prática – LPI 101.2: Inicialização do Sistema Linux

## 🎯 Objetivo Geral

Compreender e visualizar **como o Linux inicializa**, desde o BIOS/UEFI até o `systemd`, entendendo o papel do **bootloader (GRUB)**, do **kernel**, e dos **serviços do sistema**.  
Ao final, o aluno será capaz de **analisar problemas de boot**, **listar serviços ativos**, e **identificar fases da inicialização**.

---

## 📚 Contexto no LPI 101.2

Corresponde ao tópico “**Boot the system**” do exame **LPI 101**, abordando:

- Sequência de inicialização: BIOS/UEFI → Bootloader → Kernel → init/systemd  
- Gerenciador de boot (GRUB)  
- Modos de inicialização (runlevels / targets)  
- Logs de inicialização  
- Gerenciamento de serviços com `systemctl`

---

## 🧩 Requisitos

- Qualquer sistema Linux com `systemd`  
- Acesso `sudo`  
- Terminal com privilégios administrativos  
- (Opcional) Máquina virtual para simulações de falhas de boot  

---

# 🕐 Duração Total: ~25 minutos

---

## 🧠 1. Introdução Teórica (3 min)

📖 **Pontos de fala:**

1. O processo de inicialização segue estas fases:
   - **BIOS/UEFI:** inicia o hardware e procura um disco bootável.
   - **Bootloader (GRUB):** carrega o kernel na memória.
   - **Kernel:** inicializa os dispositivos e monta o sistema de arquivos raiz.
   - **systemd/init:** inicia os serviços e prepara o ambiente de login.

💡 **Dica:** Mostre um diagrama rápido (mesmo desenhado no quadro):

```
BIOS/UEFI → GRUB → Kernel → systemd → Login
```

---

## 🚀 2. Verificando o Bootloader (GRUB) (4 min)

### Comando:

```bash
sudo cat /boot/grub/grub.cfg | less
```

👩‍🏫 **Explique:**

- O `grub.cfg` contém as entradas de inicialização (menuentries).

- Mostre uma entrada típica:
  
  ```
  menuentry 'Ubuntu' {
      linux /boot/vmlinuz-6.8.0 root=UUID=... ro quiet splash
      initrd /boot/initrd.img-6.8.0
  }
  ```

- A linha `linux` indica o **kernel** e os **parâmetros de boot**.

- `initrd` é o **ramdisk inicial** (contém drivers e scripts usados antes de montar o root FS).

💡 **Dica:**  
Peça aos alunos para identificar o parâmetro `root=` e explicar o que ele define.

---

## 🧩 3. Identificando o Kernel em Uso (2 min)

### Comando:

```bash
uname -r
```

👩‍🏫 **Explique:**

- Mostra a versão do kernel atualmente carregada.
- Compare com as entradas do GRUB.

---

## 🔥 4. Observando o Processo de Inicialização (4 min)

### Comandos:

```bash
sudo journalctl -b
```

ou para ver apenas mensagens do kernel:

```bash
sudo journalctl -k -b
```

📖 **Explique:**

- `journalctl -b` mostra todos os logs do último boot.
- É útil para diagnosticar **falhas de serviços ou drivers** na inicialização.

💡 **Dica:**  
Mostre como filtrar:

```bash
sudo journalctl -b | grep -i error
```

---

## ⚙️ 5. Entendendo o systemd (6 min)

### Listar serviços ativos:

```bash
systemctl list-units --type=service --state=running
```

### Listar unidades com falha:

```bash
systemctl --failed
```

👩‍🏫 **Explique:**

- `systemd` é o gerenciador de inicialização e serviços do Linux moderno.
- Cada serviço é uma *unit*, e há dependências entre elas.
- Compare com o antigo modelo SysV (runlevels).

---

## 🔄 6. Runlevels vs Targets (4 min)

### Comando:

```bash
systemctl get-default
```

👩‍🏫 **Explique:**

- Mostra o *target* padrão (geralmente `graphical.target` ou `multi-user.target`).
- Cada target equivale a um runlevel do SysV.

|-------------------------------------------------------------------|
| Runlevel | Target equivalente | Descrição                         |
| -------- | ------------------ | --------------------------------- |
| 0        | poweroff.target    | Desligar                          |
| 1        | rescue.target      | Modo de recuperação (single-user) |
| 3        | multi-user.target  | Modo texto multiusuário           |
| 5        | graphical.target   | Interface gráfica                 |
| 6        | reboot.target      | Reiniciar                         |
|-------------------------------------------------------------------|

### Alterar temporariamente:

```bash
sudo systemctl isolate multi-user.target
```

### Tornar permanente:

```bash
sudo systemctl set-default multi-user.target
```

---

## 🧰 7. Investigando o Tempo de Boot (3 min)

### Comando:

```bash
systemd-analyze
```

### Explicação:

Mostra quanto tempo levou o boot e quanto cada parte demorou:

```
Startup finished in 2.934s (kernel) + 5.126s (userspace) = 8.060s
```

Para detalhar os serviços mais lentos:

```bash
systemd-analyze blame
```

💡 **Dica:**  
Peça aos alunos para identificar qual serviço mais demorou no sistema deles.

---

## 💬 8. Discussão e Conclusão (4 min)

### Questões:

1. Quais são as fases do processo de inicialização?
2. O que é o GRUB e qual sua função?
3. Qual diferença entre `multi-user.target` e `graphical.target`?
4. Como verificar se algum serviço falhou no boot?
5. Onde encontrar mensagens de inicialização?

📚 **Resumo:**

- BIOS/UEFI → GRUB → Kernel → systemd  
- GRUB carrega o kernel e initrd.  
- `systemd` organiza a inicialização dos serviços e targets.  
- Ferramentas úteis: `journalctl`, `systemctl`, `systemd-analyze`.

---

## 🧾 Referências

- [LPI Learning 101.2 – Boot the System](https://learning.lpi.org/en/learning-materials/101-500/101-2/)
- `man systemd`
- `man systemctl`
- `man journalctl`
- `man grub`
- `/usr/share/doc/systemd/`

---

## 🧭 Sugestão Extra (para casa)

1. Edite uma entrada temporária no GRUB (pressionando `e` no boot) e adicione o parâmetro `single` para iniciar em modo de recuperação.

2. Use `systemctl rescue` para alternar entre modos.

3. Analise o log de boot anterior com:
   
   ```bash
   sudo journalctl -b -1
   ```

---

✳️ **Tempo total:** ~25 minutos
✳️ **Objetivo didático atingido:** aluno compreende o processo de inicialização e domina as ferramentas de diagnóstico de boot.



THAT'S ALL FOLKS!
