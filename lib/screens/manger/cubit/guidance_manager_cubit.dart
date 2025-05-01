import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/academic_advisor_model.dart';
import '../../../models/dean_model.dart';
import '../../../models/manger_model.dart';
import '../../../models/student_model.dart';
import '../../../shared/constant/end_point.dart';
import '../../login/login_screen.dart';
import '../guidance_manager_home_screen.dart';
import 'auth_state.dart';


class GuidanceManagerCubit extends Cubit<GuidanceManagerState> {
  static GuidanceManagerCubit get(context)=> BlocProvider.of(context);
  GuidanceManagerCubit() : super(GuidanceManagerInitial());
  StreamSubscription? _advisorSubscription;
  StreamSubscription? _studentsSubscription;
  List<StudentModel> allStudentsData = [];
  ManagerModel? currentManager;

  Future<void> loadStudents() async {
    // Cancel any existing subscription to avoid memory leaks
    _studentsSubscription?.cancel();

    // Clear previous data and show loading state
    allStudentsData.clear();
    emit(GuidanceManagerLoading());

    try {
      // Create new subscription to students collection
      _studentsSubscription = FirebaseFirestore.instance
          .collection("students")
          .snapshots()
          .listen((querySnapshot) {

        // Clear existing data before adding new data
        allStudentsData.clear();

        // Process each document
        for (final doc in querySnapshot.docs) {
          try {
            final student = StudentModel.fromMap(doc.data());
            allStudentsData.add(student);
          } catch (e) {
            print('Error parsing student document ${doc.id}: $e');
          }
        }

        // Emit loaded state with the new data
        emit(StudentsLoaded(allStudentsData));

      }, onError: (error) {
        emit(GuidanceManagerError(
            message: 'حدث خطأ أثناء استقبال البيانات: ${error.toString()}'
        ));
      });

    } catch (e) {
      emit(GuidanceManagerError(
          message: 'فشل في تحميل بيانات الطلاب: ${e.toString()}'
      ));
    }
  }


  List<AdvisorModel> alladvisorssdata=[];


  Future<void> loadAdvisors() async {
    _advisorSubscription?.cancel();
    alladvisorssdata.clear();
    emit(GuidanceManagerLoading());
    try {
      // Create new subscription to students collection
      _studentsSubscription = FirebaseFirestore.instance
          .collection("advisors")
          .snapshots()
          .listen((querySnapshot) {

        // Clear existing data before adding new data
        alladvisorssdata.clear();

        // Process each document
        for (final doc in querySnapshot.docs) {
          try {
            final advisor = AdvisorModel.fromMap(doc.data());
            alladvisorssdata.add(advisor);
          } catch (e) {
            print('Error parsing student document ${doc.id}: $e');
          }
        }

        // Emit loaded state with the new data
        emit(AdvisorsLoaded(alladvisorssdata));

      }, onError: (error) {
        emit(GuidanceManagerError(
            message: 'حدث خطأ أثناء استقبال البيانات: ${error.toString()}'
        ));
      });

    } catch (e) {
      emit(GuidanceManagerError(
          message: 'فشل في تحميل بيانات المرشدين الاكاديمين: ${e.toString()}'
      ));
    }
  }
  Future<void> close1() {
    // Cancel subscription when cubit is closed
    _advisorSubscription?.cancel();
    return super.close();
  }

  Future<void> loadAdvisorStudents(String advisorId) async {
    emit(GuidanceManagerLoading());
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('students')
          .where('advisorId', isEqualTo: advisorId)
          .get();
      final students = snapshot.docs
          .map((doc) => StudentModel.fromMap(doc.data()))
          .toList();
      emit(AdvisorStudentsLoaded(students));
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحميل طلاب المرشد'));
    }
  }

  Future<void> updateStudent(StudentModel student) async {
    emit(GuidanceManagerLoading());
    try {
      await FirebaseFirestore.instance
          .collection('students')
          .doc(student.id)
          .update(student.toMap());
      emit(OperationSuccess(message: 'تم تحديث بيانات الطالب بنجاح'));
      loadStudents(); // Refresh the list
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحديث بيانات الطالب: ${e.toString()}'));
    }
  }
  Future<void> updateasvisor(AdvisorModel student) async {
    emit(GuidanceManagerLoading());
    try {
      await FirebaseFirestore.instance
          .collection('advisors')
          .doc(student.id)
          .update(student.toMap());
      emit(OperationSuccess(message: 'تم تحديث بيانات المرشد بنجاح'));
      loadStudents(); // Refresh the list
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحديث بيانات المرشد: ${e.toString()}'));
    }
  }

  void create_student({required String email,
    required String uid,
    required String name,
    required String phone,
    required String universityId,
    required String advisoremail,
    required double gpa,
    required String major,
    required String password,
    required int warnings,
    required int failures,
    required String status



  }){
    emit(create_student_loading_state());
    StudentModel student1=StudentModel(

      id: uid,
      name: name,
      universityId: universityId,
      phone: phone,
      major: major,
      gpa: gpa ,
      status: status,
      warnings: warnings,
      failures: failures,
      advisoremail: advisoremail,
      email: email,
      password: password,



      );

    emit(reg_student_loading_state());

    FirebaseFirestore.instance.collection("students").doc(uid).set(student1!.toMap()).then(
            (value){
          emit(create_student_success_state());

        }).catchError((error){
      print(error.toString());
      emit(create_student_fail_state(error.toString()));
    });

  }



  Future<void> addStudent({
    required String email,
  required String name,
  required String phone,
  required String universityId,
  required String advisoremail,
  required double gpa,
  required String major,
  required String password,
  required int warnings,
  required int failures,
  required String status}
      ) async {
    emit(GuidanceManagerLoading());

    try {
      emit(create_student_loading_state());

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).
      then((value) async {
        create_student(
          uid: value.user!.uid!,
          name: name,
          universityId: universityId,
          phone: phone,
          major: major,
          gpa: gpa ,
          status: status,
          warnings: warnings,
          failures: failures,
          advisoremail: advisoremail,
          email: email,
          password: password,

        );

        emit(OperationSuccess(message: 'تمت إضافة الطالب بنجاح'));
      } ).
      catchError((onError){});



      // تحديث قائمة الطلاب لدى المرشد إذا كان لديه مرشد



    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في إضافة الطالب'));
    }
  }



  void create_Advisor({required String email,
    required String uid,
    required String name,
    required String phone,
    required String password,
  }){
    emit(create_advidor_loading_state());
    AdvisorModel advisor1=AdvisorModel(

      id: uid,
      name: name,
      phone: phone,
      email: email,
      password: password,

    );

    emit(create_advidor_success_state());

    FirebaseFirestore.instance.collection("advisors").doc(uid).set(advisor1!.toMap()).then(
            (value){
          emit(create_advidor_success_state());

        }).catchError((error){
      print(error.toString());
      emit(create_advidor_fail_state(error.toString()));
    });

  }


  Future<void> addadvisor({
    required String email,
    required String name,
    required String phone,
    required String password,
}
      ) async {
    emit(GuidanceManagerLoading());

    try {
      emit(advidor_loading_state());

      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).
      then((value) async {
        create_Advisor(
          uid: value.user!.uid!,
          name: name,
          phone: phone,
          email: email,
          password: password,

        );

        emit(advidor_success_state());
      } ).
      catchError((onError){});



      // تحديث قائمة الطلاب لدى المرشد إذا كان لديه مرشد



    } catch (e) {
      emit(advidor_success_state());
    }
  }


  Future<void> removeStudent({
    required String id,
    required String email,
  }) async {
    emit(removeStudent_loading_state());

    try {
      // First delete the student's authentication account
      final user = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email)
          .then((methods) async {
        if (methods.isNotEmpty) {
          return await FirebaseAuth.instance.currentUser?.delete();
        }
        return null;
      });

      // Then delete the student document from Firestore
      await FirebaseFirestore.instance
          .collection('students')
          .doc(id)
          .delete();

      // Also remove the student from their advisor's assignedStudents list
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(id)
          .get();

      if (studentDoc.exists) {
        final advisorId = studentDoc.data()?['advisorId'];
        if (advisorId != null && advisorId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('advisors')
              .doc(advisorId)
              .update({
            'assignedStudents': FieldValue.arrayRemove([id])
          });
        }
      }

      // Update local data
      allStudentsData.removeWhere((student) => student.id == id);

      emit(removeStudent_success_state());
    } catch (error) {
      emit(GuidanceManagerError(message: 'فشل في حذف الطالب: ${error.toString()}'));
    }
  }


  Future<void> removeadvisor({
    required String id,
    required String email,
  }) async {
    emit(removeStudent_loading_state());

    try {
      // First delete the student's authentication account
      final user = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(email)
          .then((methods) async {
        if (methods.isNotEmpty) {
          return await FirebaseAuth.instance.currentUser?.delete();
        }
        return null;
      });

      // Then delete the student document from Firestore
      await FirebaseFirestore.instance
          .collection('advisors')
          .doc(id)
          .delete();

      // Also remove the student from their advisor's assignedStudents list
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(id)
          .get();

      if (studentDoc.exists) {
        final advisorId = studentDoc.data()?['advisorId'];
        if (advisorId != null && advisorId.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('advisors')
              .doc(advisorId)
              .update({
            'assignedStudents': FieldValue.arrayRemove([id])
          });
        }
      }

      // Update local data
      alladvisorssdata.removeWhere((student) => student.id == id);

      emit(removeStudent_success_state());
    } catch (error) {
      emit(GuidanceManagerError(message: 'فشل في حذف الطالب: ${error.toString()}'));
    }
  }




  void generateReport(String reportType) {
    emit(GuidanceManagerLoading());

    try {
      List<StudentModel> filteredStudents = [];

      switch (reportType) {
        case 'low_gpa':
          filteredStudents = allStudentsData
              .where((student) => student.gpa != null && student.gpa! <= 2.15)
              .toList();
          break;

        case 'failures':
          filteredStudents = allStudentsData
              .where((student) => student.failures != null && student.failures! > 0)
              .toList();
          break;

        case 'warnings':
          filteredStudents = allStudentsData
              .where((student) => student.warnings != null && student.warnings! > 0)
              .toList();
          break;

        case 'students_stats':
        // إحصائيات عامة لجميع الطلاب
          emit(ReportsGenerated(
            students: allStudentsData,
            advisors: alladvisorssdata,
            reportType: reportType,
          ));
          return;

        case 'students_by_advisors':
        // توزيع الطلاب حسب المرشدين
          emit(ReportsGenerated(
            students: allStudentsData,
            advisors: alladvisorssdata,
            reportType: reportType,
          ));
          return;

        default:
          filteredStudents = allStudentsData;
      }

      emit(ReportsGenerated(
        students: filteredStudents,
        advisors: alladvisorssdata,
        reportType: reportType,
      ));

    } catch (e) {
      emit(GuidanceManagerError(
          message: 'فشل في إنشاء التقرير: ${e.toString()}'
      ));
    }
  }

  // إحصائيات الطلاب
  Map<String, dynamic> getStudentsStatistics() {
    if (allStudentsData.isEmpty) return {};

    int totalStudents = allStudentsData.length;
    double averageGPA = allStudentsData
        .map((s) => s.gpa ?? 0)
        .reduce((a, b) => a + b) / totalStudents;

    int studentsWithWarnings = allStudentsData
        .where((s) => (s.warnings ?? 0) > 0)
        .length;

    int studentsWithFailures = allStudentsData
        .where((s) => (s.failures ?? 0) > 0)
        .length;

    // توزيع التخصصات
    Map<String, int> majorsDistribution = {};
    for (var student in allStudentsData) {
      String major = student.major ?? 'غير محدد';
      majorsDistribution[major] = (majorsDistribution[major] ?? 0) + 1;
    }

    return {
      'totalStudents': totalStudents,
      'averageGPA': averageGPA.toStringAsFixed(2),
      'studentsWithWarnings': studentsWithWarnings,
      'studentsWithFailures': studentsWithFailures,
      'majorsDistribution': majorsDistribution,
    };
  }

  // إحصائيات المرشدين
  Map<String, dynamic> getAdvisorsStatistics() {
    if (alladvisorssdata.isEmpty) return {};

    int totalAdvisors = alladvisorssdata.length;

    // عدد الطلاب لكل مرشد
    Map<String, int> studentsPerAdvisor = {};
    for (var student in allStudentsData) {
      String advisorEmail = student.advisoremail ?? 'غير معين';
      studentsPerAdvisor[advisorEmail] = (studentsPerAdvisor[advisorEmail] ?? 0) + 1;
    }

    return {
      'totalAdvisors': totalAdvisors,
      'studentsPerAdvisor': studentsPerAdvisor,
    };
  }

  // توزيع الطلاب حسب المرشدين
  Map<String, List<StudentModel>> getStudentsByAdvisors() {
    Map<String, List<StudentModel>> result = {};

    for (var student in allStudentsData) {
      String advisorEmail = student.advisoremail ?? 'غير معين';
      if (!result.containsKey(advisorEmail)) {
        result[advisorEmail] = [];
      }
      result[advisorEmail]!.add(student);
    }

    return result;
  }

  @override
  Future<void> close() {
    _studentsSubscription?.cancel();
    _advisorSubscription?.cancel();
    return super.close();
  }


  Future<void> createDeanAccount({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(GuidanceManagerLoading());

    try {
      // إنشاء المستخدم في Firebase Auth
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // إنشاء نموذج العميد
      final dean = DeanModel(
        id: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        password: password,
      );

      // حفظ في Firestore
      await FirebaseFirestore.instance
          .collection('deans')
          .doc(credential.user!.uid)
          .set(dean.toMap());

      emit(OperationSuccess(message: 'تم إنشاء حساب العميد بنجاح'));
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'weak-password') {
        errorMessage = 'كلمة المرور ضعيفة جدًا';
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'البريد الإلكتروني مستخدم بالفعل';
      } else {
        errorMessage = 'حدث خطأ أثناء إنشاء الحساب: ${e.message}';
      }
      emit(GuidanceManagerError(message: errorMessage));
    } catch (e) {
      emit(GuidanceManagerError(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  Future<void> loadDeans() async {
    emit(GuidanceManagerLoading());

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('deans')
          .get();

      final deans = querySnapshot.docs
          .map((doc) => DeanModel.fromMap(doc.data()))
          .toList();

      emit(DeansLoaded(deans));
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحميل بيانات العمداء: ${e.toString()}'));
    }
  }

  Future<void> updateDean(DeanModel dean) async {
    emit(GuidanceManagerLoading());

    try {
      await FirebaseFirestore.instance
          .collection('deans')
          .doc(dean.id)
          .update(dean.toMap());

      emit(OperationSuccess(message: 'تم تحديث بيانات العميد بنجاح'));
      loadDeans(); // تحديث القائمة
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحديث بيانات العميد: ${e.toString()}'));
    }
  }

  Future<void> removeDean({required String id, required String email}) async {
    emit(GuidanceManagerLoading());

    try {
      // حذف الحساب من Firebase Auth
      final user = await FirebaseAuth.instance.fetchSignInMethodsForEmail(email)
          .then((methods) async {
        if (methods.isNotEmpty) {
          return await FirebaseAuth.instance.currentUser?.delete();
        }
        return null;
      });

      // حذف من Firestore
      await FirebaseFirestore.instance
          .collection('deans')
          .doc(id)
          .delete();

      emit(OperationSuccess(message: 'تم حذف العميد بنجاح'));
      loadDeans(); // تحديث القائمة
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في حذف العميد: ${e.toString()}'));
    }
  }



  String name = '';
  String email = '';
  String phone = '';
  String currentPassword = '';
  String newPassword = '';
  String confirmPassword = '';


  // Future<void> updateProfile() async {
  //   emit(GuidanceManagerLoading());
  //
  //   try {
  //     // التحقق من تطابق كلمة المرور الجديدة
  //     if (newPassword.isNotEmpty && newPassword != confirmPassword) {
  //       throw Exception('كلمة المرور الجديدة غير متطابقة');
  //     }
  //
  //     // التحقق من كلمة المرور الحالية
  //     final user = FirebaseAuth.instance.currentUser;
  //     if (user == null) throw Exception('المستخدم غير مسجل دخول');
  //
  //     // إعادة المصادقة لتأكيد كلمة المرور الحالية
  //     final credential = EmailAuthProvider.credential(
  //       email: user.email!,
  //       password: currentPassword,
  //     );
  //
  //     await user.reauthenticateWithCredential(credential);
  //
  //     // تحديث البيانات في Firebase Auth إذا تغيرت كلمة المرور
  //     if (newPassword.isNotEmpty) {
  //       await user.updatePassword(newPassword);
  //     }
  //
  //     // تحديث البيانات في Firestore
  //     final updatedManager = ManagerModel(
  //       id: user.uid,
  //       name: name.isNotEmpty ? name : currentManager?.name ?? '',
  //       email: email.isNotEmpty ? email : currentManager?.email ?? '',
  //       phone: phone.isNotEmpty ? phone : currentManager?.phone ?? '',
  //       password: newPassword.isNotEmpty ? newPassword : currentManager?.password ?? '',
  //     );
  //
  //     await FirebaseFirestore.instance
  //         .collection('managers')
  //         .doc(user.uid)
  //         .update(updatedManager.toMap());
  //
  //     emit(OperationSuccess(message: 'تم تحديث الملف الشخصي بنجاح'));
  //   } on FirebaseAuthException catch (e) {
  //     String errorMessage;
  //     if (e.code == 'wrong-password') {
  //       errorMessage = 'كلمة المرور الحالية غير صحيحة';
  //     } else if (e.code == 'weak-password') {
  //       errorMessage = 'كلمة المرور الجديدة ضعيفة جداً';
  //     } else {
  //       errorMessage = 'حدث خطأ أثناء التحديث: ${e.message}';
  //     }
  //     emit(GuidanceManagerError(message: errorMessage));
  //   } catch (e) {
  //     emit(GuidanceManagerError(message: 'حدث خطأ غير متوقع: ${e.toString()}'));
  //   }
  // }

  Future<void> loadManagerProfile() async {
    emit(GuidanceManagerLoading());

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('المستخدم غير مسجل دخول');

      final doc = await FirebaseFirestore.instance
          .collection('managers')
          .doc(token!)
          .get();

      if (doc.exists) {
        currentManager = ManagerModel.fromMap(doc.data()!);
        emit(ManagerProfileLoaded(currentManager!));
      } else {
        throw Exception('الملف الشخصي غير موجود');
      }
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحميل الملف الشخصي: ${e.toString()}'));
    }
  }

  Future<void> update_managerProfile() async {
    emit(GuidanceManagerLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('المستخدم غير مسجل الدخول');

      // Validate password changes
      if (newPassword.isNotEmpty) {
        if (newPassword != confirmPassword) {
          throw Exception('كلمة المرور الجديدة غير متطابقة');
        }
        if (currentPassword.isEmpty) {
          throw Exception('يجب إدخال كلمة المرور الحالية');
        }

        // Reauthenticate before password change
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
      }

      // Update Firestore data
      final updatedManager = ManagerModel(
        id: user.uid,
        name: name.isNotEmpty ? name : currentManager?.name ?? '',
        email: email.isNotEmpty ? email : currentManager?.email ?? '',
        phone: phone.isNotEmpty ? phone : currentManager?.phone ?? '',
        password: newPassword.isNotEmpty ? newPassword : currentManager?.password ?? '',
      );

      await FirebaseFirestore.instance
          .collection('managers')
          .doc(user.uid)
          .update(updatedManager.toMap());

      ManagerModel currentManager1 =  updatedManager;

      // Emit both success and profile loaded states
      emit(OperationSuccess(message: 'تم تحديث الملف الشخصي بنجاح'));
      emit(ManagerProfileLoaded(currentManager1)); // Add this line

    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'كلمة المرور الحالية غير صحيحة';
          break;
        case 'weak-password':
          errorMessage = 'كلمة المرور الجديدة ضعيفة جداً';
          break;
        default:
          errorMessage = 'فشل في تحديث الملف الشخصي: ${e.message}';
      }
      emit(GuidanceManagerError(message: errorMessage));
    } catch (e) {
      emit(GuidanceManagerError(message: 'فشل في تحديث الملف الشخصي: ${e.toString()}'));
    }
  }



}