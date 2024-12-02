import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:to_do_app/UI/Auth/Login_Screen/LogInScreen.dart';
import 'package:to_do_app/UI/ToDo_Screens/AddTaskScreen.dart';
import 'package:to_do_app/UI/ToDo_Screens/UpdateTaskScreen.dart';

import '../../Utils/Colors.dart';
import '../../Utils/toasts.dart';
import 'ProfileScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseDatabase.instance.ref('todo');
  TextEditingController searchcontroller = TextEditingController();
  final database = FirebaseDatabase.instance
      .ref('todo')
      .orderByChild('uid')
      .equalTo(FirebaseAuth.instance.currentUser!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Align(
            alignment: Alignment.topRight, child: Image.asset('assets/1.png')),
        backgroundColor: colors.mainblue,
        title: const Text(
          'Home Screen',
          style: TextStyle(
            fontFamily: 'Cursive',
            color: colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions:[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Profile()));
            },
            icon: const Icon(Icons.person,color: colors.white,),
          ),
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((v) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  LoginScreen()));
              });
            },
            icon: const Icon(Icons.logout,color: colors.white,),
          ),


          IconButton(
            onPressed: () {
              FirebaseAuth.instance.currentUser!.delete().then((v) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>  LoginScreen()));
              });
            },
            icon: const Icon(Icons.delete,color: colors.white,),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTask()));
        },
        backgroundColor: colors.maingreen,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          SizedBox(height: 10.h),
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
            child: Column(
              children: [
                SizedBox(height: 20.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: TextField(
                    controller: searchcontroller,
                    onChanged: (v) {
                      setState(() {});
                    },
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search task',
                      hintStyle: TextStyle(fontSize: 16, color: colors.white),
                      fillColor: colors.mainblue.withOpacity(.8),
                      filled: true,
                      // enabledBorder: InputBorder.none,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Lottie.asset(
                  'assets/hello.json',
                  width: 150.w,
                  height: 150.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 5.h),

                Container(
                  decoration: BoxDecoration(
                    color: colors.mainblue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding:
                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  child: Text(
                    'ALL TASKS',
                    style: TextStyle(
                      color: colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Tasks List
                Expanded(
                  child: FirebaseAnimatedList(
                    query: db,
                    itemBuilder: (context, snapshot, animation, index) {
                      if (snapshot
                          .child('title')
                          .value
                          .toString()
                          .contains(searchcontroller.text.toString())) {
                        return Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.black,
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.child('title').value}',
                                            style: const TextStyle(
                                              color: colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            '${snapshot.child('description').value}',
                                            style: const TextStyle(
                                              color: colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateTaskScreen(
                                                          title: snapshot
                                                              .child('title')
                                                              .value,
                                                          description: snapshot
                                                              .child('description')
                                                              .value,
                                                          id: snapshot
                                                              .child('id')
                                                              .value,
                                                        )));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.purpleAccent,
                                          )),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            print('this is key ${snapshot.key}');
                                            db
                                                .child(snapshot.key!)
                                                .remove()
                                                .then((v) {
                                              fluttertoas().showpopup(
                                                  colors.green, 'task deleted');
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else if (searchcontroller.text.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.all(4.w),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.black,
                                width: 1.5.w,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Card(
                              color: Colors.transparent,
                              elevation: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 80.h,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${snapshot.child('title').value}',
                                            style: const TextStyle(
                                              color: colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                            '${snapshot.child('description').value}',
                                            style: const TextStyle(
                                              color: colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateTaskScreen(
                                                          title: snapshot
                                                              .child('title')
                                                              .value,
                                                          description: snapshot
                                                              .child('description')
                                                              .value,
                                                          id: snapshot
                                                              .child('id')
                                                              .value,
                                                        )));
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: Colors.purpleAccent,
                                          )),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            print('this is key ${snapshot.key}');
                                            db
                                                .child(snapshot.key!)
                                                .remove()
                                                .then((v) {
                                              fluttertoas().showpopup(
                                                  colors.green, 'task deleted');
                                            });
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          )),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }


                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
