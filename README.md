# 🐧 Comunidade Officinas

![Banner do Site](../imagens/officinas.png) 
<!-- Sugestão: Crie um banner legal para o projeto e coloque aqui! -->

**Bem-vindo ao repositório da Comunidade Officinas! Este é o código-fonte do nosso portal de conhecimento dedicado ao universo do Software Livre, com foco em Linux, servidores e preparação para certificações.**

O site principal está no ar em: **[https://officinas.com.br](https://officinas.com.br )**

---

## 🎯 Sobre o Projeto

A **Comunidade Officinas** nasceu da paixão por tecnologia e da crença no poder do conhecimento compartilhado. Nossa missão é criar um espaço com tutoriais, guias e artigos de alta qualidade, aliando os conceitos de **<span class="text-red-code">SOFTWARE LIVRE</span>**, diversão e responsabilidade.

Este site é construído de forma aberta e colaborativa, usando ferramentas como:

*   **MkDocs:** Para gerar um site estático, rápido e limpo a partir de simples arquivos Markdown.
*   **Material for MkDocs:** Um tema moderno e altamente customizável.
*   **Apache & Cloudflare:** Hospedagem auto-gerenciada, segura e resiliente, sem depender de plataformas de terceiros.

## ✨ Tópicos Abordados

Nosso conteúdo cobre uma vasta gama de tópicos, incluindo:

*   **Administração de Servidores Linux** (Debian, Rocky Linux)
*   Configuração de Serviços de Rede (DNS, DHCP, Firewall, Samba)
*   **Preparação para Exames LPI** (Módulos 101, 102 e além)
*   Fundamentos do ecossistema NIX e do Filesystem Hierarchy Standard (FHS)
*   Dicas e truques para a linha de comando.
*   E muito mais!

## 🚀 Como Contribuir

Este é um projeto comunitário e sua contribuição é muito bem-vinda!

1.  **Fork este repositório:** Crie uma cópia do projeto na sua própria conta do GitHub.
2.  **Crie uma nova branch:** (`git checkout -b minha-contribuicao`)
3.  **Faça suas alterações:** Corrija um erro, adicione um novo tutorial ou melhore um já existente.
4.  **Faça o commit das suas alterações:** (`git commit -m "Adiciona tutorial sobre X"`)
5.  **Faça o push para a sua branch:** (`git push origin minha-contribuicao`)
6.  **Abra um Pull Request:** Volte para a página do nosso repositório e abra um Pull Request para que possamos revisar e integrar sua contribuição.

## 🛠️ Rodando o Projeto Localmente

Para visualizar o site no seu próprio computador:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/educharquero/officinas.git
    cd officinas
    ```

2.  **Configure o ambiente Python (recomendado ):**
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt 
    # Nota: Crie um arquivo requirements.txt com o conteúdo de 'pip freeze'
    ```

3.  **Inicie o servidor de desenvolvimento:**
    ```bash
    mkdocs serve
    ```
    O site estará disponível em `http://127.0.0.1:8000`.

## 📜 Licença

O conteúdo deste projeto é distribuído sob a licença **[CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/ )**, em alinhamento com a filosofia de compartilhamento e colaboração do Software Livre.


