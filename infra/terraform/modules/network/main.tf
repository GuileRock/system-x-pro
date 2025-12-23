# 1. A Rede Principal (VPC)
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = { Name = "SystemX-VPC" }
}

# 2. A Sub-rede Pública (Onde ficará o servidor)
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Garante IP público automático
  availability_zone       = "us-east-1a"
  tags = { Name = "SystemX-Public-Subnet" }
}

# 3. O Portão para a Internet (Internet Gateway)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = { Name = "SystemX-IGW" }
}

# 4. A Tabela de Roteamento (O GPS da rede)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Todo tráfego de saída...
    gateway_id = aws_internet_gateway.igw.id # ...vai para o Gateway
  }
  tags = { Name = "SystemX-Public-RT" }
}

# 5. Associação (Ligando a Subnet ao GPS)
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# --- OUTPUTS (O que esse módulo exporta para os outros?) ---
output "subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
