provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "root" {
  zone_id = var.cloudflare_zone_id
  name = "root"
  value   = hcloud_server.control_plane.ipv4_address
  type    = "A"
  ttl     = 3600

  depends_on = [hcloud_server.control_plane]
}

resource "cloudflare_record" "root-cname" {
  zone_id = var.cloudflare_zone_id
  name = "root-cname"
  value   = "macks.cloud"
  type    = "CNAME"
  ttl     = 3600

  depends_on = [hcloud_server.control_plane]
}
