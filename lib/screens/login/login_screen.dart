import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:followupst/shared/constant/end_point.dart';
import 'package:followupst/shared/local/cach_helper.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../componants/components.dart';

import '../advisor/advisor_home_screen.dart';
import '../manger/guidance_manager_home_screen.dart';
import 'cubit/login state.dart';
import 'cubit/login_cubit.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String selectedRole = 'الطالب';

  final List<String> roles = [
    'الطالب',
    'المرشد الأكاديمي',
    'مدير وحدة التوجيه',
    'مدير الكلية',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 5,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
          if (state is LoginSuccessState) {

            print(state.uid);
            print("hemaaaaaaaaaaaa");
            token=state.uid;
            selected_Role=selectedRole;

            CacheHelper.saveData(key: 'role', value: selectedRole);
            CacheHelper.saveData(key: 'token', value: state.uid).then((value) {
              _navigateBasedOnRole(context, selectedRole, state.uid);
              // توجيه المستخدم حسب نوعه

            });

          }
        },
        builder: (context, state) {
          var cubit = LoginCubit.get(context);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text(
                          'تسجيل الدخول',
                          style: GoogleFonts.tajawal(
                            fontSize: 20,
                            color: Colors.blue[800],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: DropdownButtonFormField<String>(
                            value: selectedRole,
                            items: roles.map((role) {
                              return DropdownMenuItem(
                                value: role,
                                child: Text(
                                  role,
                                  style: GoogleFonts.tajawal(color: Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              selectedRole = value!;
                            },
                            decoration: InputDecoration(
                              labelText: 'نوع المستخدم',
                              labelStyle: GoogleFonts.tajawal(),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            style: GoogleFonts.tajawal(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: 'البريد الإلكتروني',
                              labelStyle: GoogleFonts.tajawal(),
                              prefixIcon: const Icon(Icons.email),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال البريد الإلكتروني';
                              }
                              if (selectedRole == 'الطالب' &&
                                  !value.endsWith('@student.kk.edu.sa')) {
                                return 'يجب أن ينتهي البريد بـ @student.kk.edu.sa';
                              }
                              if (selectedRole == 'المرشد الأكاديمي' &&
                                  !value.endsWith('@kk.edu.sa')) {
                                return 'يجب أن ينتهي البريد بـ @kk.edu.sa';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextFormField(
                            controller: passwordController,
                            obscureText: cubit.isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'كلمة المرور',
                              labelStyle: GoogleFonts.tajawal(),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.togglePasswordVisibility();
                                },
                                icon: Icon(cubit.suffixIcon),
                              ),
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(height: 30),
                        ConditionalBuilder(
                          condition: state is! LoginLoadingState,
                          builder: (context) => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.userLogin(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                    role: selectedRole,
                                  );
                                }
                              },
                              child: Text(
                                'تسجيل الدخول',
                                style: GoogleFonts.tajawal(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(height: 20),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _navigateBasedOnRole(BuildContext context, String role, String uid) {
    switch (role) {
      case 'الطالب':
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => StudentHomeScreen()),
      // );
        break;
      case 'المرشد الأكاديمي':
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => AdvisorHomeScreen()),
      // );
        break;
      case 'مدير وحدة التوجيه':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GuidanceManagerHomeScreen()),
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
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
    }
  }

}