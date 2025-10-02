#!/bin/bash

# deploy.sh - v3 - Script para construir, versionar e implantar o site em DUAS plataformas.
# Uso: ./deploy.sh "Sua mensagem de commit"

# --- Configuração ---
PROJECT_DIR="/opt/mkdocs"
APACHE_DIR="/var/www/html"
COMMIT_MESSAGE="Docs: Atualiza o conteúdo do site"

# --- Início do Script ---
set -e
echo "🚀 Iniciando o deploy duplo do site Comunidade Officinas..."

# 1. Navega para o diretório do projeto
cd "$PROJECT_DIR" || exit
echo "✅ Navegou para $PROJECT_DIR"

## 2. Sincroniza o CÓDIGO-FONTE com o repositório Git
#echo "☁️  Sincronizando código-fonte com o repositório Git (branch main)..."
#git add .
#git commit -m "${1:-$COMMIT_MESSAGE}"
#git push origin main
#echo "✅ Repositório Git (main) atualizado."

echo "☁️  Sincronizando código-fonte com o repositório Git (branch main)..."
git add .
# Tenta fazer o commit. Se não houver nada, apenas continua.
if ! git diff-index --quiet HEAD --; then
    git commit -m "${1:-$COMMIT_MESSAGE}"
fi
git push origin main
echo "✅ Repositório Git (main) atualizado."

# 3. Ativa o ambiente virtual
source "venv/bin/activate"
echo "✅ Ambiente virtual 'venv' ativado."

# 4. Constrói o site (APENAS UMA VEZ)
echo "🛠️  Construindo o site com MkDocs..."
mkdocs build --clean
echo "✅ Site construído com sucesso na pasta 'site/'."

# 5. DEPLOY PARA O SERVIDOR APACHE (Plataforma 1)
echo "🚚 Sincronizando arquivos com o diretório do Apache..."
sudo rsync -avz --delete site/ "$APACHE_DIR/"
echo "✅ Deploy para o Apache concluído."

# 6. DEPLOY PARA O GITHUB PAGES (Plataforma 2)
echo "🚀 Fazendo deploy para o GitHub Pages (branch gh-pages)..."
mkdocs gh-deploy --force
echo "✅ Deploy para o GitHub Pages concluído."

# --- Fim do Script ---
echo "🎉 Deploy duplo finalizado com sucesso!"

