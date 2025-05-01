import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AddCourseScreen extends StatefulWidget {
  final String studentId; // ID الطالب

  const AddCourseScreen({super.key, required this.studentId});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController courseCodeController = TextEditingController();
  final TextEditingController courseGradeController = TextEditingController();
  final TextEditingController courseHoursController = TextEditingController();

  bool isLoading = false;

  Future<void> addCourse() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final newCourse = {
        'name': courseNameController.text.trim(),
        'code': courseCodeController.text.trim(),
        'grade': double.parse(courseGradeController.text.trim()),
        'hours': int.parse(courseHoursController.text.trim()),
      };

      // إضافة الكورس إلى مصفوفة المواد الحالية
      await FirebaseFirestore.instance.collection('students').doc(widget.studentId).update({
        'courses': FieldValue.arrayUnion([newCourse]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم إضافة المادة بنجاح')),
      );

      Navigator.pop(context); // رجوع بعد إضافة المادة
    } catch (e) {
      print('Error adding course: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء إضافة المادة: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0056B3),
        title: const Text('إضافة مادة جديدة'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: courseNameController,
                decoration: const InputDecoration(labelText: 'اسم المادة'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: courseCodeController,
                decoration: const InputDecoration(labelText: 'رمز المادة'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: courseGradeController,
                decoration: const InputDecoration(labelText: 'درجة المادة'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: courseHoursController,
                decoration: const InputDecoration(labelText: 'عدد الساعات'),
                validator: (value) => value!.isEmpty ? 'مطلوب' : null,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: addCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0056B3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('إضافة المادة', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
