resource "null_resource" "ecs_service" {
  # automatically set off a deploy
  # after this has run once, you can deploy manually by running
  # ecs-cli compose --project-name datacube service up
  triggers {
    project-name           = "${var.service_name}"
    task-role-arn          = "${module.ecs_policy.role_arn}"
    cluster                = "${var.cluster}"
    target-group-arn       = "${module.load_balancer.alb_target_group}"
    role                   = "/ecs/${module.public.ecs_lb_role}"
    container-name         = "${var.service_entrypoint}"
    compose-file           = "${md5(file(var.service_compose))}"
    deployment-max-percent = "${var.max_percent}"
    timeout                = "${var.timeout}"

    #enable for debugging
    timestamp = "${timestamp()}"
  }

  provisioner "local-exec" {
    # create and start our our ecs service
    command = <<EOF
export PUBLIC_URL=${module.load_balancer.alb_dns_name} && \
ecs-cli compose \
--project-name ${var.service_name} \
--task-role-arn ${module.ecs_policy.role_arn} \
--cluster ${var.cluster} \
--file ${var.service_compose} \
service up \
--target-group-arn ${module.load_balancer.alb_target_group} \
--role /ecs/${module.public.ecs_lb_role} \
--container-name ${var.service_entrypoint} \
--container-port ${var.container_port} \
--deployment-max-percent ${var.max_percent} \
--timeout ${var.timeout}
EOF
  }
}
