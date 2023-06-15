# ---------------------------------------------
# Security Group(attatch to alb)
# ---------------------------------------------
resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "alb security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-alb-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "in_http" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "in_https" {
  security_group_id = aws_security_group.alb_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# Security Group(attatch to web)
# ---------------------------------------------
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-web-sg"
  description = "web security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name    = "${var.project}-web-sg"
    Project = var.project
  }
}

resource "aws_security_group_rule" "in_from_alb_sg" {
  security_group_id        = aws_security_group.web_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3000
  to_port                  = 3000
  source_security_group_id = aws_security_group.alb_sg.id
}

resource "aws_security_group_rule" "out_to_app" {
  security_group_id = aws_security_group.web_sg.id
  type              = "egress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}
