# terraform-aws-ecr-repository

A pragmatic (opinionated) Terraform module to create AWS ECR repositories.

- AWS lambdas in the same AWS account can pull images by default
- Only the latest 10 images will be kept

## Examples

### Basic configuration

```hcl
module "skeleton" {
  source = "questionable-focus/ecr-repository"
  name   = "skeleton"
}
```

### Requiring additional permissions

To specify a custom policy on the repository, define a policy document and pass it through to the module. This is helpful if you want to configure common permissions across all repositories (since the best practice is to have a repository per container image to be stored).

```hcl
data "aws_iam_policy_document" "main" {
    statement {
        # ...
    }
}

module "skeleton" {
  source  = "app.terraform.io/questionable-focus/ecr-repository/aws"
  version = "1.0.0"

  name              = "skeleton"
  repository_policy = data.aws_iam_policy_document.main.json
}
```
