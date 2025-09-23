# Copilot Instructions for Valheim OVHCloud Automation

## Project Overview
Automates deployment and management of a dedicated Valheim server on OVHCloud using Terraform, cloud-init, and Bash scripts. The infrastructure is provisioned via Terraform, with server setup handled by cloud-init and custom scripts.

## Key Components
- **terraform/**: Infrastructure as Code (OpenStack resources, security groups, floating IP, instance provisioning)
- **scripts/**: Automation scripts for setup (`setup.sh`), server management (`manage_server.sh`), and cloud-init configuration (`cloud-init.yml`)
- **config/**: Valheim server configuration files (e.g., `valheim_plus.cfg`)
- **docs/**: Deployment and usage documentation (`DEPLOYMENT.md`)

## Developer Workflows
- **Initial Setup**: Run `scripts/setup.sh` to check requirements, configure API keys, initialize Terraform, and set script permissions.
- **Configuration**: Edit `terraform/terraform.tfvars` with OVH API keys and Valheim server details.
- **Provisioning**: Use `terraform plan` and `terraform apply` in the `terraform/` directory to deploy infrastructure.
- **Server Management**: Use `scripts/manage_server.sh <IP_SERWERA> <akcja>` for actions: `start`, `stop`, `restart`, `status`, `logs`, `backup`, `update`.
- **Backup**: Run `manage_server.sh <IP_SERWERA> backup` to create world backups. Retrieve with `scp`.
- **Destroy**: Use `terraform destroy` to remove all resources.

## Patterns & Conventions
- **Bash scripts**: All management and setup scripts are Bash, with clear usage instructions and error handling.
- **Cloud-init**: Server setup is fully automated via `cloud-init.yml`, including SteamCMD, Valheim install, firewall, and systemd service.
- **Systemd**: Valheim server runs as a systemd service (`valheim.service`).
- **Security**: Only required ports (2456-2458/udp, 22/tcp) are open. SSH access is restricted via `ssh_allowed_cidr`.
- **API Keys**: Sensitive OVH API keys are stored in `terraform.tfvars` (never commit real credentials).

## Integration Points
- **OVHCloud**: Uses OpenStack provider for VM provisioning.
- **SteamCMD**: Installs and updates Valheim server.
- **Systemd**: Manages server lifecycle.
- **UFW/Fail2ban**: Basic security hardening.

## Troubleshooting
- **Logs**: Use `manage_server.sh <IP_SERWERA> logs` or SSH to check `journalctl -u valheim -f`.
- **Status**: Use `systemctl status valheim` via SSH or management script.
- **Cloud-init issues**: Check `journalctl -u cloud-final -f`.
- **Firewall/Ports**: Validate with `ufw status` and `netstat`.

## Example Workflow
```bash
# Setup environment
./scripts/setup.sh

# Configure API keys and server details
vim terraform/terraform.tfvars

# Deploy infrastructure
cd terraform
terraform plan
terraform apply

# Manage server
./scripts/manage_server.sh <IP_SERWERA> status
./scripts/manage_server.sh <IP_SERWERA> backup
scp -i ~/.ssh/id_rsa ubuntu@<IP_SERWERA>:/home/steam/valheim_backup_*.tar.gz ./

# Destroy resources
terraform destroy
```

Refer to `README.md` and `docs/DEPLOYMENT.md` for full documentation and troubleshooting steps.
