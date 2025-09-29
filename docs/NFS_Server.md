# 📁 NFS Server no Debian Linux

O **NFS (Network File System)** permite que sistemas Linux compartilhem diretórios e arquivos pela rede, como se estivessem em um mesmo disco local.  
Neste tutorial, você aprenderá a configurar um servidor NFS no **Debian Linux** e montar os compartilhamentos em clientes.

---

## 🖥️ 1. Pré-requisitos

- Um servidor rodando **Linux**
- Acesso root ou permissões `sudo`
- Um ou mais clientes Linux (também pode ser Debian, Ubuntu, CentOS, etc.)

---

## 📦 2. Instalando o Servidor NFS

No servidor:

```bash
sudo apt update
sudo apt install nfs-kernel-server -y
```

---

## 📂 3. Criando Diretório para Compartilhamento

Crie a pasta que será compartilhada:

```bash
sudo mkdir -p /srv/nfs/<minha-pasta>
```

Defina as permissões (exemplo: acesso leitura/escrita para todos os clientes da rede):

```bash
sudo chown -R nobody:nogroup /srv/nfs/<minha-pasta>
sudo chmod -R 777 /srv/nfs/<minha-pasta>
```

Valide as permissões:

```bash
sudo ls -l /srv/nfs/<minha-pasta>
```
---

## ⚙️ 4. Configurando o Arquivo de `EXPORTAÇÃO` para a rede ter acesso á SUA pasta.

Edite o arquivo `/etc/exports`:

```bash
sudo vim /etc/exports
```

Adicione uma linha especificando o diretório e as permissões.  
Exemplo (compartilhar para toda a rede local `192.168.0.0/24`):

```bash
/srv/nfs/<minha-pasta> 192.168.0.0/24(rw,sync,no_subtree_check,no_root_squash)
```

Parâmetros principais:

- `rw` → leitura e escrita
- `sync` → grava dados imediatamente no disco (mais seguro)
- `no_subtree_check` → melhora desempenho em subdiretórios
- `no_root_squash` → Permite acesso sem o usuário root

Após salvar, aplique as configurações:

```bash
sudo exportfs -ra
```

---

## ▶️ 5. Iniciando e Habilitando o Serviço

```bash
sudo systemctl enable nfs-server
sudo systemctl start nfs-server
sudo systemctl status nfs-server
```

---

## 💻 7. Configurando o Cliente NFS

No cliente (exemplo: outro Debian/Ubuntu):

### 7.1 Instale o cliente NFS

```bash
sudo apt install nfs-common -y
```

### 7.2 Crie um ponto de montagem

```bash
sudo mkdir -p /mnt/nfs/compartilhado
```

### 7.3 Monte manualmente o compartilhamento

```bash
sudo mount <ip-do-amigo>:/srv/nfs/<path-do-amigo  /mnt/nfs/compartilhado
```

*(Substitua `<ip-do-amigo>` pelo ip do Servidor NFS Remoto)*

Verifique com:

```bash
df -h | grep nfs
```

### 7.4 Montagem automática no boot (substitua com o ip do Servidor NFS Remoto)

Edite o arquivo `/etc/fstab` e adicione:

```bash
<ip-do-amigo>:/srv/nfs/<pasta-do-amigo> /mnt/nfs/compartilhado nfs defaults 0 0
```

---

## 🛠️ 8. Testando a Configuração

No cliente:

```bash
touch /mnt/nfs/compartilhado/teste.txt
```

Verifique no servidor:

```bash
ls -l /srv/nfs/compartilhado/
```

Se o arquivo aparecer, o compartilhamento está funcionando corretamente.

---

Para desmontar, use o comando:

```bash
sudo umount /mnt/nfs/compartilhado 
```

## ✅ Conclusão

Agora você tem um servidor **NFS configurado no Debian Linux**, com compartilhamento acessível a clientes da rede.  
Esse método é útil para **armazenamento centralizado, clusters de servidores e ambientes de virtualização**.


That's all Folks!
