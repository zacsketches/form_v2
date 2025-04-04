# form_v2

This **test only** project that contain **no security** is a small project I set up primarily to test IaC for deploying to the cloud.  I do not recommend this HTML for any production system.

## site/index.html
This is the homepage for a very simple website that serves as a numeric data entry form sending data to a webhook API defined in the project https://github.com/zacsketches/datastore_v2.

The `index.html` file is hosted on AWS S3 and uses Github actions to automate deployment to the S3 bucket `on: push` to the `main` branch. 

## infra/main.tf
This IaC creates the S3 bucket that hosts the website. Using `terraform apply` requires AWS credentials be loaded into the AWS cli on the host laptop running the `apply`. Using `terraform destroy` will tear down the bucket and break the automation since the deployment target will be gone.

## infra/s3-cors.json
The S3 bucket serving the site requires CORS to be enabled in order to access the webhook API. This file contains the **too permissive** CORS settings I have enabled to quickly iterate to a functional demo.
