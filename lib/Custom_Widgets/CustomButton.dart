import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../Utils/Colors.dart';
class CustomButton extends StatelessWidget {
  final String text;
  final Color btncolor;
  final VoidCallback ontap;
  final isloading;

  CustomButton({
    required this.text,
    required this.btncolor,
    required this.ontap,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 40.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: btncolor, borderRadius: BorderRadius.circular(10.r)),
        child: isloading
            ? Center(
            child: Container(
                height: 35.h,
                width: 40.w,
                child: CircularProgressIndicator(
                  color: colors.green,
                )))
            : Center(
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
