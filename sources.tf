#Create s3 bucket 
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.s3_bucket
}

# Local variables to grab all relevant files
locals {
  # Get all CSS files in the assets/css directory
  css_files = fileset("portfolio/assets/css", "**/*.css")

  # Get all JS files in the assets/js directory
  js_files = fileset("portfolio/assets/js", "**/*.js")

  # Get all image files in the assets/images directory
  image_files = fileset("portfolio/assets/images", "**/*.*")
}

# Upload all files
resource "aws_s3_object" "css_files" {
  for_each = toset(local.css_files)

  bucket       = aws_s3_bucket.my_bucket.id
  key          = "assets/css/${each.value}"
  source       = "portfolio/assets/css/${each.value}"
 
  content_type = "text/css"
}

# Upload all JS files
resource "aws_s3_object" "js_files" {
  for_each = toset(local.js_files)

  bucket       = aws_s3_bucket.my_bucket.id
  key          = "assets/js/${each.value}"
  source       = "portfolio/assets/js/${each.value}"
  
  content_type = "application/javascript"
}

# Upload all image files
resource "aws_s3_object" "image_files" {
  for_each = toset(local.image_files)

  bucket       = aws_s3_bucket.my_bucket.id
  key          = "assets/images/${each.value}"
  source       = "portfolio/assets/images/${each.value}"
 
  content_type = "image/${split(".", each.value)[length(split(".", each.value)) - 1]}"
}

# Upload index.html
resource "aws_s3_object" "html" {
  bucket       = aws_s3_bucket.my_bucket.id
  key          = "index.html"
  source       = "portfolio/index.html"

  content_type = "text/html"
}


#create Key_pair instance
resource "aws_key_pair" "Deployer" {
  key_name   = "YOUR_SSH_KEY"
  public_key = file("${path.module}/YOUR_SSH_KEY")
}

#Create EC2 instance
resource "aws_instance" "prod-my-instance-1" {
  ami = "ami-0e35ddab05955cf57"
  instance_type = "t2.micro"
  key_name = aws_key_pair.Deployer.key_name
  subnet_id = aws_subnet.public-subnet-1.id
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name


  user_data = file("script.sh")

  vpc_security_group_ids = [aws_security_group.Allow-inbound-outbound.id]

  tags = {
    Name = "Prod : Ec2_public_subnet-1"
  }
}
#Create EC2 instance in another subnet
resource "aws_instance" "prod-my-instance-2" {
  ami = "ami-0e35ddab05955cf57"
  instance_type = "t2.micro"
  key_name = aws_key_pair.Deployer.key_name
  subnet_id = aws_subnet.public-subnet-2.id
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name


  user_data = file("script.sh")

  vpc_security_group_ids = [aws_security_group.Allow-inbound-outbound.id]

  tags = {
    Name = "Prod : Ec2_public_subnet-2"
  }
}










