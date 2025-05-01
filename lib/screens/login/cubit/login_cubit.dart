import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../manger/guidance_manager_home_screen.dart';
import '../login_screen.dart';
import 'login state.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool isPasswordVisible = true;
  IconData suffixIcon = Icons.visibility;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    suffixIcon = isPasswordVisible ? Icons.visibility : Icons.visibility_off;
    emit(ChangePasswordVisibilityState());
  }

  void userLogin({
    required String email,
    required String password,
    required String role,
  }) async {
    emit(LoginLoadingState());

    // التحقق من صيغة البريد الإلكتروني للطلاب والمرشدين فقط
    if (role == 'الطالب' && !email.endsWith('@student.kk.edu.sa')) {
      emit(LoginErrorState('البريد الإلكتروني للطالب يجب أن ينتهي بـ @student.kk.edu.sa'));
      Fluttertoast.showToast(
        msg: 'البريد الإلكتروني للطالب يجب أن ينتهي بـ @student.kk.edu.sa',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (role == 'المرشد الأكاديمي' && !email.endsWith('@kk.edu.sa')) {
      emit(LoginErrorState('البريد الإلكتروني للمرشد الأكاديمي يجب أن ينتهي بـ @kk.edu.sa'));
      Fluttertoast.showToast(
        msg: 'البريد الإلكتروني للمرشد الأكاديمي يجب أن ينتهي بـ @kk.edu.sa',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccessState(credential.user!.uid));
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getErrorMessage(e.code);
      emit(LoginErrorState(errorMessage));
      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } catch (error) {
      emit(LoginErrorState('حدث خطأ غير متوقع أثناء تسجيل الدخول'));
      Fluttertoast.showToast(
        msg: 'حدث خطأ غير متوقع أثناء تسجيل الدخول',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'البريد الإلكتروني غير مسجل';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'invalid-email':
        return 'بريد إلكتروني غير صالح';
      case 'user-disabled':
        return 'هذا الحساب معطل';
      case 'too-many-requests':
        return 'محاولات تسجيل دخول كثيرة، يرجى المحاولة لاحقاً';
      default:
        return 'فشل تسجيل الدخول';
    }
  }


}