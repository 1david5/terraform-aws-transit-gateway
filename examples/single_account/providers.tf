provider "aws" {
  region = var.region_a
}

provider "aws" {
  alias  = "region_a"
  region = var.region_a
}

provider "aws" {
  alias  = "region_b"
  region = var.region_b
}
