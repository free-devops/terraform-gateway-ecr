# WIP: AWS GATEWAY-ECR module for creating repositories behind Gateway(Lambda auth)

## Usage:

### Terragrunt
``` hcl
include {
  path = find_in_parent_folders()
}


terraform {
  source = "<git-url-or-local-path>"
}


inputs = {
  respositores = ["test", "test1", "test2"]
  mutability = "MUTABLE"
  tags = {
    maintainer = "terraform"
    test = "this is a test"
  }
  protocol = "HTTP"
  name = "demo"
  scan = true
  env = "prod"
  fn_name = "demo_fn"
  lambda_s3 = "lambda_bucket"
  lambda_zip = "demo.zip"
  lambda_source = "s3" #"local"
  handler = "main.example"
  runtime = "nodejs12.x"
}
```
### Terraform
``` hcl
module "ecr" {
 source = "<git url or local relative path>"
 # input vars
 respositores = ["test", "test1", "test2"] 
 env = "prod"
 tags = {
    maintainer = "terraform"
    test = "this is a test repo"
  } 
}
```

#### Output

ecr = map(string)


