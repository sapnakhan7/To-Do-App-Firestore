import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/UI/ToDo_Screens/HomeScreen.dart';

import '../Utils/Colors.dart';
import 'Auth/SignUp_Screen/SignUp_Screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

      final user = FirebaseAuth.instance.currentUser;
      Future.delayed(const Duration(seconds: 5), () {
        print('user: $user');
        if (user == null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => SignUpScreen()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colors.mainblue,
            colors.maingreen,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Lottie.asset(
          'assets/hello.json',
          width: 330.w,
          height: 330.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
