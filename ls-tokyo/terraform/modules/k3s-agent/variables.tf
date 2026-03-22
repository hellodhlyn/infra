variable "node_name" {
  type = string
}

variable "aws_availability_zone" {
  type = string
}

variable "k3s_server_host" {
  type      = string
  sensitive = true
}

variable "k3s_token" {
  type      = string
  sensitive = true
}

variable "tailscale_auth_key" {
  type      = string
  sensitive = true
}
