// // Missing Search Methods

// import 'package:flutter/material.dart';

// class Searchbar extends StatelessWidget {
//   const Searchbar({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ShaderMask(shaderCallback: (bounds) => LinearGradient(
//         colors: [Color(0xFFF09AA2),
//           Color(0xFF6BB6DF)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ).createShader(bounds),
//         child: Container(
//           margin: EdgeInsets.symmetric(vertical: 8),
//           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//           decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//             border: Border.all(
//               color: Colors.white,
//               width: 1,
//             ),
//           ),
//           child: Row (children: [
//             Icon(
//               Icons.search,
//               color: Colors.white,
//               size: 28,
//             ),
//             Expanded(
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: 'Search Notes',                  
//                   hintStyle: TextStyle(fontSize: 20, color: Colors.grey[200]),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 10),
//                 ),
//               ),
//             ),
//           ],)
//         )
//       ),
//     );
//   }
// }