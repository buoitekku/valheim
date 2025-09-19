#!/bin/bash

# Skrypt zarządzania serwerem Valheim
# Użycie: ./manage_server.sh [start|stop|restart|status|logs|backup]

SERVER_IP="$1"
ACTION="$2"
SSH_KEY="${3:-~/.ssh/id_rsa}"

if [ -z "$SERVER_IP" ] || [ -z "$ACTION" ]; then
    echo "Użycie: $0 <IP_SERWERA> <AKCJA> [ŚCIEŻKA_DO_KLUCZA_SSH]"
    echo ""
    echo "Dostępne akcje:"
    echo "  start   - Uruchom serwer Valheim"
    echo "  stop    - Zatrzymaj serwer Valheim"
    echo "  restart - Zrestartuj serwer Valheim"
    echo "  status  - Sprawdź status serwera"
    echo "  logs    - Pokaż logi serwera"
    echo "  backup  - Utwórz backup świata"
    echo "  update  - Zaktualizuj serwer Valheim"
    exit 1
fi

SSH_CMD="ssh -i $SSH_KEY ubuntu@$SERVER_IP"

case $ACTION in
    "start")
        echo "Uruchamianie serwera Valheim..."
        $SSH_CMD "sudo systemctl start valheim"
        echo "Serwer został uruchomiony!"
        ;;
    "stop")
        echo "Zatrzymywanie serwera Valheim..."
        $SSH_CMD "sudo systemctl stop valheim"
        echo "Serwer został zatrzymany!"
        ;;
    "restart")
        echo "Restartowanie serwera Valheim..."
        $SSH_CMD "sudo systemctl restart valheim"
        echo "Serwer został zrestartowany!"
        ;;
    "status")
        echo "Status serwera Valheim:"
        $SSH_CMD "sudo systemctl status valheim --no-pager"
        ;;
    "logs")
        echo "Logi serwera Valheim (Ctrl+C aby wyjść):"
        $SSH_CMD "sudo journalctl -u valheim -f"
        ;;
    "backup")
        echo "Tworzenie backupu świata..."
        BACKUP_NAME="valheim_backup_$(date +%Y%m%d_%H%M%S)"
        $SSH_CMD "sudo systemctl stop valheim && \
                  sudo tar -czf /home/steam/${BACKUP_NAME}.tar.gz -C /home/steam/.config/unity3d/IronGate/Valheim . && \
                  sudo systemctl start valheim"
        echo "Backup utworzony: ${BACKUP_NAME}.tar.gz"
        ;;
    "update")
        echo "Aktualizacja serwera Valheim..."
        $SSH_CMD "sudo systemctl stop valheim && \
                  sudo -u steam /home/steam/steamcmd.sh +force_install_dir /home/steam/valheim +login anonymous +app_update 896660 validate +exit && \
                  sudo systemctl start valheim"
        echo "Serwer został zaktualizowany!"
        ;;
    *)
        echo "Nieznana akcja: $ACTION"
        exit 1
        ;;
esac