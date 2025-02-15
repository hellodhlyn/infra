// AWS Lightsail instance
resource "aws_lightsail_instance" "lightsail_instance" {
  name              = var.node_name
  availability_zone = var.aws_availability_zone
  blueprint_id      = "debian_12"
  bundle_id         = "small_3_0"
  ip_address_type   = "dualstack"

  key_pair_name  = "ls-tokyo"
  user_data      = templatefile("${path.module}/node-init.sh", {
    NODE_NAME     = var.node_name
    K3S_SERVER_IP = var.k3s_server_ip
    K3S_TOKEN     = var.k3s_token
  })

  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "19:00"
    status        = "Disabled"
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}
