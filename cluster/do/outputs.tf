output "Public ip" {
  value = "${digitalocean_droplet.vanessa.ipv4_address}"
}

output "Name" {
  value = "${digitalocean_droplet.vanessa.name}"
}