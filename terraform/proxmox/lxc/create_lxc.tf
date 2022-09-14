##
# Create LXC Server
##
resource "proxmox_lxc" "test-lxc" {
  target_node  = "pve"
  hostname     = "terraform-test"
  ostemplate   = "VMs:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  unprivileged = true
  memory       = 1024
  pool         = "Default"
  start        = true
  features {
    nesting = true
  }
  ssh_public_keys = sensitive(file("~/.ssh/id_rsa.pub"))

  rootfs {
    storage = "VMs"
    size    = "4G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.6.31/24"
    gw     = "192.168.6.1"
  }

  tags = "Terrraform"
}

output "lxc-vmid" {
    description = "LXC VM ID"
    value = proxmox_lxc.test-lxc.vmid
}

output "lxc-ip" {
    description = "LXC IP Address"
    value = proxmox_lxc.test-lxc.network[0].ip
}

output "lxc-tag" {
    description = "LXC Name"
    value = proxmox_lxc.test-lxc.tags
}

output "os-type" {
    description = "Operating System Type"
    value = proxmox_lxc.test-lxc.ostype
}