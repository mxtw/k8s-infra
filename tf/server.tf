terraform {
  required_providers {
    hcloud = {
      source  = "registry.terraform.io/hetznercloud/hcloud"
      version = "~> 1.47"
    }
  }
}

variable "hcloud_token" {
    sensitive = true
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "server" {
  name        = "k3s-1"
  server_type = "cx21"
  image       = "ubuntu-24.04"
  location    = "fsn1"
  ssh_keys    = ["main"]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }
}
