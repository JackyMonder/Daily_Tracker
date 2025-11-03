# Docker cho daily_tracker (Flutter)

## Yêu cầu
- Docker Desktop (Windows 10/11)

## Dev: chạy Flutter Web
```bash
# 1) Build image dev (lần đầu hoặc khi thay đổi Dockerfile.dev)
docker compose build flutter

# 2) Chạy server dev ở http://localhost:8080
docker compose up flutter

# 3) Dừng
# Ctrl+C hoặc
# docker compose down
```
- Mã nguồn được mount vào container (hot reload khả dụng với web-server của Flutter).
- Cache pub được lưu ở volume `flutter_pub_cache` để tăng tốc.

## Prod: build web và serve bằng Nginx
```bash
# Build image production (web)
docker build -f Dockerfile.web -t daily-tracker-web:prod .

# Run container
docker run -p 8080:80 --name daily-tracker-web daily-tracker-web:prod

# Mở http://localhost:8080
```

## Lệnh hữu ích
```bash
# Mở shell trong container dev đang chạy
docker exec -it daily_tracker_flutter_dev bash

# Chạy lệnh Flutter bất kỳ
docker compose run --rm flutter bash -lc "flutter test"
```

## Ghi chú
- Nếu dự án có Android/iOS native, các thư mục `android/` và `ios/` đang bị ignore
  khỏi build context để nhẹ hơn. Nếu bạn cần build APK/IPA bằng Docker, hãy bỏ
  các dòng đó khỏi `.dockerignore` và điều chỉnh Dockerfile phù hợp với SDK.
- Trên Windows, cổng phát triển mặc định là `8080` (có thể đổi trong `docker-compose.yml`).

## Chạy trên điện thoại (2 cách)

### 1) Dùng Flutter Web dev server từ điện thoại trong cùng mạng LAN
```bash
docker compose up flutter
```
- Điện thoại và máy tính phải cùng Wi‑Fi.
- Trên điện thoại, mở trình duyệt tới: `http://<IP_may_tinh>:8080`
  - Ví dụ: `http://192.168.1.100:8080`
- Nếu không truy cập được, kiểm tra Windows Firewall và cho phép cổng 8080.

### 2) Cài app Android (APK) lên điện thoại
```bash
# Build APK (artifact sẽ nằm trong thư mục build_artifacts/)
docker compose build android_builder
docker compose run --rm android_builder

# APK sẽ xuất ra:
# build_artifacts/app-release.apk (hoặc app-debug.apk)
```
- Chép file APK sang điện thoại và cài đặt (bật cho phép cài ứng dụng không rõ nguồn gốc).
- Nếu cần ký phát hành, cung cấp keystore và biến ARG trong `Dockerfile.android` (xem comment trong file).

