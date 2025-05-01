import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/student_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';


class ReportsScreen extends StatelessWidget {
  final String uid;

  const ReportsScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuidanceManagerCubit()..loadStudents(),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'تقارير الطلاب',
              style: GoogleFonts.tajawal(),
            ),
            backgroundColor: AppColors.primaryColor,
          ),
          body: Directionality(textDirection: TextDirection.ltr,
              child: const ReportsContent()),
        ),
      ),
    );
  }
}

class ReportsContent extends StatelessWidget {
  const ReportsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Basic Reports Section
          const ReportSectionHeader(title: 'التقارير الأساسية'),
          const SizedBox(height: 8),
          ReportButton(
            title: 'الطلاب ذوو المعدل التراكمي ≤ 2.15',
            icon: Icons.school,
            reportType: 'low_gpa',
          ),
          const SizedBox(height: 16),
          ReportButton(
            title: 'الطلاب الذين رسبوا مرة أو أكثر',
            icon: Icons.warning,
            reportType: 'failures',
          ),
          const SizedBox(height: 16),
          ReportButton(
            title: 'الطلاب الذين لديهم إنذار أو أكثر',
            icon: Icons.notification_important,
            reportType: 'warnings',
          ),

          // Additional Reports Section
          const SizedBox(height: 24),
          const ReportSectionHeader(title: 'تقارير إضافية'),
          const SizedBox(height: 8),
          ReportButton(
            title: 'إحصائيات الطلاب',
            icon: Icons.people,
            reportType: 'students_stats',
          ),
          const SizedBox(height: 16),
          ReportButton(
            title: 'الطلاب حسب المرشدين',
            icon: Icons.supervisor_account,
            reportType: 'students_by_advisors',
          ),

          // Results Section
          const SizedBox(height: 24),
          const Expanded(child: ReportResultsDisplay()),
        ],
      ),
    );
  }
}

class ReportSectionHeader extends StatelessWidget {
  final String title;

  const ReportSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.tajawal(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class ReportButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final String reportType;

  const ReportButton({
    super.key,
    required this.title,
    required this.icon,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        context.read<GuidanceManagerCubit>().generateReport(reportType);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.tajawal(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class ReportResultsDisplay extends StatelessWidget {
  const ReportResultsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GuidanceManagerCubit, GuidanceManagerState>(
      builder: (context, state) {
        if (state is GuidanceManagerLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is ReportsGenerated) {
          switch (state.reportType) {
            case 'students_stats':
              return StudentsStatisticsReport(students: state.students);
            case 'students_by_advisors':
              return StudentsByAdvisorsReport(students: state.students);
            default:
              return BasicStudentsReport(
                students: state.students,
                reportType: state.reportType,
              );
          }
        }

        return Center(
          child: Text(
            'اختر نوع التقرير لعرض النتائج',
            style: GoogleFonts.tajawal(),
          ),
        );
      },
    );
  }
}

class BasicStudentsReport extends StatelessWidget {
  final List<StudentModel> students;
  final String reportType;

  const BasicStudentsReport({
    super.key,
    required this.students,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    if (students.isEmpty) {
      return Center(
        child: Text(
          'لا توجد نتائج',
          style: GoogleFonts.tajawal(),
        ),
      );
    }

    String reportTitle;
    switch (reportType) {
      case 'low_gpa':
        reportTitle = 'الطلاب ذوو المعدل التراكمي ≤ 2.15 (${students.length} طالب)';
        break;
      case 'failures':
        reportTitle = 'الطلاب الذين رسبوا مرة أو أكثر (${students.length} طالب)';
        break;
      case 'warnings':
        reportTitle = 'الطلاب الذين لديهم إنذار أو أكثر (${students.length} طالب)';
        break;
      default:
        reportTitle = 'تقرير الطلاب (${students.length} طالب)';
    }

    return Column(
      children: [
        Text(
          reportTitle,
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentCard(student: student, reportType: reportType);
            },
          ),
        ),
      ],
    );
  }
}

class StudentCard extends StatelessWidget {
  final StudentModel student;
  final String reportType;

  const StudentCard({
    super.key,
    required this.student,
    required this.reportType,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ListTile(
          title: Text(
            student.name,
            style: GoogleFonts.tajawal(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('الرقم الجامعي: ${student.universityId}'),
              Text('التخصص: ${student.major}'),
              if (student.advisoremail != null && student.advisoremail!.isNotEmpty)
                Text('المرشد الأكاديمي: ${student.advisoremail}'),
              if (reportType == 'low_gpa')
                Text('المعدل: ${student.gpa?.toStringAsFixed(2) ?? "غير محدد"}'),
              if (reportType == 'failures')
                Text('مرات الرسوب: ${student.failures ?? 0}'),
              if (reportType == 'warnings')
                Text('عدد الإنذارات: ${student.warnings ?? 0}'),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentsStatisticsReport extends StatelessWidget {
  final List<StudentModel> students;

  const StudentsStatisticsReport({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    // Calculate statistics
    int totalStudents = students.length;


    double averageGPA = students.map((s) => s.gpa ?? 0).reduce((a, b) => a + b) / totalStudents;
    int studentsWithWarnings = students.where((s) => (s.warnings ?? 0) > 0).length;
    int studentsWithFailures = students.where((s) => (s.failures ?? 0) > 0).length;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'إحصائيات الطلاب (${students.length} طالب)',
              style: GoogleFonts.tajawal(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            StatCard(label: 'إجمالي عدد الطلاب', value: totalStudents.toString()),
            StatCard(label: 'متوسط المعدل التراكمي', value: averageGPA.toStringAsFixed(2)),
            StatCard(label: 'طلاب لديهم إنذارات', value: studentsWithWarnings.toString()),
            StatCard(label: 'طلاب لديهم رسوب', value: studentsWithFailures.toString()),
            const SizedBox(height: 16),
            Text(
              'توزيع الطلاب حسب التخصص',
              style: GoogleFonts.tajawal(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            MajorsDistribution(students: students),
          ],
        ),
      ),
    );
  }
}

class StudentsByAdvisorsReport extends StatelessWidget {
  final List<StudentModel> students;

  const StudentsByAdvisorsReport({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    // Group students by advisor
    Map<String, List<StudentModel>> studentsByAdvisor = {};
    for (var student in students) {
      String advisorName = student.advisoremail ?? 'غير معين';
      studentsByAdvisor.putIfAbsent(advisorName, () => []).add(student);
    }

    // Sort advisors by number of students
    var sortedAdvisors = studentsByAdvisor.entries.toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Column(
      children: [
        Text(
          'توزيع الطلاب حسب المرشدين الأكاديميين',
          style: GoogleFonts.tajawal(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: sortedAdvisors.length,
            itemBuilder: (context, index) {
              final entry = sortedAdvisors[index];
              return AdvisorStudentsGroup(
                advisorName: entry.key,
                students: entry.value,
              );
            },
          ),
        ),
      ],
    );
  }
}

class AdvisorStudentsGroup extends StatelessWidget {
  final String advisorName;
  final List<StudentModel> students;

  const AdvisorStudentsGroup({
    super.key,
    required this.advisorName,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ExpansionTile(
        title: Text(
          '$advisorName (${students.length} طالب)',
          style: GoogleFonts.tajawal(
            fontWeight: FontWeight.bold,
          ),
        ),
        children: students.map((student) => ListTile(
          title: Text(student.name),
          subtitle: Text('${student.major} - ${student.universityId}'),
        )).toList(),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String label;
  final String value;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.tajawal(
                    fontSize: 16,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MajorsDistribution extends StatelessWidget {
  final List<StudentModel> students;

  const MajorsDistribution({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    // Group students by major
    Map<String, int> majorsCount = {};
    for (var student in students) {
      String major = student.major ?? 'غير محدد';
      majorsCount[major] = (majorsCount[major] ?? 0) + 1;
    }

    // Sort majors by count
    var sortedMajors = majorsCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: sortedMajors.map((entry) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  entry.key,
                  style: GoogleFonts.tajawal(),
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  entry.value.toString(),
                  textAlign: TextAlign.end,
                  style: GoogleFonts.tajawal(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }
}