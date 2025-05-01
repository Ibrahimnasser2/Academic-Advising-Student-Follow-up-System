import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdvisorStudentsCubit extends Cubit<List<Map<String, dynamic>>> {
  AdvisorStudentsCubit() : super([]);

  Future<void> fetchStudents(String advisorId) async {
    try {
      final studentsSnapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('advisorId', isEqualTo: advisorId)
          .get();

      final students = studentsSnapshot.docs
          .map((doc) => {...doc.data(), "id": doc.id})
          .toList();

      emit(students);
    } catch (e) {
      print("Error fetching students: $e");
      emit([]);
    }
  }
}
