# 🧠 Entendendo a NVRAM no UEFI

## 🎯 Objetivo
Compreender o que é a **NVRAM** (Non-Volatile RAM), sua função no **UEFI**, e como manipulá-la no Linux utilizando ferramentas de linha de comando.

---

## ⚙️ O que é NVRAM

**NVRAM (Non-Volatile Random Access Memory)** é um tipo de memória que **mantém seus dados mesmo sem energia elétrica**.

No contexto do **UEFI**, a NVRAM é usada para armazenar **variáveis persistentes do firmware**, como:

- Entradas de boot (ex: “Ubuntu”, “Windows Boot Manager”)  
- Ordem de inicialização  
- Parâmetros de kernel ou configurações do firmware  
- Dados de segurança e chaves de inicialização segura (Secure Boot)

---

## 💾 Localização física

A NVRAM fica **dentro do mesmo chip de memória flash da placa-mãe** onde o firmware UEFI está gravado.  
Ela é uma **pequena área reservada** separada do código principal do firmware.

📘 Isso significa que **mesmo desligando o computador ou removendo a bateria CMOS**, os dados da NVRAM continuam armazenados.

---

## 🧩 Função no processo de inicialização

Durante o boot, o UEFI:

1. Carrega o firmware da memória flash.  
2. Lê da **NVRAM** as variáveis de boot (`Boot0000`, `Boot0001`, etc.).  
3. Determina a **ordem de boot** (`BootOrder`).  
4. Localiza o **EFI System Partition (ESP)** e carrega o bootloader (por exemplo, GRUB, Windows Boot Manager).  

📈 Essas variáveis UEFI armazenadas na NVRAM são o que definem **qual sistema operacional inicia primeiro**.

---

## 🧰 Manipulando variáveis UEFI/NVRAM no Linux

Para interagir com a NVRAM, utilizamos os comandos `efivar` e `efibootmgr`.

### 🔍 Listar todas as variáveis UEFI:
```bash
sudo efivar -l
```

### 📄 Exibir o conteúdo de uma variável específica:
```bash
sudo efivar -p -n Boot0000
```

### 🧾 Listar as entradas de boot:
```bash
sudo efibootmgr
```

Saída típica:
```
BootCurrent: 0000
BootOrder: 0000,0001,0002
Boot0000* ubuntu
Boot0001* Windows Boot Manager
```

### 🔄 Alterar a ordem de boot:
```bash
sudo efibootmgr -o 0001,0000
```

👉 Neste exemplo, o **Windows Boot Manager** terá prioridade sobre o **Ubuntu** no próximo boot.

---

## 🧠 Comparativo: BIOS (CMOS) vs UEFI (NVRAM)

| Característica | BIOS (CMOS) | UEFI (NVRAM) |
|----------------|-------------|---------------|
| Tipo de memória | CMOS (volátil) | NVRAM (não volátil) |
| Armazenamento | Configurações simples (hora, ordem de boot) | Estrutura padronizada com múltiplas variáveis |
| Persistência sem energia | Depende da bateria CMOS | Persistente mesmo sem energia |
| Suporte a múltiplos sistemas | Limitado | Avançado e padronizado (entradas EFI separadas) |
| Ferramentas de acesso | Setup BIOS | `efibootmgr`, `efivar` |

---

## 💡 Curiosidades

- A NVRAM usa um **sistema de variáveis nomeadas** — cada uma tem um identificador único (UUID) e pode armazenar dados binários ou texto.  
- O UEFI cria variáveis como `BootOrder`, `BootNext`, `BootCurrent`, `SecureBoot`, etc.  
- Em sistemas dual boot, cada SO pode adicionar sua própria entrada na NVRAM.  

Exemplo de entrada GRUB:
```
Boot0000* ubuntu HD(1,GPT,1234-5678-9ABC-DEF0,0x800,0x32000)/File(\EFI\ubuntu\grubx64.efi)
```

---

## 🧾 Referências

- [UEFI Specification – Boot Manager Variables](https://uefi.org/specifications)
- `man efibootmgr`
- `man efivar`
- `/sys/firmware/efi/efivars/` (diretório do kernel com variáveis NVRAM)
- [LPI Learning 101.2 – Boot the System](https://learning.lpi.org/en/learning-materials/101-500/101-2/)

---

## ✅ Resumo

| Conceito | Explicação |
|-----------|------------|
| **NVRAM** | Memória não volátil usada pelo UEFI para armazenar variáveis persistentes |
| **Função principal** | Guardar entradas e ordem de boot |
| **Ferramentas Linux** | `efibootmgr`, `efivar` |
| **Local físico** | Chip de firmware da placa-mãe |
| **Vantagem** | Dados estruturados e persistentes, sem depender da bateria CMOS |

---

✳️ **Em resumo:**  
A **NVRAM é o “banco de dados” interno do UEFI**, onde ficam todas as variáveis de inicialização.  
Ela substitui o antigo CMOS, sendo mais confiável, persistente e flexível.
