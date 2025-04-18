#!/bin/bash

# 1. Mettre à jour le système (exemple pour Debian/Ubuntu)
echo -e "\e[33mMise à jour du système en cours...\e[0m"
apk update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "\e[33mMises à jour disponibles. Lancement de l'upgrade...\e[0m"
    apk upgrade -y > /dev/null 2>&1
    echo -e "\e[32mMises à jour terminées avec succès.\e[0m"
else
    echo -e "\e[31mÉchec de la mise à jour. Vérifiez les erreurs.\e[0m"
fi

# 2. Vérifier l'espace disque
DISK_USAGE=$(df -h / | tail -n 1 | awk '{print $5}' | cut -d'%' -f1)
if [ $DISK_USAGE -ge $THRESHOLD_SPACE ]; then
    echo -e "\e[31mAlerte : Espace disque critique ($DISK_USAGE%) sur /\e[0m"
fi

# 3. Vérifier l'utilisation de la mémoire
MEMORY_USAGE=$(free | grep "Mem:" | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $THRESHOLD_MEMORY" | bc) )); then
    echo -e "\e[31mAlerte : Utilisation mémoire critique ($MEMORY_USAGE%)\e[0m"
fi

# 4. Nettoyer les anciens logs
echo -e "\e[33mNettoyage des anciens logs...\e[0m"
find $LOG_DIR -type f -name "*.log" -mtime +30 -exec gzip {} \; 2>/dev/null
find $LOG_DIR -type f -name "*.gz" -mtime +90 -exec rm {} \; 2>/dev/null
echo -e "\e[32mNettoyage des logs terminé.\e[0m"

# 5. Vérifier le statut du CPU
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
if [ $(echo "$CPU_LOAD > 80" | bc) -eq 1 ]; then
    echo -e "\e[31mAlerte : Charge CPU élevée ($CPU_LOAD%)\e[0m"
fi
echo -e "\e[33mCharge CPU actuelle : $CPU_LOAD%\e[0m" >> /var/log/system_monitor.log

echo -e "\e[32mAutomatisation terminée à $(date)\e[0m" >> /var/log/system_monitor.log
