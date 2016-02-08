aws public/private subnets terraform module
===========

A terraform module to take an empty VPC and add public and private subnets across availability zones.


Module Input Variables
----------------------

- `vpc_id` - vpc that we should use
- `public_subnets` - comma separated list of public subnet cidrs
- `private_subnets` - - comma separated list of private subnet cidrs
- `availability_zones` - comma separated lists of AZs in which to distribute subnets
- `name` - base name for all resorces
- `env` - the environment name, used for tagging
- `project` - the project name, used for tagging


It is mandatory to keep `public_subnets`, `private_subnets`, and
`availability_zones` to lists of the same length.

Usage
-----

```js
resource "terraform_remote_state" "tf_base" {
    backend = "s3"
    config {
      bucket = "terraform-state-myproject-${var.env}"
      key    = "tf_base.tfstate"
      region = "${var.aws_region}"
    }
}

module "vpc" {
  source = "github.com/bjss/tf_aws_public_private_subnets"

  vpc_id = "${terraform_remote_state.tf_base.vpc_id}"
  name = "my-vpc"

  availability_zones = "us-west-2a,us-west-2b,us-west-2c"
  private_subnets = "10.0.1.0/24,10.0.2.0/24,10.0.3.0/24"
  public_subnets  = "10.0.101.0/24,10.0.102.0/24,10.0.103.0/24"

}
```

Outputs
=======

 - `vpc_id` - does what it says on the tin
 - `private_subnets` - comma separated list of private subnet ids
 - `public_subnets` - comma separated list of public subnet ids
 - `public_route_table_id` - public route table id string
 - `private_route_table_id` - private route table id string

Authors
=======

[David Roussel](https://github.com/diroussel), based on work by
[Casey Ransom](https://github.com/cransom) and
[Paul Hinze](https://github.com/phinze)

License
=======

Apache 2 Licensed. See LICENSE for full details.
