terraform {
  backend "s3" {
    bucket  = "nt548-lab02-tfstate"
    key     = "env/terraform.tfstate"
    region  = "ap-southeast-1"
    encrypt = true
  }
}