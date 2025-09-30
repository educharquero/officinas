#!/bin/bash

# deploy.sh - Script para construir e implantar o site da Comunidade Officinas

# --- Configuração ---
# Caminho para o diretório do projeto
PROJECT_DIR="/opt/mkdocs"
# Diretório de destino do Apache
APACHE_DIR="/var/www/html"
# Mensagem de commit padrão
COMMIT_MESSAGE="Docs: Atualiza o conteúdo do site"

# --- Início do Script ---

# Para o script se um comando falhar
set -e

echo "🚀 Iniciando o deploy do site Comunidade Officinas..."

# 1. Navega para o diretório do projeto
cd "$PROJECT_DIR" || exit
echo "✅ Navegou para $PROJECT_DIR"

# 2. Ativa o ambiente virtual
source "venv/bin/activate"
echo "✅ Ambiente virtual 'venv' ativado."

# 3. Constrói o site
echo "🛠️  Construindo o site com MkDocs..."
mkdocs build --clean
echo "✅ Site construído com sucesso na pasta 'site/'."

# 4. Implanta os arquivos no servidor Apache
echo "🚚 Sincronizando arquivos com o diretório do Apache..."
# Usamos sudo aqui porque /var/www/html geralmente requer permissões de root
sudo rsync -avz --delete site/ "$APACHE_DIR/"
echo "✅ Arquivos sincronizados com $APACHE_DIR."

# 5. (Opcional) Sincroniza com o repositório Git
echo "☁️  Sincronizando com o repositório Git..."
# Adiciona todas as alterações
git add .
# Faz o commit. Usa a mensagem padrão ou a que for passada como argumento.
git commit -m "${1:-$COMMIT_MESSAGE}"
# Envia para a branch main
git push origin main
echo "✅ Repositório Git atualizado."

# --- Fim do Script ---
echo "🎉 Deploy concluído com sucesso!"

