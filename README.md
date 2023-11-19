# localstack-infra-base

Using `Terragrunt` to provision infra on `localstack`

```
docker-compose up -d
./init-s3-backend.sh
./terragrunt-apply-all.sh
docker-compose stop
```

## localstack

* [install guide](https://docs.localstack.cloud/getting-started/installation/)

* configure aws-cli


```
cat <<EOF >> ~/.aws/config
[profile localstack]
region = us-east-1
output=json
endpoint_url = http://localhost:4566
EOF

cat <<EOF >> ~/.aws/credentials
[localstack]
aws_access_key_id = test
aws_secret_access_key = test
EOF
```

* useful alias

```
alias awsl='aws --profile localstack'
```

* run

```
docker-compose up -d
```

## terragrunt

* init s3 backend manually

```
./init-s3-backend.sh
```

* never let terragrunt to update bucket, it won't work on localstack! i have no idea why

```
Remote state S3 bucket terragrunt-localstack-us-east-1 is out of date. Would you like Terragrunt to update it? (y/n) n
```

### vpc

* using `terraform-aws-modules/vpc/aws` because it's awesome
* how to get rid of this dumb way to fetch data for module input?
* check vpc peering on both sides

### iam

### eks

* kms key ✅
* Operator Lifecycle Manager
* external-secrets
* external-dns
* cluster-autoscaler 
* argocd
* terraform operator

### databases

* postgres
* redis
* mongodb
* clickhouse

## example microservice app
