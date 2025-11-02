/**
 * Model đại diện cho một User trong ứng dụng Daily Tracker
 * 
 * User chứa thông tin xác thực và profile của người dùng.
 */
export interface User {
    /** ID duy nhất của user (thường là Firebase UID) */
    id: string;
    
    /** Tên hiển thị của user */
    name: string;
    
    /** Email của user (dùng để đăng nhập) */
    email: string;
    
    /** Password đã được hash (chỉ ở backend, không trả về client) */
    password?: string;
    
    /** URL ảnh đại diện (optional) */
    avatarUrl?: string;
    
    /** Thời gian tạo tài khoản (ISO 8601 string) */
    createdAt: string;
    
    /** Thời gian cập nhật profile lần cuối (ISO 8601 string) */
    updatedAt: string;
    
    /** Số điện thoại (optional) */
    phoneNumber?: string;
    
    /** Trạng thái tài khoản (active, inactive, banned, etc.) */
    status?: string;
}

/**
 * Type cho việc tạo user mới (cần password, không cần id, createdAt, updatedAt)
 */
export type UserCreateInput = Omit<User, 'id' | 'createdAt' | 'updatedAt'> & {
    password: string; // Required khi tạo mới
    createdAt?: string;
    updatedAt?: string;
};

/**
 * Type cho việc cập nhật user (tất cả fields đều optional trừ id, password không bao giờ được update trực tiếp)
 */
export type UserUpdateInput = Partial<Omit<User, 'id' | 'password'>> & {
    id: string;
    updatedAt?: string;
};

/**
 * Type cho user response (không bao gồm password)
 */
export type UserResponse = Omit<User, 'password'>;