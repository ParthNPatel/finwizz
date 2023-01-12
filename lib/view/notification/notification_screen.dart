import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_ntification_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/viewModel/get_notification_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GetNotificationViewModel getNotificationViewModel =
      Get.put(GetNotificationViewModel());

  final globalKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotificationViewModel.getNotificationViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Image.asset("assets/png/stack_bubel.png", scale: 4.2),
              Column(
                children: [
                  CommonWidget.commonSizedBox(height: 10),
                  appWidget(),
                  GetBuilder<GetNotificationViewModel>(builder: (controller) {
                    if (controller.getNotificationApiResponse.status ==
                        Status.LOADING) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (controller.getNotificationApiResponse.status ==
                        Status.COMPLETE) {
                      GetNotificationResponseModel response =
                          controller.getNotificationApiResponse.data;
                      if (response.message!.length != 0) {
                        return ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.only(
                              left: 40.sp,
                              right: 20.sp,
                              top: 15.sp,
                              bottom: 15.sp),
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: response.message!.length,
                          separatorBuilder: (context, index) => SizedBox(
                            height: 30,
                          ),
                          itemBuilder: (context, index) {
                            var time = DateTime.now()
                                        .difference(
                                            response.message![index].updatedAt!)
                                        .inSeconds >
                                    60
                                ? DateTime.now()
                                            .difference(response
                                                .message![index].updatedAt!)
                                            .inMinutes >
                                        60
                                    ? DateTime.now()
                                                .difference(response
                                                    .message![index].updatedAt!)
                                                .inHours >
                                            24
                                        ? '${DateTime.now().difference(response.message![index].updatedAt!).inDays} days ago'
                                        : '${DateTime.now().difference(response.message![index].updatedAt!).inHours} Hrs ago'
                                    : '${DateTime.now().difference(response.message![index].updatedAt!).inMinutes} m ago'
                                : '${DateTime.now().difference(response.message![index].updatedAt!).inSeconds} sec ago';

                            return GestureDetector(
                              onTap: () {
                                Get.offAll(BottomNavScreen(
                                  selectedIndex: 1,
                                  isNoti: true,
                                  newsId: response.message![index].id,
                                ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText.textBoldWight500(
                                      text: response.message![index].title !=
                                              null
                                          ? response.message![index].title!
                                                      .length >
                                                  25
                                              ? response.message![index].title!
                                                      .substring(0, 25) +
                                                  ".."
                                              : response.message![index].title!
                                          : ""),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            response.message![index].body !=
                                                    null
                                                ? response.message![index].body!
                                                            .length >
                                                        75
                                                    ? response.message![index]
                                                            .body!
                                                            .substring(0, 75) +
                                                        ".."
                                                    : response
                                                        .message![index].body!
                                                : "",
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: Color(0xff7B6F72))),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      CommonText.textBoldWight400(
                                          text: time,
                                          fontSize: 9.sp,
                                          color: Color(0xff7B6F72)
                                              .withOpacity(.5)),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText.textBoldWight500(
                                  text: "No Message Received yet."),
                            ],
                          ),
                        );
                      }
                    } else
                      return SizedBox();
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar appWidget() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back,
            size: 28.sp,
            color: Color(0xff424366),
          )),
      centerTitle: true,
      title: CommonText.textBoldWight500(
          text: 'Notification', fontSize: 14.sp, color: Colors.black),
      actions: [
        InkWell(
          onTap: () {
            Get.off(BottomNavScreen(selectedIndex: 0));
          },
          child: Container(
            padding: EdgeInsets.all(6.sp),
            margin: EdgeInsets.only(right: 13.sp),
            height: 30.sp,
            width: 30.sp,
            decoration: BoxDecoration(
                color: CommonColor.themColor9295E2.withOpacity(.6),
                shape: BoxShape.circle),
            child: SvgPicture.asset(ImageConst.home),
          ),
        )
      ],
    );
  }

  // Row appWidget() {
  //   return Row(
  //     children: [
  //       IconButton(
  //           onPressed: () {
  //             globalKey.currentState!.openDrawer();
  //           },
  //           icon: Icon(
  //             Icons.arrow_back_ios,
  //             size: 28.sp,
  //             color: CommonColor.themColor9295E2,
  //           )),
  //       CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 14.sp),
  //       Spacer(),
  //       CommonWidget.commonSizedBox(width: 10),
  //     ],
  //   );
  // }
}
