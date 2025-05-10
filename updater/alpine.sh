#!/bin/bash

# Source common functions
# shellcheck source=../common/script.sh
# . "$(dirname "$0")/../common/script.sh" # This might be needed if run directly, but sourced from root, common/script.sh is fine

update_alpine() {
    echo -e "\e[32mAlpine Linux update process started.\e[0m"

    if prompt_yes_no "𝐕𝐨𝐮𝐬 voulez que l'installation 𝐝𝐞𝐬 𝐦𝐢𝐬𝐞𝐬 𝐚̀ 𝐣𝐨𝐮𝐫 𝐜𝐨𝐦𝐦𝐞𝐧𝐜𝐞 ?"; then
        echo -e "\e[33m✅ 𝐌𝐢𝐬𝐞 𝐚̀ 𝐣𝐨𝐮𝐫 𝐝𝐮 𝐬𝐲𝐬𝐭𝐞̀𝐦𝐞 𝐞𝐧 𝐜𝐨𝐮𝐫𝐬...\e[0m"
        apk update > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "\e[33m✅ Mises à jour disponibles. Lancement de l'upgrade...\e[0m"
            apk upgrade -y > /dev/null 2>&1
            check_success "Mise à jour du système"

            if prompt_yes_no "Est ce que vous voulez que j'installe les paquets de sécurité sur le système ?"; then
                echo -e "\e[33m🔐 Installation des paquets de sécurité...\e[0m"
                
                echo -e "\e[33m Installation de fail2ban ...\e[0m"
                apk add fail2ban > /dev/null 2>&1
                check_success "Installation de fail2ban"
                
                echo -e "\e[33m Installation de OpenRC pour la gestion des services...\e[0m"
                apk add openrc > /dev/null 2>&1
                check_success "Installation de OpenRC"
                
                echo -e "\e[33m⚙️ Configuration et activation de fail2ban...\e[0m"
                rc-update add fail2ban default > /dev/null 2>&1
                rc-service fail2ban start > /dev/null 2>&1
                check_success "Activation de fail2ban"
                
                echo -e "\e[33m Installation de clamav accompagné de clamav-libunrar ...\e[0m"
                apk add clamav clamav-libunrar > /dev/null 2>&1
                check_success "Installation de clamav & clamav-libunrar"
                
                echo -e "\e[33m📥 Mise à jour des signatures de clamav & clamav-libunrar \e[0m"
                freshclam > /dev/null 2>&1
                check_success "Mise à jour des signatures ClamAV"
                
                echo -e "\e[33m Installation d'un firewall qu'on appelle ufw \e[0m"
                apk add ufw > /dev/null 2>&1
                check_success "Installation du firewall ufw"
                
                echo -e "\e[33m🔒 Activation du firewall ufw \e[0m"
                ufw enable <<EOF
y
EOF
                if [ $? -eq 0 ]; then
                    echo -e "\e[32m✅ Activation du firewall ufw réussie.\e[0m"
                else
                    echo -e "\e[31m❌ Échec de l'activation du firewall ufw.\e[0m"
                    echo -e "\e[35m💡 Vous pouvez activer manuellement le firewall ufw avec la commande suivante : ufw enable \e[0m"
                    echo -e "\e[35m💡 N'oubliez pas de passer en root ou soit utilisez le sudo [sudo ufw enable] \e[0m"
                    # Do not exit here, let the script continue or finish gracefully
                fi
                echo -e "\e[32m✅ Installation et configuration des paquets de sécurité terminées.\e[0m"
            else
                echo -e "\e[33mℹ️ Installation des paquets de sécurité annulée.\e[0m"
            fi
        else
            echo -e "\e[31m❌ Échec de la vérification des mises à jour (apk update). Vérifiez les erreurs.\e[0m"
            # exit 1 # Decided by check_success or main script
        fi
    else
        echo -e "\e[31m❌ Mise à jour 𝐚𝐧𝐧𝐮𝐥𝐞́𝐞.\e[0m"
    fi
    echo -e "\e[32mAlpine Linux update process terminé.\e[0m"
} 