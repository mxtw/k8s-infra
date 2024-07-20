variable "hcloud_token" {
  type = string
  sensitive = true
}

variable "node_count" {
  type = number
  default = 0
}

variable "cloudflare_api_token" {
  sensitive = true
}

variable "cloudflare_zone_id" {
  sensitive = true
}
