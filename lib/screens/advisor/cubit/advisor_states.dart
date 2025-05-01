abstract class AdvisorStates {}

class AdvisorInitialState extends AdvisorStates {}

class AdvisorLoadingState extends AdvisorStates {}

class AdvisorSuccessState extends AdvisorStates {}

class AdvisorErrorState extends AdvisorStates {
  final String error;
  AdvisorErrorState({required this.error});
}

class AdvisorStudentCreationLoadingState extends AdvisorStates {}

class AdvisorStudentCreationSuccessState extends AdvisorStates {}

class AdvisorStudentCreationErrorState extends AdvisorStates {
  final String error;
  AdvisorStudentCreationErrorState({required this.error}){
    print(error);
  }
}

class AdvisorNotificationSuccessState extends AdvisorStates {}

class AdvisorNotificationErrorState extends AdvisorStates {
  final String error;
  AdvisorNotificationErrorState({required this.error});
}