# --------------------------
# key pair
# --------------------------
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-keypair"
  public_key = file("./src/tastylog-dev-keypair.pub")

  tags = {
    Name    = "${var.project}-keypair"
    Project = var.project
    Env     = var.environment
  }
}

# --------------------------
# create EC2 instance
# --------------------------
resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.app.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet_1a
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.app_ec2_profile.name #インスタンスプロフィールをEC2ヘアタッチ
  vpc_security_group_ids = [
    aws_security_group.app_sg.id,
    aws_security_group.opmng_sg.id
  ]
  key_name = aws_key_pair.keypair.key_name
  lifecycle {
    ignore_changes = [
      ami,
    ]
  }

  tags = {
    Name    = "${var.project}-web-ec2"
    Project = var.project
    type    = "web"
  }
}