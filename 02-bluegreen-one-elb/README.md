# What?

In this example, we have only one ELB providing canary blue-green deployment.
_Blue/Green_ in this example do not mean _Production/Staging_ but they are interchangable: the first time blue is production, then green is production, then blue again, etc.

The production environment and staging are both reachable on the internet by using different URLs.

The code is similar to example 01, the main difference is that we are using `aws_lb_listener_rule` to define rules to redirect requests from the ELB.

# How-To


1. run `terraform init`
2. run `terraform apply -var 'production_environment=blue' -var 'enable_green_env=false'` to create the blue environment
3. run `while true; do curl $(terraform output -raw lb_dns_name) -H "Host: production-example.org"; done` to test it
4. to deploy "staging", `terraform apply -var 'production_environment=blue' -var 'enable_green_env=true'`
5. to test staging `while true; do curl $(terraform output -raw lb_dns_name) -H "Host: staging-example.org"; done`
6. to promote "staging" to production", `terraform apply -var 'production_environment=green'`
7. after the deployment, `terraform apply -var 'production_environment=green' -var 'enable_blue_env=false'` will destroy the former "production"
8. `terraform destroy -var 'production_environment=$LAST_TRAFFIC_DISTRIBUTION'` will destroy the entire environment