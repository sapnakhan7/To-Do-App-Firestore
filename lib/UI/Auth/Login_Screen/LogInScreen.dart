import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/UI/Auth/SignUp_Screen/SignUp_Screen.dart';
import 'package:to_do_app/UI/ToDo_Screens/HomeScreen.dart';
import '../../../Custom_Widgets/CustomButton.dart';
import '../../../Custom_Widgets/TextFormField.dart';
import '../../../Utils/Colors.dart';
import '../../../Utils/toasts.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isloading = false;

  loginFunction() {
    isloading = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      print("Login Successful");
    }
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim())
        .then((v) {
      fluttertoas().showpopup(colors.green, 'login successfully');

      isloading = false;
      setState(() {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    }).onError((error, Stack) {
      fluttertoas().showpopup(colors.red, error.toString());
      isloading = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),
                Container(
                  width: 230.w,
                  height: 230.h,
                  child: Lottie.asset(
                    'assets/hello.json',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.bold,
                    color: colors.black,
                    fontFamily: 'Cursive',
                  ),
                ),
                SizedBox(height: 30.h),
                CustomTextFormField(
                  controller: _emailController,
                  labelText: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: "Password",
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },),
                SizedBox(height: 20.h),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        colors.mainblue,
                        colors.maingreen,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomButton(
                    isloading: isloading,
                    text: 'LogIn',
                    btncolor: Colors.transparent,
                    ontap: loginFunction,
                  ),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "If you don't have an account, Please ",
                      style: TextStyle(fontSize: 12.sp, color: colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        " Sign Up",
                        style: TextStyle(
                          fontSize: 22.sp,
                          color: colors.mainblue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

