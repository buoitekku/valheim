# Przewodnik wdrażania serwera Valheim na OVHCloud

## Przygotowanie

### 1. Konto OVHCloud
- Załóż konto na [OVHCloud](https://www.ovhcloud.com/)
- Aktywuj darmowy okres próbny (€200 kredytów na 30 dni)
- Utwórz nowy projekt Public Cloud

### 2. Klucze API OVHCloud
1. Przejdź do [generatora tokenów](https://eu.api.ovh.com/createToken/)
2. Wypełnij formularz:
   - **Application name**: `Valheim Server Automation`
   - **Application description**: `Automatyzacja serwera Valheim`
   - **Validity**: `Unlimited`
   - **Rights**: Dodaj następujące uprawnienia:
     ```
     GET    /cloud/project/*
     POST   /cloud/project/*
     PUT    /cloud/project/*
     DELETE /cloud/project/*
     ```
3. Zapisz wygenerowane klucze:
   - Application Key
   - Application Secret
   - Consumer Key

### 3. Identyfikator projektu
1. Zaloguj się do [panelu OVHCloud](https://www.ovh.com/manager/)
2. Przejdź do sekcji "Public Cloud"
3. Skopiuj identyfikator projektu (Project ID)

## Wdrażanie

### 1. Uruchomienie instancji VM
1. Zaloguj się do [panelu OVHCloud](https://www.ovh.com/manager/)
2. Przejdź do sekcji "Public Cloud" → Twój projekt
3. Kliknij "Instances" w menu bocznym
4. Kliknij "Create an instance"
5. Wybierz:
   - **Region**: Najbliższy Twojej lokalizacji
   - **Image**: Ubuntu 22.04 LTS
   - **Flavor**: s1-4 (1 vCPU, 4GB RAM) - zalecane dla Valheim
**Generowanie klucza SSH (jeśli nie masz):**
     ```bash
     # Wygeneruj nowy klucz SSH
     ssh-keygen -t rsa -b 4096 -C "twoj-email@example.com"
     
     # Wyświetl klucz publiczny do skopiowania
     cat ~/.ssh/id_rsa.pub
6. Kliknij "Create instance"

### 2. Dostęp do konsoli VM
**Opcja A - Panel OVHCloud:**
1. W sekcji "Instances" kliknij na swoją instancję
2. Kliknij przycisk "VNC Console" aby otworzyć konsolę w przeglądarce

**Opcja B - SSH (zalecane):**
```bash
# Połącz się przez SSH (IP znajdziesz w panelu)
ssh ubuntu@<IP_INSTANCJI>
### 1. Konfiguracja
```bash
# Sklonuj lub pobierz projekt
git clone <repository_url>
cd valheim-ovh-automation

# Uruchom skrypt konfiguracji
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 2. Wypełnienie konfiguracji
Edytuj plik `terraform/terraform.tfvars`:
```hcl
ovh_application_key    = "twoj_application_key"
ovh_application_secret = "twoj_application_secret"
ovh_consumer_key      = "twoj_consumer_key"
ovh_service_name      = "twoj_project_id"

valheim_server_name = "Mój Serwer Valheim"
valheim_world_name  = "MojSwiat"
valheim_password    = "bezpieczne_haslo_123"
```

### 3. Wdrożenie infrastruktury
```bash
cd terraform

# Sprawdź plan wdrożenia
terraform plan

# Inicjalizuj Terraform
terraform init


# Wdróż infrastrukturę
terraform apply
```

### 4. Oczekiwanie na instalację
- Terraform utworzy VPS (~2 minuty)
- Cloud-init zainstaluje serwer Valheim (~8 minut)
- Łączny czas: ~10 minut

## Zarządzanie serwerem

### Podstawowe komendy
```bash
# Sprawdź IP serwera
terraform output server_ip

# Zarządzanie serwerem
./scripts/manage_server.sh <IP_SERWERA> status
./scripts/manage_server.sh <IP_SERWERA> logs
./scripts/manage_server.sh <IP_SERWERA> restart
```

### Połączenie SSH
```bash
# Komenda zostanie wyświetlona po wdrożeniu
ssh -i ~/.ssh/id_rsa ubuntu@<IP_SERWERA>
```

## Koszty

### Szacunkowe koszty miesięczne:
- **s1-2** (1 vCPU, 2GB RAM): ~€7/miesiąc
- **s1-4** (1 vCPU, 4GB RAM): ~€14/miesiąc
- **s1-8** (2 vCPU, 8GB RAM): ~€28/miesiąc

### Darmowy okres próbny:
- €200 kredytów na 30 dni
- Wystarczy na ~28 dni pracy serwera s1-2
- Lub ~14 dni pracy serwera s1-4

## Rozwiązywanie problemów

### Serwer nie startuje
```bash
# Sprawdź logi instalacji
ssh ubuntu@<IP> "sudo journalctl -u cloud-final -f"

# Sprawdź status serwera Valheim
ssh ubuntu@<IP> "sudo systemctl status valheim"
```

### Problemy z połączeniem
```bash
# Sprawdź firewall
ssh ubuntu@<IP> "sudo ufw status"

# Sprawdź porty
ssh ubuntu@<IP> "sudo netstat -tulpn | grep 2456"
```

### Aktualizacja serwera
```bash
./scripts/manage_server.sh <IP_SERWERA> update
```

## Backup i przywracanie

### Tworzenie backupu
```bash
./scripts/manage_server.sh <IP_SERWERA> backup
```

### Pobieranie backupu
```bash
scp -i ~/.ssh/id_rsa ubuntu@<IP>:/home/steam/valheim_backup_*.tar.gz ./
```

## Usuwanie zasobów

```bash
cd terraform
terraform destroy
```

**Uwaga**: To usunie wszystkie zasoby i dane serwera!