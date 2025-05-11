#Static Website Hosting with AWS S3 + CloudFront (No Terraform)

This project demonstrates how to host a static website on **Amazon S3** with global distribution and HTTPS using **CloudFront**, **without using Terraform** — all within the AWS Free Tier.

---

## 📦 Features

- Static site hosted on S3
- Public access enabled via bucket policy
- Global CDN via CloudFront
- Free HTTPS (CloudFront default certificate)
- 100% AWS Free Tier eligible (no custom domain)

---

## 🛠 Prerequisites

- AWS CLI installed and configured  

  ```bash
  aws configure


A folder named website/ containing:
	•	index.html
	•	error.html

Setup instructions:

1. Create S3 bucket
  ```bash
  aws s3 mb s3://my-static-site-devops-2025
  ```
2. Enable static webhosting
CLI:
```bash
aws s3 website s3://my-static-site-devops-2025/ \
--index-document index.html \
--error-document error.html
```
3. Set public read access for S3 bucket
Refer bucket-policy.json

4. Apply the policy
```bash
aws s3api put-bucket-policy \
  --bucket my-static-site-devops-2025 \
  --policy file://bucket-policy.json
```
5. Upload files to S3
```bash
aws s3 sync ./website s3://my-static-site-devops-2025
```
6.  Create CloudFront Distribution
	•	Go to AWS Console → CloudFront → Create Distribution
	•	Origin domain: my-static-site-devops-2025.s3-website-<region>.amazonaws.com
	•	Origin protocol policy: HTTP only
	•	Viewer protocol policy: Redirect HTTP to HTTPS
	•	Viewer certificate: Default CloudFront certificate (*.cloudfront.net)

7. Once deployed, use cloudfront url to access website

8. If cloudfront url shows "Access Denied"
  •	Verify the bucket’s Block Public Access settings:
  ```bash
  aws s3api get-public-access-block --bucket my-static-site-devops-2025
  ```

  •	 If BlockPublicPolicy is true, it’s preventing the policy application.
  
  •	 To allow public policies (required for static website hosting), disable the BlockPublicPolicy setting:
```bash
  aws s3api put-public-access-block \
  --bucket my-static-site-devops-2025 \
  --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
```