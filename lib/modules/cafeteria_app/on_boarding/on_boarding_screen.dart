import 'package:cafeteriat/layout/cafeteria_app/cafeteria_app_layout.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/cubit/cubit.dart';
import 'package:cafeteriat/shared/cubit/states.dart';
import 'package:cafeteriat/shared/network/local/cache_helper.dart';
import 'package:cafeteriat/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingModel {
  final String image;
  final String screenTitle;
  final String screenBody;

  OnBoardingModel({
    required this.image,
    required this.screenTitle,
    required this.screenBody,
  });
}

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<OnBoardingModel> boardingList = [
          OnBoardingModel(
            image: "assets/images/on_boarding_0.JPG",
            screenTitle: 'مرحباً بك في تطبيق ',
            screenBody: 'تعرف على التطبيق من خلال الصور التالية',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_1.JPG",
            screenTitle: '',
            screenBody: 'تنقل بين انواع الأكل المختلفة لإختيار وجبتك المفضلة',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_2.JPG",
            screenTitle: '',
            screenBody: 'قم بإضافة او حذف الطلبات من عربتك',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_3.JPG",
            screenTitle: '',
            screenBody:
                ' بعد اختيار طلبك انتقل إلى صفحة سلتي لمراجعة وتأكيد الطلب',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_4.JPG",
            screenTitle: '',
            screenBody: 'تفاصيل صفحة سلتي',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_5.JPG",
            screenTitle: '',
            screenBody:
                'إضغط تأكيد بعد مراجعة طلبك جيداً مع العلم انه سوف يتم خصم إجمالي الطلب من مرتبك الخاص',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_6.JPG",
            screenTitle: '',
            screenBody: 'إستخدم رقم طلبك لتسهيل عملية الإستلام',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_7.JPG",
            screenTitle: '',
            screenBody:
                'هذا الكود خاص بك ولا تقم بمشاركته مع أحد إلا للشخص المسئول عن تسليم الطلبات',
          ),
          OnBoardingModel(
            image: "assets/images/on_boarding_10.JPG",
            screenTitle: '',
            screenBody: 'برجاء إختيار الواجهة المفضلة لديك',
          ),
        ];
        var cubit = AppCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 35.0,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0, top: 10),
                child: defaultTextButton(
                  text: 'تخطي',
                  onPressed: () => cubit.onBoardingSubmit(context),
                ),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    itemBuilder: (context, index) =>
                        buildBoardingItem(index, boardingList, context),
                    itemCount: boardingList.length,
                    physics: const BouncingScrollPhysics(),
                    reverse: true,
                    onPageChanged: (index) {
                      if (index == boardingList.length - 1) {
                        cubit.changePageViewIndex(
                          isLastPageView: true,
                        );
                      } else {
                        cubit.changePageViewIndex(
                          isLastPageView: false,
                        );
                      }
                    },
                    controller: cubit.boardingController,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      mini: true,
                      child: const Icon(
                        Icons.arrow_back_ios,
                        size: 20.0,
                      ),
                      onPressed: () {
                        if (cubit.isLastIndex) {
                          cubit.onBoardingSubmit(context);
                        } else {
                          cubit.nextOnBoardingPage();
                        }
                      },
                    ),
                    const Spacer(),
                    SmoothPageIndicator(
                      controller: cubit.boardingController,
                      effect: const ExpandingDotsEffect(
                        dotColor: Colors.grey,
                        activeDotColor: defaultColor,
                        dotHeight: 10.0,
                        expansionFactor: 4,
                        dotWidth: 10.0,
                        spacing: 5.0,
                      ),
                      count: boardingList.length,
                      textDirection: TextDirection.rtl,
                      onDotClicked: (index) {
                        cubit.animateToNextOnBoardingPage(index: index);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildOnBoardingPage(
      int index, List<OnBoardingModel> boardingList, BuildContext context) {
    if (index == boardingList.length - 1) {
      return Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                boardingList[index].image,
              ),
            ),
            Column(
              children: [
                Switch(
                  value: !(AppCubit.get(context).isDarkMode),
                  onChanged: (value) {
                    AppCubit.get(context).changeAppThemeMode();
                  },
                  activeColor: Colors.amber,
                ),
                AppCubit.get(context).isDarkMode
                    ? const Icon(
                        Icons.dark_mode,
                        size: 30.0,
                      )
                    : const Icon(
                        Icons.light_mode,
                        color: Colors.amber,
                        size: 30.0,
                      ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Expanded(
        child: Center(
          child: Image(
            image: AssetImage(
              boardingList[index].image,
            ),
          ),
        ),
      );
    }
  }

  Widget buildBoardingItem(int index, List<OnBoardingModel> boardingList,
          BuildContext context) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildOnBoardingPage(index, boardingList, context),
          const SizedBox(
            height: 5.0,
          ),
          if (boardingList[index].screenTitle.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (index == 0)
                  const Text(
                    'كافتريتي',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 23.0, color: Colors.amber),
                  ),
                Text(
                  boardingList[index].screenTitle,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontSize: 23.0,
                  ),
                ),
              ],
            ),
          const SizedBox(
            height: 10.0,
          ),
          Container(
            height: 56.0,
            alignment: Alignment.centerRight,
            child: Text(
              boardingList[index].screenBody,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      );
}
