module "iam_assumable_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  create_role             = true
  create_instance_profile = true

  role_name         = "ec2InstanceRole"
  role_requires_mfa = false

  trusted_role_services = [
    "ec2.amazonaws.com"
  ]

  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}