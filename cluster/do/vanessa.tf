provider "digitalocean" {
  token = "${var.do_token}"
}

resource "atlas_artifact" "vanessa-apache-cluster-ub16LTSmaster-do" {
  name = "silverbulleters/vanessa-apache-cluster-ub16LTSmaster-do"
  type = "digitalocean.image"
  version = "1"
}

resource "digitalocean_droplet" "vanessa" {
  ssh_keys           = ["${var.ssh_key_ID}"]
  image = "${atlas_artifact.vanessa-apache-cluster-ub16LTSmaster-do.id}"
  region             = "${var.region}"
  size               = "2gb"
  private_networking = true
  name               = "vanessa${count.index + 1}"
  count              = "${var.num_instances}"

  connection {
    type        = "ssh"
    private_key = "${file("${var.key_path}")}"
    user        = "root"
    timeout     = "2m"
  }

  provisioner "file" {
    source      = "${path.module}/vanessa-start.sh"
    destination = "/opt/vanessa-start.sh"
  }

  provisioner "file" {
    source      = "${path.module}/../../docker-compose.yml"
    destination = "/opt/docker-compose.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "echo ${var.num_instances} > /opt/vanessa-server-count",
      "echo ${digitalocean_droplet.vanessa.0.ipv4_address} > /opt/vanessa-server-addr",
      "curl -sSL https://agent.digitalocean.com/install.sh | sh"
    ]
  }
}
