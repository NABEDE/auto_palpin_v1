#!/bin/bash

# Définir les variables globales
THRESHOLD_MEMORY=80  # Seuil critique de la mémoire (en pourcentage)
THRESHOLD_SPACE=80  # Seuil critique d'espace disque (en pourcentage)

# Fonction pour vérifier la connectivité Internet
check_internet() {
    echo -e "\e[34m🌐 Vérification de la connexion Internet...\e[0m"
    wget -q --spider http://google.com
    if [ $? -eq 0 ]; then
        echo -e "\e[32m✅ Connexion Internet détectée.\e[0m"
        return 0
    else
        echo -e "\e[31m❌ Aucune connexion Internet détectée. Veuillez vérifier votre réseau.\e[0m"
        return 1
    fi
}

# Appel de la fonction pour vérifier la connectivité Internet
check_internet

# Fonction pour détecter le système d'exploitation
detect_os() {
    if [ -f /etc/os-release ]; then
        # Lecture du fichier os-release pour identifier le système
        os_name=$(grep ^ID= /etc/os-release | cut -d= -f2 | tr -d '"')
        echo "$os_name"
    else
        # Si os-release n'existe pas, fallback sur uname
        os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
        echo "$os_name"
    fi
}

# Détection du système actuel
system_detected=$(detect_os)

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

if [ "$number" = "1" ] && [[ "${system_detected,,}" == *alpine* ]]; then
    echo -e "\e[32m✅ Le système détecté est bien Alpine Linux.\e[0m"
    read -p "𝐕𝐨𝐮𝐬 voulez que l'installation 𝐝𝐞𝐬 𝐦𝐢𝐬𝐞𝐬 𝐚̀ 𝐣𝐨𝐮𝐫 𝐜𝐨𝐦𝐦𝐞𝐧𝐜𝐞 ? Tapez 𝐎 pour 𝐎𝐮𝐢 et 𝐍 pour 𝐍𝐨𝐧 : " response
    
    if [ "$response" == "O" ] || [ "$response" == "o" ]; then
        echo -e "\e[33m✅ 𝐌𝐢𝐬𝐞 𝐚̀ 𝐣𝐨𝐮𝐫 𝐝𝐮 𝐬𝐲𝐬𝐭𝐞̀𝐦𝐞 𝐞𝐧 𝐜𝐨𝐮𝐫𝐬...\e[0m"
        apk update > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "\e[33m✅ Mises à jour disponibles. Lancement de l'upgrade...\e[0m"
            apk upgrade -y > /dev/null 2>&1
            echo -e "\e[32m✅ Mises à jour terminées avec succès.\e[0m"
            read -p "Est ce que vous voulez que j'installe les paquets de sécurité sur le système ? Tapez 𝐎 pour 𝐎𝐮𝐢 et 𝐍 pour 𝐍𝐨𝐧 : " response_autre
            if [ "$response_autre" == "O" ] || [ "$response_autre" == "o" ]; then
                echo -e "\e[33m✅ Ajout de quelques paquets de sécurité du système en cours ...\e[0m"
                echo -e "\e[33m Installation de fail2ban ...\e[0m"
                apk add fail2ban
                if [ $? -eq 0 ]; then
                    echo -e "\e[32m✅ Installation de fail2ban réussie\e[0m"
                    echo -e "\e[33m Installation de OpenRC pour la gestion des services...\e[0m"
                    apk add openrc
                    if [ $? -eq 0 ]; then
                        echo -e "\e[32m✅ Installation de OpenRC réussie\e[0m"
                        echo -e "\e[33m Configuration et activation de fail2ban...\e[0m"
                        # Ajouter fail2ban au démarrage
                        rc-update add fail2ban default
                        # Démarrer le service fail2ban
                        rc-service fail2ban start
                        : "if rc-service fail2ban start; then
                            echo -e "\e[32m✅ Service fail2ban démarré avec succès\e[0m"
                        else
                            echo -e "\e[31m❌ Échec du démarrage du service fail2ban\e[0m"
                            exit 1
                        fi"
                        if [ $? -eq 0 ]; then
                            echo -e "\e[32m✅ Activation de fail2ban réussi ...\e[0m"
                            echo -e "\e[33m Installation de clamav accompagné de clamav-libunrar ...\e[0m"
                            apk add clamav clamav-libunrar
                            if [ $? -eq 0 ]; then
                                echo -e "\e[32m✅ Installation de clamav & clamav-libunrar réussi ...\e[0m"
                                echo -e "\e[32m Mise à jour des signatures de clamav & clamav-libunrar \e[0m"
                                freshclam
                                if [ $? -eq 0 ]; then
                                    echo -e "\e[32m✅ Mise à jour réussie ...\e[0m"
                                    echo -e "\e[33m Installation d'un firewall qu'on appelle ufw \e[0m"
                                    apk add ufw
                                    if [ $? -eq 0 ]; then
                                        echo -e "\e[32m✅ Installation du firewall ufw réussie ...\e[0m"
                                        echo -e "\e[33m Activation du firewall ufw \e[0m"
                                        ufw enable
                                        if [ $? -eq 0 ]; then
                                            echo -e "\e[32m✅ Activation du firewall ufw réussie ...\e[0m"
                                        else
                                            echo -e "\e[31m❌ Activation du firewall échoué, vérifiez votre connexion internet \e[0m"
                                            exit 1
                                        fi
                                    else
                                        echo -e "\e[31m❌ Échec de l'installation du firewall ufw \e[0m"
                                        exit 1
                                    fi
                                else
                                    echo -e "\e[31m❌ Échec de la mise à jour \e[0m"
                                    exit 1
                                fi
                            else
                                echo -e "\e[31m❌ Échec de l'installation de clamav & clamav-libunrar, vérifiez votre connexion internet...\e[0m"
                                exit 1
                            fi
                        else
                            echo -e "\e[31m❌ Échec de l'activation de fail2ban, vérifier votre connexion internet ...\e[0m"
                            exit 1
                        fi
                    else
                        echo -e "\e[31m❌ Échec de l'activation de fail2ban, vérifier votre connexion internet ...\e[0m"
                        exit 1
                    fi
                else
                    echo -e "\e[31m❌ Échec de l'installation de fail2ban\e[0m"
                    exit 1
                fi
            elif [ "$response_autre" == "N" ] || [ "$response_autre" == "n" ]; then
                echo -e "\e[31m❌ Mise à jour 𝐚𝐧𝐧𝐮𝐥𝐞́𝐞.\e[0m"
                exit 0
            else
                echo -e "\e[31m❌ Réponse non valide. Veuillez taper 𝐎 ou 𝐍.\e[0m"
                exit 1
            fi
        else
            echo -e "\e[31m❌ Échec de la mise à jour. Vérifiez 𝐥𝐞𝐬 𝐞𝐫𝐫𝐞𝐮𝐫𝐬.\e[0m"
            exit 1
        fi
    elif [ "$response" == "N" ] || [ "$response" == "n" ]; then
        echo -e "\e[31m❌ Mise à jour 𝐚𝐧𝐧𝐮𝐥𝐞́𝐞.\e[0m"
        exit 0
    else
        echo -e "\e[31m❌ Réponse non valide. Veuillez taper 𝐎 ou 𝐍.\e[0m"
        exit 1
    fi
else
    echo -e "\e[31m❌ Le système détecté n'est pas Alpine Linux. Système actuel : $system_detected.\e[0m"
    exit 1
fi
