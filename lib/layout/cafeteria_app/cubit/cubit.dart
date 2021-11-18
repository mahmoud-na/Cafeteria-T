import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/history_model.dart';
import 'package:cafeteriat/models/cafeteria_app/my_cart_model.dart';
import 'package:cafeteriat/models/cafeteria_app/my_order_model.dart';
import 'package:cafeteriat/models/cafeteria_app/product_model.dart';
import 'package:cafeteriat/models/cafeteria_app/submit_order_response_model.dart';
import 'package:cafeteriat/models/cafeteria_app/user_model.dart';
import 'package:cafeteriat/modules/cafeteria_app/dessert/desserts_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/drinks/drinks_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/food/food_screen.dart';
import 'package:cafeteriat/modules/cafeteria_app/snacks/snacks_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/network/remote/socket_helper.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../cafeteria_app_layout.dart';

class CafeteriaCubit extends Cubit<CafeteriaStates> {
  CafeteriaCubit() : super(CafeteriaInitialState());

  static CafeteriaCubit get(context) => BlocProvider.of(context);
  bool isMyOrder = true;
  int navBarCurrentIndex = 0;

  var platFormType = Platform.operatingSystem;

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

  ProductModel? menuModel;

  Future<void> getMenuData() async {
    emit(CafeteriaMenuLoadingState());
    await SocketHelper.getData(query: "EID:$uId,DayMenu<EOF>").then((value) {
      menuModel = ProductModel.fromJson(value);
      if (myCartDataModel!.totalItems != 0) {
        findAndReplaceMenu(list: menuModel!.data!.food);
        findAndReplaceMenu(list: menuModel!.data!.snacks);
        findAndReplaceMenu(list: menuModel!.data!.beverages);
        findAndReplaceMenu(list: menuModel!.data!.desserts);
      }
      emit(CafeteriaMenuSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaMenuErrorState(error.toString()));
    });
  }

  UserModel? userModel;

  Future<void> getUserData({
    required String activationCode,
  }) async {
    emit(CafeteriaUserDataLoadingState());
    await SocketHelper.getData(query: "EID:0,ACTCODE:$activationCode<EOF>")
        .then((value) {
      userModel = UserModel.fromJson(value);
      uId = userModel!.data!.userId!;
      if (CacheHelper.getData(key: 'profileImageUrl') != null) {
        userModel!.data!.profileImage =
            CacheHelper.getData(key: 'profileImageUrl');
      }
      if (CacheHelper.getData(key: 'coverImageUrl') != null) {
        userModel!.data!.coverImage = CacheHelper.getData(key: 'coverImageUrl');
      }
      emit(CafeteriaUserDataSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaUserDataErrorState(error.toString()));
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
    emit(CafeteriaCurrentHistoryLoadingState());
    await SocketHelper.getData(query: "EID:$uId,CurrentHistory<EOF>")
        .then((value) {
      currentHistoryModel = HistoryModel.fromJson(value, "CurrentHistory");
      currentHistoryModel!.data = historySorting(currentHistoryModel!.data);
      emit(CafeteriaCurrentHistorySuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaCurrentHistoryErrorState(error.toString()));
    });
  }

  HistoryModel? previousHistoryModel;

  Future<void> getPreviousHistoryData() async {
    emit(CafeteriaPreviousHistoryLoadingState());
    await SocketHelper.getData(
      query: "EID:$uId,PreviousHistory<EOF>",
    ).then((value) {
      previousHistoryModel = HistoryModel.fromJson(value, "PreviousHistory");
      previousHistoryModel!.data = historySorting(previousHistoryModel!.data);
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

  Future<void> getMyOrderData() async {
    emit(CafeteriaMyOrderLoadingState());
    await SocketHelper.getData(
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

  String sendOrder({required List<ProductDataModel> myCartList}) {
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

  void postMyOrderData(BuildContext context) {
    emit(CafeteriaPostMyOrderLoadingState());
    SocketHelper.postData(
      query: "EID:$uId,Order,${sendOrder(
        myCartList: myCartDataModel!.products,
      )},EName:${userModel!.data!.name},TCost:${myCartDataModel!.totalPrice}<EOF>",
    ).then((value) {
      submitOrderResponseModel = SubmitOrderResponseModel.fromJson(value);
      print(submitOrderResponseModel!.data!.orderNumber);
      print(submitOrderResponseModel!.data!.errMsg);
      print(submitOrderResponseModel!.data!.orderValid);

      if (submitOrderResponseModel!.data!.orderValid == 'true') {
        CacheHelper.removeData(key: 'savedMyCartString').then((value) async {
          await getMenuData().then(
            (value) => emit(CafeteriaPostMyOrderSuccessState()),
          );
        });
        clearMyCart();
        Navigator.pop(context);
      }
      emit(CafeteriaPostMyOrderSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CafeteriaPostMyOrderErrorState(error.toString()));
    });
  }

  Widget shopItemRemoveIcon(var menuModel, context) {
    if (menuModel.counter > 0) {
      return IconButton(
        onPressed: () {
          decrementMenuItemCounter(menuModel, context);
        },
        icon: const Icon(Icons.remove_circle_outline,
            size: 40.0, color: Colors.redAccent),
      );
    } else {
      return const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.remove_circle_outline,
            size: 40.0,
            color: Colors.grey,
          ));
    }
  }

  Widget shopItemAddIcon(var menuModel) {
    if (menuModel.counter < 1000) {
      return IconButton(
        onPressed: () {
          incrementMenuItemCounter(menuModel);
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

  void changeBottomNav(int index) {
    navBarCurrentIndex = index;
    emit(CafeteriaChangeNavBarState());
  }

  void incrementMenuItemCounter(ProductDataModel menuModel) {
    menuModel.counter = menuModel.counter + 1;

    addToCart(menuModel);

    emit(CafeteriaChangeIncrementCounterSuccessState());
  }

  void decrementMenuItemCounter(ProductDataModel menuModel, context) {
    menuModel.counter = menuModel.counter - 1;
    removeFromCart(menuModel, context);
    emit(CafeteriaChangeDecrementCounterSuccessState());
  }

  MyCartModel? myCartDataModel;

  Future<void> getMyCartData() async {
    if (CacheHelper.getData(key: "savedMyCartString") != null) {
      myCartDataModel = MyCartModel.fromJson(
        jsonDecode(
          CacheHelper.getData(
            key: "savedMyCartString",
          ),
        ),
      );
    } else {
      clearMyCart();
    }
  }

  void addToCart(ProductDataModel menuModel) {
    if (menuModel.counter == 1) {
      myCartDataModel!.products.add(menuModel);
    }
    myCartDataModel!.totalItems = myCartDataModel!.totalItems + 1;
    myCartDataModel!.totalPrice = myCartDataModel!.totalPrice + menuModel.price;
    String savedMyCartString = json.encode(myCartDataModel!.toMap());
    CacheHelper.saveData(key: 'savedMyCartString', value: savedMyCartString);
    print(savedMyCartString);
  }

  void removeFromCart(ProductDataModel menuModel, BuildContext context) {
    if (menuModel.counter == 0) {
      myCartDataModel!.products.remove(menuModel);
      if (myCartDataModel!.products.isEmpty) {
        Navigator.of(context).maybePop();
      }
    }

    myCartDataModel!.totalItems = myCartDataModel!.totalItems - 1;
    myCartDataModel!.totalPrice = myCartDataModel!.totalPrice - menuModel.price;
    String savedMyCartString = json.encode(myCartDataModel!.toMap());
    CacheHelper.saveData(key: 'savedMyCartString', value: savedMyCartString);
    print(savedMyCartString);
  }

  void clearMyCart() {
    Map<String, dynamic> myCart = {
      "totalItems": 0,
      "totalPrice": 0.0,
      "list": [],
    };
    myCartDataModel = MyCartModel.fromJson(myCart);
  }

  void getAppData() async {
    await getUserData(activationCode: "jm");
    await getMyCartData();
    await getMenuData();
    await getPreviousHistoryData();
    await getCurrentHistoryData();
  }

  String getQrCodeDataReady({
    required String name,
    required String userId,
  }) {
    List<dynamic> asciiArray = "Name is:$name \nUserID is:$userId".codeUnits;
    List<int> asciiArrayAfterMod = [];
    asciiArray.forEach((value) {
      asciiArrayAfterMod.add(((value + 5) * 5) - 55);
    });
    final String qrData = String.fromCharCodes(asciiArrayAfterMod);
    return qrData;
  }

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
          .refFromURL(userModel!.data!.profileImage)
          .delete()
          .then((value) {
            CacheHelper.removeData(key: 'profileImageUrl');
            userModel!.data!.profileImage = '';
          })
          .then((value) => emit(CafeteriaRemoveImageSuccessState()))
          .catchError((error) {
            print(error.toString());
            emit(CafeteriaRemoveImageErrorState(error.toString()));
          });
    } else {
      FirebaseStorage.instance
          .refFromURL(userModel!.data!.coverImage)
          .delete()
          .then((value) {
            CacheHelper.removeData(key: 'coverImageUrl');
            userModel!.data!.coverImage = '';
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
            'ProfilesPics/${userModel!.data!.name}:${userModel!.data!.userId}',
          );
      UploadTask uploadTask = ref.putFile(newImage);
      await uploadTask.then((res) {
        res.ref.getDownloadURL().then((fileURL) {
          userModel!.data!.profileImage = fileURL;

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
            'drawerBGimages/${userModel!.data!.name}:${userModel!.data!.userId}',
          );
      UploadTask uploadTask = ref.putFile(newImage);
      uploadTask.then((res) {
        res.ref.getDownloadURL().then((fileURL) {
          userModel!.data!.coverImage = fileURL;
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
}
