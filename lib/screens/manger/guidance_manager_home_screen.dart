import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:followupst/screens/login/login_screen.dart';
import 'package:followupst/screens/manger/reports/reports_screen.dart';
import 'package:followupst/screens/manger/settings/settings.dart';
import 'package:followupst/screens/manger/students/students_list_screen.dart';
import 'package:followupst/shared/constant/end_point.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/local/cach_helper.dart';
import '../../tools/widgets.dart';
import 'advisors/add_advisor.dart';
import 'advisors/advisorsListScreen.dart';
import 'deans/create_dean_account_screen.dart';
import 'students/add_student_dialog.dart';
import 'cubit/auth_state.dart';
import 'cubit/guidance_manager_cubit.dart';

class GuidanceManagerHomeScreen extends StatelessWidget {
  const GuidanceManagerHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      GuidanceManagerCubit()..loadManagerProfile(),
      child: BlocConsumer<GuidanceManagerCubit, GuidanceManagerState>(
        listener: (context, state) {},
        builder: (context, state) {
          GuidanceManagerCubit cubit = GuidanceManagerCubit.get(context);
          if (state is GuidanceManagerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OperationSuccess) {
            cubit.loadManagerProfile();
          }
          if (state is GuidanceManagerError) {
            return Center(child: Text(state.message.toString()));
          }

          final managerName = (state is ManagerProfileLoaded)
              ? state.manager.name
              : FirebaseAuth.instance.currentUser?.displayName ?? 'مدير النظام';

          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.primaryColor.withOpacity(0.2),
                            ),
                          ),
                        ),
                        Positioned(
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor:
                            AppColors.primaryColor.withOpacity(0.2),
                            child: Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        managerName,
                        style: GoogleFonts.tajawal(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 15,
                        children: [
                          _buildMenuItem(
                            context,
                            'رفع ملف الطلاب',
                            Icons.note_add,
                            Colors.blue,
                                () {
                              navigate_to(context, const AddStudentDialog());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'رفع ملف المرشدين',
                            Icons.people,
                            Colors.blue,
                                () {
                              navigate_to(context, const AddadvisorDialog());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'انشاء حساب العميد',
                            Icons.person_pin_outlined,
                            Colors.green,
                                () {
                              navigate_to(context,
                                  const CreateDeanAccountScreen());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'عرض الطلاب',
                            Icons.school_sharp,
                            Colors.orange,
                                () {
                              navigate_to(
                                  context, const StudentsListScreen());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'عرض المرشدين',
                            Icons.supervised_user_circle,
                            Colors.green,
                                () {
                              navigate_to(
                                  context, const advisorsListScreen());
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'تقارير الطلاب المتعثرين',
                            Icons.assessment,
                            Colors.orange,
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReportsScreen(
                                      uid: FirebaseAuth
                                          .instance.currentUser?.uid ??
                                          ''),
                                ),
                              );
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'تقارير المرحلة الأولي',
                            Icons.library_books,
                            Colors.purpleAccent,
                                () {
                              // TODO
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'تقارير المرحلة الثانية',
                            Icons.library_books,
                            Colors.purple,
                                () {
                              // TODO
                            },
                          ),
                          _buildMenuItem(
                            context,
                            'اعدادت الملف الشخصي',
                            Icons.settings_applications,
                            Colors.teal,
                                () {
                              navigate_to(context, EditProfileScreen());
                            },
                          ),
                        ],
                      ),
                    ),

                    // 🔴 Logout Button Section

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 5,
                        ),
                        icon: const Icon(Icons.logout, color: Colors.white),
                        label: Text(
                          'تسجيل الخروج',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          CacheHelper.removeData(key: "role");
                          CacheHelper.removeData(key: "token");
                          await FirebaseAuth.instance.signOut();
                          navigate_to(context, LoginScreen());
                           // Adjust if needed
                        },
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.tajawal(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
