#!/bin/bash

# Définir les variables globales
THRESHOLD_MEMORY=80  # Seuil critique de la mémoire (en pourcentage)
THRESHOLD_SPACE=80  # Seuil critique d'espace disque (en pourcentage)

# 1. Mettre à jour le système (exemple pour Alpine)
echo -e "\e[35m===========================================\e[0m"
echo -e "\e[35m🤖 Hello ! Bienvenue sur votre assistant autopalpine\e[0m"
echo -e "\e[35mPour l'automatisation des mises à jour de votre système Alpine\e[0m"
echo -e "\e[35m===========================================\e[0m"
read -p "Vous voulez que l'installation des mises à jour commence ? Tapez Y pour Yes et N pour No: " response

# Vérification de la réponse
if [ "$response" == "Y" ] || [ "$response" == "y" ]; then
    echo -e "\e[33mMise à jour du système en cours...\e[0m"
    apk update > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\e[33mMises à jour disponibles. Lancement de l'upgrade...\e[0m"
        apk upgrade -y > /dev/null 2>&1
        echo -e "\e[32mMises à jour terminées avec succès.\e[0m"
    else
        echo -e "\e[31mÉchec de la mise à jour. Vérifiez les erreurs.\e[0m"
    fi
elif [ "$response" == "N" ] || [ "$response" == "n" ]; then
    echo -e "\e[31mMise à jour annulée.\e[0m"
    exit 0
else
    echo -e "\e[31mRéponse non valide. Veuillez taper Y ou N.\e[0m"
    exit 1
fi
