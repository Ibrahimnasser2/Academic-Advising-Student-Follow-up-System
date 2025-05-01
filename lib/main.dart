import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:followupst/screens/login/cubit/login_cubit.dart';
import 'package:followupst/screens/login/login_screen.dart';
import 'package:followupst/screens/manger/cubit/guidance_manager_cubit.dart';
import 'package:followupst/screens/splash_screen.dart';
import 'package:followupst/shared/bloc_observer.dart';
import 'package:followupst/tools/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => GuidanceManagerCubit()..loadStudents()..loadAdvisors(),
        ),
      ],
      child: MaterialApp(
        title: 'كلية ك ك',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: AppColors.secondaryColor,
          ),
          fontFamily: GoogleFonts.tajawal().fontFamily,
          appBarTheme: const AppBarTheme(
            color: AppColors.primaryColor,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        home: SplashScreen(),
      ),
    );
  }
}