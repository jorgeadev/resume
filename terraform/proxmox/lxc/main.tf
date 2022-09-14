# Terraform Block
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url = ""
  pm_debug = true
  pm_api_token_id = ""
  pm_api_token_secret = ""
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
}