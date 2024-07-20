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
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
  required_version = "~> 1.7"
}

resource "random_string" "k3s_token" {
  length  = 48
  special = false
}

provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_server" "control_plane" {
  name        = "k3s-control-plane-1"
  server_type = "cx22"
  image       = "ubuntu-24.04"
  location    = "fsn1"
  ssh_keys    = ["main"]

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
  }

  user_data = templatefile("${path.module}/templates/control-plane-init.sh",
    {
      k3s_channel = "stable"
      k3s_token   = "{resource.random_string.k3s_token}"
    }
  )
}

// TODO: make multiple nodes work
// resource "hcloud_server" "node" {
//   count       = var.node_count
//   name        = "k3s-node-${count.index + 1}"
//   server_type = "cx21"
//   image       = "ubuntu-24.04"
//   location    = "fsn1"
//   ssh_keys    = ["main"]
// 
//   public_net {
//     ipv4_enabled = true
//     ipv6_enabled = true
//   }
// 
//   user_data = templatefile("${path.module}/templates/node-init.sh",
//     {
//       k3s_channel      = "stable"
//       k3s_token        = resource.random_string.k3s_token.result
//       control_plane_ip = resource.hcloud_server.control_plane.ipv4_address
//     }
//   )
// 
//   depends_on = [hcloud_server.control_plane]
// }

output "server-ip" {
  description = "IPv4 of server"
  value       = hcloud_server.control_plane.ipv4_address
}

