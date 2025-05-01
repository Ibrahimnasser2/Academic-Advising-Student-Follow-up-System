import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:followupst/screens/manger/students/students_list_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/student_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';

class StudentDetailsScreen extends StatefulWidget {
  final StudentModel student;

  const StudentDetailsScreen({super.key, required this.student});

  @override
  State<StudentDetailsScreen> createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  late StudentModel _currentStudent;
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _majorController;
  late TextEditingController _gpaController;
  late TextEditingController _warningsController;
  late TextEditingController _failuresController;

  @override
  void initState() {
    super.initState();
    _currentStudent = widget.student;
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: _currentStudent.name);
    _phoneController = TextEditingController(text: _currentStudent.phone);
    _majorController = TextEditingController(text: _currentStudent.major);
    _gpaController = TextEditingController(text: _currentStudent.gpa.toString());
    _warningsController = TextEditingController(text: _currentStudent.warnings.toString());
    _failuresController = TextEditingController(text: _currentStudent.failures.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _majorController.dispose();
    _gpaController.dispose();
    _warningsController.dispose();
    _failuresController.dispose();
    super.dispose();
  }

  void _updateLocalStudentData(StudentModel updatedStudent) {
    setState(() {
      _currentStudent = updatedStudent;
      _initializeControllers(); // Refresh controllers with new data
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuidanceManagerCubit, GuidanceManagerState>(
      listener: (context, state) {
        if (state is OperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.toString())),
          );
        }
        if (state is GuidanceManagerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.toString())),
          );
        }
      },
      builder: (context, state) {
        final cubit = GuidanceManagerCubit.get(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                'تفاصيل الطالب',
                style: GoogleFonts.tajawal(),
              ),
              backgroundColor: AppColors.primaryColor,
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDetailCard(),
                  const SizedBox(height: 30),
                  _buildActionButtons(context, cubit),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('اسم الطالب', _currentStudent.name),
            _buildDetailRow('الرقم الجامعي', _currentStudent.universityId),
            _buildDetailRow('رقم الجوال', _currentStudent.phone),
            _buildDetailRow('التخصص', _currentStudent.major),
            _buildDetailRow('المعدل التراكمي', _currentStudent.gpa.toStringAsFixed(2)),
            _buildDetailRow('الحالة', _currentStudent.status),
            _buildDetailRow('عدد الإنذارات', _currentStudent.warnings.toString()),
            _buildDetailRow('مرات الرسوب', _currentStudent.failures.toString()),
            _buildDetailRow('المرشد الأكاديمي', _currentStudent.advisoremail),
            const SizedBox(height: 10),
            const Divider(),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.tajawal(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.tajawal(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, GuidanceManagerCubit cubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
          context,
          'تعديل',
          Icons.edit,
          Colors.blue,
              () {
            _showEditDialog(context, cubit);
          },
        ),
        _buildActionButton(
          context,
          'حذف',
          Icons.delete,
          Colors.red,
              () {
            _showDeleteConfirmation(context, cubit);
          },
        ),
        _buildActionButton(
          context,
          'إرسال رسالة',
          Icons.message,
          Colors.green,
              () {
            _showMessageDialog(context);
          },
        ),
      ],
    );
  }

  void _showEditDialog(BuildContext context, GuidanceManagerCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'تعديل بيانات الطالب',
            style: GoogleFonts.tajawal(),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditField('اسم الطالب', _nameController,keyboardType:TextInputType.name ),
                _buildEditField('رقم الجوال', _phoneController,keyboardType:TextInputType.phone ),
                _buildEditField('التخصص', _majorController,keyboardType:TextInputType.name ),
                _buildEditField('المعدل التراكمي', _gpaController, keyboardType: TextInputType.number),
                _buildEditField('عدد الإنذارات', _warningsController, keyboardType: TextInputType.number),
                _buildEditField('مرات الرسوب', _failuresController, keyboardType: TextInputType.number),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: GoogleFonts.tajawal(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () async {
                final updatedStudent = StudentModel(
                  id: _currentStudent.id,
                  name: _nameController.text,
                  universityId: _currentStudent.universityId,
                  phone: _phoneController.text,
                  major: _majorController.text,
                  gpa: double.tryParse(_gpaController.text) ?? _currentStudent.gpa,
                  status: _currentStudent.status,
                  warnings: int.tryParse(_warningsController.text) ?? _currentStudent.warnings,
                  failures: int.tryParse(_failuresController.text) ?? _currentStudent.failures,
                  advisoremail: _currentStudent.advisoremail,
                  email: _currentStudent.email,
                  password: _currentStudent.password,
                );

                await cubit.updateStudent(updatedStudent);
                _updateLocalStudentData(updatedStudent);
                Navigator.pop(context);
              },
              child: Text(
                'حفظ',
                style: GoogleFonts.tajawal(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, GuidanceManagerCubit cubit) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'تأكيد الحذف',
            style: GoogleFonts.tajawal(),
          ),
          content: const Text(
            'هل أنت متأكد من حذف هذا الطالب؟',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: GoogleFonts.tajawal(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                cubit.removeStudent(id: _currentStudent.id, email: _currentStudent.email);
                nav_and_finish(context,StudentsListScreen());
                // Go back to previous screen
              },
              child: Text(
                'حذف',
                style: GoogleFonts.tajawal(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context) {
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(
            'إرسال رسالة',
            style: GoogleFonts.tajawal(),
          ),
          content: TextField(
            controller: messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'أكتب رسالتك هنا...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'إلغاء',
                style: GoogleFonts.tajawal(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                if (messageController.text.isNotEmpty) {
                  // TODO: Implement message sending functionality
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إرسال الرسالة بنجاح')),
                  );
                }
              },
              child: Text(
                'إرسال',
                style: GoogleFonts.tajawal(color: AppColors.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
      BuildContext context,
      String text,
      IconData icon,
      Color color,
      VoidCallback onPressed,
      ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: GoogleFonts.tajawal(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}