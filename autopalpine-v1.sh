#!/bin/bash

# Définir les variables globales
THRESHOLD_MEMORY=80  # Seuil critique de la mémoire (en pourcentage)
THRESHOLD_SPACE=80  # Seuil critique d'espace disque (en pourcentage)

# Arrêter à la moindre erreur
set -e

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

check_success() {
    if [ $? -eq 0 ]; then
        echo -e "\e[32m✅ $1 réussi.\e[0m"
    else
        echo -e "\e[31m❌ $1 échoué. Vérifiez votre connexion internet.\e[0m"
        exit 1
    fi
}

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

while true; do
echo  "Choisissez la distribution Linux :"
echo "1. Alpine"
echo "2. Ubuntu"
echo "3. Debian"
echo "4. CentOS"
echo "5. Quitter"
read -p "Choisissez un numéro entre 1 et 5  :" number

case $number in
1)
    if [[ "${system_detected,,}" == *alpine* ]]; then
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
                                                echo -e "\e[32m Installation de fail2ban réussie ...\e[0m"
                                            else
                                                echo -e "\e[31m❌ Échec de l'activation du firewall ufw \e[0m"
                                                echo -e "\e[35m💡 Vous pouvez activer manuellement le firewall ufw avec la commande suivante : ufw enable \e[0m"
                                                echo -e "\e[35m💡 N'oubliez pas de passer en root ou soit utilisez le sudo [sudo ufw enable] \e[0m"
                                                break
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
    ;;

2) if [[ "${system_detected,,}" == *alpine* ]]; then
    echo -e "\e[32m✅ Le système détecté est bien Alpine Linux.\e[0m"
    
    read -p "Voulez-vous mettre à jour le système ? (O/N) " response
    if [[ "$response" =~ ^[Oo]$ ]]; then
        echo -e "\e[33m🔄 Mise à jour du système en cours...\e[0m"
        apk update > /dev/null 2>&1
        apk upgrade -y > /dev/null 2>&1
        check_success "Mise à jour du système"
        
        read -p "Voulez-vous installer les paquets de sécurité ? (O/N) " response_security
        if [[ "$response_security" =~ ^[Oo]$ ]]; then
            echo -e "\e[33m🔐 Installation des paquets de sécurité...\e[0m"
            
            apk add fail2ban clamav clamav-libunrar ufw openrc > /dev/null 2>&1
            check_success "Installation des paquets de sécurité"
            
            echo -e "\e[33m⚙️ Configuration de fail2ban...\e[0m"
            rc-update add fail2ban default > /dev/null 2>&1
            rc-service fail2ban start > /dev/null 2>&1
            check_success "Activation de fail2ban"

            echo -e "\e[33m📥 Mise à jour des signatures ClamAV...\e[0m"
            freshclam > /dev/null 2>&1
            check_success "Mise à jour des signatures ClamAV"

            echo -e "\e[33m🔒 Activation du pare-feu UFW...\e[0m"
            ufw enable > /dev/null 2>&1
            check_success "Activation du pare-feu UFW"

        else
            echo -e "\e[33mℹ️ Installation des paquets de sécurité annulée.\e[0m"
        fi
    else
        echo -e "\e[33mℹ️ Mise à jour du système annulée.\e[0m"
    fi
else
    echo -e "\e[31m❌ Le système détecté n'est pas Alpine Linux. Système actuel : $system_detected\e[0m"
    exit 1
fi
;;

3)
    if [[ "$system_detected" == *debian* ]]; then
    echo -e "\e[32m✅ Le système détecté est Debian.\e[0m"
    
    read -p "Voulez-vous mettre à jour le système ? (O/N) " response
    if [[ "$response" =~ ^[Oo]$ ]]; then
        echo -e "\e[33m🔄 Mise à jour du système en cours...\e[0m"
        sudo apt update -y > /dev/null 2>&1
        sudo apt upgrade -y > /dev/null 2>&1
        check_success "Mise à jour du système"
        
        read -p "Voulez-vous installer les paquets de sécurité ? (O/N) " response_security
        if [[ "$response_security" =~ ^[Oo]$ ]]; then
            echo -e "\e[33m🔐 Installation des paquets de sécurité...\e[0m"
            
            sudo apt install -y fail2ban clamav clamav-freshclam ufw unattended-upgrades > /dev/null 2>&1
            check_success "Installation des paquets de sécurité"
            
            echo -e "\e[33m⚙️ Configuration de fail2ban...\e[0m"
            sudo systemctl enable fail2ban
            sudo systemctl start fail2ban
            check_success "Activation de fail2ban"

            echo -e "\e[33m📥 Mise à jour des signatures ClamAV...\e[0m"
            sudo freshclam > /dev/null 2>&1
            check_success "Mise à jour des signatures ClamAV"

            echo -e "\e[33m🔧 Activation des mises à jour automatiques...\e[0m"
            sudo dpkg-reconfigure -plow unattended-upgrades > /dev/null 2>&1
            check_success "Configuration de unattended-upgrades"

            echo -e "\e[33m🔒 Activation du pare-feu UFW...\e[0m"
            sudo ufw enable > /dev/null 2>&1
            check_success "Activation du pare-feu UFW"

        else
            echo -e "\e[33mℹ️ Installation des paquets de sécurité annulée.\e[0m"
        fi
    else
        echo -e "\e[33mℹ️ Mise à jour du système annulée.\e[0m"
    fi
else
    echo -e "\e[31m❌ Le système détecté n'est pas Debian. Système actuel : $system_detected\e[0m"
    exit 1
fi
;;

4)
    if [[ "$system_detected" == *centos* ]]; then
        echo -e "\e[32m✅ Le système détecté est CentOS.\e[0m"
        
        read -p "Voulez-vous mettre à jour le système ? (O/N) " response
        if [[ "$response" =~ ^[Oo]$ ]]; then
            echo -e "\e[33m🔄 Mise à jour du système en cours...\e[0m"
            sudo yum update -y > /dev/null 2>&1
            check_success "Mise à jour du système"
            
            read -p "Voulez-vous installer les paquets de sécurité ? (O/N) " response_security
            if [[ "$response_security" =~ ^[Oo]$ ]]; then
                echo -e "\e[33m🔐 Installation des paquets de sécurité...\e[0m"
                
                # Installation des dépôts EPEL nécessaires
                sudo yum install -y epel-release > /dev/null 2>&1
                check_success "Installation du dépôt EPEL"
                
                # Installation des paquets de sécurité
                sudo yum install -y fail2ban clamav clamav-update firewalld > /dev/null 2>&1
                check_success "Installation des paquets de sécurité"
                
                # Configuration de fail2ban
                echo -e "\e[33m⚙️ Configuration de fail2ban...\e[0m"
                sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
                sudo systemctl enable fail2ban
                sudo systemctl start fail2ban
                check_success "Configuration et activation de fail2ban"

                # Configuration de ClamAV
                echo -e "\e[33m📥 Configuration et mise à jour de ClamAV...\e[0m"
                sudo systemctl enable clamav-freshclam
                sudo systemctl start clamav-freshclam
                sudo freshclam > /dev/null 2>&1
                check_success "Configuration de ClamAV"

                # Configuration du pare-feu
                echo -e "\e[33m🔒 Configuration du pare-feu firewalld...\e[0m"
                sudo systemctl enable firewalld
                sudo systemctl start firewalld
                sudo firewall-cmd --permanent --add-service=ssh
                sudo firewall-cmd --reload > /dev/null 2>&1
                check_success "Configuration du pare-feu"

                # Configuration des mises à jour automatiques
                echo -e "\e[33m🔧 Configuration des mises à jour automatiques...\e[0m"
                sudo yum install -y yum-cron > /dev/null 2>&1
                sudo sed -i 's/apply_updates = no/apply_updates = yes/' /etc/yum/yum-cron.conf
                sudo systemctl enable yum-cron
                sudo systemctl start yum-cron
                check_success "Configuration des mises à jour automatiques"

                echo -e "\e[32m✅ Installation et configuration terminées avec succès.\e[0m"
            else
                echo -e "\e[33mℹ️ Installation des paquets de sécurité annulée.\e[0m"
            fi
        else
            echo -e "\e[33mℹ️ Mise à jour du système annulée.\e[0m"
        fi
    else
        echo -e "\e[31m❌ Le système détecté n'est pas CentOS. Système actuel : $system_detected\e[0m"
    fi
    ;;

5)
    echo -e "\e[32m✅ Vous avez choisi de quitter le script.\e[0m"
    exit 0
    ;;
*)
    echo -e "\e[31m❌ Choix invalide. Veuillez entrer un numéro entre 1 et 5.\e[0m"
    ;;
    esac
done

