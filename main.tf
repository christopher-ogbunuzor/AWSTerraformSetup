provider "aws" {
  region     = "eu-west-1"
}
provider "aws" {
  alias = "east"
  region     = "us-east-1"
}
provider "aws" {
  alias = "oregon"
  region     = "us-west-2"
}

resource "aws_s3_bucket" "mys3statebucket" {
    
    bucket = "chris16555tfstate"
    acl = "private"
}

# https://quileswest.medium.com/how-to-lock-terraform-state-with-s3-bucket-in-dynamodb-3ba7c4e637
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "terraform-lock"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_keypair" {
  key_name   = "ta-lab-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.ec2_keypair.key_name}.pem"
  content  = tls_private_key.example.private_key_pem
}

# =================== us east 1 =======================

resource "aws_key_pair" "ec2_keypair_east" {
  provider = aws.east
  key_name   = "ta-lab-key"
  public_key = tls_private_key.example.public_key_openssh
}
resource "aws_s3_bucket" "mys3statebucket_east" {
    provider = aws.east
    bucket = "chris16555tfstateeast"
    acl = "private"
}
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock_east" {
  provider = aws.east
  name = "terraform-lock-east"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}

# =================== us west 2 =======================

resource "aws_key_pair" "ec2_keypair_oregon" {
  provider = aws.oregon
  key_name   = "ta-lab-key"
  public_key = tls_private_key.example.public_key_openssh
}
resource "aws_s3_bucket" "mys3statebucket_oregon" {
    provider = aws.oregon
    bucket = "chris16555tfstateoregon"
    acl = "private"
}
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock_oregon" {
  provider = aws.oregon
  name = "terraform-lock-oregon"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
}