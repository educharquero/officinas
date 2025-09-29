# 📁 Servidor de documentação MkDocs


MkDocs é um gerador de site estático rápido, simples e absolutamente lindo que é voltado para a documentação do projeto de construção. Os arquivos de origem da documentação são gravados em Markdown e configurados com um único arquivo de configuração YAML.

#### Setando e validando o hostname do Servidor MkDocs:

```bash
hostnamectl set-hostname mkdocs
```

#### Configurando o arquivo de hosts:

```bash
vim /etc/hosts
```

```bash
.0.0.1             localhost
127.0.1.1          mkdocs.officinas.edu        mkdocs
192.168.70.150     fileserver.officinas.edu    fileserver
192.168.70.200     dcslave.officinas.edu       dcslave
192.168.70.222     mkdocs.officinas.edu        mkdocs
192.168.70.250     dcmaster.officinas.edu      dcmaster
192.168.70.254     firewall.officinas.edu      firewall
```

```bash
hostname -f
```

#### Setando ip fixo no servidor dcmaster:

```bash
vim /etc/network/interfaces
```

```bash
iface enp1s0 inet static
address           192.168.70.222
netmask           255.255.255.0
gateway           192.168.70.254
dns-nameserver    192.168.70.254 #(firewall)
dns-search        officinas.edu
```

#### Setando endereço do firewall como resolvedor externo:

```bash
vim /etc/resolv.conf
```

```bash
domain             officinas.edu
search             officinas.edu.
nameserver         192.168.70.254 #(firewall)
```

#### Validando o ip da placa:

```bash
ip -c addr
```

```bash
ip -br link
```

#### Instalação dos pacotes necessários ao Debian:

```bash
apt install wget net-tools tree python3-pip vim
```

#### Instalação dos pacotes do MkDocs:

```bash
apt install mkdocs mkdocs-material-extensions mkdocs-nature mkdocs-click
```

#### Validando versão do pacote:

```bash
mkdocs --version
```

#### Criando um novo projeto:

```bash
cd /opt/
mkdocs new mkdocs
cd /opt/mkdocs
```

#### Valide a criação da estrutura:

```bash
tree
```

```bash
├── docs
│   └── index.md
├── mkdocs.yml
└── site
    ├── 404.html
    ├── css
    │   ├── base.css
    │   ├── bootstrap.min.css
    │   └── font-awesome.min.css
    ├── fonts
    │   ├── FontAwesome.otf
    │   ├── fontawesome-webfont.eot
    │   ├── fontawesome-webfont.svg
    │   ├── fontawesome-webfont.ttf
    │   ├── fontawesome-webfont.woff
    │   └── fontawesome-webfont.woff2
    ├── img
    │   ├── favicon.ico
    │   └── grid.png
    ├── index.html
    ├── js
    │   ├── base.js
    │   ├── bootstrap.min.js
    │   └── jquery-1.10.2.min.js
    ├── search
    │   ├── lunr.js
    │   ├── main.js
    │   ├── search_index.json
    │   └── worker.js
    ├── sitemap.xml
    └── sitemap.xml.gz
```

#### Valida o ip do Servidor:

```bash
ip -c addr
```

#### Inicia o Servidor:

```bash
mkdocs serve -a 192.168.70.222:8000
```

```bash
INFO     -  Building documentation...
INFO     -  Cleaning site directory
INFO     -  Documentation built in 0.05 seconds
INFO     -  [10:41:22] Serving on http://192.168.70.222:8000/
```

#### Agora abra no seu navegador o endereço:

```bash
http://192.168.70.222:8000
```

#### Edite o arquivo de configuração principal:

```bash
vim /opt/mkdocs/mkdocs.yml
```
```bash
site_name: Officina's
theme:
  name: readthedocs
```

#### Restart do Serviço:

```bash
systemctl restart mkdocs
```

#### Agora vamos criar 2 arquivos de exemplo, "Sobre.md" e "Instalação.md":

```bash
vim /opt/mkdocs/docs/sobre.md
```

```bash
# Markdown

## O que é Markdown ?

Markdown é uma linguagem de marcação leve com sintaxe de formatação de texto simples projetada para que ela possa ser convertida em HTML e muitos outros formatos usando uma ferramenta com o mesmo nome. Markdown é usado frequentemente para formatar arquivos readme, para escrever mensagens em fóruns de discussão on-line e para criar texto rico usando um editor de texto simples.

## Porque usar Markdown?

* **FÁCIL** : A sintaxe é tão fácil que você pode aprender em um minuto ou dois, em seguida, escreva sem perceber nada estranho ou nerd.

* **RÁPIDO** : Ele economiza tempo em comparação com outros tipos de arquivos / formatos de texto. Isso ajuda a aumentar a produtividade e os fluxos de trabalho do escritor.

* **LIMPO** : Tanto a sintaxe como a saída são limpas, sem confusão com nossos olhos e simples de gerenciar.

* **FLEXÍVEL** : Com apenas algumas configurações, o seu texto será traduzido atravessando qualquer plataforma lá fora, editável em qualquer software de edição de texto e conversível para uma ampla variedade de formatos.


**Em resumo**, os usuários comuns acharão útil em todos os casos, especialmente quando você precisar de algo melhor que o texto simples, mas menos funcional do que o Microsoft Word.

**Para desenvolvedores**, Se você é preguiçoso para escrever código HTML, você vai adorar o markdown. **Além disso**, **Github** e muitos sites favorecem o markdown para o arquivo readme de projetos. Isso significa que você vai encontrar o markdown em sua vida de uma forma ou de outra.
```

```bash
vim /opt/mkdocs/docs/instalação.md
```
```bash
# apt install mkdocs
# pip3 install mkdocs
```
```bash

Crie um novo projeto chamado mkdocs e construa um novo site:
```bash
# cd /opt/
# mkdocs new mkdocs
# cd /opt/mkdocs
# mkdocs build
```

#### Inicie o serviço:
```bash
# mkdocs serve -a 192.168.70.222:8000
```

#### É possível inserir figuras na documentação, com a seguinte estrutura:
```bash
![Descrição da imagem](caminho/para/a/imagem.jpg)
```
#### ou
```bash
![Descrição da imagem](URL_da_imagem)
```

#### O MKDocs pode gerar conteúdo estático, para ser inserido no Apache Server ou NGINX Server:
```bash
mkdocs build
```

#### Vai criar um diretório chamado de site, que pode ser copiado para /var/www/html:
```bash
cp -rv /opt/mkdocs/site /var/www/html
```

#### Seta permissões no diretório:
```bash
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html 
```

#### Restart do Apache Server:
```bash
systemctl restart apache2
```

#### Acesse pelo seu navegador Web favorito:
```bash
http://192.168.70.251/site
```

THAT’S ALL FOLKS!!


