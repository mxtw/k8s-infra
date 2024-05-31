terraform {
  required_providers {
    hcloud = {
      source  = "registry.terraform.io/hetznercloud/hcloud"
      version = "~> 1.47"
    }
    random = {
      source  = "registry.terraform.io/hashicorp/random"
      version = "~> 3.6"
    }
  }
  required_version = "~> 1.7"
}

variable "hcloud_token" {
  type = string
  sensitive = true
}

resource "random_string" "k3s_token" {
  length  = 48
  special = false
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "main" {
  name        = "k3s-1"
  server_type = "cx21"
  image       = "ubuntu-24.04"
  location    = "fsn1"
  ssh_keys    = ["main"]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = templatefile("${path.module}/templates/init.sh",
    {
      k3s_channel = "stable"
      k3s_token   = "{resource.random_string.k3s_token}"
    }
  )
}
