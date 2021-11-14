abstract class CafeteriaStates {}

class CafeteriaInitialState extends CafeteriaStates {}

class CafeteriaChangeNavBarState extends CafeteriaStates {}

class CafeteriaProfilePictureLoadingState extends CafeteriaStates {}

class CafeteriaProfilePictureSuccessState extends CafeteriaStates {}

class CafeteriaProfilePictureErrorState extends CafeteriaStates {
  final String error;
  CafeteriaProfilePictureErrorState(this.error);
}

class CafeteriaMenuLoadingState extends CafeteriaStates {}

class CafeteriaMenuSuccessState extends CafeteriaStates {}

class CafeteriaMenuErrorState extends CafeteriaStates {
  final String error;
  CafeteriaMenuErrorState(this.error);
}

class CafeteriaCurrentHistoryLoadingState extends CafeteriaStates {}

class CafeteriaCurrentHistorySuccessState extends CafeteriaStates {}

class CafeteriaCurrentHistoryErrorState extends CafeteriaStates {
  final String error;
  CafeteriaCurrentHistoryErrorState(this.error);
}

class CafeteriaPreviousHistoryLoadingState extends CafeteriaStates {}

class CafeteriaPreviousHistorySuccessState extends CafeteriaStates {}

class CafeteriaPreviousHistoryErrorState extends CafeteriaStates {
  final String error;
  CafeteriaPreviousHistoryErrorState(this.error);
}

class CafeteriaMyOrderLoadingState extends CafeteriaStates {}

class CafeteriaMyOrderSuccessState extends CafeteriaStates {}

class CafeteriaMyOrderErrorState extends CafeteriaStates {
  final String error;
  CafeteriaMyOrderErrorState(this.error);
}

class CafeteriaOrderNumberAndDateLoadingState extends CafeteriaStates {}

class CafeteriaOrderNumberAndDateSuccessState extends CafeteriaStates {}

class CafeteriaOrderNumberAndDateErrorState extends CafeteriaStates {
  final String error;
  CafeteriaOrderNumberAndDateErrorState(this.error);
}

class CafeteriaPostMyOrderLoadingState extends CafeteriaStates {}

class CafeteriaPostMyOrderSuccessState extends CafeteriaStates {}

class CafeteriaPostMyOrderErrorState extends CafeteriaStates {
  final String error;
  CafeteriaPostMyOrderErrorState(this.error);
}

class CafeteriaUserDataLoadingState extends CafeteriaStates {}

class CafeteriaUserDataSuccessState extends CafeteriaStates {}

class CafeteriaUserDataErrorState extends CafeteriaStates {
  final String error;
  CafeteriaUserDataErrorState(this.error);
}
