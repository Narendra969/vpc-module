module "dev-vpc" {
  source              = "git::https://github.com/Narendra969/Tera-Ans-Vpc.git"
  vpccidr             = "172.16.0.0/24"
  publicsubnetscidrs  = ["172.16.0.0/26", "172.16.0.64/26"]
  privatesubnetscidrs = ["172.16.0.128/26", "172.16.0.192/26"]
  availability_zones  = ["ap-south-1a", "ap-south-1b"]
  enable_dns_support  = true
  commontags = {
    "ProjectName" = "Demo",
    "Environment" = "Develeopment"
  }
  security_group_name        = "K8S_Servers__SG"
  security_group_description = "Allow all Ports"
  security_group_inbound_rules = [{
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all Traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    }
  ]
  sg_tags = { Name = "K8S_Servers__SG", Managed = "Tera_Ans" }
}

module "K8S_Workers" {
  source                 = "git::https://github.com/Narendra969/Tera-Ans-Ec2.git"
  ami_id                 = "ami-08e5424edfe926b43"
  instance_type          = "t2.micro"
  count                  = 2
  subnet_id              = element(module.dev-vpc.privatesubnets_ids[*], count.index)
  vpc_security_group_ids = [module.dev-vpc.sg_id]
  tags                   = { Name = "K8S_Worker_${count.index + 1}", Type = "Workers" }
  key_name               = "K8S_Servers_Pub_Key"
  public_key             = "/home/ubuntu/id_rsa"
}

module "K8S_Master" {
  source                 = "git::https://github.com/Narendra969/Tera-Ans-Ec2.git"
  ami_id                 = "ami-08e5424edfe926b43"
  instance_type          = "t2.medium"
  subnet_id              = module.dev-vpc.publicsubnets_ids[0]
  vpc_security_group_ids = [module.dev-vpc.sg_id]
  tags                   = { Name = "K8S_Master", Type = "Master" }
  key_name               = "K8S_Servers_Pub_Key"
  public_key             = "/home/ubuntu/id_rsa"
}
