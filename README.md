# What?

This project has different folders. Each folder has a readme file that explain a slightly different deployment strategy.
They are mostly blue-green with different options.

## The examples
1) blue/green and canary with one ELB. The production is the only environment accessible from the internet.
2) blue/green with one ELB. Both can be accessed on the internet with different URLs
3) blue/green with two ELBs. TBD

# How?

This is based from [this
tutorial](https://learn.hashicorp.com/tutorials/terraform/blue-green-canary-tests-deployments) by Hashicorp.

# Why?

We need to experiment with different deployments strategies, because TF can be quite complex when it comes to that