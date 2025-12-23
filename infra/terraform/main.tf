terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# --- CHAMANDO O MÓDULO DE REDE ---
module "network_module" {
  source = "./modules/network"
}

# --- CHAMANDO O MÓDULO DE COMPUTAÇÃO ---
module "compute_module" {
  source = "./modules/compute"

  # Passando os valores que saíram da Rede para a Computação
  vpc_id    = module.network_module.vpc_id
  subnet_id = module.network_module.subnet_id
}

# Mostra o IP final na tela
output "ip_do_servidor" {
  value = module.compute_module.public_ip
}
