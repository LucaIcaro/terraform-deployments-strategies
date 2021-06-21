# What?

In this example, we have only one ELB providing canary and/or blue-green deployment (this depends on the `traffic_distribution` variable).
_Blue/Green_ in this example do not mean _Production/Staging_ but they are interchangable: the first time blue is production, then green is production, then blue again, etc.

Here, the production environment is the only one that can be accessible from the internet, unless there is canary involved.

# How-To

This is the exact same code used by [this
tutorial](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments), so it's used in the same way.

1. run `terraform init`
2. run `terraform apply -var 'traffic_distribution=blue' -var 'enable_green_env=false'` to create the blue environment
3. run `while true; do curl $(terraform output -raw lb_dns_name); done` to test it
4. to deploy "staging", `terraform apply -var 'traffic_distribution=blue' -var 'enable_green_env=true'`
5. to promote "staging" to production", `terraform apply -var 'traffic_distribution=green'`, or, if someone wants to test canary, in the variables there are all the other `traffic_dist_map` to do that
6. after the deployment, `terraform apply -var 'traffic_distribution=green' -var 'enable_blue_env=false'` will destroy the former "production"
7. `terraform destroy -var 'traffic_distribution=$LAST_TRAFFIC_DISTRIBUTION'` will destroy the entire environment