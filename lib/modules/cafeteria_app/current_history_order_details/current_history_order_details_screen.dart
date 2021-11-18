import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/history_model.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentHistoryOrderDetailsScreen extends StatelessWidget {
  HistoryDataModel? historyOrderDetailsModel;

  CurrentHistoryOrderDetailsScreen({
    required this.historyOrderDetailsModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("تفاصيل الطلب"),
            titleSpacing: 5.0,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                IconBroken.Arrow___Right_2,
              ),
            ),
          ),
          body: Column(
            children: [
              Text(
                dateFormatting(historyOrderDetailsModel!),
                style: Theme.of(context).textTheme.bodyText1,
              ),
              myVDivider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "رقم الطلب: ",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    "${historyOrderDetailsModel!.orderNumber}",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
              myVDivider(),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              "الصنف",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "الكمية",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "السعر",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "التسليم",
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Expanded(
                      child: historyOrderDetailsBuilder(
                        historyOrderDetailsListModel: historyOrderDetailsModel,
                      ),
                    ),
                  ],
                ),
              ),
              myVDivider(),
              Padding(
                padding: const EdgeInsets.only(
                  right: 20.0,
                  top: 20.0,
                ),
                child: Row(
                  children: [
                    Text(
                      "السعر الكلي: ",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Text(
                      "${historyOrderDetailsModel!.price}",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35.0,
              )
            ],
          ),
        );
      },
    );
  }
}
