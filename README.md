Static Website Hosting on AWS
=============================

[![website](https://img.shields.io/badge/website-8bitof.me-brightgreen)](https://www.8bitof.me)
[![Build Status](https://travis-ci.com/senter7/Terraform-Online-Static-Website.svg?branch=master)](https://travis-ci.com/senter7/Terraform-Online-Static-Website)
![tflint](https://github.com/senter7/Terraform-Online-Static-Website/workflows/tflint/badge.svg?branch=master)
[![license](https://img.shields.io/hexpm/l/plug)](https://opensource.org/licenses/Apache-2.0)
![terraform_version](https://img.shields.io/badge/terraform-0.12.20%2B-blue)


This is a personal Terraform project to hosting a static website on AWS
with S3, CloudFront CDN, SSL and CodePipeline for CI/CD.
I hosted my website templates on [Online-CV](https://github.com/senter7/Online-CV) repo, so i can update webpages and trigger the pipeline after every push action.

This project is used for the deployment of my website: [8bitof.me](https://www.8bitof.me)


Prerequisites
-------------

1. AWS Account, AWS CLI, Terraform (i used 0.12.12)
2. A domain purchased on AWS Route53 or other provider (with DNS service)
3. A personal static website or templates on GitHub
4. GitHub Access Token

If the domain was not purchased on AWS Route53, certificate validation for SSL will fail.
The certificate is validated through the 'DNS' mode. If the domain was purchased from another provider:
- **EMAIL VALIDATION**: select validation via EMAIL in `terraform.tfvars`; AWS will send an email to the following addresses ([AWS Documentation](https://docs.aws.amazon.com/acm/latest/userguide/setup-email.html)):
  - administrator@domain_name
  - hostmaster@domain_name
  - postmaster@domain_name
  - webmaster@domain_name
  - admin@domain_name
- **DNS VALIDATION**: manually create the zone on route53, and use the nameservers provided by AWS to delegate the zone on the provider where the domain was purchased.
Insert the `hosted_zone_id` in `terraform.tfvars` and run the apply.

For generate an Access Token on GitHub:
1. Log in to GitHub and access [*personal access token*](https://github.com/settings/tokens) page
2. Generate a new token with `read:repo_hook policy`

**NB**
GitHub Access Token is **reserved**, remember not to commit to the repo with the `github_token` variable initialized.  
I used AWS SSM Parameter Store to store the secret as SecureString with standard encryption key `alias/aws/ssm`.  
I retrieve the secret with:  
```
aws ssm get-parameter --name /online-cv/github/token --region eu-west-1 --with-decryption --query 'Parameter.Value' --output text
```

Environment Customization
-------------------------
Terraform states are saved on S3 and lock is performed on DynamoDB. To customize the environment, modify the `system/backend.tf` according to the [Terraform Documentation](https://www.terraform.io/docs/backends/types/s3.html).

Variables Customization
-----------------------
Use `terraform.tfvars` file to customize the environment

| Name | Type | Description | Example |
|:-----|:-----|:------------|:--------|
|region|string|The AWS region where the entire system will be deployed|"eu-west-1"|
|root_domain_name|string|The root domain purchased on Route53 or another provider|"8bitof.me"|
|subject_alternative_names|list(string)|List of third level domains for which the certificate is issued|"\[*.8bitof.me]"|
|app_name|string|App or project name|"online-cv"|
|buildspec_relative_path|string|Relative path of the buildspec.yml file for CodeBuild|"assets/buildspec.yml"|
|github_repository_branch|string|The branch of the GitHub repo where to apply the webhook to trigger the CI/CD pipeline|"master"|
|github_repository_name|string|The name of the GitHub repo where to apply the webhook to trigger the CI/CD pipeline|"Online-CV"|
|github_repository_owner|string|The owner of the GitHub repo where to apply the webhook to trigger the CI/CD pipeline|"senter7"|
|hosted_zone_id|string|ID of the Route53 public hosted zone (see **prerequisites** section)|"Z2UGAOGM1DPCYV"|
|github_token|string|GitHub Access Token (see **prerequisites** section|To be inserted during the Apply action|

Build Customization
-------------------
CodeBuild uses the `buildspec.yml` file to configure the build. For my personal website, i used
[HUGO](https://gohugo.io), and this build runs only for HUGO templates.  
For customize the build, modify the `buildspec.yml` according to [AWS Documentation](https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html#build-spec-ref-example)

Possible Improvements
---------------------
- `buildspec.yml` could be better rewritten
- The IAM policy for CodePipeline perhaps has more permissions than necessary
- Chache invalidation of all files maybe too expensive
- Second CDN for root domain redirect
- ...