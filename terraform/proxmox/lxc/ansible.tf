
  connection {
    type     = "ssh"
    user     = "root"
    host_key = "${file("~/.ssh/id_rsa")}"
    host     = proxmox_lxc.basic.network.ip
  }

  provisioner "remote-exec" {
    inline = [
      "uptime >> /root/uptime.out",
    ]
  }