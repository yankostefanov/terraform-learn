variable "cidr_blocks" {    
  type = list(object({
    cidr_block = string
    name = string
  }))
  description = "vpc cider blocks and names"  
}
variable "environment" {
  description = "environment"  
}