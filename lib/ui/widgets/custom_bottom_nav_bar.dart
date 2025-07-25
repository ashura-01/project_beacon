import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: const Color(0xFF0A0F2C), // matches your dark theme
      shape: const CircularNotchedRectangle(),
      elevation: 12,
      notchMargin: 10,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Left: Location icon
            IconButton(
              icon: Icon(
                Icons.location_on,
                color: currentIndex == 0 ? Colors.white : Colors.white54,
              ),
              onPressed: () => onTap(0),
            ),

            // Spacer for center FAB (home icon)
            const SizedBox(width: 40),

            // Right: Messaging icon
            IconButton(
              icon: Icon(
                Icons.message,
                color: currentIndex == 2 ? Colors.white : Colors.white54,
              ),
              onPressed: () => onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}
