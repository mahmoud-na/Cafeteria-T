import 'dart:convert';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/modules/cafeteria_app/login/cubit/states.dart';
import 'package:cafeteriat/modules/cafeteria_app/on_boarding/on_boarding_screen.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';

class CafeteriaLoginScreen extends StatelessWidget {
  CafeteriaLoginScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  TextEditingController activationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CafeteriaLoginCubit(),
      child: BlocConsumer<CafeteriaLoginCubit, CafeteriaLoginStates>(
        listener: (context, state) {
          // if(state is CafeteriaUserDataLoadingState ){
          //   CafeteriaLoginCubit.get(context).
          // }
          if (state is CafeteriaUserDataSuccessState) {
            if (state.userModel.data!.activationValid == true) {
              print('=======================================');
              print(state.userModel.data!.name);
              print('=======================================');
              print(state.userModel.data!.userId);
              print('=======================================');

              CacheHelper.saveData(
                key: 'userData',
                value: json.encode(
                  CafeteriaLoginCubit.get(context).userModelToMap(
                    userID: state.userModel.data!.userId!,
                    userName: state.userModel.data!.name!,
                  ),
                ),
              ).then((value) async {
                userId = state.userModel.data!.userId!;
                userName = state.userModel.data!.name!;
                await CafeteriaLoginCubit.get(context).getUserImages(
                  userId: state.userModel.data!.userId!,
                  userName: state.userModel.data!.name!,
                );
                await CafeteriaCubit.get(context).getAppData();
                CafeteriaLoginCubit.get(context).isLoading = false;
                showToast(
                  msg: 'تم تسجيل الدخول بنجاح',
                  state: ToastStates.SUCCESS,
                );
                navigateAndReplace(context, OnBoardingScreen());
              });
            } else if (state.userModel.data!.activationValid == false) {
              CafeteriaLoginCubit.get(context).isLoading = false;
              showToast(
                msg: 'برجاء إدخال كود تفعيل صحيح',
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.0,
              ),
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 80.0,
                              backgroundColor:
                                  Theme.of(context).scaffoldBackgroundColor,
                              child: const Image(
                                image: AssetImage(
                                    'assets/images/Aio_Logo_original.png'),
                              ),
                            ),
                            const Text(
                              'الكافيتريا',
                              style: TextStyle(
                                fontFamily: 'ElMessiri',
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            defaultFormField(
                              textEditingController: activationController,
                              textInputType: TextInputType.visiblePassword,
                              labelText: 'كود التفعيل',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  CafeteriaLoginCubit.get(context)
                                      .changePasswordVisibilityState();
                                },
                                icon: CafeteriaLoginCubit.get(context).suffix,
                              ),
                              enableInteractiveSelection: true,
                              onFieldSubmitted: (value) {
                                if (formKey.currentState!.validate()) {
                                  CafeteriaLoginCubit.get(context).getUserData(
                                    activationCode: activationController.text,
                                  );
                                }
                              },
                              maxLength: 6,
                              obscureText: CafeteriaLoginCubit.get(context)
                                  .isPasswordVisible,
                              prefixIcon: const Icon(
                                Icons.person,
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'برجاء إدخال كود التفعيل';
                                }
                                // if(value.length<6){
                                //   return 'برجاء إدخال كود تفعيل صحيح مكون من ست أرقام';
                                // }
                              },
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            ConditionalBuilder(
                              condition: CafeteriaLoginCubit.get(context).isLoading,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                              fallback: (BuildContext context) => defaultButton(
                                context: context,
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await CafeteriaLoginCubit.get(context)
                                        .getUserData(
                                      activationCode: activationController.text
                                          .toUpperCase(),
                                    );
                                  }
                                },
                                text: 'تفعيل',
                                isUpperCase: true,
                                height: 50.0,
                              ),
                            ),
                            const SizedBox(
                              height: 15.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: defaultTextButton(
                                    text: 'اضغط هنا',
                                    onPressed: () {
                                      defaultShowDialog(
                                        content:
                                            'هذا التطبيق خاص بالعاملين بالشركة العربية العالمية للبصريات إذا كنت تعمل بالشركة ولا تملك كود التفعيل برجاء التوجه إلى قسم شئون العاملين لإستلام كودك',
                                        title:
                                            'الشركة العربية العالمية للبصريات',
                                        context: context,
                                        icon: const Image(
                                          image: AssetImage(
                                            'assets/images/Aio_Logo_original.png',
                                          ),
                                          height: 100.0,
                                          width:100.0,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const Text(
                                  'إذا كنت لا تمتلك كود تفعيل ',
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
