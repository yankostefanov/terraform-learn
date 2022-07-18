resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.env_prefix}-vpc"    
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"
  subnet_cidr_block = var.subnet_cidr_block
  vpc_id = aws_vpc.myapp-vpc.id  
  avail_zone = var.avail_zone
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  env_prefix = var.env_prefix
}

module "myapp-server" {
  source = "./modules/webserver"
  vpc_id = aws_vpc.myapp-vpc.id
  myIP = var.myIP
  env_prefix = var.env_prefix
  image_name = var.image_name
  instance_type = var.instance_type
  public_key_location = var.public_key_location
  subnet_id = module.myapp-subnet.subnet.id  
  avail_zone = var.avail_zone
}