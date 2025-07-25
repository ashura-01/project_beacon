import 'package:flutter/material.dart';

class ServiceButton extends StatelessWidget {
  final VoidCallback onTap;     // required: what happens on tap
  final String title;           // required: the title below the image
  final String imagePath;       // required: path to image asset

  const ServiceButton({
    Key? key,
    required this.onTap,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        width: 200,
        height: 90,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const  Color.fromARGB(255, 0, 12, 53), // Dark blue background
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color.fromARGB(255, 0, 6, 27), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           
            SizedBox(
              height: 70,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 20),
           
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
