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
                              condition:
                                  CafeteriaLoginCubit.get(context).isLoading,
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
                                        // 'هذا التطبيق خاص بالعاملين بالشركة العربية العالمية للبصريات لتحسين وتطوير آلية عمل كافتيريا الشركة وتجربة افضل للعاملين بها \n'
                                        //     '•	نبذة عن التطبيق\n'
                                        //     'هذا التطبيق ببساطة يأخذ الطلبات المقدمة عن طريق التطبيق ويرسلها إلى مطبخ الشركة ليتم إعداد وتحضير الوجبات وتقديمها للعاملين في اوقات واماكن الراحة الرسمية من خلال عملية مميكنة بالكامل حيث انك لن تكون مضطر إلى خوض تجربة بطيئة ومزدحمة لإختيار وجبتك المفضلة يومياً وبذلك نضمن لك إستلام طلبك في المعاد المحدد لذلك.\n'
                                        //     '•	كيف يمكنني إختيار طلبي؟\n'
                                        //     'عن الطريق الذهاب لتطبيق كافتيرتي وإدخال كود التفعيل الخص بك من ثم إختيار وجبتك. وبمجرد إختيار طلبك سيتم إتاحة لك إمكانية الدفع عن طريق زر إدفع في صفحة سلتي.\n'
                                        //     'برجاء الإنتباه جيداً من المهم التأكد من المعلومات المدخلة قبل تأكيد الدفع لأنه بمجرد الضغط على زر تأكيد الدفع سيتم خصم ثمن الوجبة المختارة من قبلك من مرتبك الشخصي مباشرةً مع سماحية تعديل أو حذف الطلب قبل الساعة التاسعة صباحاً فقط, ليقوم التطبيق بإرسال طلبك إلى المطبخ بحلول الساعة التاسعة صباحاً مباشرةً ليتم تحضيره وتقديمه لك في فترة الراحة.\n'
                                        //     '•	كم يكلفني إستخدام التطبيق؟\n'
                                        //     'تطبيق كافتيرتي لا يأخذ اي رسوم إضافية مقابل إستخدامك للتطبيق فقط ثمن الوجبة.\n'
                                        //     '•	هل يلزمني إستخدام التطبيق للإستفادة من ميزة الخصم المباشر من المرتب؟\n'
                                        //     'لا يلزمك, يمكنك الدفع لكافتيريا الشركة عن طريق الطلب من خلال التطبيق مباشرةً وسيتم تحضير الطلب لك مسبقاً لإستلامه في الميعاد المحدد لفترة الراحة, أو يمكنك الدفع عن طريق ال QR كود الخاص بك مباشرةً خلال فترة الراحة المحددة في الكافتيريا, حينها كل ما عليك فعله هو إختيار طلبك من ثم إظهر ال QR كود الخاص بك للشخص المسئول عن تسليم الطلبات لتستلم طلبك وسيتم خصم ثمن الطلب من مرتبك الخاص مباشرةً دون الحاجة إلى الدفع نقدياً. \n'
                                        //     '•	ماذا سوف يحدث إذا لم أتسلم طلبي؟\n'
                                        //     'حيث اننا نوفر لك سماحية حذف أو تعديل الطلب قبل الساعة التاسعة صباحاً فإذا لم تقم بإستلام طلبك في الميعاد المحدد سيتم ',
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
