import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/student_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';
import '../guidance_manager_home_screen.dart';
import 'student_details.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  @override
  void initState() {
    super.initState();
    // Load students when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      GuidanceManagerCubit.get(context).loadStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuidanceManagerCubit, GuidanceManagerState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const GuidanceManagerHomeScreen(),
                    ),
                  );
                },
              ),
              title: Text(
                'عرض الطلاب',
                style: GoogleFonts.tajawal(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: AppColors.primaryColor,
              centerTitle: true,
            ),
            body: _buildBody(context, state),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, GuidanceManagerState state) {
    if (state is GuidanceManagerLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final cubit = GuidanceManagerCubit.get(context);
    final students = cubit.allStudentsData;

    if (students.isEmpty) {
      return Center(
        child: Text(
          'لا توجد بيانات طلاب متاحة',
          style: GoogleFonts.tajawal(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await cubit.loadStudents();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: students.length,
        itemBuilder: (context, index) {
          final student = students[index];
          return _buildStudentItem(context, student);
        },
      ),
    );
  }

  Widget _buildStudentItem(BuildContext context, StudentModel student) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => StudentDetailsScreen(student: student)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryColor,
                child: const Icon(
                  Icons.person_outline,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: GoogleFonts.tajawal(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'الرقم الجامعي: ',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          student.universityId,
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}