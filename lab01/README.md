# Lab 1

## Nội dung Lab

- Xem [Lab01.pdf](./lab01/Lab01.pdf)

## Hướng dẫn chạy

### Yêu cầu

- Cài đặt [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Cài đặt [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Thiết lập trước khi triển khai

1. **Tạo IAM User trên AWS:**

   - Truy cập [IAM Console](https://console.aws.amazon.com/iam/)
   - Tạo một user mới với quyền `AdministratorAccess`
   - Chọn loại truy cập là **Programmatic access** để nhận `Access Key ID` và `Secret Access Key`

2. **Thiết lập Key Pair:**
   - Truy cập AWS EC2 Console và chọn mục `Key pairs`
   - Tạo key pair với các thông tin sau:
     - Name: `lab01-keypair`
     - Key pair type: `RSA`
     - Private key file format: `.pem`
   - File `lab01-keypair.pem` sẽ được tải về. Copy file vào thư mục `cloudformation` và `terraform`.

### **Triển khai bằng Terraform**

- Di chuyển đến thư mục: `cd terraform`
- Nhập thông tin AWS vào file `secrets.tfvars`
- Khởi tạo Terraform: `terraform init`
- Xem trước những gì sẽ được tạo: `terraform plan -out=plan.tfplan`
- Triển khai: `terraform apply "plan.tfplan"`

### **Triển khai bằng CloudFormation**

- Trước tiên, tạo một Bucket S3
- Di chuyển đến thư mục: `cd cloudformation`
- Thiết lập thông tin AWS bằng cách chạy lệnh `aws configure`, sau đó kiểm tra kết nối thông qua lệnh `aws sts get-caller-identity`
- Chạy lệnh package:

```bash
aws cloudformation package \
  --template-file main.yaml \
  --s3-bucket <TÊN_BUCKET_S3> \
  --output-template-file packaged.yaml
```

- Sau khi chạy xong, các file module template sẽ được upload lên S3 bucket. File `packaged.yaml` mới được tạo sẽ reference các file template này
- Chạy tiếp lệnh deploy để triển khai:

```bash
aws cloudformation deploy \
  --template-file packaged.yaml \
  --stack-name lab01-main-stack \
  --capabilities CAPABILITY_NAMED_IAM \
```

### SSH vào Public EC2

- Tìm Public IP của Public EC2 instance thông qua AWS Console
- Chạy lệnh sau để SSH:

```bash
ssh -i lab01-keypair ec2-user@<EC2_PUBLIC_IP>
```

### SSH vào Private EC2 thông qua Public EC2

- Copy file `lab01-keypair` vào Public instance:

```bash
scp -i lab01-keypair.pem lab01-keypair.pem ec2-user@<EC2_PUBLIC_IP>:~/
```

- Tìm Private IP của Private EC2 instance thông qua AWS Console
- Chạy lệnh sau để SSH:

```bash
ssh -i lab01-keypair ec2-user@<EC2_PRIVATE_IP>
```
