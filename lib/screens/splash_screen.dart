// splash_screen.dart
import 'package:flutter/material.dart';
import 'package:followupst/screens/advisor/advisor_home_screen.dart';
import 'package:followupst/screens/login/login_screen.dart';
import 'package:followupst/screens/manger/guidance_manager_home_screen.dart';

import 'package:followupst/shared/constant/end_point.dart';
import 'package:followupst/shared/local/cach_helper.dart';
import 'package:followupst/tools/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeCacheAndCheckLogin();
  }

  Future<void> _initializeCacheAndCheckLogin() async {
    await CacheHelper.init(); // Initialize SharedPreferences
    Future.delayed(const Duration(seconds: 2), _checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    try {
       token = CacheHelper.getData(key: "token");
       selected_Role = CacheHelper.getData(key: "role");
       print(token);
       print(selected_Role);


      if (token == null || selected_Role == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()),
        );
      } else {
        NavigationHelper.navigateBasedOnRole(context, selected_Role);
      }
    } catch (e) {
      // Fallback to login screen if any error occurs
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school,
              size: 100,
              color: const Color(0xFF4169E1),
            ),
            const SizedBox(height: 20),
            CircularProgressIndicator(
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationHelper {
  static void navigateBasedOnRole(BuildContext context, dynamic role) {
    // Convert role to String if it's not null
    final roleString = role?.toString();

    switch (roleString) {
      case 'الطالب':
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => StudentHomeScreen()),
      // );
        break;
      case 'المرشد الأكاديمي':
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const AdvisorHomeScreen()),
        // );
        break;
      case 'مدير وحدة التوجيه':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const GuidanceManagerHomeScreen()),
        );
        break;
      case 'مدير الكلية':
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => DeanHomeScreen()),
      // );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  LoginScreen()),
        );
    }
  }
}