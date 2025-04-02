# form_v2

This **test only** project that contain **no security** is a small project I set up primarily to test IaC for deploying to the cloud.  I do not recommend this HTML for any production system.

## index.html
This is the homepage for a very simple website that serves as a numeric data entry form sending data to a webhook API defined in the project https://github.com/zacsketches/datastore_v2.

The `index.html` file is hosted on AWS S3, after clicking through all of the warnings about hosting public content on S3 in the AWS console. 

## s3-cors.json
The S3 bucket serving the site requires CORS to be enabled in order to access the webhook API. This file contains the **too permissive** CORS settings I have enabled to quickly iterate to a functional demo.
