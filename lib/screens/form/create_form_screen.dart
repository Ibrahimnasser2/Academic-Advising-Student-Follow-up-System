import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateFormScreen extends StatefulWidget {
  final String advisorId; // رقم حساب المرشد الأكاديمي

  const CreateFormScreen({Key? key, required this.advisorId}) : super(key: key);

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final formTitle = _titleController.text.trim();
    final options = _optionControllers.map((c) => c.text.trim()).where((text) => text.isNotEmpty).toList();

    if (options.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('أضف على الأقل خيارين.')));
      setState(() => _isLoading = false);
      return;
    }

    final formDoc = await FirebaseFirestore.instance.collection('forms').add({
      'advisorId': widget.advisorId,
      'title': formTitle,
      'options': options,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // (اختياري) إرسال إشعارات للطلبة (سنكملها بعدين لو تحب)

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إنشاء النموذج بنجاح.')));

    Navigator.pop(context); // العودة للخلف
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء نموذج جديد'),
        backgroundColor: const Color(0xFF0056B3),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'عنوان النموذج',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'برجاء إدخال عنوان النموذج' : null,
              ),
              const SizedBox(height: 20),
              const Text('الخيارات:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ..._optionControllers.map((controller) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: 'خيار',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'برجاء إدخال نص الخيار' : null,
                ),
              )),
              TextButton.icon(
                onPressed: _addOption,
                icon: const Icon(Icons.add, color: Color(0xFF0056B3)),
                label: const Text('إضافة خيار جديد', style: TextStyle(color: Color(0xFF0056B3))),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056B3),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _submitForm,
                child: const Text('إنشاء النموذج', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
