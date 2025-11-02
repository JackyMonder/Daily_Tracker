# Hướng dẫn cấu hình Google Sign In để fix lỗi ApiException: 10

## Vấn đề
Lỗi `PlatformException(sign_in_failed, com.google.android.gms.common.api.ApiException: 10)` xảy ra khi Google Sign In chưa được cấu hình đúng.

## Giải pháp

### Bước 1: Lấy SHA-1 fingerprint

Mở terminal/command prompt và chạy lệnh sau:

**Windows:**
```bash
cd %USERPROFILE%\.android
keytool -list -v -keystore debug.keystore -alias androiddebugkey -storepass android -keypass android
```

**macOS/Linux:**
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Sao chép các giá trị **SHA1** và **SHA256** (không bao gồm dấu `:`)

### Bước 2: Thêm SHA-1 vào Firebase Console

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Chọn project: `daily-tracker-55976`
3. Vào **Project Settings** (⚙️ ở sidebar) > **General** tab
4. Scroll xuống phần **Your apps** > Chọn app Android (`com.example.daily_tracker`)
5. Click **Add fingerprint**
6. Thêm **SHA-1** và **SHA-256** đã lấy ở bước 1
7. Click **Save**

### Bước 3: Bật Google Sign-In trong Firebase Authentication

1. Vào **Authentication** > **Sign-in method** trong Firebase Console
2. Click vào **Google** provider
3. Bật **Enable** toggle
4. Nhập **Support email** (bắt buộc)
5. Click **Save**

### Bước 4: Tải lại google-services.json

1. Trong Firebase Console, vào **Project Settings** > **General**
2. Scroll xuống phần **Your apps** > App Android
3. Click nút **Download google-services.json**
4. Thay thế file cũ trong `android/app/google-services.json`
5. **Rebuild app**: `flutter clean && flutter run`

### Bước 5: Kiểm tra google-services.json

Sau khi tải lại, file `google-services.json` phải có `oauth_client` không rỗng:

```json
{
  "client": [
    {
      "client_info": {
        ...
      },
      "oauth_client": [
        {
          "client_id": "...",
          "client_type": 1,
          ...
        },
        {
          "client_id": "...",
          "client_type": 3,
          ...
        }
      ]
    }
  ]
}
```

## Kiểm tra

Sau khi hoàn thành các bước trên:
1. **Rebuild app**: `flutter clean && flutter run`
2. Thử đăng nhập với Google lại
3. Nếu vẫn lỗi, kiểm tra logs trong console để xem chi tiết lỗi

## Lưu ý

- **Debug keystore**: Dùng cho development
- **Release keystore**: Khi build release, cần thêm SHA-1 của release keystore
- **Package name**: Đảm bảo package name trong Firebase Console khớp với `applicationId` trong `build.gradle` (hiện tại: `com.example.daily_tracker`)


