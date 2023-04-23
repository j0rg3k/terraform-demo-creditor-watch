terraform {
  backend "local" {
    path = "../state/acm.tfstate"
  }
}