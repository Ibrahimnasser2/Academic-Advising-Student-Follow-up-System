import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:followupst/componants/components.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/student_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';


class AddadvisorDialog extends StatefulWidget {
  const AddadvisorDialog({super.key});

  @override
  State<AddadvisorDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddadvisorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();


  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context)=>GuidanceManagerCubit(),
        child:BlocConsumer<GuidanceManagerCubit,GuidanceManagerState>(
            listener: (context, state){
              if (state is OperationSuccess ) {
                Fluttertoast.showToast(
                  msg: state.message!,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
              if (state is GuidanceManagerError) {
                Fluttertoast.showToast(
                  msg: state.message!,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 5,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            builder:(context, state) {
              GuidanceManagerCubit cubit=GuidanceManagerCubit.get(context);

              return Scaffold(
                body:
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    title: Text(
                      'إضافة مرشد اكاديمي جديد',
                      style: GoogleFonts.tajawal(),
                    ),
                    content: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                labelText: 'اسم المرشد',
                                labelStyle: GoogleFonts.tajawal(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty ) {
                                  return 'الرجاء إدخال اسم المرشد';
                                }
                                return null;
                              },
                            ),

                            TextFormField(
                              controller: _phoneController,
                              decoration: InputDecoration(
                                labelText: 'رقم الجوال',
                                labelStyle: GoogleFonts.tajawal(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال رقم الجوال';
                                }
                                if (value.length<6) {
                                  return ' إدخل رقم الجوال من 6 ارقام او اكثر';
                                }
                                return null;
                              },
                            ),





                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'إلغاء',
                          style: GoogleFonts.tajawal(color: Colors.red),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            cubit.addadvisor(
                              name: _nameController.text,
                              phone: _phoneController.text,
                              email: '${_phoneController.text}@kk.edu.sa',
                              password:'UU${_phoneController.text.substring(_phoneController.text.length - 5)}',
                            );
                            toast(message: "تمت رفع ملف المرشدالاكاديمي بنجاح", state: ToastStates.SUCCESS);



                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'حفظ',
                          style: GoogleFonts.tajawal(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );}



        )
    );
  }
}