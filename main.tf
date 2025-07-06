resource "proxmox_vm_qemu" "k8s-master" {
  count = 2
  name = "k8s-master${count.index + 1}"
  tags = "control-plane;production;ubuntu;server;kubernetes"
  desc = "Estudo de Kubernetes para prova CKA"
  target_node = "pve-01"
  clone = "ubuntu-24-cloudinit-template"
  cores = 2
  sockets = 2
  memory = 4096
  agent = 1
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  boot = "order=scsi0"
  
  disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "storage-vms"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = "55"
                    cache           = "writeback"
                    storage         = "storage-vms"
                    replicate       = true
                }
            }
        }
    }

  network {
    id    = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.39.${count.index + 130 }/24,gw=10.0.39.10"
  os_type = "cloud-init"
  vmid = "${count.index + 9100}"

  ciuser = var.ssh_user
  cipassword = var.ssh_password

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

  serial {
      id   = 0
      type = "socket"
    }

#provisioner "remote-exec" {
#    inline = ["echo ${var.ssh_password} | sudo -S -k hostnamectl set-hostname ${self.name}"]
#provisioner "remote-exec" {
#  inline = [
#    "echo ${var.ssh_password} | sudo -S -k apt update -y && sudo apt upgrade -y",
#    "echo ${var.ssh_password} | sudo -S -k apt install -y python3 curl keepalived",
#    "echo '${file("files/hosts_custom")}' | sudo tee /etc/hosts > /dev/null",
#    "echo ${var.ssh_password} | sudo -S -k mkdir -p /etc/keepalived",
#    "echo '${file("files/keepalived_custom.conf")}' | sudo tee /etc/keepalived/keepalived.conf > /dev/null",
#    "echo '${file("files/check_apiserver_custom.sh")}' | sudo tee /etc/keepalived/check_apiserver.sh > /dev/null",
#    "echo ${var.ssh_password} | sudo -S -k adduser --system --no-create-home --disabled-password --disabled-login keepalived_script || true",
#    "echo ${var.ssh_password} | sudo -S -k chown keepalived_script /etc/keepalived/check_apiserver.sh",
#    "echo ${var.ssh_password} | sudo -S -k chmod u+x /etc/keepalived/check_apiserver.sh",
#    "echo ${var.ssh_password} | sudo -S -k systemctl enable --now keepalived"
#    ]
#  }
provisioner "remote-exec" {
  inline = [
    "echo ${var.ssh_password} | sudo -S -k hostnamectl set-hostname ${self.name}",
    "echo ${var.ssh_password} | sudo -S -k apt update -y && sudo apt upgrade -y",
    "echo ${var.ssh_password} | sudo -S -k apt install -y python3 haproxy",
#    "echo '${file("files/hosts_custom")}' | sudo tee /etc/hosts > /dev/null"
  ]
}
  connection {
    host        = self.ssh_host
    type        = "ssh"
    user        = var.ssh_user
    password    = var.ssh_password
    private_key = file("/home/joelfernandes/.ssh/id_rsa")
  }
}

resource "proxmox_vm_qemu" "k8s-node" {
  count = 2
  name = "k8s-node${count.index + 1}"
  tags = "control-workers;production;ubuntu;server;kubernetes"
  desc = "Estudo de Kubernetes para prova CKA"
  target_node = "pve-01"
  clone = "ubuntu-24-cloudinit-template"
  cores = 2
  sockets = 1
  memory = 2048 
  agent = 1
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  boot = "order=scsi0"

  disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "storage-vms"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = "55"
                    cache           = "writeback"
                    storage         = "storage-vms"
                    replicate       = true
                }
            }
        }
    }

  network {
    id    = 0
    model = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.39.${count.index + 230 }/24,gw=10.0.39.10"
  os_type = "cloud-init"
  vmid = "${count.index + 9200 }"

  ciuser = var.ssh_user
  cipassword = var.ssh_password

#  sshkeys = <<EOF
#    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCt4kFTou6QMv2PmWBKfKKxJJjCWVZauAAbqVILKkTRqtR74Bx2kSUcpXGAz3iY4xPdw8BlLWWkGYeEQdewxNfZdbK3UPOAOmmbP6zx8RFMLa8oyjjZ7qOtzCPTA95j0cEAZhiCvkak+uhlcZAff4wYefCPErSIbrt6MC80qq8xiGah6CBYGTqV1CXewYYerK+cC5tAjFt3RV1gHEdkKZZ9TNA/RH4ra9rx5nXCLDqsXPjbgYBnAYvm7X1z6f03/JNqjVuBQKaKE/XzkF25cp708SbHQnrH8MpjRsz3N1bxBfTZb4sLqGqI2L7MNac4JlxV1kYmv5Dm9jy3ao1slJJRGELFwuXiGTYOyGp/0lHZ5hWhqzOyppamrebeRJsbQSuxfZEv7F8TjfsLNreahrLCyL0aJih+oYzJ8Qm70TuXAdG2StzztjGQYnOP2dDEjvCGqgIj2cGXGJEmJSFyGrfT7BWJKSls0lrNSqBmorbeSfdilO+9CJ6hO3a2glcgS7U= joel_fernandes@hotmail.com
#    EOF
#  sshkeys = var.ssh_key
  sshkeys = <<EOF
  ${var.ssh_key}
  EOF
  
  serial {
      id   = 0
      type = "socket"
    }

#  provisioner "remote-exec" {
#    inline = ["echo ${var.ssh_password} | sudo -S -k hostnamectl set-hostname ${self.name}"]
#  }
provisioner "remote-exec" {
  inline = [
    "echo ${var.ssh_password} | sudo -S -k hostnamectl set-hostname ${self.name}",
    "echo ${var.ssh_password} | sudo -S -k apt update -y && sudo apt upgrade -y",
    "echo ${var.ssh_password} | sudo -S -k apt install -y python3",
    "echo '${file("files/hosts_custom")}' | sudo tee /etc/hosts > /dev/null"
  ]
    connection {
      host = self.ssh_host
      type = "ssh"
      user = var.ssh_user
      password = var.ssh_password
      private_key = "${file("/home/joelfernandes/.ssh/id_rsa")}"
    }
  }
}

resource "proxmox_vm_qemu" "ha-proxy" {
  count        = 1
  name         = "ha-proxy${count.index + 1}"
  tags         = "ha-proxy;production;ubuntu;server;kubernetes"
  desc         = "Estudo de Kubernetes para prova CKA"
  target_node  = "pve-01"
  clone        = "ubuntu-24-cloudinit-template"
  cores        = 2
  sockets      = 2
  memory       = 4096
  agent        = 1
  scsihw       = "virtio-scsi-pci"
  bootdisk     = "scsi0"
  boot         = "order=scsi0"

  disks {
        ide {
            ide2 {
                cloudinit {
                    storage = "storage-vms"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    size            = "55"
                    cache           = "writeback"
                    storage         = "storage-vms"
                    replicate       = true
                }
            }
        }
    }

  network {
    id     = 0
    model  = "virtio"
    bridge = "vmbr0"
  }

  ipconfig0 = "ip=10.0.39.${count.index + 150}/24,gw=10.0.39.10"
  os_type   = "cloud-init"
  vmid      = count.index + 9150

  ciuser     = var.ssh_user
  cipassword = var.ssh_password

  sshkeys = <<EOF
${var.ssh_key}
EOF

  serial {
    id   = 0
    type = "socket"
  }

  connection {
    host        = self.ssh_host
    type        = "ssh"
    user        = var.ssh_user
    password    = var.ssh_password
    private_key = file("/home/joelfernandes/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.ssh_password} | sudo -S -k apt update -y && sudo apt upgrade -y",
      "echo ${var.ssh_password} | sudo -S -k apt install -y python3 curl haproxy",
#      "echo '${file("files/hosts_custom")}' | sudo tee /etc/hosts > /dev/null",
#      "echo ${var.ssh_password} | sudo -S -k mkdir -p /etc/keepalived",
#      "echo '${file("files/keepalived_custom.conf")}' | sudo tee /etc/keepalived/keepalived.conf > /dev/null",
#      "echo '${file("files/check_apiserver_custom.sh")}' | sudo tee /etc/keepalived/check_apiserver.sh > /dev/null",
#      "echo ${var.ssh_password} | sudo -S -k adduser --system --no-create-home --disabled-password --disabled-login keepalived_script || true",
#      "echo ${var.ssh_password} | sudo -S -k chown keepalived_script /etc/keepalived/check_apiserver.sh",
#      "echo ${var.ssh_password} | sudo -S -k chmod u+x /etc/keepalived/check_apiserver.sh",
#      "echo ${var.ssh_password} | sudo -S -k systemctl enable --now keepalived"
    ]
  }
}


output "proxmox_master_default_ip_addresses" {
  description = "Current IP Default"
  value = proxmox_vm_qemu.k8s-master.*.default_ipv4_address
}

output "proxmox_nodes_default_ip_addresses" {
  description = "Current IP Default"
  value = proxmox_vm_qemu.k8s-node.*.default_ipv4_address
}
output "proxmox_ha-proxy_default_ip_addresses" {
  description = "Current IP Default"
  value = proxmox_vm_qemu.ha-proxy.*.default_ipv4_address
}
