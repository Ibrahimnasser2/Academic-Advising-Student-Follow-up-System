import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/student_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';

class AddStudentDialog extends StatefulWidget {
  const AddStudentDialog({super.key});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _universityIdController = TextEditingController();
  final _phoneController = TextEditingController();
  final _majorController = TextEditingController();
  final _gpaController = TextEditingController();
  final _statusController = TextEditingController(text: 'منتظم');
  final _warningsController = TextEditingController();
  final _failuresController = TextEditingController();
  final _advisorIdController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _universityIdController.dispose();
    _phoneController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    _statusController.dispose();
    _warningsController.dispose();
    _failuresController.dispose();
    _advisorIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GuidanceManagerCubit(),
      child: BlocConsumer<GuidanceManagerCubit, GuidanceManagerState>(
        listener: (context, state) {
          if (state is OperationSuccess) {
            setState(() => _isLoading = false);
            Fluttertoast.showToast(
              msg: state.message!,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
            Navigator.pop(context);
          }
          if (state is GuidanceManagerError) {
            setState(() => _isLoading = false);
            Fluttertoast.showToast(
              msg: state.message!,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
          }
        },
        builder: (context, state) {
          final cubit = GuidanceManagerCubit.get(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text(
                'إضافة طالب جديد',
                style: GoogleFonts.tajawal(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildTextField(
                        controller: _nameController,
                        label: 'اسم الطالب',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال اسم الطالب';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _universityIdController,
                        label: 'الرقم الجامعي',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال الرقم الجامعي';
                          }

                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _phoneController,
                        label: 'رقم الجوال',
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الجوال';
                          }
                          if (value.length < 9) {
                            return 'يجب أن يتكون رقم الجوال من 9 أرقام على الأقل';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _majorController,
                        label: 'التخصص',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال التخصص';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _gpaController,
                        label: 'المعدل التراكمي',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال المعدل التراكمي';
                          }
                          final gpa = double.tryParse(value);
                          if (gpa == null || gpa < 0 || gpa > 5) {
                            return 'يجب أن يكون المعدل بين 0 و 5';
                          }
                          return null;
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: _statusController.text,
                        items: ['منتظم', 'غير منتظم', 'مفصول'].map((status) {
                          return DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          );
                        }).toList(),
                        onChanged: (value) {
                          _statusController.text = value!;
                        },
                        decoration: InputDecoration(
                          labelText: 'حالة الطالب',
                          labelStyle: GoogleFonts.tajawal(),
                        ),
                      ),
                      _buildTextField(
                        controller: _warningsController,
                        label: 'عدد الإنذارات',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال عدد الإنذارات';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        controller: _failuresController,
                        label: 'عدد مرات الرسوب',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال عدد مرات الرسوب';
                          }
                          return null;
                        },
                      ),
                      _buildTextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: _advisorIdController,
                        label: 'المرشد الأكاديمي',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال المرشد الأكاديمي';
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
                  onPressed: _isLoading ? null : () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: GoogleFonts.tajawal(color: Colors.red),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => _isLoading = true);
                      await cubit.addStudent(
                        name: _nameController.text,
                        universityId: _universityIdController.text,
                        phone: _phoneController.text,
                        major: _majorController.text,
                        gpa: double.parse(_gpaController.text),
                        status: _statusController.text,
                        warnings: int.parse(_warningsController.text),
                        failures: int.parse(_failuresController.text),
                        advisoremail: _advisorIdController.text,
                        email:
                        '${_universityIdController.text}@student.kk.edu.sa',
                        password:
                        'KK${_universityIdController.text.substring(_universityIdController.text.length - 5)}',
                      );
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                    'حفظ',
                    style: GoogleFonts.tajawal(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.tajawal(),
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: validator,
      ),
    );
  }
}