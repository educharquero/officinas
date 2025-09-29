# 📁 FHS Filesystem Hierarchy Standard

##  A estrutura Hierárquica de Diretórios no Linux

O sistema operacional Linux utiliza uma estrutura de diretórios hierárquica e organizada para gerenciar todos os arquivos e recursos do sistema. Compreender essa estrutura é fundamental para usuários e administradores, pois fornece uma visão clara da organização do sistema de arquivos e onde encontrar ou armazenar diferentes tipos de dados.

A hierarquia de diretórios no Linux é padronizada pelo Filesystem Hierarchy Standard (FHS), que define a função de cada diretório e estabelece convenções para a organização dos arquivos. Ao entender a finalidade de cada diretório, os usuários podem navegar no sistema com mais facilidade, armazenar dados nos locais apropriados e os administradores podem gerenciar o sistema de forma eficiente.

Neste documento, exploraremos detalhadamente os principais diretórios do sistema, desde o diretório raiz até os locais destinados a programas, configurações, arquivos temporários e muito mais. Vamos examinar a função de cada diretório, os tipos de dados armazenados neles e como eles contribuem para o funcionamento adequado do sistema Linux.

Vamos mergulhar na estrutura de diretórios do Linux para entender melhor como o sistema organiza seus arquivos e recursos, proporcionando uma base sólida para a utilização e administração do sistema operacional:


## `/`

- O diretório raiz é o ponto inicial do sistema de arquivos. Todos os outros diretórios e arquivos são acessíveis a partir daqui.

## `/bin`

- É um `link simbólico` apontando para `/usr/bin`, contendo os binários essenciais do sistema. Estes incluem comandos básicos do sistema utilizados tanto por usuários regulares quanto por administradores.

## `/boot`

- Armazena os arquivos necessários para inicialização do sistema, como o kernel, arquivos de configuração do bootloader e informações relacionadas à inicialização.

## `/dev`

- Contém arquivos de dispositivo, que representam dispositivos físicos ou virtuais no sistema. Cada hardware é representado como um arquivo neste diretório.

## `/etc`

- É o diretório onde os arquivos de configuração do sistema e dos aplicativos são armazenados. Isso inclui configurações de rede, informações de usuários, configurações de serviços e muito mais.

## `/home`

- Contém os diretórios pessoais dos usuários. Cada usuário normalmente possui um diretório correspondente aqui, onde podem armazenar seus arquivos pessoais.

## `/lib` e `/lib64`

- São `links simbólicos` apontando para `/usr/lib` e `/usr/lib64`, onde se armazenam as bibliotecas compartilhadas e módulos do kernel, necessárias para os binários localizados em `/usr/bin` e `/usr/sbin`. Enquanto o `/lib` é usado para sistemas de 32 bits, o `/lib64` dá suporte para sistemas de 64 bits.

## `/media` e `/mnt`

- São diretórios para montagem temporária de dispositivos de armazenamento removíveis. O diretório `/media` é geralmente utilizado para montagem automática, enquanto `/mnt` é comumente utilizado para montagens manuais.

## `/opt`

- É utilizado para a instalação de pacotes de software adicionais que não são parte da distribuição principal. Os aplicativos instalados aqui têm suas próprias subpastas separadas.

## `/proc` e `/sys`

- São sistemas de arquivos virtuais que fornecem informações sobre processos, hardware e interfaces do kernel. O diretório `/proc` contém informações em tempo real sobre o sistema, enquanto `/sys` é usado para interagir com o kernel.

## `/sbin`

- É um `link simbólico` apontando para `/usr/sbin`, armazenando binários do sistema utilizados principalmente pelo superusuário (root) para realizar tarefas administrativas. Esses comandos geralmente não estão disponíveis para usuários regulares.

## `/tmp`

- É um diretório destinado a arquivos temporários. O conteúdo aqui é frequentemente excluído entre as reinicializações do sistema.

## `/usr`

- Uma hierarquia secundária, contendo a maioria dos programas, bibliotecas e documentações do sistema. É subdividido em `/usr/bin`, `/usr/sbin`, `/usr/lib`, entre outros, que contêm executáveis, binários de sistema, bibliotecas e outros recursos.

## `/var`

- Armazena arquivos que podem variar de tamanho dinamicamente durante a operação do sistema. Isso inclui logs, spools de impressão, arquivos de cache e bancos de dados.

Esta é uma visão mais detalhada da estrutura de diretórios no Linux, destacando a função e o propósito de cada diretório. Cada um desempenha um papel vital no funcionamento adequado do sistema operacional.


that's all folks!

