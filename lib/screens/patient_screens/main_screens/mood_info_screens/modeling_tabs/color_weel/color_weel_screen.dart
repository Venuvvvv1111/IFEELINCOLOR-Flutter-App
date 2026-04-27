import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/assesment_controller.dart';
import 'package:ifeelin_color/controllers/patient_controllers/mood_info_controller/two_d_model_controller.dart';
import 'dart:async';

import 'package:ifeelin_color/utils/medial_query_util/media_query_util.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/constants/my_toast.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';
import 'package:ifeelin_color/utils/helpers/app_icons.dart';
import 'package:ifeelin_color/utils/helpers/custom_colors.dart';
import 'package:ifeelin_color/utils/widgets/speakable.dart';
import 'package:lottie/lottie.dart';
import 'package:readmore/readmore.dart';

class ColorWheelScreen extends StatefulWidget {
  final bool isAssesment;
  final bool isBodyAssesment;
  const ColorWheelScreen(
      {super.key, required this.isAssesment, required this.isBodyAssesment});

  @override
  ColorWheelScreenState createState() => ColorWheelScreenState();
}

class ColorWheelScreenState extends State<ColorWheelScreen> {
  StreamController<int> controller = StreamController<int>();
  var assessmentController = Get.put(AssesmentController());
  // var sendAlertController = Get.put(SendAlertController());
  var bodyController = Get.put(TwoDModelController());

  UserInfo userInfo = Get.put(UserInfo());
  final List<Map<String, String>> items = [
    {'emoji': '😊', 'title': 'Happy'},
    {'emoji': '😢', 'title': 'Sad'},
    {'emoji': '🤢', 'title': 'Disgusted'},
    {'emoji': '😡', 'title': 'Angry'},
    {'emoji': '😨', 'title': 'Fearful'},
    {'emoji': '😖', 'title': 'Bad'},
    {'emoji': '😲', 'title': 'Surprised'},
  ];

  final List<Color> itemColors = [
    const Color(0xFFFFD700),
    const Color(0xFF1E90FF),
    const Color(0xFF808080),
    const Color(0xFFFF0000),
    const Color(0xFFFF8C00),
    const Color(0xFF00A36C),
    const Color(0xFF8A2BE2),
  ];

  @override
  void dispose() {
    super.dispose();
    Get.delete<TwoDModelController>();
    Get.delete<AssesmentController>();
  }

  bool animationCompleted = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                const CircularContainerWithSectors(),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: MediaQuery.of(context).size.width / 1.4,
                  child: FortuneWheel(
                    selected: Stream.value(widget.isAssesment
                        ? assessmentController.colorValue.value == 7
                            ? 6
                            : assessmentController.colorValue.value
                        : bodyController.colorValue.value == 7
                            ? 6
                            : bodyController.colorValue.value),
                    items: [
                      for (var i = 0; i < itemColors.length; i++)
                        FortuneItem(
                          style: FortuneItemStyle(
                            textAlign: TextAlign.end,
                            color: itemColors[i],
                            borderColor: (widget.isAssesment
                                    ? assessmentController.colorCircle.value ==
                                        itemColors[i]
                                    : bodyController.colorCircle.value ==
                                        itemColors[i])
                                ? itemColors[i]
                                : Colors.white,
                            borderWidth: (widget.isAssesment
                                    ? assessmentController.colorCircle.value ==
                                        itemColors[i]
                                    : bodyController.colorCircle.value ==
                                        itemColors[i])
                                ? 10.0
                                : 8.0,
                          ),
                          child: Transform(
                            transform: Matrix4.identity()
                              ..scale(
                                (widget.isAssesment
                                        ? assessmentController
                                                .colorCircle.value ==
                                            itemColors[i]
                                        : bodyController.colorCircle.value ==
                                            itemColors[i])
                                    ? 1.1
                                    : 1.0,
                              )
                              ..setEntry(3, 2, 0.002)
                              ..rotateX((widget.isAssesment
                                      ? assessmentController
                                              .colorCircle.value ==
                                          itemColors[i]
                                      : bodyController.colorCircle.value ==
                                          itemColors[i])
                                  ? 0.1
                                  : 0.0),
                            alignment: Alignment.center,
                            child: _buildFortuneItem(
                              items[i]['emoji']!,
                              items[i]['title']!,
                              itemColors[i],
                              context,
                            ),
                          ),
                        ),
                    ],
                    onAnimationEnd: () {
                      setState(() {
                        animationCompleted = true;
                      });
                      final newValue = widget.isAssesment
                          ? assessmentController.colorValue.value
                          : bodyController.colorValue.value;
                      if (kDebugMode) {
                        print("new value $newValue ${controller.stream}");
                      }
                    },
                    indicators: const <FortuneIndicator>[
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ],
                    onFling: () {
                      // final newValue = 3;
                      // print("new value $newValue ${controller.stream}");
                      // controller.add(newValue);
                    },
                    physics: CircularPanPhysics(),
                  ),
                ),
                Container(
                  height: 110,
                  width: 110,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1)),
                ),
                Positioned(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        AppIcons.colorWeelIcon,
                        fit: BoxFit.contain,
                        height: 100,
                        width: 100,
                      ),
                      const Text(
                        'Color weel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (animationCompleted)
                  Positioned(
                      top: 0,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Lottie.asset(
                            'assets/animations/flowers.json',
                            fit: BoxFit.cover,
                            repeat: false,
                          )))
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Colors.black)),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: !animationCompleted
                        ? Column(
                            children: [
                              Lottie.asset(
                                'assets/animations/search_result.json',
                                height: 150.0,
                                width: 150.0,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text("Please wait for result")
                            ],
                          )
                        : Obx(() {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                widget.isAssesment
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(() {
                                            return CircleAvatar(
                                              radius: 10,
                                              backgroundColor: assessmentController
                                                          .colorValue.value ==
                                                      0
                                                  ? itemColors[0]
                                                  : assessmentController
                                                              .colorValue
                                                              .value ==
                                                          1
                                                      ? itemColors[1]
                                                      : assessmentController
                                                                  .colorValue
                                                                  .value ==
                                                              2
                                                          ? itemColors[2]
                                                          : assessmentController
                                                                      .colorValue
                                                                      .value ==
                                                                  3
                                                              ? itemColors[3]
                                                              : assessmentController
                                                                          .colorValue
                                                                          .value ==
                                                                      4
                                                                  ? itemColors[
                                                                      4]
                                                                  : assessmentController
                                                                              .colorValue
                                                                              .value ==
                                                                          5
                                                                      ? itemColors[
                                                                          5]
                                                                      : const Color(
                                                                          0xFFffffff),
                                            );
                                          }),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Speakable(
                                            text: assessmentController
                                                        .colorCategory.value ==
                                                    ''
                                                ? "Error"
                                                : "${assessmentController.mainColor.value} (${assessmentController.colorCategory.value})",
                                            child: Text(
                                              assessmentController.colorCategory
                                                          .value ==
                                                      ''
                                                  ? "Error"
                                                  : "${assessmentController.mainColor.value} (${assessmentController.colorCategory.value})",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                          ),
                                        ],
                                      )
                                    : widget.isBodyAssesment
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Obx(() {
                                                return CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor: bodyController
                                                              .colorValue
                                                              .value ==
                                                          0
                                                      ? itemColors[0]
                                                      : bodyController
                                                                  .colorValue
                                                                  .value ==
                                                              1
                                                          ? itemColors[1]
                                                          : bodyController
                                                                      .colorValue
                                                                      .value ==
                                                                  2
                                                              ? itemColors[2]
                                                              : bodyController
                                                                          .colorValue
                                                                          .value ==
                                                                      3
                                                                  ? itemColors[
                                                                      3]
                                                                  : bodyController
                                                                              .colorValue
                                                                              .value ==
                                                                          4
                                                                      ? itemColors[
                                                                          4]
                                                                      : bodyController.colorValue.value ==
                                                                              5
                                                                          ? itemColors[
                                                                              5]
                                                                          : bodyController.colorValue.value == 6
                                                                              ? itemColors[6]
                                                                              : const Color(0xFFFFFFFF),
                                                );
                                              }),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Speakable(
                                                text: bodyController
                                                            .colorCategory
                                                            .value ==
                                                        ''
                                                    ? 'Error'
                                                    : "${bodyController.mainColor.value} (${bodyController.colorCategory.value})",
                                                child: Text(
                                                  bodyController.colorCategory
                                                              .value ==
                                                          ''
                                                      ? 'Error'
                                                      : "${bodyController.mainColor.value} (${bodyController.colorCategory.value})",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                const SizedBox(height: 16),
                                Obx(() {
                                  return Speakable(
                                    text: widget.isAssesment
                                        ? assessmentController
                                                    .colorSubtitle.value ==
                                                ''
                                            ? 'Sorry! Please submit new assesment.'
                                            : assessmentController
                                                .colorSubtitle.value
                                        : widget.isBodyAssesment
                                            ? bodyController
                                                        .colorSubtitle.value ==
                                                    ''
                                                ? 'Sorry! Please submit new assesment.'
                                                : bodyController
                                                    .colorSubtitle.value
                                            : "Sorry! Please submit new assesment.",
                                    child: ReadMoreText(
                                      widget.isAssesment
                                          ? assessmentController
                                                      .colorSubtitle.value ==
                                                  ''
                                              ? 'Sorry! Please submit new assesment.'
                                              : assessmentController
                                                  .colorSubtitle.value
                                          : widget.isBodyAssesment
                                              ? bodyController.colorSubtitle
                                                          .value ==
                                                      ''
                                                  ? 'Sorry! Please submit new assesment.'
                                                  : bodyController
                                                      .colorSubtitle.value
                                              : "Sorry! Please submit new assesment.",
                                      trimLines: 4,
                                      // colorClickableText: Colors.white,
                                      colorClickableText: Colors.black,
                                      trimMode: TrimMode.Line,
                                      trimCollapsedText: '   Read more..',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(fontSize: 13),
                                      trimExpandedText: '    Read less..',
                                      moreStyle: const TextStyle(
                                          color: newIdentitiyPrimaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                      lessStyle: const TextStyle(
                                          color: newIdentitiyPrimaryColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 20,
                                ),
                                Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQueryUtil.size(context).width /
                                                3,
                                        child: widget.isAssesment
                                            ? ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        // assessmentController
                                                        //             .mainColor
                                                        //             .value !=
                                                        //         "Black"
                                                        //     ? greyColor
                                                        //         .withValues(
                                                        //             alpha: 0.3)
                                                        //     :
                                                        alertColor),
                                                onPressed: () {
                                                  // if (assessmentController
                                                  //         .mainColor.value ==
                                                  //     "Black") {
                                                  Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .sendAlertscreen);
                                                  // } else {
                                                  //   MyToast.showGetToast(
                                                  //       title: 'Safe 😊',
                                                  //       message:
                                                  //           'You are already safe from emergency',
                                                  //       backgroundColor:
                                                  //           Colors.green,
                                                  //       color: whiteColor);
                                                  // }
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .dnd_forwardslash_outlined),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text('Send Alert'),
                                                  ],
                                                ))
                                            : ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        // bodyController.mainColor
                                                        //             .value !=
                                                        //         "Black"
                                                        //     ? greyColor
                                                        //         .withValues(
                                                        //             alpha: 0.3)
                                                        //     :
                                                        alertColor),
                                                onPressed: () {
                                                  // if (kDebugMode) {
                                                  //   print('clicked');
                                                  // }
                                                  // if (bodyController
                                                  //         .mainColor.value ==
                                                  //     "Black") {
                                                  userInfo.removeAssememt();
                                                  Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .sendAlertscreen);
                                                  // } else {
                                                  //   MyToast.showGetToast(
                                                  //       title: 'Safe 😊',
                                                  //       message:
                                                  //           'You are already safe from emergency',
                                                  //       backgroundColor:
                                                  //           Colors.green,
                                                  //       color: whiteColor);
                                                  // }
                                                },
                                                child: const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .dnd_forwardslash_outlined),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text('Send Alert'),
                                                  ],
                                                )),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQueryUtil.size(context).width /
                                                3,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              userInfo.removeAssememt();

                                              Navigator.pushNamedAndRemoveUntil(
                                                  context,
                                                  AppRoutes.mainScreenTabs,
                                                  (route) => false);
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.home),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Text('Home'),
                                              ],
                                            )),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            );
                          }),
                  ),
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     final newValue = Fortune.randomInt(0, items.length);
            //     controller.add(newValue);
            //   },
            //   child: Text('Spin'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildFortuneItem(
      String emoji, String title, Color color, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 4, bottom: 4, right: 28),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.height / 2,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.rectangle,
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      emoji,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularContainerWithSectors extends StatelessWidget {
  const CircularContainerWithSectors({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.width / 1.2,
      child: CustomPaint(
        painter: CircleWithSectorsPainter(
          numSectors: 6,
          sectorColors: [
            const Color(0xFFFFD700),
            const Color(0xFF1E90FF),
            const Color(0xFF808080),
            const Color(0xFFFF0000),
            const Color(0xFFFF8C00),
            const Color(0xFF00A36C),
            const Color(0xFF8A2BE2),
          ],
        ),
        child: Center(
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class WaterDropIndicator extends StatelessWidget {
  final Color color;
  final double size;

  const WaterDropIndicator({
    super.key,
    this.color = Colors.white,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: WaterDropPainter(color: color),
    );
  }
}

class WaterDropPainter extends CustomPainter {
  final Color color;

  WaterDropPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double bottomWidth = size.width * 1;
    double height = size.height * 0.6;

    Path path = Path()
      ..moveTo(centerX, centerY)
      ..quadraticBezierTo(centerX + bottomWidth / 2, centerY + height, centerX,
          centerY + height * 2)
      ..quadraticBezierTo(
          centerX - bottomWidth / 2, centerY + height, centerX, centerY)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircleWithSectorsPainter extends CustomPainter {
  final int numSectors;
  final List<Color> sectorColors;

  CircleWithSectorsPainter({
    required this.numSectors,
    required this.sectorColors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double sweepAngle = 2 * pi / numSectors;
    double startAngle = -pi / 2;

    double spaceBetweenSectors = 4;
    double borderWidth = 8;

    double innerRadius = radius - borderWidth - spaceBetweenSectors;

    for (int i = 0; i < numSectors; i++) {
      Paint sectorPaint = Paint()
        ..color = sectorColors[i % sectorColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

      double angleStart =
          startAngle + i * sweepAngle + spaceBetweenSectors / innerRadius;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: innerRadius),
        angleStart,
        sweepAngle - 2 * spaceBetweenSectors / innerRadius,
        false,
        sectorPaint,
      );
    }

    Paint innerCirclePaint = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(centerX, centerY),
        radius - borderWidth - spaceBetweenSectors - 5, innerCirclePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
