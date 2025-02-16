terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}


// AWS Lightsail instance
resource "aws_lightsail_instance" "lightsail_instance" {
  name              = var.node_name
  availability_zone = var.aws_availability_zone
  blueprint_id      = "debian_12"
  bundle_id         = "small_3_0"
  ip_address_type   = "ipv4"

  key_pair_name  = "ls-tokyo"
  user_data      = templatefile("${path.module}/node-init.sh", { NODE_NAME = var.node_name })

  add_on {
    type          = "AutoSnapshot"
    snapshot_time = "19:00"
    status        = "Enabled"
  }

  lifecycle {
    ignore_changes = [
      user_data,
    ]
  }
}

resource "aws_lightsail_static_ip" "static-ip-v4" {
  name = "${var.node_name}-ipv4"
}

resource "aws_lightsail_static_ip_attachment" "static-ip-v4" {
  instance_name  = aws_lightsail_instance.lightsail_instance.name
  static_ip_name = aws_lightsail_static_ip.static-ip-v4.name
}

resource "aws_lightsail_instance_public_ports" "public-port-443" {
  instance_name = aws_lightsail_instance.lightsail_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidrs = [
      "0.0.0.0/0"
    ]
  }
}

// Cloudflare DNS records
resource "cloudflare_dns_record" "dns-record-ipv4" {
  zone_id = var.cloudflare_zone_id
  comment = var.node_name
  content = aws_lightsail_static_ip.static-ip-v4.ip_address
  name    = "${var.node_name}.node.lynlab.cc"
  proxied = true
  ttl     = 1
  type    = "A"
}
