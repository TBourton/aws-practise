https://awstip.com/to-set-up-docker-container-inside-ec2-instance-with-terraform-3af5d53e54ba
https://www.middlewareinventory.com/blog/terraform-aws-example-ec2/
https://klotzandrew.com/blog/deploy-an-ec2-to-run-docker-with-terraform


```bash
terraform init
terraform validate
terraform plan
terraform apply
```

SSH to the instance
```bash
ssh ubuntu@instance-public-dns-name
```
The `instance-public-dns-name` should look something like `ec2-xx-xxx-xx-xx.eu-west-2.compute.amazonaws.com`

After done
```bash
terraform destroy
```
