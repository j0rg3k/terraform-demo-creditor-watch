terraform {
  backend "local" {
    path = "../state/ecs.tfstate"
  }
}

data "terraform_remote_state" "network"{
  backend = "local"
  config = {
    path = "../state/network.tfstate"
  }
}

data "terraform_remote_state" "alb"{
  backend = "local"
  config = {
    path = "../state/alb.tfstate"
  }
}