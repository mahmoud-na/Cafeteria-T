import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/models/cafeteria_app/product_model.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({Key? key}) : super(key: key);
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("البحث"),
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
          body: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: defaultFormField(
                    textEditingController: searchController,
                    textInputType: TextInputType.text,
                    onChanged: (value) {
                      cubit.searchInMenu(
                        text: value,
                      );
                    },
                    labelText: 'إبحث عن أكلك',
                    prefixIcon: const Icon(Icons.search),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'ادخل ما تريد البحث عنه في مربع البحث';
                      }
                    },
                  ),
                ),
                if (searchController.text.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: LinearProgressIndicator(),
                  ),
                if (cubit.searchList.isNotEmpty &&
                    searchController.text.isNotEmpty)
                  Expanded(
                    child: shopItemBuilder(
                      model: cubit.menuModel!,
                      searchList: cubit.searchList,
                    ),
                  ),
                if (state is CafeteriaSearchErrorState)
                  Center(
                    child: Text(
                      "للأسف, لا يتوفر هذا المنتج لدينا",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget shopItem({
    required var menuModel,
  }) =>
      BlocConsumer<CafeteriaCubit, CafeteriaStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = CafeteriaCubit.get(context);
          return Column(
            children: [
              SizedBox(
                height: 150.0,
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 15.0,
                  margin: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        key: UniqueKey(),
                        imageUrl: menuModel.image,
                        height: 150.0,
                        width: 150.0,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          );
                        },
                        errorWidget: (context, url, error) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.black12,
                            ),
                            child: const Icon(
                              Icons.fastfood,
                              color: Colors.red,
                              size: 30,
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${menuModel.name}",
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Text(
                              "${menuModel.price}",
                              style: const TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: cubit.shopItemAddIcon(menuModel),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  width: 43.0,
                                  child: Text(
                                    "${menuModel.counter}",
                                    style: const TextStyle(
                                      fontSize: 24.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: cubit.shopItemRemoveIcon(
                                    menuModel,
                                    context,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );

  Widget shopItemBuilder({
    required ProductModel model,
    required List<ProductDataModel> searchList,
  }) {
    return ConditionalBuilder(
      condition: model != null,
      builder: (context) => ListView.separated(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        itemBuilder: (context, index) {
          if ((searchList[index].id! >= 2000) &&
              (searchList[index].id! < 3000)) {
            return shopItem(
              menuModel: findAndDisplayMenu(
                menuList: model.data!.food,
                searchItem: searchList[index],
              ),
            );
          } else if ((searchList[index].id! >= 3000) &&
              (searchList[index].id! < 4000)) {
            return shopItem(
              menuModel: findAndDisplayMenu(
                menuList: model.data!.beverages,
                searchItem: searchList[index],
              ),
            );
          } else if ((searchList[index].id! >= 4000) &&
              (searchList[index].id! < 5000)) {
            return shopItem(
              menuModel: findAndDisplayMenu(
                menuList: model.data!.desserts,
                searchItem: searchList[index],
              ),
            );
          } else {
            // print(searchList[index].name!);
            return shopItem(
              menuModel: findAndDisplayMenu(
                menuList: model.data!.snacks,
                searchItem: searchList[index],
              ),
            );
          }
        },
        separatorBuilder: (context, index) => myVDivider(),
        itemCount: searchList.length,
      ),
      fallback: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  findAndDisplayMenu({
    required List<ProductDataModel> menuList,
    required ProductDataModel searchItem,
  }) {
    for (int i = 0; i < menuList.length; i++) {
      if (menuList[i].id == searchItem.id) {
        return menuList[i];
      }
    }
  }
}
