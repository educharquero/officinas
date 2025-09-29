# OpenSUSE TW Pós instalação:

## Atualiza a distibuição

```
sudo zypper ref && sudo zypper dup
```

## Alterando o valor da swappiness

```
sudo nano /etc/sysctl.conf
```

```
vm.swappiness=10
```

## Adicionando o Repositório Packman (codecs non-free)

```
sudo zypper addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
```

## Importando a chave da assinatura GPG do repositório

```
sudo zypper --gpg-auto-import-keys ref
```

## Atualização no sistema a partir do repositório Packman

```
sudo zypper dist-upgrade --from packman --allow-vendor-change
```

## Instalando os codecs no openSUSE Tumbleweed

```
sudo zypper install --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec
```

## Adicionando o repositório Flathub (Flatpak)

```
sudo zypper in flatpak
```

```
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

## Instalando a máquina virtual JAVA

```
sudo zypper in java-24-openjdk
```

## Suporte para extração e compactação de arquivos

```
sudo zypper in bzip2 cabextract lhasa lzip 7zip rar unrar unzip zip
```

## Baixar torrents

```
sudo zypper in qbittorrent
```

## Player VLC

```
sudo zypper in --from packman vlc vlc-codecs
```

## Edição de vídeo

```
sudo zypper in --from packman kdenlive
```

## Gravação de tela

```
sudo zypper in --from packman obs-studio
```

## Cliente de email

```
sudo zypper in thunderbird
```

## Cliente de chat

```
flatpak install discord
```

```
flatpak install telegram
```

## Ferramentas para gerenciamento de Banco de dados

```
flatpak install dbeaver
```

```
flatpak install pgadmin4
```

## Navegadores

```
flatpak install chrome
```

```
flatpak install edge
```

## Ferramenta de acesso remoto

```
flatpak install rustdesk
```

## Gerenciamento de discos

```
sudo zypper in gparted
```

## Instalando o Virtualbox

```
sudo zypper in virtualbox virtualbox-guest-tools
```

```
sudo gpasswd -a $USER vboxusers
```

## Gnome

Instale o Gerenciador de Extensões, pelo "Programas" e busque pela extensão "dash2doc animated"

## MKDocs Server

```
sudo zypper install python313-pipx
```

```
sudo pipx install mkdocs
```

```
sudo mkdocs --version
```

```
sudo mkdocs new mkdocs
```

```
sudo mkdocs build
```

```
mkdocs serve -a localhost
```
