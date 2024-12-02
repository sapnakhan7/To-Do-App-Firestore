import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../Custom_Widgets/CustomButton.dart';
import '../../Utils/Colors.dart';
import '../../Utils/toasts.dart';

class AddTask extends StatefulWidget {
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final database = FirebaseDatabase.instance.ref('todo');

  bool isdataadded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.mainblue,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios,color: Colors.white,)),
        title: const Text(
          'Add Task Screen',
          style: TextStyle(
            fontFamily: 'Cursive',
            color: colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      backgroundColor: Colors.amber.withOpacity(.9),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colors.maingreen,
                  colors.mainblue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Foreground Content
          Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  // Lottie Animation
                  Lottie.asset(
                    'assets/hello.json',
                    width: 150.w,
                    height: 150.h,
                    fit: BoxFit.contain,
                  ),
              Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Please Add Task',
                            style: TextStyle(
                              fontFamily: 'Cursive',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colors.white,
                            )),
                        SizedBox(height: 20.h),
                        TextField(
                          controller: titleController,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Title',
                            hintStyle: TextStyle(fontSize: 16),
                            fillColor: colors.white,
                            filled: true,
                            enabledBorder: InputBorder.none,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TextField(
                          controller: descriptionController,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            hintStyle: TextStyle(fontSize: 16),
                            fillColor: colors.white,
                            filled: true,
                            enabledBorder: InputBorder.none,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        CustomButton(
                            isloading: isdataadded,
                            text: 'Add Task',
                            btncolor: colors.mainblue,
                            ontap: () {
                              print(
                                  'this is titla data ${titleController.text.trim().toString()}');
                              print(
                                  'this is description data ${descriptionController.text.trim().toString()}');
                              if (titleController.text.isEmpty) {
                                fluttertoas().showpopup(
                                    colors.red, 'please enter title of task');
                              } else if (descriptionController.text.isEmpty) {
                                fluttertoas().showpopup(
                                    colors.red, 'please enter description of task');
                              } else {
                                isdataadded = true;
                                setState(() {});
                                String id =
                                DateTime.now().microsecondsSinceEpoch.toString();
                                database.child(id).set({
                                  'title': titleController.text.trim().toString(),
                                  'description':
                                  descriptionController.text.trim().toString(),
                                  'id': id,
                                  'uid': FirebaseAuth.instance.currentUser!.uid,
                                }).then((v) {
                                  fluttertoas().showpopup(
                                      colors.green, 'Task Added successfully');
                                  titleController.clear();
                                  descriptionController.clear();
                                  isdataadded = false;
                                  setState(() {});
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                }).onError((error, v) {
                                  isdataadded = false;
                                  setState(() {});
                                  fluttertoas()
                                      .showpopup(colors.red, 'Error $error');
                                });
                              }
                            }),
                      ],
                    ),
                  ),
                ),
              
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}