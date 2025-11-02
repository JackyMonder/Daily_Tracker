import 'package:flutter/material.dart';

/// Widget hiển thị nút tạo note mới
/// 
/// Lưu ý: Widget này chỉ hiển thị UI, navigation được handle bởi parent
class NewNote extends StatelessWidget {
  const NewNote({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 55,
        height: 55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Gradient background applied only to the circular container
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Color(0xFFF09AA2), Color(0xFF6BB6DF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds),
              child: Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
            // Icon placed above, not affected by ShaderMask
            Icon(
              Icons.create,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
    );
  }
}