# 🔒 Hướng dẫn Firebase Security Rules

Tài liệu này giải thích các Firebase Security Rules đã được cấu hình cho dự án Daily Tracker.

## 📋 Tổng quan

Dự án sử dụng **Firebase Realtime Database** để lưu trữ:
- **Users**: Profile của người dùng (`users/{uid}`)
- **Notes**: Ghi chú của người dùng (`notes/{noteId}`)
- **Test**: Path để test kết nối (development only)

## 🔐 Firebase Realtime Database Rules

File: `database.rules.json`

### Cấu trúc Rules

```json
{
  "rules": {
    "users": { ... },      // Rules cho user profiles
    "notes": { ... },      // Rules cho notes
    "test": { ... },       // Rules cho testing
    ".read": false,        // Mặc định: không cho phép đọc
    ".write": false        // Mặc định: không cho phép ghi
  }
}
```

### 1. Users Rules (`users/{uid}`)

**Mục đích**: Chỉ cho phép user đọc/ghi profile của chính họ.

**Rules**:
- ✅ **Đọc**: Chỉ khi `uid === auth.uid` (user chỉ đọc được profile của mình)
- ✅ **Ghi**: Chỉ khi `uid === auth.uid` (user chỉ ghi được profile của mình)
- ✅ **Validate**: 
  - Phải có các fields: `name`, `email`, `createdAt`, `updatedAt`
  - `id` phải trùng với `uid`
  - `email` phải đúng format email
  - **KHÔNG** được chứa field `password` (bảo mật)

**Ví dụ**:
```
✅ Được phép:
- User A đọc/ghi /users/userA_id
- User B đọc/ghi /users/userB_id

❌ Không được phép:
- User A đọc/ghi /users/userB_id
- User B đọc/ghi /users/userA_id
```

### 2. Notes Rules (`notes/{noteId}`)

**Mục đích**: Chỉ cho phép user đọc/ghi notes của chính họ.

**Rules**:
- ✅ **Đọc từng note**: Chỉ khi `note.userId === auth.uid` hoặc `note.userId == null` (backward compatibility)
- ✅ **Đọc collection**: Cho phép user đã đăng nhập đọc collection để filter client-side
- ✅ **Ghi từng note**: 
  - Chỉ khi `note.userId === auth.uid`
  - Khi tạo mới, `newData.userId` phải trùng với `auth.uid`
- ✅ **Validate**:
  - Phải có các fields: `title`, `content`, `createdAt`, `updatedAt`
  - `userId` phải trùng với `auth.uid`
  - `title` không được rỗng và tối đa 500 ký tự
  - `isDeleted` phải là boolean

**Lưu ý quan trọng**:
- Code đọc toàn bộ `/notes` collection rồi filter client-side theo `userId`
- Rules cho phép đọc collection nhưng Firebase sẽ tự động filter chỉ trả về notes mà user có quyền đọc
- Điều này đảm bảo dù có đọc cả collection, user vẫn chỉ thấy notes của mình

**Ví dụ**:
```
✅ Được phép:
- User A tạo note với userId = userA_id
- User A đọc/ghi note có userId = userA_id
- User A đọc collection /notes (nhưng chỉ thấy notes của mình)

❌ Không được phép:
- User A tạo note với userId = userB_id
- User A đọc/ghi note có userId = userB_id
- User chưa đăng nhập đọc/ghi notes
```

### 3. Test Rules (`test`)

**Mục đích**: Path để test kết nối Firebase (development/testing).

**Rules**:
- ✅ **Đọc**: Cho phép tất cả (không cần authentication)
- ✅ **Ghi**: Cho phép tất cả (không cần authentication)

**⚠️ Cảnh báo**: 
- Rules này cho phép truy cập công khai
- **Nên xóa hoặc bảo mật trong production**
- Chỉ dùng cho development/testing

### 4. Default Rules

- ❌ **Đọc mặc định**: `false` (không cho phép)
- ❌ **Ghi mặc định**: `false` (không cho phép)

Đảm bảo chỉ các path được khai báo cụ thể mới được truy cập.

## 🔥 Firestore Rules

File: `firestore.rules`

**Lưu ý**: Hiện tại dự án chủ yếu sử dụng Realtime Database. Rules cho Firestore được cung cấp để tương lai có thể migrate hoặc sử dụng song song.

### Cấu trúc tương tự Realtime Database:

1. **Users Collection**: Chỉ user mới đọc/ghi được profile của mình
2. **Notes Collection**: Chỉ user mới đọc/ghi được notes của mình
3. **Validation**: Kiểm tra đầy đủ dữ liệu và quyền truy cập

## 🚀 Cách triển khai Rules

### 1. Realtime Database Rules

**Cách 1: Qua Firebase Console (Khuyến nghị)**
1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Chọn project: `daily-tracker-55976`
3. Vào **Realtime Database** > **Rules**
4. Copy nội dung từ `database.rules.json`
5. Paste vào editor
6. Click **Publish**

**Cách 2: Qua Firebase CLI**
```bash
# Cài đặt Firebase CLI (nếu chưa có)
npm install -g firebase-tools

# Login
firebase login

# Deploy rules
firebase deploy --only database:rules
```

### 2. Firestore Rules

**Cách 1: Qua Firebase Console**
1. Vào **Firestore Database** > **Rules**
2. Copy nội dung từ `firestore.rules`
3. Paste vào editor
4. Click **Publish**

**Cách 2: Qua Firebase CLI**
```bash
firebase deploy --only firestore:rules
```

## ✅ Kiểm tra Rules

### 1. Rules Simulator (Firebase Console)

1. Vào **Realtime Database** > **Rules** > **Rules playground**
2. Test các scenarios:
   - User đọc profile của mình
   - User đọc profile của user khác (nên fail)
   - User tạo note với userId của mình
   - User tạo note với userId của user khác (nên fail)

### 2. Test trong App

1. Đăng nhập với user A
2. Tạo note → ✅ Thành công
3. Thử đọc notes → Chỉ thấy notes của user A
4. Logout và đăng nhập với user B
5. Tạo note → ✅ Thành công
6. Thử đọc notes → Chỉ thấy notes của user B (không thấy notes của user A)

## 🔒 Best Practices

1. **Luôn validate dữ liệu**: Rules validate format email, độ dài title, etc.
2. **Không lưu password**: Rules chặn việc lưu password trong database
3. **Kiểm tra authentication**: Tất cả operations đều yêu cầu `auth != null`
4. **Kiểm tra ownership**: User chỉ có thể thao tác với dữ liệu của mình
5. **Default deny**: Mặc định không cho phép, chỉ cho phép những gì cần thiết

## ⚠️ Lưu ý quan trọng

1. **Rules hiện tại cho phép đọc collection `/notes`**: 
   - Điều này cần thiết vì code đọc toàn bộ rồi filter client-side
   - Firebase sẽ tự động filter chỉ trả về notes mà user có quyền
   - Tuy nhiên, có thể tối ưu bằng cách đổi sang query theo userId ở code level

2. **Test path công khai**:
   - Path `/test` cho phép truy cập công khai
   - **Nên xóa hoặc bảo mật trong production**

3. **Backward compatibility**:
   - Rules cho phép đọc notes có `userId == null` để tương thích với data cũ
   - Nên migrate data cũ để set userId cho tất cả notes

## 📚 Tài liệu tham khảo

- [Firebase Realtime Database Security Rules](https://firebase.google.com/docs/database/security)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Rules Testing](https://firebase.google.com/docs/database/security/test-rules)

---

**Tác giả**: Auto-generated  
**Cập nhật**: 2025-01-02

