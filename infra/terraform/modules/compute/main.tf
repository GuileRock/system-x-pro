# Variáveis que este módulo EXIGE receber
variable "subnet_id" {
  description = "ID da subnet onde a maquina vai rodar"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC para criar o Firewall"
  type        = string
}

# 1. O Firewall (Security Group)
resource "aws_security_group" "web_sg" {
  name        = "systemx-sg"
  description = "Permite SSH e HTTP"
  vpc_id      = var.vpc_id # Usa a variável recebida

  # Entrada: SSH (Porta 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Entrada: HTTP (Porta 80 - Futuro Nginx)
  ingress {
    from_port   = 5000 # Vamos liberar a 5000 para teste do Flask
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Saída: Tudo liberado (para baixar atualizações)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. A Máquina Virtual (EC2)
resource "aws_instance" "app_server" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu 24.04 LTS (us-east-1)
  instance_type = "t3.micro"              # Lembra do erro? Usamos t3.micro!
  subnet_id     = var.subnet_id           # Conecta na rede criada pelo outro módulo
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name    = "SystemX-App-Server"
    Project = "System-X"
  }
}

# Output: Retorna o IP para o usuário
output "public_ip" {
  value = aws_instance.app_server.public_ip
}
