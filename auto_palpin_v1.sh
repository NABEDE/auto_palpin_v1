#!/bin/bash

# 1. Mettre à jour le système (exemple pour Debian/Ubuntu)
echo -e "\e[32mMise à jour du système en cours...\e[0m"
apk update > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "Mises à jour disponibles. Lancement de l'upgrade..."
    sudo apt upgrade -y > /dev/null 2>&1
    echo "Mises à jour terminées avec succès."
else
    echo "Échec de la mise à jour. Vérifiez les erreurs."
fi

# 2. Vérifier l'espace disque
DISK_USAGE=$(df -h / | tail -n 1 | awk '{print $5}' | cut -d'%' -f1)
if [ $DISK_USAGE -ge $THRESHOLD_SPACE ]; then
    echo "Alerte : Espace disque critique ($DISK_USAGE%) sur /"
fi

# 3. Vérifier l'utilisation de la mémoire
MEMORY_USAGE=$(free | grep "Mem:" | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMORY_USAGE > $THRESHOLD_MEMORY" | bc) )); then
    echo "Alerte : Utilisation mémoire critique ($MEMORY_USAGE%)"
fi

# 4. Nettoyer les anciens logs
echo "Nettoyage des anciens logs..."
find $LOG_DIR -type f -name "*.log" -mtime +30 -exec gzip {} \; 2>/dev/null
find $LOG_DIR -type f -name "*.gz" -mtime +90 -exec rm {} \; 2>/dev/null
echo "Nettoyage des logs terminé."

# 5. Vérifier le statut du CPU
CPU_LOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
if [ $(echo "$CPU_LOAD > 80" | bc) -eq 1 ]; then
    echo "Alerte : Charge CPU élevée ($CPU_LOAD%)"
fi
echo "Charge CPU actuelle : $CPU_LOAD%" >> /var/log/system_monitor.log

echo "Automatisation terminée à $(date)" >> /var/log/system_monitor.log
