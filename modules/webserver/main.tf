
resource "aws_security_group" "myapp-sg" {
  name = "myapp-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [var.myIP]   
    from_port = 22        
    protocol = "tcp"        
    to_port = 22
  } 
  ingress {
    cidr_blocks = [var.myIP]   
    from_port = 8080       
    protocol = "tcp"    
    to_port = 8080
  } 
  egress {    
    from_port = 0  
    protocol = "-1"    
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
    prefix_list_ids = []
  }
  tags = {
    "Name" = "${var.env_prefix}-sg"
  }
}
data "aws_ami" "latest-amazon-image"{
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = [var.image_name]
  }
}

resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  public_key = file(var.public_key_location)
  
}
resource "aws_instance" "myapp-server" {
  ami = data.aws_ami.latest-amazon-image.id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone = var.avail_zone
  associate_public_ip_address = true
  key_name = aws_key_pair.ssh-key.key_name

  user_data = file("entry-script.sh")  
}