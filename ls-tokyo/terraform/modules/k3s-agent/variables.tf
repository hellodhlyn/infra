variable "node_name" {
  type = string
}

variable "aws_availability_zone" {
  type = string
}

variable "k3s_server_ip" {
  type      = string
  sensitive = true
}

variable "k3s_token" {
  type      = string
  sensitive = true
}
