# 📁 Tutorial de Permissões de Arquivos e Diretórios no Linux

> Aprenda a visualizar, modificar e entender o sistema de permissões no Linux utilizando comandos como `chmod`, `chown` e `chgrp`.

---

## 🔍 Introdução

O sistema de permissões do Linux é fundamental para garantir a segurança e organização do sistema. Cada arquivo ou diretório possui regras que definem quem pode **ler (r)**, **escrever (w)** e **executar (x)**.

---

## 📑 Entendendo as Permissões

Execute:

```bash
ls -l
```

Exemplo de saída:

```
-rwxr-xr-- 1 user grupo 1234 jul 28 10:00 script.sh
```

Explicando os campos:

| Campo          | Significado                                  |
| -------------- | -------------------------------------------- |
| `-`            | Tipo de arquivo (`-` arquivo, `d` diretório) |
| `rwx`          | Permissões do **dono**                       |
| `r-x`          | Permissões do **grupo**                      |
| `r--`          | Permissões de **outros (público)**           |
| `1`            | Número de links                              |
| `user`         | Dono do arquivo                              |
| `grupo`        | Grupo do arquivo                             |
| `1234`         | Tamanho em bytes                             |
| `jul 28 10:00` | Data de modificação                          |
| `script.sh`    | Nome do arquivo                              |

---

## 🔧 Modificando Permissões: `chmod`

### 🧮 Modo Numérico

As permissões são representadas por números:

| Permissão     | Valor |
| ------------- | ----- |
| `r` (read)    | 4     |
| `w` (write)   | 2     |
| `x` (execute) | 1     |

**Exemplo**:

```bash
chmod 754 script.sh
```

Isso define:

- Dono: `7` = `rwx`
- Grupo: `5` = `r-x`
- Outros: `4` = `r--`

### 🔤 Modo Simbólico

```bash
chmod u+x script.sh
```

Adiciona permissão de execução para o **usuário (u)**.

Outros símbolos:

| Símbolo | Descrição                          |
| ------- | ---------------------------------- |
| `u`     | Usuário (owner)                    |
| `g`     | Grupo                              |
| `o`     | Outros                             |
| `a`     | Todos                              |
| `+`     | Adiciona permissão                 |
| `-`     | Remove permissão                   |
| `=`     | Define exatamente essas permissões |

**Exemplos**:

```bash
chmod g-w arquivo.txt     # Remove escrita do grupo
chmod o=r arquivo.txt     # Outros só podem ler
chmod a+x script.sh       # Todos ganham permissão de execução
```

---

## 👤 Mudando Dono e Grupo: `chown` e `chgrp`

### `chown` – Altera o dono e/ou grupo

```bash
chown novo_dono arquivo.txt
chown novo_dono:novo_grupo arquivo.txt
```

### `chgrp` – Altera apenas o grupo

```bash
chgrp novo_grupo arquivo.txt
```

**Exemplo**:

```bash
chown joao:desenvolvedores projeto/
```

---

## 📁 Permissões em Diretórios

As permissões têm efeitos diferentes:

| Permissão | Significado no diretório      |
| --------- | ----------------------------- |
| `r`       | Listar arquivos (`ls`)        |
| `w`       | Criar/apagar arquivos         |
| `x`       | Acessar arquivos no diretório |

---

## 🔄 Permissões Recursivas

```bash
chmod -R 755 pasta/
chown -R user:grupo pasta/
```

---

## 📌 Permissões Especiais

### 🔒 `setuid` (S)

Permite que o programa execute com permissões do dono.

```bash
chmod u+s arquivo
```

### 🔒 `setgid` (S)

Arquivos criados no diretório herdam o grupo.

```bash
chmod g+s pasta
```

### 🔒 Sticky bit (t)

Em diretórios públicos, evita que usuários deletem arquivos de outros.

```bash
chmod +t /tmp
```

---

## 🧪 Exemplos Práticos

### 1. Tornar um script executável apenas para o dono:

```bash
chmod 700 script.sh
```

### 2. Permitir que todos leiam um arquivo, mas apenas o dono possa editar:

```bash
chmod 644 documento.txt
```

### 3. Definir uma pasta compartilhada por um grupo:

```bash
chgrp grupo pasta/
chmod 2770 pasta/
```

---

## ✅ Verificando Permissões

```bash
stat arquivo.txt
```

---

## 🛑 Atenção

- Cuidado com `chmod 777` — permite tudo para todos, o que representa risco de segurança.
- Modifique permissões com consciência, especialmente em ambientes multiusuário ou servidores.

---

## 📚 Referências

- `man chmod`
- `man chown`
- `man chgrp`
- [The Linux Documentation Project](https://tldp.org)
