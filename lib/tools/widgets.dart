import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF4169E1); // أزرق ملكي
  static const Color secondaryColor = Color(0xFF003366);
  static const Color accentColor = Color(0xFF6699CC);
  static const Color textColor = Color(0xFF333333);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
}


void nav_and_finish(context, newRoute)=>Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context)=>newRoute), (route) => false);

void navigate_to(context,widget){
  Navigator.push(
      context, MaterialPageRoute(builder: (context)=>widget)

  );
}