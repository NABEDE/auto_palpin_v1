#!/bin/bash

# Définir les variables globales
THRESHOLD_MEMORY=80  # Seuil critique de la mémoire (en pourcentage)
THRESHOLD_SPACE=80  # Seuil critique d'espace disque (en pourcentage)

# 1. Mettre à jour le système (exemple pour Alpine)
echo -e "\e[35m===========================================\e[0m"
echo -e "\e[35m🤖 𝐇𝐞𝐥𝐥𝐨 ! 𝐁𝐢𝐞𝐧𝐯𝐞𝐧𝐮𝐞 𝐬𝐮𝐫 𝐯𝐨𝐭𝐫𝐞 𝐚𝐬𝐬𝐢𝐬𝐭𝐚𝐧𝐭 𝐚𝐮𝐭𝐨𝐩𝐚𝐥𝐩𝐢𝐧𝐞 𝐕𝐞𝐫𝐬𝐢𝐨𝐧 𝟏.𝟎 \e[0m"
echo -e "\e[35m𝐏𝐨𝐮𝐫 𝐥'𝐚𝐮𝐭𝐨𝐦𝐚𝐭𝐢𝐬𝐚𝐭𝐢𝐨𝐧 𝐝𝐞𝐬 𝐦𝐢𝐬𝐞𝐬 𝐚̀ 𝐣𝐨𝐮𝐫 𝐝𝐞 𝐯𝐨𝐭𝐫𝐞 𝐬𝐲𝐬𝐭𝐞̀𝐦𝐞 𝐋𝐢𝐧𝐮𝐱 ( 𝐀𝐥𝐩𝐢𝐧𝐞, 𝐔𝐛𝐮𝐧𝐭𝐮, 𝐃𝐞𝐛𝐢𝐚𝐧 𝐞𝐭 𝐂𝐞𝐧𝐭𝐎𝐒 )\e[0m"
echo -e "\e[35m===========================================\e[0m"
echo  "Choisissez la distribution Linux :"
echo "1. Alpine"
echo "2. Ubuntu"
echo "3. Debian"
echo "4. CentOS"
read -p "Choisissez un numéro :" number
if [ "$number" == "1" ]; then
    read -p "𝐕𝐨𝐮𝐬 voulez que l'installation 𝐝𝐞𝐬 𝐦𝐢𝐬𝐞𝐬 𝐚̀ 𝐣𝐨𝐮𝐫 𝐜𝐨𝐦𝐦𝐞𝐧𝐜𝐞 ? Tapez 𝐎 pour 𝐎𝐮𝐢 et 𝐍 pour 𝐍𝐨𝐧 : " response
    
    # Vérification de la réponse
    if [ "$response" == "O" ] || [ "$response" == "o" ]; then
        echo -e "\e[33m✅ 𝐌𝐢𝐬𝐞 𝐚̀ 𝐣𝐨𝐮𝐫 𝐝𝐮 𝐬𝐲𝐬𝐭𝐞̀𝐦𝐞 𝐞𝐧 𝐜𝐨𝐮𝐫𝐬...\e[0m"
        apk update > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "\e[33m✅ Mises à jour disponibles. Lancement de l'upgrade...\e[0m"
            apk upgrade -y > /dev/null 2>&1
            echo -e "\e[32m✅ Mises à jour terminées avec succès.\e[0m"
        else
            echo -e "\e[31m❌ Échec de la mise à jour. Vérifiez 𝐥𝐞𝐬 𝐞𝐫𝐫𝐞𝐮𝐫𝐬.\e[0m"
        fi
    elif [ "$response" == "N" ] || [ "$response" == "n" ]; then
        echo -e "\e[31m❌ Mise à jour 𝐚𝐧𝐧𝐮𝐥𝐞́𝐞.\e[0m"
        exit 0
    else
        echo -e "\e[31m❌ Réponse non valide. Veuillez taper 𝐎 ou 𝐍.\e[0m"
        exit 1
    fi
fi
