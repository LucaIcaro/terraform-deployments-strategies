
resource "aws_lb" "production" {
  name               = "prod-main-app-${random_pet.app.id}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.lb_security_group.this_security_group_id]
}

resource "aws_lb" "staging" {
  name               = "stag-main-app-${random_pet.app.id}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [module.lb_security_group.this_security_group_id]
}


resource "aws_lb_listener" "production" {
  load_balancer_arn = aws_lb.production.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.blue.arn
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}

resource "aws_lb_listener" "staging" {
  load_balancer_arn = aws_lb.staging.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.green.arn
      }

      stickiness {
        enabled  = false
        duration = 1
      }
    }
  }
}

resource "aws_lb_listener_rule" "production_app" {
  action {
    order            = "1"
    target_group_arn = var.production_environment == "blue" ? aws_lb_target_group.blue.arn : aws_lb_target_group.green.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = ["production-example.org"]
    }
  }

  listener_arn = aws_lb_listener.production.arn
  priority     = "1"
}

resource "aws_lb_listener_rule" "staging_app" {
  action {
    order            = "2"
    target_group_arn = var.production_environment == "blue" ? aws_lb_target_group.green.arn : aws_lb_target_group.blue.arn
    type             = "forward"
  }

  condition {
    host_header {
      values = ["staging-example.org"]
    }
  }

  listener_arn = aws_lb_listener.staging.arn
  priority     = "2"

}