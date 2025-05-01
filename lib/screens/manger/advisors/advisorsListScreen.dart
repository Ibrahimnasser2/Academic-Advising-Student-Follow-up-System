import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:followupst/models/academic_advisor_model.dart';
import 'package:followupst/screens/manger/students/student_details.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/student_model.dart';
import '../../../tools/widgets.dart';
import '../cubit/auth_state.dart';
import '../cubit/guidance_manager_cubit.dart';
import '../guidance_manager_home_screen.dart';
import 'advisorDetailsScreen.dart';


class advisorsListScreen extends StatefulWidget {
  const advisorsListScreen({super.key});

  @override
  State<advisorsListScreen> createState() => _advisorsListScreenState();
}

class _advisorsListScreenState extends State<advisorsListScreen> {
  @override
  void initState() {
    super.initState();
    // Load students when screen initializes
    GuidanceManagerCubit.get(context).loadAdvisors();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GuidanceManagerCubit, GuidanceManagerState>(
      listener: (context, state) {
        if (state is GuidanceManagerError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.toString())),
          );
        }
        if (state is OperationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message.toString())),
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  navigate_to(context, const GuidanceManagerHomeScreen());
                },
              ),
              title: Text(
                'عرض المرشدين الاكاديمين',
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
    final Advisors = cubit.alladvisorssdata;

    if (Advisors.isEmpty) {
      return Center(
        child: Text(
          'لا توجد بيانات مرشدين متاحة',
          style: GoogleFonts.tajawal(),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: Advisors.length,
      itemBuilder: (context, index) {
        final Advisor = Advisors[index];
        return _buildStudentItem(context, Advisor);
      },
    );
  }

  Widget _buildStudentItem(BuildContext context, AdvisorModel Advisor) {
    return InkWell(
      onTap: () {
        navigate_to(context, advisorDetailsScreen(Advisor:  Advisor));
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
              const CircleAvatar(
                radius: 28,
                child: Icon(
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
                      Advisor.name,
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
                          'رقم الهاتف: ',
                          style: GoogleFonts.tajawal(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          Advisor.phone,
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