import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/models/cafeteria_app/user_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/login/cubit/states.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/network/remote/socket_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CafeteriaLoginCubit extends Cubit<CafeteriaLoginStates> {
  CafeteriaLoginCubit() : super(CafeteriaLoginInitialState());

  static CafeteriaLoginCubit get(context) => BlocProvider.of(context);

  bool isLoading =false;
  Map userModelToMap({
    required String userID,
    required String userName,
  }) {
    return {
      "LogIN": [
        {
          "activationValid": true,
          'ID': userID,
          'Name': userName,
        }
      ]
    };
  }

  FirebaseStorage storageReference = FirebaseStorage.instance;

  late UserModel? userModel;

  Future<void> getUserData({
    required String activationCode,
  }) async {
    emit(CafeteriaUserDataLoadingState());
    isLoading =true;
    await SocketHelper.getData(query: "EID:0,ACTCODE:$activationCode<EOF>")
        .then((value) async {
      userModel = UserModel.fromJson(value);
      await getUserImages(
        userId: userModel!.data!.userId!,
        userName: userModel!.data!.name!,
      );

      emit(CafeteriaUserDataSuccessState(userModel: userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaUserDataErrorState(error.toString()));
    });
  }

  Future<void> getUserImages({
    required String userName,
    required String userId,
  }) async {
    try {
      storageReference
          .ref()
          .child(
            'ProfilesPics/$userName:$userId',
          )
          .getDownloadURL()
          .then((fileURL) {
        userProfileImage = fileURL;
        CacheHelper.saveData(key: 'profileImageUrl', value: fileURL);
      });
    } on Exception catch (e) {
      print(e);
    }
    try {
      storageReference
          .ref()
          .child(
            'drawerBGimages/$userName:$userId',
          )
          .getDownloadURL()
          .then((fileURL) {
        userCoverImage = fileURL;
        CacheHelper.saveData(key: 'coverImageUrl', value: fileURL);
      });
    } on Exception catch (e) {
      print(e);
    }
  }

  Widget suffix = const Icon(Icons.visibility_outlined);
  bool isPasswordVisible = true;

  void changePasswordVisibilityState() {
    isPasswordVisible = !isPasswordVisible;
    suffix = isPasswordVisible
        ? const Icon(Icons.visibility_outlined)
        : const Icon(Icons.visibility_off_outlined);
    emit(CafeteriaLoginChangeVisibilityState());
  }
}
