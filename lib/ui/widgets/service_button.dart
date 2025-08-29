import 'package:flutter/material.dart';


class ServiceButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final String imagePath;

  const ServiceButton({
    super.key,
    required this.onTap,
    required this.title,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    
    double buttonWidth = (screenWidth / 2) - 24; 
    double buttonHeight = buttonWidth * 0.45;    

   
    double scale = buttonWidth / 180;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonWidth,
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: 10 * scale, vertical: 8 * scale),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 0, 12, 53),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 6, 27),
            width: 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 28 * scale,
              width: 28 * scale,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 8 * scale),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15 * scale,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class ServiceButton extends StatelessWidget {
//   final VoidCallback onTap;
//   final String title;
//   final String imagePath;

//   const ServiceButton({
//     Key? key,
//     required this.onTap,
//     required this.title,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Screen width
//     double screenWidth = MediaQuery.of(context).size.width;

//     // Calculate button width (2 per row, including spacing and padding)
//     double buttonWidth = (screenWidth / 2) - 30;

//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: buttonWidth,
//         height: 80,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: const Color.fromARGB(255, 0, 12, 53),
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: const Color.fromARGB(255, 0, 6, 27),
//             width: 2,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               imagePath,
//               height: 36,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(width: 8),
//             Flexible(
//               child: Text(
//                 title,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 16,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';

// class ServiceButton extends StatelessWidget {
//   final VoidCallback onTap;    
//   final String title;           
//   final String imagePath;       

//   const ServiceButton({
//     Key? key,
//     required this.onTap,
//     required this.title,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,

//       child: Container(
//         width: 168,
//         height: 70,
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: const  Color.fromARGB(255, 0, 12, 53), // Dark blue background
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(color: const Color.fromARGB(255, 0, 6, 27), width: 2),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
           
//             SizedBox(
//               height: 70,
//               child: Image.asset(
//                 imagePath,
//                 fit: BoxFit.contain,
//               ),
//             ),

//             const SizedBox(width: 5),
           
//             Text(
//               title,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 16,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
