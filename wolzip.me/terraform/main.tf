terraform {
  cloud {
    organization = "hellodhlyn"
    workspaces {
      name = "wolzip-me"
    }
  }

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }
}
