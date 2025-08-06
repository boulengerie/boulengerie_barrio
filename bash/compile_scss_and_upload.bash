#!/bin/bash
# compile_scss_and_upload.bash

# Script pour compiler localement PUIS uploader le CSS

# Arrête le script si une commande échoue
set -e

# Détermine le dossier où se trouve ce script deploy.sh
# (Suppose que compile_scss.bash et upload.bash sont dans le même dossier)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

COMPILE_SCRIPT="${SCRIPT_DIR}/compile_scss.bash"
UPLOAD_SCRIPT="${SCRIPT_DIR}/upload.bash"

# --- Configuration Serveur Distant ---
REMOTE_USER="u584466092"
REMOTE_HOST="153.92.217.175"
SSH_PORT="65002"
# Chemin ABSOLU vers le dossier où le contenu du thème doit aller sur le SERVEUR
REMOTE_THEME_DEST_ROOT="~/domains/boulengerie.com/public_html/themes/custom/boulengerie_barrio/"
# --- Fin Configuration ---

echo "▶️  Début du déploiement (Compilation locale + Upload CSS)..."
echo ""

# --- Étape 1: Compilation ---
if [ -f "$COMPILE_SCRIPT" ]; then
  echo "---> Exécution de la compilation locale..."
  bash "$COMPILE_SCRIPT" # Utilise bash pour exécuter, pas besoin de +x sur les autres
  echo "---> Compilation terminée."
else
  echo "❌ Erreur: Script de compilation introuvable: $COMPILE_SCRIPT"
  exit 1
fi

echo "" # Ligne vide pour séparer les étapes

# --- Étape 2: Upload ---
if [ -f "$UPLOAD_SCRIPT" ]; then
  echo "---> Exécution de l'upload CSS..."
  bash "$UPLOAD_SCRIPT" # Utilise bash pour exécuter
  echo "---> Upload terminé."
else
  echo "❌ Erreur: Script d'upload introuvable: $UPLOAD_SCRIPT"
  exit 1
fi

echo ""

# --- Étape 3: Vider le cache Drupal sur le serveur distant ---
echo "--- (3/3) Exécution de 'drush cr' sur le serveur distant..."
ssh -p "${SSH_PORT}" "${REMOTE_USER}@${REMOTE_HOST}" "source ~/.bashrc && cd ${REMOTE_DRUPAL_ROOT} && ~/domains/boulengerie.com/vendor/bin/drush cr -y"
echo "--- Cache distant vidé avec succès."
echo ""
echo "✅ Processus de déploiement terminé."

exit 0
