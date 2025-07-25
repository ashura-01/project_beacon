import 'dart:ui'; // For ImageFilter
import 'package:beacon/ui/utils/assets_path.dart';
import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;

  const ScreenBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          
          Container(
            color: Colors.white,
          ),

         
          Positioned(
            child: Image.asset(
              AssetsPath.logo,
              width: 550,
              fit: BoxFit.contain,
              color: Colors.white24, // fade into background
              colorBlendMode: BlendMode.modulate,   // smooth blend
            ),
          ),

          
          child,
        ],
      ),
    );
  }
}
