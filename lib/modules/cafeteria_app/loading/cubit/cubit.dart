import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cafeteriat/models/cafeteria_app/user_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/loading/cubit/states.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CafeteriaLoadingCubit extends Cubit<CafeteriaLoadingStates> {
  CafeteriaLoadingCubit() : super(CafeteriaLoadingInitialState());

  static CafeteriaLoadingCubit get(context) => BlocProvider.of(context);

  late UserModel? userModel;
  Future<void> loadingNavigator() async {
    userData = await CacheHelper.getData(key: "userData");
    if (userData != null) {
      userModel = UserModel.fromJson(jsonDecode(userData!));
      userId = userModel!.data!.userId;
      userName = userModel!.data!.name;
      userProfileImage = CacheHelper.getData(key: "profileImageUrl");
      userCoverImage = CacheHelper.getData(key: "coverImageUrl");
      emit(CafeteriaLoadingCafeteriaLayoutState());
    } else {
      emit(CafeteriaLoadingLoginState());
    }
  }
}
