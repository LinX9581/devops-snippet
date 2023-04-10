
* 安裝 cf-terraforming
https://github.com/cloudflare/cf-terraforming/releases

curl -LO https://github.com/cloudflare/cf-terraforming/releases/download/v0.11.0/cf-terraforming_0.11.0_linux_386.tar.gz
tar -zxvf cf-terraforming_0.11.0_linux_386.tar.gz
mv cf-terraforming /usr/local/bin

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = $token
}


cf-terraforming generate \
  --resource-type "cloudflare_record" \
  --zone $CLOUDFLARE_ZONE_ID