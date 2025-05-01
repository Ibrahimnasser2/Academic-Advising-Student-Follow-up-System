import 'package:equatable/equatable.dart';

import '../../../models/academic_advisor_model.dart';
import '../../../models/dean_model.dart';
import '../../../models/manger_model.dart';
import '../../../models/student_model.dart';


abstract class GuidanceManagerState extends Equatable {
  const GuidanceManagerState();

  @override
  List<Object> get props => [];
}

class GuidanceManagerInitial extends GuidanceManagerState {}

class GuidanceManagerLoading extends GuidanceManagerState {}

class StudentsLoaded extends GuidanceManagerState {
  final List<StudentModel> students;

  const StudentsLoaded(this.students);


}

class AdvisorsLoaded extends GuidanceManagerState {
  final List<AdvisorModel> advisors;

  const AdvisorsLoaded(this.advisors);

  @override
  List<Object> get props => [advisors];
}

class AdvisorStudentsLoaded extends GuidanceManagerState {
  final List<StudentModel> students;

  const AdvisorStudentsLoaded(this.students);

  @override
  List<Object> get props => [students];
}



class GuidanceManagerError extends GuidanceManagerState {
   String? message;

   GuidanceManagerError({this.message});

}

class OperationSuccess extends GuidanceManagerState {
   String? message;

   OperationSuccess({ this.message});


}

class create_student_loading_state extends GuidanceManagerState{}
class create_student_success_state extends GuidanceManagerState{
  // login_model? loginmodel;
  // login_success_state(this.loginmodel);
}

class create_student_fail_state extends GuidanceManagerState{
  late final String error;

  create_student_fail_state(this.error);
}
class reg_student_loading_state extends GuidanceManagerState{}

class create_advidor_loading_state extends GuidanceManagerState{}
class create_advidor_success_state extends GuidanceManagerState{
  // login_model? loginmodel;
  // login_success_state(this.loginmodel);
}

class create_advidor_fail_state extends GuidanceManagerState{
  late final String error;

  create_advidor_fail_state(this.error);}


class advidor_loading_state extends GuidanceManagerState{}
class advidor_success_state extends GuidanceManagerState{
  // login_model? loginmodel;
  // login_success_state(this.loginmodel);
}

class advidor_fail_state extends GuidanceManagerState{
  late final String error;

  advidor_fail_state(this.error);}

class removeStudent_loading_state extends GuidanceManagerState{}
class removeStudent_success_state extends GuidanceManagerState{
  // login_model? loginmodel;
  // login_success_state(this.loginmodel);
}

class removeStudent_fail_state extends GuidanceManagerState{
  late final String error;

  removeStudent_fail_state(this.error);}


class ReportsGenerated extends GuidanceManagerState {
  final List<StudentModel> students;
  final List<AdvisorModel> advisors;
  final String reportType;

  ReportsGenerated({
    required this.students,
    required this.advisors,
    required this.reportType,
  });

  @override
  List<Object> get props => [students, advisors, reportType];
}
class DeansLoaded extends GuidanceManagerState {
  final List<DeanModel> deans;

  const DeansLoaded(this.deans);

  @override
  List<Object> get props => [deans];
}


class ManagerProfileLoaded extends GuidanceManagerState {
  final ManagerModel manager;

  const ManagerProfileLoaded(this.manager);

  @override
  List<Object> get props => [manager];
}