terraform {
  backend "s3" {
    bucket = "terraform-state.ricky-dev.com"
    key    = "personal/password.ricky-dev.com.tfstate"
    region = "us-east-2"
  }
}