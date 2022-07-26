module "ec2_east" {
  source = "./modules/ec2"
}

module "ec2_west2" {
  providers = {
    aws = aws.west
  }
  source = "./modules/ec2"
}
