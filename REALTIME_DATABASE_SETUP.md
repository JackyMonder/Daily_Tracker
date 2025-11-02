# Hướng dẫn cấu hình Firebase Realtime Database

## Bước 1: Bật Realtime Database trong Firebase Console

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Chọn project: `daily-tracker-55976`
3. Vào mục **Realtime Database** (hoặc **Build** > **Realtime Database**)
4. Click **Create Database**
5. Chọn location (ví dụ: `asia-southeast1` - gần Việt Nam)
6. Chọn chế độ bảo mật:
   - **Start in test mode** (cho development)
   - Hoặc **Start in locked mode** (cho production - cần cấu hình rules)

## Bước 2: Cấu hình Database Rules

Trong Firebase Console, vào **Realtime Database** > **Rules**, thay thế bằng:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

⚠️ **CẢNH BÁO**: Rules này cho phép đọc/ghi công khai - CHỈ DÙNG CHO DEVELOPMENT!

### Rules an toàn hơn cho Production:

```json
{
  "rules": {
    "users": {
      "$uid": {
        ".read": "$uid === auth.uid",
        ".write": "$uid === auth.uid"
      }
    },
    "test": {
      ".read": true,
      ".write": true
    }
  }
}
```

## Bước 3: Lấy Database URL

1. Vào **Realtime Database** trong Firebase Console
2. Copy **Database URL** (ví dụ: `https://daily-tracker-55976-default-rtdb.asia-southeast1.firebasedatabase.app/`)
3. URL này sẽ được sử dụng trong code nếu cần

## Bước 4: Test kết nối

1. Chạy app: `flutter run`
2. Click nút **"Test Kết Nối Firebase"** trong app
3. Kiểm tra Firebase Console > **Realtime Database** > **Data** để xem dữ liệu test

## Cấu trúc dữ liệu trong Realtime Database

Realtime Database sử dụng JSON tree structure:

```
{
  "test": {
    "connection_test": {
      "timestamp": 1234567890,
      "message": "Test kết nối Firebase thành công",
      "device": "Flutter App",
      "createdAt": 1234567890
    }
  }
}
```

## So sánh với Firestore

| Feature | Realtime Database | Firestore |
|---------|------------------|-----------|
| Cấu trúc | JSON tree | Collections/Documents |
| Query | Limited | Advanced queries |
| Realtime sync | Real-time | Real-time |
| Offline | Supported | Supported |
| Scalability | Better for small-medium | Better for large-scale |

## Lưu ý quan trọng

- Realtime Database KHÔNG cần bật API trong Google Cloud Console (khác với Firestore)
- Realtime Database miễn phí với quota nhất định
- Chỉ cần tạo database và cấu hình rules là có thể sử dụng ngay

