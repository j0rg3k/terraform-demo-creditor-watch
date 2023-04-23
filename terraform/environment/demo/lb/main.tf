terraform {
  backend "local" {
    path = "../state/alb.tfstate"
  }
}

data "terraform_remote_state" "network"{
  backend = "local"
  config = {
    path = "../state/network.tfstate"
  }
}

data "terraform_remote_state" "acm"{
  backend = "local"
  config = {
    path = "../state/acm.tfstate"
  }
}
