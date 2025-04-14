# Script d'Automatisation Système

Ce script bash automatise diverses tâches de maintenance système et opérations de surveillance, avec envoi de notifications par email pour les événements et alertes importantes.

## Fonctionnalités

- Automatisation des mises à jour système (pour les systèmes Debian/Ubuntu ou les systèmes qui sont basé sur ça)
- Surveillance de l'espace disque
- Surveillance de l'utilisation de la mémoire
- Gestion des fichiers journaux
- Surveillance de la charge CPU
- Notifications par email pour tous les événements majeurs

## Prérequis

- Un système d'exploitation de type Unix (Debian/Ubuntu)
- Commande `mail` configurée
- Privilèges administrateur (sudo)
- Commande `bc` pour les calculs à virgule flottante

## Configuration

Modifiez les variables suivantes dans le script selon vos besoins :

```bash
EMAIL="votre@email.com"
LOG_DIR="/var/log"
THRESHOLD_SPACE=90  # Seuil critique d'espace disque (%)
THRESHOLD_MEMORY=80 # Seuil critique d'utilisation mémoire (%)