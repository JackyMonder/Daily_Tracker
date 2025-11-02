/**
 * Model đại diện cho một Note trong ứng dụng Daily Tracker
 * 
 * Note chứa thông tin về tiêu đề, nội dung và các thông tin metadata
 * như thời gian tạo, cập nhật và người sở hữu.
 */
export interface Note {
    /** ID duy nhất của note (thường từ Firebase) */
    id: string;
    
    /** Tiêu đề của note */
    title: string;
    
    /** Nội dung chi tiết của note */
    content: string;
    
    /** ID của user sở hữu note này (optional để hỗ trợ multi-user) */
    userId?: string;
    
    /** Thời gian tạo note (ISO 8601 string) */
    createdAt: string;
    
    /** Thời gian cập nhật lần cuối (ISO 8601 string) */
    updatedAt: string;
    
    /** Màu sắc của note (optional - để hỗ trợ màu sắc tùy chỉnh) */
    colorValue?: number;
    
    /** Trạng thái đã xóa hay chưa (soft delete) */
    isDeleted?: boolean;
}

/**
 * Type cho việc tạo note mới (không cần id, createdAt, updatedAt)
 */
export type NoteCreateInput = Omit<Note, 'id' | 'createdAt' | 'updatedAt'> & {
    createdAt?: string;
    updatedAt?: string;
};

/**
 * Type cho việc cập nhật note (tất cả fields đều optional trừ id)
 */
export type NoteUpdateInput = Partial<Omit<Note, 'id'>> & {
    id: string;
    updatedAt?: string;
};