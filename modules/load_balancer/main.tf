# Default ALB implementation that can be used connect ECS instances to it

resource "aws_alb_target_group" "default" {
  name                 = "${var.alb_name}"
  port                 = "${var.container_port}"
  protocol             = "HTTP"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.deregistration_delay}"

  health_check {
    path     = "${var.health_check_path}"
    protocol = "HTTP"
    matcher  = "200-299"
  }

  tags {
    workspace  = "${var.workspace}"
    Cluster    = "${var.cluster}"
    Service    = "${var.service_name}"
    Created_by = "terraform"
    Owner      = "${var.owner}"
  }
}

resource "aws_alb" "alb" {
  name            = "${var.alb_name}"
  subnets         = ["${var.public_subnet_ids}"]
  security_groups = ["${aws_security_group.alb.id}"]

  tags {
    workspace  = "${var.workspace}"
    Cluster    = "${var.cluster}"
    Service    = "${var.service_name}"
    Created_by = "terraform"
    Owner      = "${var.owner}"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.alb.id}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.default.id}"
    type             = "forward"
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.alb_name}_alb"
  vpc_id = "${var.vpc_id}"

  tags {
    workspace  = "${var.workspace}"
    Cluster    = "${var.cluster}"
    Service    = "${var.service_name}"
    Created_by = "terraform"
    Owner      = "${var.owner}"
  }
}

resource "aws_security_group_rule" "http_from_anywhere" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["${var.allow_cidr_block}"]
  security_group_id = "${aws_security_group.alb.id}"
}

resource "aws_security_group_rule" "outbound_internet_access" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.alb.id}"
}

# ECS dynamically assigns ports in the ephemeral range
resource "aws_security_group_rule" "container_from_alb" {
  type              = "ingress"
  from_port         = 32768
  to_port           = 65535
  protocol          = "TCP"
  security_groups   = ["${aws_security_group.alb.id}"]
  security_group_id = "${var.ec2_security_group}"
}
