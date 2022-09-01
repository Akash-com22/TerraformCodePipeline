#configure backend

terraform {
  backend "s3" {
    bucket = "appmodernization-terraform-backend"
    key    = "codepipeline/terraform.tfstate"
    region = "us-west-2"
  }
}