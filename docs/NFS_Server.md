# 🔥 NFS Server no Debian 13 para disponibilizar diretórios

🎯 O Objetivo nesse tutorial de **NFS (Network File System)** é permitir que sistemas Linux compartilhem diretórios e arquivos pela rede, como se estivessem em um mesmo disco local.  

---

## 🌐 Topologia da rede:

- Domínio: OFFICINAS.EDU

- SRVFIREWALL 192.168.70.254/24

- SRVDC01 192.168.70.253/24

- SRVARQUIVOS 192.168.70.252/24

---

## 📦 Instalando o pacote do NFS Server

## No servidor:

```bash
sudo apt update
```

```bash
sudo apt install nfs-kernel-server
```

## 📂 Criando o Diretório para Compartilhamento

## Crie a pasta que será compartilhada:

```bash
sudo mkdir -p /srv/nfs/compartilhado
```

## Defina as permissões (exemplo: acesso leitura/escrita para todos os clientes da rede):

```bash
sudo chown -R nobody:nogroup /srv/nfs/compartilhado
```

```bash
sudo chmod -R 777 /srv/nfs/compartilhado
```

## Valide as permissões:

```bash
sudo ls -l /srv/nfs/compartilhado
```

## ⚙️  Configurando o Arquivo de `EXPORTAÇÃO` para a rede ter acesso á SUA pasta.

## Edite o arquivo `/etc/exports`:

```bash
sudo vim /etc/exports
```

## Adicione uma linha especificando o diretório e as permissões. Exemplo, compartilhar para toda a rede local `192.168.0.0/24`:

```bash
/srv/nfs/compartilhado 192.168.0.0/24(rw,sync,no_subtree_check,no_root_squash)
```

## Parâmetros principais:

- `rw` → leitura e escrita
- `sync` → grava dados imediatamente no disco (mais seguro)
- `no_subtree_check` → melhora desempenho em subdiretórios
- `no_root_squash` → Permite acesso sem o usuário root

## Após salvar, aplique as configurações:

```bash
sudo exportfs -ra
```

## ▶️  Iniciando e Habilitando o Serviço

```bash
sudo systemctl enable nfs-server
```

```bash
sudo systemctl start nfs-server
```

```bash
sudo systemctl status nfs-server
```

## 💻 Configurando o Cliente NFS, que podem ser máquinas Linux ou Windows com o pacote nfs-client instalado

## Instale o pacote do cliente NFS no Debian

```bash
sudo apt install nfs-common 
```

## Crie um ponto de montagem

```bash
sudo mkdir -p /mnt/nfs/compartilhado
```

## Monte manualmente o compartilhamento

```bash
sudo mount <ip-remoto>:/srv/nfs/<path-remoto>  /mnt/nfs/compartilhado
```

*(Substitua `<ip-remoto>` pelo ip do Servidor NFS Remoto)*

## Valide com:

```bash
df -h | grep nfs
```

## Montagem automática no boot (substitua com o ip do Servidor NFS Remoto)

## Edite o arquivo fstab e adicione o path

```bash
vim /etc/fstab
```

```bash
<ip-remoto>:/srv/nfs/<pasta-remota> /mnt/nfs/compartilhado nfs defaults 0 0
```

## 🛠️ Testando a Configuração

## No cliente:

```bash
touch /mnt/nfs/compartilhado/teste.txt
```

## Verifique no servidor:

```bash
ls -l /srv/nfs/compartilhado/
```

## Se o arquivo aparecer, o compartilhamento está funcionando corretamente.

## Para desmontar, use o comando:

```bash
sudo umount /mnt/nfs/compartilhado 
```

## ✅ Conclusão

## Agora você tem um servidor **NFS configurado no Debian Linux**, com compartilhamento acessível a clientes da rede. Esse método é útil para **armazenamento centralizado, clusters de servidores e ambientes de virtualização**.


That's all Folks!

