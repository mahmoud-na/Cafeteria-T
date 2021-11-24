import 'package:cached_network_image/cached_network_image.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/cubit.dart';
import 'package:cafeteriat/layout/cafeteria_app/cubit/states.dart';
import 'package:cafeteriat/shared/components/components.dart';
import 'package:cafeteriat/shared/components/constants.dart';
import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

class profileScreen extends StatelessWidget {
  profileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CafeteriaCubit, CafeteriaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = CafeteriaCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text("بياناتي"),
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
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 210.0,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Align(
                        alignment: AlignmentDirectional.topCenter,
                        child: GestureDetector(
                          onTap: () {
                            selectImageSource(
                              platformType: cubit.platFormType,
                              context: context,
                              cubit: cubit,
                              isProfilePicture: false,
                            );
                          },
                          child: SizedBox(
                            height: 160.0,
                            child: CachedNetworkImage(
                              imageUrl:
                                  userCoverImage != null ? userCoverImage! : '',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ),
                                    topRight: Radius.circular(
                                      10.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => Container(
                                height: 131.0,
                                width: 131.0,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 4,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.black12,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ),
                                    topRight: Radius.circular(
                                      10.0,
                                    ),
                                  ),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                        'assets/images/DrawerBackground.jpg'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 68.0,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: GestureDetector(
                          onTap: () {
                            selectImageSource(
                              platformType: cubit.platFormType,
                              context: context,
                              cubit: cubit,
                              isProfilePicture: true,
                            );
                          },
                          child: CachedNetworkImage(
                            imageUrl: userProfileImage != null
                                ? userProfileImage!
                                : "",
                            imageBuilder: (context, imageProvider) => Container(
                              height: 128.0,
                              width: 128.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              height: 131.0,
                              width: 131.0,
                              child: const CircularProgressIndicator(
                                strokeWidth: 4,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                shape: BoxShape.circle,
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 128.0,
                              height: 128.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                shape: BoxShape.circle,
                              ),
                              child: const Image(
                                image: AssetImage('assets/images/person.png'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 7.0,
                ),
                Center(
                  child: Text(
                    userName!,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.black,
                      width: 10.0,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: qrImage,
                ),
                Text(
                  'قم بمسح هذا الكود للإستلام.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future selectImageSource({
    required String platformType,
    required context,
    required CafeteriaCubit cubit,
    required bool isProfilePicture,
  }) {
    switch (platformType) {
      case 'ios':
        {
          return showCupertinoModalPopup(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: CupertinoActionSheet(
                actions: [
                  CupertinoActionSheetAction(
                    child: const Text('الكاميرا'),
                    onPressed: () {
                      Navigator.pop(context);
                      cubit.takeImageFromCamera(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('الصور'),
                    onPressed: () async {
                      Navigator.pop(context);
                      await cubit.chooseImageFromGallery(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                  ),
                  CupertinoActionSheetAction(
                    child: const Text('إحذف الصورة'),
                    onPressed: () {
                      Navigator.pop(context);
                      cubit.deleteImage(isProfilePicture: isProfilePicture);
                    },
                  ),
                ],
              ),
            ),
          );
        }
      case 'android':
        {
          return showModalBottomSheet(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                children: [
                  defaultListTile(
                    title: 'الكاميرا',
                    onTap: () {
                      Navigator.pop(context);
                      cubit.takeImageFromCamera(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
                  defaultListTile(
                    title: 'الصور',
                    onTap: () {
                      Navigator.pop(context);
                      cubit.chooseImageFromGallery(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                    icon: const Icon(
                      Icons.photo_album,
                    ),
                  ),
                  defaultListTile(
                    title: 'إحذف الصورة',
                    onTap: () {
                      Navigator.pop(context);
                      cubit.deleteImage(isProfilePicture: isProfilePicture);
                    },
                    icon: const Icon(
                      Icons.broken_image_outlined,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      default:
        {
          return showModalBottomSheet(
            context: context,
            builder: (context) => Directionality(
              textDirection: TextDirection.rtl,
              child: Wrap(
                children: [
                  defaultListTile(
                    title: 'الكاميرا',
                    onTap: () {
                      Navigator.pop(context);
                      cubit.takeImageFromCamera(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                    ),
                  ),
                  defaultListTile(
                    title: 'الصور',
                    onTap: () {
                      Navigator.pop(context);
                      cubit.chooseImageFromGallery(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                    icon: const Icon(
                      Icons.photo_album,
                    ),
                  ),
                  defaultListTile(
                    title: 'إحذف الصورة',
                    onTap: () {
                      Navigator.pop(context);
                      cubit.deleteImage(
                        isProfilePicture: isProfilePicture,
                      );
                    },
                    icon: const Icon(
                      Icons.broken_image_outlined,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    }
  }
}
