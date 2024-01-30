
## install terraform
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

## install terraformer
export PROVIDER=cloudflare
curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
chmod +x terraformer-${PROVIDER}-linux-amd64
sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer

export CLOUDFLARE_API_TOKEN=
export CLOUDFLARE_ACCOUNT_ID=

cat>cd /devops/cloudflare/version.tf<<EOF
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}
EOF

terraformer import cloudflare --resources=dns

cat>/devops/cloudflare/generated/cloudflare/dns/provider.tf<<EOF
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}

provider "cloudflare" {
  api_token = 
  account_id = 
}
EOF

cd /devops/cloudflare/generated/cloudflare/dns/
terraform state replace-provider -auto-approve "registry.terraform.io/-/cloudflare" "cloudflare/cloudflare"
tf init