# nt548-labs

## Lab 1

### Nội dung Lab
- Xem [Lab01.pdf](./lab01/Lab01.pdf)

### Yêu cầu
- Cài đặt [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- Cài đặt [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Cách chạy

1. **Tạo IAM User trên AWS:**
   - Truy cập [IAM Console](https://console.aws.amazon.com/iam/)
   - Tạo một user mới với quyền `AdministratorAccess`
   - Chọn loại truy cập là **Programmatic access** để nhận `Access Key ID` và `Secret Access Key`
   
2. **Thiết lập thông tin AWS với AWS CLI:**
   - Sử dụng câu lệnh `aws configure` và nhập thông tin được yêu cầu
   - Nếu sử dụng Linux hoặc MacOS, bạn có thể  load các biến vào shell session. AWS và Terraform sẽ tự động đọc và sử dụng:
      - Tạo file `.env`
      - Copy từ file [`.env.example`](./lab01/.env.example) và thay thế thông tin của bạn
      - Chạy `source .env`
   - Sau khi thiết lập thông tin AWS, chạy `aws sts get-caller-identity` để kiểm tra kết nối

3. **Triển khai Terraform**
   - Di chuyển đến thư mục lab01 (nếu bạn chưa ở đây): `cd lab01`
   - Khởi tạo Terraform: `terraform init`
   - Xem trước những gì sẽ được tạo: `terraform plan`
   - Triển khai: `terraform apply`