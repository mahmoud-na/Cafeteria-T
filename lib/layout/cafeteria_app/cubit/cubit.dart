import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/edit_order_response_model.dart';
import 'package:cafeteriat/models/cafeteria_app/history_model.dart';
import 'package:cafeteriat/models/cafeteria_app/my_cart_model.dart';
import 'package:cafeteriat/models/cafeteria_app/my_order_model.dart';
import 'package:cafeteriat/models/cafeteria_app/product_model.dart';
import 'package:cafeteriat/models/cafeteria_app/submit_order_response_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/dessert/desserts_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/drinks/drinks_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/food/food_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/snacks/snacks_screen.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/network/remote/socket_helper.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ntp/ntp.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CafeteriaCubit extends Cubit<CafeteriaStates> {
  CafeteriaCubit() : super(CafeteriaInitialState());

  static CafeteriaCubit get(context) => BlocProvider.of(context);
  bool isMyOrder = true;
  int navBarCurrentIndex = 0;
  DateTime? dateAndTimeNow;
  bool menuTimerFire = false;
  bool currentHistoryTimerFire = false;
  bool previousHistoryTimerFire = false;
  var platFormType = Platform.operatingSystem;

  bool isBottomSheetShown = false;

  List<Widget> screens = [
    const FoodScreen(),
    const DrinksScreen(),
    const SnacksScreen(),
    const DessertsScreen(),
  ];

  List<String> appBarTitles = [
    'أكل',
    'مشروبات',
    'تسالي',
    'حلويات',
  ];

  void changeBottomSheetState({required bool isShow}) {
    isBottomSheetShown = isShow;
    emit(AppChangeBottomSheetState());
  }

  void navBarSweepToTheRight() {
    navBarCurrentIndex += 1;
    if (navBarCurrentIndex == screens.length) {
      navBarCurrentIndex = 0;
      changeBottomNav(navBarCurrentIndex);
    } else {
      changeBottomNav(navBarCurrentIndex);
    }
  }

  void navBarSweepToTheLeft() {
    navBarCurrentIndex -= 1;
    if (navBarCurrentIndex < 0) {
      navBarCurrentIndex = screens.length - 1;
      changeBottomNav(navBarCurrentIndex);
    } else {
      changeBottomNav(navBarCurrentIndex);
    }
  }

  void changeBottomNav(int index) {
    navBarCurrentIndex = index;
    emit(CafeteriaChangeNavBarState());
  }

  void findAndReplaceMenu({
    required List<ProductDataModel> list,
  }) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < myCartDataModel!.products.length; j++) {
        if (list[i].id == myCartDataModel!.products[j].id) {
          list[i] = myCartDataModel!.products[j];
        }
      }
    }
  }

  Future getDateAndTimeNow() async {
    try {
      return await NTP.now();
    } catch (e) {
      return null;
    }
  }

  ProductModel? menuModel;

  Future<void> getMenuData() async {
    menuTimerFire = false;
    emit(CafeteriaMenuLoadingState());
    await SocketHelper.getData(query: "EID:$userId,DayMenu<EOF>").then((value) {
      menuModel = ProductModel.fromJson(value);
      if (myCartDataModel!.totalItems != 0) {
        findAndReplaceMenu(list: menuModel!.data!.food);
        findAndReplaceMenu(list: menuModel!.data!.snacks);
        findAndReplaceMenu(list: menuModel!.data!.beverages);
        findAndReplaceMenu(list: menuModel!.data!.desserts);
      }
      emit(CafeteriaMenuSuccessState());
    }).catchError((error) {
      menuModel = null;
      Timer(
        const Duration(seconds: 5),
        () async {
          menuTimerFire = true;
          emit(CafeteriaConnectionTimeoutState());
        },
      );
      print(error.toString());
      emit(CafeteriaMenuErrorState(error.toString()));
    });
  }

  List<HistoryDataModel> historySorting(
    List<HistoryDataModel> tmpHistorySorting,
  ) {
    var tmp;
    for (int i = 0; i < tmpHistorySorting.length; i++) {
      for (int j = 0; j < tmpHistorySorting.length - 1; j++) {
        if (int.parse(tmpHistorySorting[j].dateTime!.substring(4, 6)) <
            int.parse(tmpHistorySorting[j + 1].dateTime!.substring(4, 6))) {
          tmp = tmpHistorySorting[j];
          tmpHistorySorting[j] = tmpHistorySorting[j + 1];
          tmpHistorySorting[j + 1] = tmp;
        } else if (int.parse(tmpHistorySorting[j].dateTime!.substring(4, 6)) ==
            int.parse(tmpHistorySorting[j + 1].dateTime!.substring(4, 6))) {
          if (int.parse(tmpHistorySorting[j].dateTime!.substring(12, 14)) <
              int.parse(tmpHistorySorting[j + 1].dateTime!.substring(12, 14))) {
            tmp = tmpHistorySorting[j];
            tmpHistorySorting[j] = tmpHistorySorting[j + 1];
            tmpHistorySorting[j + 1] = tmp;
          } else if (int.parse(
                  tmpHistorySorting[j].dateTime!.substring(12, 14)) ==
              int.parse(tmpHistorySorting[j + 1].dateTime!.substring(12, 14))) {
            if (int.parse(tmpHistorySorting[j].dateTime!.substring(15, 17)) <
                int.parse(
                    tmpHistorySorting[j + 1].dateTime!.substring(15, 17))) {
              tmp = tmpHistorySorting[j];
              tmpHistorySorting[j] = tmpHistorySorting[j + 1];
              tmpHistorySorting[j + 1] = tmp;
            } else if (int.parse(
                    tmpHistorySorting[j].dateTime!.substring(15, 17)) ==
                int.parse(
                    tmpHistorySorting[j + 1].dateTime!.substring(15, 17))) {
              if (int.parse(tmpHistorySorting[j].dateTime!.substring(18, 20)) <
                  int.parse(
                      tmpHistorySorting[j + 1].dateTime!.substring(18, 20))) {
                tmp = tmpHistorySorting[j];
                tmpHistorySorting[j] = tmpHistorySorting[j + 1];
                tmpHistorySorting[j + 1] = tmp;
              }
            }
          }
        }
      }
    }
    return tmpHistorySorting;
  }

  HistoryModel? currentHistoryModel;

  Future<void> getCurrentHistoryData() async {
    currentHistoryTimerFire = false;
    emit(CafeteriaCurrentHistoryLoadingState());
    await SocketHelper.getData(query: "EID:$userId,CurrentHistory<EOF>")
        .then((value) {
      currentHistoryModel = HistoryModel.fromJson(value, "CurrentHistory");
      currentHistoryModel!.data = historySorting(currentHistoryModel!.data);
      emit(CafeteriaCurrentHistorySuccessState());
    }).catchError((error) {
      currentHistoryModel = null;
      Timer(
        const Duration(seconds: 5),
        () async {
          currentHistoryTimerFire = true;
          emit(CafeteriaConnectionTimeoutState());
        },
      );
      print(error.toString());
      emit(CafeteriaCurrentHistoryErrorState(error.toString()));
    });
  }

  HistoryModel? previousHistoryModel;

  Future<void> getPreviousHistoryData() async {
    previousHistoryTimerFire = false;
    emit(CafeteriaPreviousHistoryLoadingState());
    await SocketHelper.getData(
      query: "EID:$userId,PreviousHistory<EOF>",
    ).then((value) {
      previousHistoryModel = HistoryModel.fromJson(value, "PreviousHistory");
      previousHistoryModel!.data = historySorting(previousHistoryModel!.data);
      emit(CafeteriaPreviousHistorySuccessState());
    }).catchError((error) {
      previousHistoryModel = null;
      Timer(
        const Duration(seconds: 5),
        () async {
          previousHistoryTimerFire = true;
          emit(CafeteriaConnectionTimeoutState());
        },
      );
      print(error.toString());
      emit(CafeteriaPreviousHistoryErrorState(error.toString()));
    });
  }
  MyOrderModel? myOrderModel;
  MyOrderModel? myEditedOrderModel;

  Future<void> getMyOrderData() async {
    emit(CafeteriaMyOrderLoadingState());
    await SocketHelper.postData(
      query: "EID:$userId,RequestUpdateOrder<EOF>",
    ).then((value) {
      myOrderModel = MyOrderModel.fromJson(value);
      myEditedOrderModel = MyOrderModel(data: myOrderModel!.data);
      emit(CafeteriaMyOrderSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaMyOrderErrorState(error.toString()));
    });
  }

  String sendOrder({required List myCartList}) {
    String order = '';
    for (int index = 0; index < myCartList.length; index++) {
      if (myCartList[index].id! >= 2000 && myCartList[index].id! < 3000) {
        order = order +
            'LID:${myCartList[index].id!},LQty:${myCartList[index].counter}';
        if (index != myCartList.length - 1) {
          order = order + ",";
        }
      } else if (myCartList[index].id! >= 3000 &&
          myCartList[index].id! < 4000) {
        order = order +
            'BID:${myCartList[index].id!},BQty:${myCartList[index].counter}';
        if (index != myCartList.length - 1) {
          order = order + ",";
        }
      } else if (myCartList[index].id! >= 4000 &&
          myCartList[index].id! < 5000) {
        order = order +
            'DID:${myCartList[index].id!},DQty:${myCartList[index].counter}';
        if (index != myCartList.length - 1) {
          order = order + ",";
        }
      } else if (myCartList[index].id! >= 5000 &&
          myCartList[index].id! < 6000) {
        order = order +
            'SID:${myCartList[index].id!},SQty:${myCartList[index].counter}';
        if (index != myCartList.length - 1) {
          order = order + ",";
        }
      } else {
        print("لا يمكن اتمام االطلب برجاء المحاولة مرة اخرى");
      }
    }
    return order;
  }

  Future<void> refreshMyOrder() async {
    await getMyOrderData();
  }

  SubmitOrderResponseModel? submitOrderResponseModel;

  void postMyOrderData(BuildContext context) {
    emit(CafeteriaPostMyOrderLoadingState());
    SocketHelper.postData(
      query: "EID:$userId,Order,${sendOrder(
        myCartList: myCartDataModel!.products,
      )},EName:$userName,TCost:${myCartDataModel!.totalPrice}<EOF>",
    ).then((value) async {
      submitOrderResponseModel = SubmitOrderResponseModel.fromJson(value);
      emit(CafeteriaPostMyOrderSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaPostMyOrderErrorState(error.toString()));
    });
  }

  EditOrderResponseModel? editOrderResponseModel;

  void editMyOrderData() {
    emit(CafeteriaEditMyOrderLoadingState());
    SocketHelper.postData(
      query: "EID:$userId,UpdateOrder,${sendOrder(
        myCartList: myEditedOrderModel!.data!.orderList,
      )},EName:$userName,TCost:${myEditedOrderModel!.data!.totalPrice}<EOF>",
    ).then((value) async {
      editOrderResponseModel = EditOrderResponseModel.fromJson(value);
      emit(CafeteriaEditMyOrderSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaEditMyOrderErrorState(error.toString()));
    });
  }

  void reloadMyOrderData() {
    List<MyOrderListModel> originalOrderList = [];
    myOrderModel!.data!.orderList.forEach(
      (element) {
        originalOrderList.add(
          MyOrderListModel(
            image: element.image,
            name: element.name,
            counter: element.counter,
            id: element.id,
            price: element.price,
          ),
        );
      },
    );
    myEditedOrderModel!.data = MyOrderDataModel(
      dateTime: myOrderModel!.data!.dateTime,
      orderList: originalOrderList,
      orderNumber: myOrderModel!.data!.orderNumber,
      timeAuthorization: myOrderModel!.data!.timeAuthorization,
      totalPrice: myOrderModel!.data!.totalPrice,
    );
  }

  void deleteMyOrder() {
    myEditedOrderModel!.data!.orderList.forEach(
      (element) {
        element.counter = 0;
      },
    );
    myEditedOrderModel!.data!.totalPrice = 0.0;
    editMyOrderData();
  }

  void clearCard({
    required ProductDataModel card,
    required BuildContext context,
    required bool mayPop
  }) {
    myCartDataModel!.totalItems =
        myCartDataModel!.totalItems - (card.counter - 1);
    myCartDataModel!.totalPrice =
        myCartDataModel!.totalPrice - (card.price * (card.counter - 1));
    card.counter = 0;
    removeFromCart(card, context,mayPop);
    emit(CafeteriaChangeDecrementCounterSuccessState());
  }

  Widget shopItemRemoveIcon(var model, context, mayPop) {
    if (model.counter > 0 &&
        (dateAndTimeNow?.hour ?? errorTempTime) < timeLimitAllowed) {
      return GestureDetector(
        child: const Icon(
          Icons.remove_circle_outline,
          size: 40.0,
          color: Colors.redAccent,
        ),
        onLongPress: () {
          if (model.runtimeType == ProductDataModel) {
            clearCard(
              card: model,
              context: context,
              mayPop: mayPop
            );
          }
        },
        onTap: () => decrementMenuItemCounter(model, context, mayPop),
      );
    } else {
      return const IconButton(
        onPressed: null,
        icon: Icon(
          Icons.remove_circle_outline,
          size: 40.0,
          color: Colors.grey,
        ),
      );
    }
  }

  Widget shopItemAddIcon(var model) {
    if (model.counter < 1000 &&
        (dateAndTimeNow?.hour ?? errorTempTime) < timeLimitAllowed) {
      return IconButton(
        onPressed: () {
          incrementMenuItemCounter(model);
        },
        icon: const Icon(
          Icons.add_circle_outline,
          size: 40.0,
          color: defaultColor,
        ),
      );
    } else {
      return const IconButton(
        onPressed: null,
        icon: Icon(
          Icons.add_circle_outline,
          size: 40.0,
          color: Colors.grey,
        ),
      );
    }
  }

  void incrementMenuItemCounter(var model) {
    model.counter = model.counter + 1;
    if (model.runtimeType == MyOrderListModel) {
      myEditedOrderModel!.data!.totalPrice =
          myEditedOrderModel!.data!.totalPrice! + model.price;
    } else {
      addToCart(model);
    }

    emit(CafeteriaChangeIncrementCounterSuccessState());
  }

  void decrementMenuItemCounter(var model, context, bool mayPop) {
    model.counter = model.counter - 1;
    if (model.runtimeType == MyOrderListModel) {
      myEditedOrderModel!.data!.totalPrice =
          myEditedOrderModel!.data!.totalPrice! - model.price;
    } else {
      removeFromCart(model, context, mayPop);
    }
    emit(CafeteriaChangeDecrementCounterSuccessState());
  }

  MyCartModel? myCartDataModel;

  Future<void> getMyCartData() async {
    myCartDataModel = MyCartModel.fromJson(
      jsonDecode(
        CacheHelper.getData(
          key: "savedMyCartString",
        ),
      ),
    );
  }

  void addToCart(ProductDataModel menuModel) {
    if (menuModel.counter == 1) {
      myCartDataModel!.products.add(menuModel);
      getDateAndTimeNow().then(
        (value) {
          myCartDataModel!.lastUpdateTime = value.day;
        },
      );
    }
    myCartDataModel!.totalItems = myCartDataModel!.totalItems + 1;
    myCartDataModel!.totalPrice = myCartDataModel!.totalPrice + menuModel.price;
    String savedMyCartString = json.encode(myCartDataModel!.toMap());
    CacheHelper.saveData(key: 'savedMyCartString', value: savedMyCartString);
    print(savedMyCartString);
  }

  void removeFromCart(var menuModel, BuildContext context, bool mayPop) {
    if (menuModel.counter == 0) {
      myCartDataModel!.products.remove(menuModel);
      getDateAndTimeNow().then((value) {
        myCartDataModel!.lastUpdateTime = value.day;
      });
      if (myCartDataModel!.products.isEmpty && mayPop) {
        Navigator.of(context).maybePop();
      }
    }
    myCartDataModel!.totalItems = myCartDataModel!.totalItems - 1;
    myCartDataModel!.totalPrice = myCartDataModel!.totalPrice - menuModel.price;
    String savedMyCartString = json.encode(myCartDataModel!.toMap());
    CacheHelper.saveData(key: 'savedMyCartString', value: savedMyCartString);
  }

  clearMyCart() async {
    myCartDataModel = MyCartModel.clear();
    await CacheHelper.removeData(key: 'savedMyCartString').then((value) async {
      emit(ClearMyCartSuccessState());
    });
  }

  Future<void> getAppData() async {
    await getDateAndTimeNow()
        .then((value) => dateAndTimeNow = value)
        .timeout(const Duration(seconds: 2))
        .catchError((error) {});

    await getMyOrderData();
    if (CacheHelper.getData(key: "savedMyCartString") != null) {
      await getMyCartData();
      if (myCartDataModel!.lastUpdateTime != dateAndTimeNow?.day &&
          myCartDataModel!.lastUpdateTime != 0) {
        await clearMyCart();
      }
    } else {
      myCartDataModel = MyCartModel.clear();
    }
    await getMenuData();
    await getPreviousHistoryData();
    await getCurrentHistoryData();
    qrImage = getQrImage();
  }

  String getQrCodeDataReady({
    required String name,
    required String userId,
  }) {
    List<dynamic> asciiArray = "Name is:$name \nUserID is:$userId".codeUnits;
    List<int> asciiArrayAfterMod = [];
    for (var value in asciiArray) {
      asciiArrayAfterMod.add(((value + 5) * 5) - 55);
    }
    final String qrData = String.fromCharCodes(asciiArrayAfterMod);
    return qrData;
  }

  Widget getQrImage() => QrImage(
        data: getQrCodeDataReady(
          name: userName ?? "",
          userId: userId ?? "",
        ),
        errorCorrectionLevel: 3,
        version: QrVersions.auto,
        embeddedImage: const AssetImage('assets/images/Aio_Logo_original.png'),
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(80, 80),
        ),
      );
  final imagePicker = ImagePicker();
  late File pickedImagePath;

  takeImageFromCamera({
    required bool isProfilePicture,
  }) async {
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );
    if (pickedImage != null) {
      pickedImagePath = File(pickedImage.path);
      await uploadFileToFirebase(
        newImage: pickedImagePath,
        isProfilePicture: isProfilePicture,
      );
    } else {
      emit(CafeteriaChangeProfileImageErrorState());
    }
  }

  chooseImageFromGallery({
    required bool isProfilePicture,
  }) async {
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage != null) {
      pickedImagePath = File(pickedImage.path);
      uploadFileToFirebase(
        newImage: pickedImagePath,
        isProfilePicture: isProfilePicture,
      ).then(
        (value) => emit(CafeteriaChangeCoverImageSuccessState()),
      );
    } else {
      emit(CafeteriaChangeCoverImageErrorState());
    }
  }

  deleteImage({
    required bool isProfilePicture,
  }) {
    if (isProfilePicture) {
      FirebaseStorage.instance
          .refFromURL(userProfileImage!)
          .delete()
          .then((value) {
            CacheHelper.removeData(key: 'profileImageUrl');
            userProfileImage = '';
          })
          .then((value) => emit(CafeteriaRemoveImageSuccessState()))
          .catchError((error) {
            print(error.toString());
            emit(CafeteriaRemoveImageErrorState(error.toString()));
          });
    } else {
      FirebaseStorage.instance
          .refFromURL(userCoverImage!)
          .delete()
          .then((value) {
            CacheHelper.removeData(key: 'coverImageUrl');
            userCoverImage = '';
          })
          .then((value) => emit(CafeteriaRemoveImageSuccessState()))
          .catchError((error) {
            print(error.toString());
            emit(CafeteriaRemoveImageErrorState(error.toString()));
          });
    }
  }

  Future uploadFileToFirebase({
    required File newImage,
    required bool isProfilePicture,
  }) async {
    FirebaseStorage storageReference = FirebaseStorage.instance;

    if (isProfilePicture) {
      Reference ref = storageReference.ref().child(
            'ProfilesPics/$userName:$userId',
          );
      UploadTask uploadTask = ref.putFile(newImage);
      await uploadTask.then((res) {
        res.ref.getDownloadURL().then((fileURL) {
          userProfileImage = fileURL;
          CacheHelper.saveData(key: 'profileImageUrl', value: fileURL).then(
            (value) {
              emit(CafeteriaUploadProfileImageToFirebaseSuccessState());
            },
          );
        });
      }).catchError((error) {
        print(error.toString());
        emit(CafeteriaUploadProfileImageToFirebaseErrorState(error.toString()));
      });
    } else {
      Reference ref = storageReference.ref().child(
            'drawerBGimages/$userName:$userId',
          );
      UploadTask uploadTask = ref.putFile(newImage);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((fileURL) {
          userCoverImage = fileURL;
          CacheHelper.saveData(key: 'coverImageUrl', value: fileURL).then(
            (value) {
              emit(CafeteriaUploadCoverImageToFirebaseSuccessState());
            },
          );
        });
      }).catchError((error) {
        print(error.toString());
        emit(CafeteriaUploadCoverImageToFirebaseErrorState(error.toString()));
      });
    }
  }

  List<ProductDataModel> searchList = [];

  void findMatch({
    required List<ProductDataModel> list,
    required String text,
  }) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].name!.contains(text)) {
        searchList.add(list[i]);
      }
    }
  }

  void searchInMenu({
    required String text,
  }) {
    emit(CafeteriaSearchLoadingState());
    searchList = [];
    findMatch(
      list: menuModel!.data!.food,
      text: text,
    );
    findMatch(
      list: menuModel!.data!.snacks,
      text: text,
    );
    findMatch(
      list: menuModel!.data!.beverages,
      text: text,
    );
    findMatch(
      list: menuModel!.data!.desserts,
      text: text,
    );
    searchList.forEach((element) {
      print(element.name);
    });
    if (searchList.isNotEmpty) {
      emit(CafeteriaSearchSuccessState());
    } else {
      emit(CafeteriaSearchErrorState());
    }
  }
}
