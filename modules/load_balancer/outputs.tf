output "alb_security_group_id" {
  value = "${aws_security_group.alb.0.id}"
}

output "alb_target_group" {
  value = "${aws_alb_target_group.default.0.arn}"
}

output "alb_dns_name" {
  value = "${aws_alb.alb.0.dns_name}"
}

output "alb_name" {
  value = "${var.alb_name}"
}

output "alb_arn" {
  value = "${aws_alb.alb.0.arn}"
}

output "zone_id" {
  value = "${aws_alb.alb.0.zone_id}"
}

output "alb_sec_group_id" {
  value = "${aws_security_group.alb.0.id}"
}
