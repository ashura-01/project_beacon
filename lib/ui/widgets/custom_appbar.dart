import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? ontap; 

  const CustomAppBar({
    super.key,
    required this.title,
    this.ontap, 
  });

  @override
  Widget build(BuildContext context) {
    final bool canGoBack = Navigator.canPop(context);

    return AppBar(
      backgroundColor: const Color.fromARGB(255, 0, 12, 53),
      elevation: 0,
      centerTitle: true,

      
      leading:
          canGoBack
              ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              )
              : (ontap != null
                  ? IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: ontap,
                  )
                  : null), 

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
