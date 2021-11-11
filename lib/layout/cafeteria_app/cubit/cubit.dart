import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/history_model.dart';
import 'package:cafeteriat/models/cafeteria_app/my_order_model.dart';
import 'package:cafeteriat/models/cafeteria_app/product_model.dart';
import 'package:cafeteriat/models/cafeteria_app/submit_order_response_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/dessert/desserts_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/drinks/drinks_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/food/food_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/snacks/snacks_screen.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/network/remote/socket_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CafeteriaCubit extends Cubit<CafeteriaStates> {
  CafeteriaCubit() : super(CafeteriaInitialState());

  static CafeteriaCubit get(context) => BlocProvider.of(context);
  bool isCartEmpty = true;
  int navBarCurrentIndex = 0;

  List<Widget> screens = [
    const FoodScreen(),
    const DrinksScreen(),
    const SnacksScreen(),
    const DessertsScreen(),
  ];

  List<String> titles = [
    'أكل',
    'مشروبات',
    'تسالي',
    'حلويات',
  ];



  ProductModel? menuModel;
  void getMenuData() {
    emit(CafeteriaMenuLoadingState());

    SocketHelper.getData(query: "EID:$uId,DayMenu<EOF>").then((value) {
      menuModel = ProductModel.fromJson(value);
      emit(CafeteriaMenuSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaMenuErrorState(error.toString()));
    });
  }


  HistoryModel? currentHistoryModel;
  void getCurrentHistoryData() {
    emit(CafeteriaCurrentHistoryLoadingState());
    SocketHelper.getData(query: "EID:$uId,CurrentHistory<EOF>").then((value) {

      currentHistoryModel = HistoryModel.fromJson(value, "CurrentHistory");
      emit(CafeteriaCurrentHistorySuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaCurrentHistoryErrorState(error.toString()));
    });
  }
  HistoryModel? previousHistoryModel;
  void getPreviousHistoryData() {
    emit(CafeteriaPreviousHistoryLoadingState());
    SocketHelper.getData(
      query: "EID:$uId,PreviousHistory<EOF>",
    ).then((value) {
      previousHistoryModel = HistoryModel.fromJson(value, "PreviousHistory");
      emit(CafeteriaPreviousHistorySuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaPreviousHistoryErrorState(error.toString()));
    });
  }

  // void getOrderNumberAndDate() {
  //   emit(CafeteriaOrderNumberAndDateLoadingState());
  //   SocketHelper.getData(
  //     query: "EID:$uId,OrderNumberAndDate<EOF>",
  //   ).then((value) {
  //     emit(CafeteriaOrderNumberAndDateSuccessState());
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(CafeteriaOrderNumberAndDateErrorState(error.toString()));
  //   });
  // }
  MyOrderModel? myOrderModel;
  void getMyOrderData() {
    emit(CafeteriaMyOrderLoadingState());
    SocketHelper.getData(
      query: "EID:$uId,RequestUpdateOrder<EOF>",
    ).then((value) {
      myOrderModel = MyOrderModel.fromJson(value);
      emit(CafeteriaMyOrderSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaMyOrderErrorState(error.toString()));
    });
  }
  SubmitOrderResponseModel? submitOrderResponseModel;
  void postMyOrderData({
    required String order,
    required String name,
    required double totalCost,
  }) {
    emit(CafeteriaPostMyOrderLoadingState());
    SocketHelper.postData(
      query: "EID:$uId,Order,$order,EName:$name,TCost:$totalCost<EOF>",
    ).then((value) {
      submitOrderResponseModel = SubmitOrderResponseModel.fromJson(value);
      emit(CafeteriaPostMyOrderSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaPostMyOrderErrorState(error.toString()));
    });
  }

  void changeBottomNav(int index) {
    navBarCurrentIndex = index;
    emit(CafeteriaChangeNavBarState());
  }
}
