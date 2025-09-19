#!/bin/bash

# Skrypt konfiguracji środowiska dla automatu Valheim

set -e

echo "=== Konfiguracja automatu serwera Valheim dla OVHCloud ==="

# Sprawdzenie wymagań
check_requirements() {
    echo "Sprawdzanie wymagań..."
    
    # Terraform
    if ! command -v terraform &> /dev/null; then
        echo "❌ Terraform nie jest zainstalowany"
        echo "Zainstaluj Terraform: https://developer.hashicorp.com/terraform/downloads"
        exit 1
    fi
    echo "✅ Terraform: $(terraform version -json | jq -r '.terraform_version')"
    
    # SSH keys
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo "⚠️  Brak klucza SSH. Generuję nowy..."
        ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -N ""
        echo "✅ Klucz SSH został wygenerowany"
    else
        echo "✅ Klucz SSH istnieje"
    fi
}

# Konfiguracja OVHCloud API
setup_ovh_api() {
    echo ""
    echo "=== Konfiguracja OVHCloud API ==="
    echo "1. Przejdź do: https://eu.api.ovh.com/createToken/"
    echo "2. Wypełnij formularz:"
    echo "   - Application name: Valheim Server Automation"
    echo "   - Application description: Automatyzacja serwera Valheim"
    echo "   - Validity: Unlimited"
    echo "   - Rights: GET/POST/PUT/DELETE na /*"
    echo "3. Skopiuj wygenerowane klucze do pliku terraform.tfvars"
    echo ""
    
    if [ ! -f terraform/terraform.tfvars ]; then
        cp terraform/terraform.tfvars.example terraform/terraform.tfvars
        echo "✅ Utworzono plik terraform/terraform.tfvars"
        echo "⚠️  WAŻNE: Wypełnij plik terraform/terraform.tfvars swoimi danymi API!"
    else
        echo "✅ Plik terraform/terraform.tfvars już istnieje"
    fi
}

# Inicjalizacja Terraform
init_terraform() {
    echo ""
    echo "=== Inicjalizacja Terraform ==="
    cd terraform
    terraform init
    echo "✅ Terraform został zainicjalizowany"
    cd ..
}

# Nadanie uprawnień skryptom
set_permissions() {
    echo ""
    echo "=== Ustawianie uprawnień ==="
    chmod +x scripts/*.sh
    echo "✅ Uprawnienia zostały ustawione"
}

# Główna funkcja
main() {
    check_requirements
    setup_ovh_api
    init_terraform
    set_permissions
    
    echo ""
    echo "🎉 Konfiguracja zakończona!"
    echo ""
    echo "Następne kroki:"
    echo "1. Wypełnij plik terraform/terraform.tfvars swoimi danymi API"
    echo "2. Uruchom: cd terraform && terraform plan"
    echo "3. Jeśli plan wygląda dobrze: terraform apply"
    echo "4. Poczekaj ~10 minut na instalację serwera"
    echo "5. Użyj scripts/manage_server.sh do zarządzania serwerem"
    echo ""
    echo "Dokumentacja: README.md"
}

main "$@"