#! /bin/bash
# upload.bash

# Script pour uploader le dossier COMPLET du thème local vers le serveur distant

# Arrête le script si une commande échoue
set -e

# --- Configuration Serveur Distant ---
REMOTE_USER="u584466092"
REMOTE_HOST="153.92.217.175"
SSH_PORT="65002"
# Chemin ABSOLU vers le dossier où le contenu du thème doit aller sur le SERVEUR
REMOTE_THEME_DEST_ROOT="~/domains/boulengerie.com/public_html/themes/custom/boulengerie_barrio/"
# --- Fin Configuration ---

# Chemin vers la racine de ton thème local
# Assure-toi qu'il ne se termine PAS par un / ici
LOCAL_THEME_PATH="${HOME}/sites/boulengerie.com/custom/boulengerie_barrio"

# --- Exclusions ---
# Liste des fichiers/dossiers à NE PAS uploader
# Ajoute d'autres éléments si nécessaire (ex: node_modules/, .git/, .sass-cache/)
EXCLUDES=(
    --exclude ".DS_Store"
    --exclude "*.swp"
    --exclude ".git/"      # Ne pas uploader le dépôt git
    --exclude "node_modules/" # Ne pas uploader les dépendances npm/yarn
    # --exclude "scss/"    # Décommente si tu ne veux PAS uploader les sources SASS
    # --exclude "*.map"    # Décommente si tu ne veux pas les source maps CSS/JS
)
# --- Fin Exclusions ---


echo "🚀 Synchronisation du thème local (${LOCAL_THEME_PATH}) vers ${REMOTE_HOST}..."

# Utilisation de rsync pour synchroniser le contenu du dossier local vers le distant
rsync -avzP --delete \
      -e "ssh -p ${SSH_PORT}" \
      "${EXCLUDES[@]}" \
      "${LOCAL_THEME_PATH}/" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_THEME_DEST_ROOT}"
      #                  ^
      #                  |--- LE SLASH FINAL EST CRUCIAL ICI pour copier le contenu

# Notes sur rsync :
# -a : Mode archive (préserve permissions, dates, etc., récursif)
# -v : Verbose (affiche les fichiers transférés)
# -z : Compresse les données pendant le transfert (plus rapide sur réseau lent)
# -P : Équivaut à --progress --partial (affiche la progression, garde les fichiers partiels si interrompu)
# --delete : Supprime les fichiers sur le serveur qui n'existent PLUS localement (assure la synchronisation)
# -e "ssh -p PORT" : Spécifie le port SSH
# "${EXCLUDES[@]}" : Injecte toutes les exclusions définies plus haut
# "${LOCAL_THEME_PATH}/" : Le CHEMIN LOCAL suivi d'un / pour copier le CONTENU du dossier
# La destination est le dossier racine du thème DISTANT

echo "✅ Synchronisation du thème terminée avec succès."
echo "➡️  N'oubliez pas de vider le cache Drupal sur le serveur !"

exit 0
