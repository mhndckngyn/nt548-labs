# Bài thực hành 01: Dùng Terraform và CloudFormation để quản lý và triển khai tự động hạ tầng AWS

## 1. Các Dịch Vụ Cần Triển Khai

### VPC: Tạo một VPC chứa các thành phần sau (3 điểm):
- **Subnets**:
  - Public Subnet: Kết nối với Internet Gateway.
  - Private Subnet: Sử dụng NAT Gateway để kết nối ra ngoài.
- **Internet Gateway**: Kết nối với Public Subnet để cho phép các tài nguyên bên trong có thể truy cập Internet.
- **Default Security Group**: Tạo Security Group mặc định cho VPC.

### Route Tables: Tạo Route Tables cho Public và Private Subnet (2 điểm):
- **Public Route Table**: Định tuyến lưu lượng Internet thông qua Internet Gateway.
- **Private Route Table**: Định tuyến lưu lượng Internet thông qua NAT Gateway.

### NAT Gateway: Cho phép các tài nguyên trong Private Subnet có thể kết nối Internet mà vẫn bảo đảm tính bảo mật (1 điểm).

### EC2: Tạo các instance trong Public và Private Subnet, đảm bảo Public instance có thể truy cập từ Internet, còn Private instance chỉ có thể truy cập từ Public instance thông qua SSH hoặc các phương thức bảo mật khác (2 điểm).

### Security Groups: Tạo các Security Groups để kiểm soát lưu lượng vào/ra của EC2 instances (2 điểm):
- **Public EC2 Security Group**: Chỉ cho phép kết nối SSH (port 22) từ một IP cụ thể (hoặc IP của người dùng).
- **Private EC2 Security Group**: Cho phép kết nối từ Public EC2 instance thông qua port cần thiết (SSH hoặc các port khác nếu có nhu cầu).

## 2. Yêu Cầu
- Các dịch vụ phải được viết dưới dạng **module**.
- Phải đảm bảo an toàn bảo mật cho EC2 (thiết lập Security Groups).
  
## 3. Kết Quả:
- Báo cáo **Word** (theo mẫu đi kèm).
- Link **GitHub** (source code và file README hướng dẫn cách chạy mã nguồn).

## 4. Lưu Ý:
- Sinh viên cần thường xuyên cập nhật mã nguồn lên GitHub.
- Phải có các **test cases** để kiểm tra từng dịch vụ được triển khai thành công.
