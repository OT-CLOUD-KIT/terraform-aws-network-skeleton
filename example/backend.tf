terraform {
  backend "s3" {
    bucket = "ot-cloud-kit-bucket"
    key    = "ot/module/networkskeleton/terraform.tfstate"
    region = "us-east-1"

  }
}