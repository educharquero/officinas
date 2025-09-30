#!/bin/bash

# deploy.sh - v2 - Script para construir, versionar e implantar o site
#  ./deploy.sh "Sua mensagem"

# --- Configuração ---
PROJECT_DIR="/opt/mkdocs"
APACHE_DIR="/var/www/html"
COMMIT_MESSAGE="Docs: Atualiza o conteúdo do site"

# --- Início do Script ---
set -e
echo "🚀 Iniciando o deploy do site Comunidade Officinas..."

# 1. Navega para o diretório do projeto
cd "$PROJECT_DIR" || exit
echo "✅ Navegou para $PROJECT_DIR"

# 2. (OPCIONAL, mas recomendado) Configura o Git se não estiver configurado
# Descomente as duas linhas abaixo se você receber o aviso sobre "Your name and email"
# git config --global user.name "Seu Nome"
# git config --global user.email "seu-email@exemplo.com"

# 3. Sincroniza com o repositório Git ANTES de qualquer outra coisa
echo "☁️  Sincronizando com o repositório Git..."
git add .
git commit -m "${1:-$COMMIT_MESSAGE}"
git push origin main
echo "✅ Repositório Git atualizado."

# 4. Ativa o ambiente virtual
source "venv/bin/activate"
echo "✅ Ambiente virtual 'venv' ativado."

# 5. Constrói o site
echo "🛠️  Construindo o site com MkDocs..."
mkdocs build --clean
echo "✅ Site construído com sucesso na pasta 'site/'."

# 6. Implanta os arquivos no servidor Apache (ÚNICA PARTE COM SUDO)
echo "🚚 Sincronizando arquivos com o diretório do Apache..."
sudo rsync -avz --delete site/ "$APACHE_DIR/"
echo "✅ Arquivos sincronizados com $APACHE_DIR."

# --- Fim do Script ---
echo "🎉 Deploy concluído com sucesso!"

