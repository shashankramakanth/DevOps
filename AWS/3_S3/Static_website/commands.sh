#1. Create an S3 bucket
aws s3api create-bucket --bucket my-static-website-bucket --region us-east-1

#2. Copy index.html to the S3 bucket
aws s3 cp index.html s3://my-static-website-bucket

#3. Enable website hosting on the bucket
aws s3 website s3://my-static-website-bucket --index-document index.html

#4. Allow public read access to the bucket
aws s3api put-bucket-acl --bucket my-static-website-bucket --acl public-read

#5. Get the website URL
aws s3api get-bucket-website --bucket my-static-website-bucket

#6. Access the website URL in a browser
# http://my-static-website-bucket.s3-website-us-east-1.amazonaws.com

#7. Clean up
aws s3 rm s3://my-static-website-bucket/index.html
aws s3 rb s3://my-static-website-bucket --force
