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
  availability_zone = "ap-northeast-1a"
  blueprint_id      = "debian_12"
  bundle_id         = "small_3_0"
  ip_address_type   = "dualstack"

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

resource "aws_lightsail_instance_public_ports" "public-port-6443" {
  instance_name = aws_lightsail_instance.lightsail_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 6443
    to_port   = 6443
    cidrs = [
      "0.0.0.0/0"
    ]
    ipv6_cidrs = [
      "::/0"
    ]
  }
}

// Cloudflare DNS records
resource "cloudflare_dns_record" "dns-record-ipv6" {
  zone_id = var.cloudflare_zone_id
  comment = var.node_name
  content = aws_lightsail_instance.lightsail_instance.ipv6_addresses[0]
  name    = "${var.node_name}.node.lynlab.cc"
  proxied = true
  ttl     = 1
  type    = "AAAA"
}
