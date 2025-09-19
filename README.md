# Valheim Server Automation dla OVHCloud

Ten projekt automatyzuje wdrażanie dedykowanego serwera Valheim na OVHCloud z wykorzystaniem darmowego okresu próbnego.

## Wymagania

- Konto OVHCloud z aktywnym darmowym okresem próbnym
- Terraform >= 1.0
- Klucze API OVHCloud
- SSH key pair

## Struktura projektu

```
valheim-ovh-automation/
├── terraform/           # Konfiguracja infrastruktury
├── scripts/            # Skrypty instalacyjne
├── config/             # Konfiguracja serwera Valheim
└── docs/               # Dokumentacja
```

## Szybki start

1. Skonfiguruj klucze API OVHCloud
2. Dostosuj zmienne w `terraform/terraform.tfvars`
3. Uruchom `terraform apply`
4. Serwer będzie dostępny po ~10 minutach

## Funkcje

- ✅ Automatyczne tworzenie VPS na OVHCloud
- ✅ Instalacja i konfiguracja SteamCMD
- ✅ Automatyczna instalacja serwera Valheim
- ✅ Konfiguracja firewall i portów
- ✅ Automatyczne backupy świata
- ✅ Monitoring i logi
- ✅ Skrypty zarządzania (start/stop/restart)# valheim
