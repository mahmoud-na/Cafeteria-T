import 'package:cafeteriat/models/cafeteria_app/user_model.dart';

abstract class CafeteriaLoginStates {}

class CafeteriaLoginInitialState extends CafeteriaLoginStates {}


class CafeteriaLoginLoadingState extends CafeteriaLoginStates {}

class CafeteriaLoginSuccessState extends CafeteriaLoginStates {
  final UserModel userModel;
  CafeteriaLoginSuccessState({required this.userModel});
}

class CafeteriaLoginErrorState extends CafeteriaLoginStates {
  final String error;

  CafeteriaLoginErrorState(this.error);
}



class CafeteriaUserDataLoadingState extends CafeteriaLoginStates {}

class CafeteriaUserDataSuccessState extends CafeteriaLoginStates {
  final UserModel userModel;
  CafeteriaUserDataSuccessState({required this.userModel});
}

class CafeteriaUserDataErrorState extends CafeteriaLoginStates {
  final String error;
  CafeteriaUserDataErrorState(this.error);
}


class CafeteriaLoginChangeVisibilityState extends CafeteriaLoginStates {}
