resource "aws_vpc" "deployment-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = var.environment,
    "vpc_env" = "dev"
  }
}
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.deployment-vpc.id
  cidr_block = var.cidr_blocks[0].cidr_block
  availability_zone = "us-east-1a"
  tags = {
    "Name" = var.cidr_blocks[0].name
  }
}

output "dev-vpc-id" {
  value = aws_vpc.deployment-vpc.id
}
output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}