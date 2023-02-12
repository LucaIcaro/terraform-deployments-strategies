# What?

In this example, we have only two ELBs providing canary blue-green deployment.
_Blue/Green_ in this example do not mean _Production/Staging_ but they are interchangable: the first time blue is production, then green is production, then blue again, etc.

The production environment and staging are both reachable on the internet by using different URLs.

# How-To


1. run `terraform init`
2. run `terraform apply -var 'production_environment=blue' -var 'enable_green_env=false'` to create the blue environment
3. run `while true; do curl $(terraform output -raw prod_lb_dns_name) -H "Host: production-example.org"; done` to test it
4. to deploy "staging", `terraform apply -var 'production_environment=blue' -var 'enable_green_env=true'`
5. to test staging `while true; do curl $(terraform output -raw stag_lb_dns_name) -H "Host: staging-example.org"; done`
6. to promote "staging" to production", `terraform apply -var 'production_environment=green'`
7. after the deployment, `terraform apply -var 'production_environment=green' -var 'enable_blue_env=false'` will destroy the former "production"
8. `terraform destroy -var 'production_environment=$LAST_TRAFFIC_DISTRIBUTION'` will destroy the entire environment

# Issues

This approach is not working, because TF tries to attach target groups __before__ removing them from the previous load balancer:
```
│ Error: Error modifying LB Listener Rule: TargetGroupAssociationLimit: The following target groups cannot be associated with more than one load balancer: arn:aws:elasticloadbalancing:us-west-2:1234567890:targetgroup/blue-tg-tops-rooster-lb/d7d9ec0c24ef07d8
```

Even if this was possible, since the logic of the code requires blue/green interchangeable, it would mean that we will have some downtime for every deploy.
