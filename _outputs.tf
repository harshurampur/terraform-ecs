output "alb_dns_name" {
  value = "${module.load_balancer.alb_dns_name}"
}

output "task_role_arn" {
  value = "${module.ecs_policy.role_arn}"
}

output "target_group_arn" {
  value = "${module.load_balancer.alb_target_group}"
}

output "lb_role" {
  value = "/ecs/${module.public.ecs_lb_role}"
}

output "lb_arn" {
  value = "${module.load_balancer.alb_arn}"
}
