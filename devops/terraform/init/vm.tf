resource "google_compute_instance" "vm_instance1" {
  name         = "nginx-instance5"
  machine_type = "e2-medium"

  tags = ["vpc-allow-ssh","vpc-allow-80","vpc-allow-443"]

  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-2004-lts"
      type  = "pd-ssd"
      # type  = "pd-balanced"
    }
  }

  metadata_startup_script = <<EOT
    sudo apt update
    sudo apt upgrade -y
    sudo apt install nginx net-tools git
    sudo timedatectl set-timezone Asia/Taipei
  EOT

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.private_network.self_link
    access_config {
      network_tier = "PREMIUM"
        # 這邊空白預設會建立一個外部IP , 整個拿掉就只會有內部IP
        # 如果有建立共同對外IP , 預設是
        # nat_ip = google_compute_address.static.address
    }
  }
}

# mysql
resource "google_compute_instance" "vm_instance2" {
  name         = "mysql1"
  machine_type = "e2-medium"

  tags = ["vpc-allow-ssh","vpc-allow-80","vpc-allow-443"]

  boot_disk {
    initialize_params {
      size  = "20"
      image = "ubuntu-2004-lts"
      type  = "pd-ssd"
      # type  = "pd-balanced"
    }
  }

  metadata_startup_script = <<EOT
    sudo apt update
    sudo apt upgrade -y
    sudo timedatectl set-timezone Asia/Taipei
    sudo apt install wget net-tools -y
    sudo apt install mariadb-server mariadb-client -y
    sudo systemctl start nginx mariadb
    sudo systemctl enable nginx mariadb

    wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
    tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
    cd node_exporter-1.3.1.linux-amd64
    ./node_exporter &
  EOT

  network_interface {
    network = google_compute_network.vpc_network.self_link
    subnetwork = google_compute_subnetwork.private_network.self_link
    access_config {
      network_tier = "PREMIUM"
        # 這邊空白預設會建立一個外部IP , 整個拿掉就只會有內部IP
        # 如果有建立共同對外IP , 預設是
        # nat_ip = google_compute_address.static.address
    }
  }
}
