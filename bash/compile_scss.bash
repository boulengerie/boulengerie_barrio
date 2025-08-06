#!/bin/bash
# compile_scss.bash

# Script pour compiler le SCSS en utilisant Gulp localement

# Arrête le script si une commande échoue
set -e

# Chemin vers la racine de ton thème local
LOCAL_THEME_PATH="${HOME}/sites/boulengerie.com/custom/boulengerie_barrio"

# Vérifie si le dossier du thème existe
if [ ! -d "$LOCAL_THEME_PATH" ]; then
  echo "❌ Erreur: Dossier du thème local introuvable: $LOCAL_THEME_PATH"
  exit 1
fi

echo "⚙️  Navigation vers le dossier du thème: $LOCAL_THEME_PATH"
cd "$LOCAL_THEME_PATH"

# Vérifie si gulpfile.js existe
if [ ! -f "gulpfile.js" ]; then
  echo "❌ Erreur: gulpfile.js introuvable dans $LOCAL_THEME_PATH"
  echo "   Assurez-vous d'être dans le bon dossier et que les fichiers Gulp sont présents."
  exit 1
fi

# Vérifie si node_modules existe (signifie que npm install a été lancé)
if [ ! -d "node_modules" ]; then
  echo "🤔 Attention: Le dossier node_modules est introuvable."
  echo "   Avez-vous lancé 'npm install' dans $LOCAL_THEME_PATH ?"
  # Optionnel : décommenter pour arrêter si node_modules est requis
  # exit 1
fi

echo "🚀 Lancement de la compilation Gulp (npx gulp)..."
# Utilise npx pour s'assurer d'utiliser la version de Gulp du projet local
npx gulp

echo "✅ Compilation SCSS terminée avec succès."

exit 0
