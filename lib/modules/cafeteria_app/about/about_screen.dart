import 'package:cafeteriat/shared/styles/icon_broken.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    bool state = false;
    int _current = 0;
    final CarouselController _controller = CarouselController();

    //
    // List<Widget> videosList = [
    //   Stack(
    //     alignment: Alignment.bottomLeft,
    //     children: [
    //       Container(
    //         color: Colors.amber,
    //         child: AspectRatio(
    //           aspectRatio: videoController.value.aspectRatio,
    //           child: VideoItems(
    //             videoPlayerController: VideoPlayerController.network(
    //               'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //             ),
    //             looping: false,
    //             autoplay: false,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   Stack(
    //     alignment: Alignment.bottomLeft,
    //     children: [
    //       Container(
    //         color: Colors.amber,
    //         child: AspectRatio(
    //           aspectRatio: videoController.value.aspectRatio,
    //           child: VideoItems(
    //             videoPlayerController: VideoPlayerController.network(
    //               'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //             ),
    //             looping: false,
    //             autoplay: false,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   Stack(
    //     alignment: Alignment.bottomLeft,
    //     children: [
    //       Container(
    //         color: Colors.amber,
    //         child: AspectRatio(
    //           aspectRatio: videoController.value.aspectRatio,
    //           child: VideoItems(
    //             videoPlayerController: VideoPlayerController.network(
    //               'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //             ),
    //             looping: false,
    //             autoplay: false,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   Stack(
    //     alignment: Alignment.bottomLeft,
    //     children: [
    //       Container(
    //         color: Colors.amber,
    //         child: AspectRatio(
    //           aspectRatio: videoController.value.aspectRatio,
    //           child: VideoItems(
    //             videoPlayerController: VideoPlayerController.network(
    //               'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //             ),
    //             looping: false,
    //             autoplay: false,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   Stack(
    //     alignment: Alignment.bottomLeft,
    //     children: [
    //       Container(
    //         color: Colors.amber,
    //         child: AspectRatio(
    //           aspectRatio: videoController.value.aspectRatio,
    //           child: VideoItems(
    //             videoPlayerController: VideoPlayerController.network(
    //               'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    //             ),
    //             looping: false,
    //             autoplay: false,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // ];
    List<ExpansionState> expansionList = [
      ExpansionState(
        headerName: 'شرح',
        index: 2,
        isExpanded: false,
        leading: const Icon(
          Icons.assignment_outlined,
          size: 30,
          color: Colors.grey,
        ),
      ),
      ExpansionState(
        headerName: 'نبذة عن التطبيق',
        index: 3,
        isExpanded: false,
        leading: const Icon(
          Icons.message_outlined,
          size: 30,
          color: Colors.grey,
        ),
      ),
    ];
    return Scaffold(
      appBar:  AppBar(
        title: const Text("حول التطبيق"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            // CarouselSlider(
            //   items: videosList,
            //   carouselController: _controller,
            //   options: CarouselOptions(
            //     viewportFraction: 0.76,
            //     height: 300,
            //     aspectRatio: 2,
            //     // autoPlay: true,
            //     enlargeCenterPage: true,
            //     onPageChanged: (index, reason) {
            //       setState(
            //             () {
            //           _current = index;
            //         },
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(
              height: 10.0,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: videosList.asMap().entries.map(
            //         (entry) {
            //       return GestureDetector(
            //         onTap: () => _controller.animateToPage(entry.key),
            //         child: Container(
            //           width: 8.0,
            //           height: 8.0,
            //           margin: const EdgeInsets.symmetric(horizontal: 4.0),
            //           decoration: BoxDecoration(
            //             shape: BoxShape.circle,
            //             color: (Theme.of(context).brightness == Brightness.dark
            //                 ? Colors.white
            //                 : Colors.black)
            //                 .withOpacity(
            //               _current == entry.key ? 0.9 : 0.4,
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ).toList(),
            // ),
            const SizedBox(
              height: 10.0,
            ),
            ExpansionPanelList.radio(
              dividerColor: Colors.transparent,
              elevation: 1,
              expansionCallback: (panelIndex, isExpand) {
                setState(
                      () {
                    expansionList[panelIndex].isExpanded = !isExpand;
                  },
                );
              },
              animationDuration: const Duration(
                milliseconds: 600,
              ),
              children: expansionList.map(
                    (widget) {
                  return ExpansionPanelRadio(
                    canTapOnHeader: true,
                    backgroundColor: Colors.grey[50],
                    value: widget.index,
                    headerBuilder: (context, isExpanded) {
                      return Container(
                        padding: const EdgeInsets.only(
                          left: 16,
                        ),
                        child: Row(
                          children: [
                            setHeaderWidget(widget),
                            const SizedBox(
                              width: 26,
                            ),
                            Expanded(
                              child: Text(
                                widget.headerName,
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    body: Container(
                      padding: const EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: const <Widget>[
                          // Container(
                          //   height: 400,
                          //   child: CarouselSlider(
                          //     items: videosList,
                          //     carouselController: _controller,
                          //     options: CarouselOptions(
                          //       height: 380,
                          //       autoPlay: true,
                          //       enlargeCenterPage: true,
                          //       onPageChanged: (index, reason) {
                          //         setState(() {
                          //           _current = index;
                          //         });
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: videosList.asMap().entries.map((entry) {
                          //     return GestureDetector(
                          //       onTap: () =>
                          //           _controller.animateToPage(entry.key),
                          //       child: Container(
                          //         width: 8.0,
                          //         height: 8.0,
                          //         margin: EdgeInsets.symmetric(horizontal: 4.0),
                          //         decoration: BoxDecoration(
                          //             shape: BoxShape.circle,
                          //             color: (Theme.of(context).brightness ==
                          //                         Brightness.dark
                          //                     ? Colors.white
                          //                     : Colors.black)
                          //                 .withOpacity(_current == entry.key
                          //                     ? 0.9
                          //                     : 0.4)),
                          //       ),
                          //     );
                          //   }).toList(),
                          // ),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
            const SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }


  setHeaderWidget(var widget) {
    return widget.leading;
  }
}

class ExpansionState {
  int index;
  String headerName;
  Widget? leading = Container();
  bool isExpanded;

  ExpansionState({
    required this.index,
    required this.headerName,
    this.leading,
    required this.isExpanded,
  });
}