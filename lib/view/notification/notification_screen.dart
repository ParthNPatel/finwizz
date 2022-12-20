import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_ntification_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/viewModel/get_notification_view_model.dart';
import 'package:flutter/material.dart';
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
    return Scaffold(
      body: Column(
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.sp, vertical: 15.sp),
                  physics: BouncingScrollPhysics(),
                  itemCount: response.message!.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 30,
                    thickness: 1.3,
                    color: Color(0xffDDDADA),
                  ),
                  itemBuilder: (context, index) {
                    var time = DateTime.now()
                                .difference(response.message![index].updatedAt!)
                                .inSeconds >
                            60
                        ? DateTime.now()
                                    .difference(
                                        response.message![index].updatedAt!)
                                    .inMinutes >
                                60
                            ? DateTime.now()
                                        .difference(
                                            response.message![index].updatedAt!)
                                        .inHours >
                                    24
                                ? 'About ${DateTime.now().difference(response.message![index].updatedAt!).inDays} days ago'
                                : 'About ${DateTime.now().difference(response.message![index].updatedAt!).inHours} hour ago'
                            : 'About ${DateTime.now().difference(response.message![index].updatedAt!).inMinutes} minute ago'
                        : 'About ${DateTime.now().difference(response.message![index].updatedAt!).inSeconds} seconds ago';

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 17.sp,
                          backgroundColor: Color(0xff6E5DE7).withOpacity(0.8),
                          child: Image.asset(
                            ImageConst.newsIcon,
                            height: 17.sp,
                            width: 17.sp,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonText.textBoldWight500(
                                text: response.message![index].title!),
                            SizedBox(
                              height: 5,
                            ),
                            CommonText.textBoldWight400(
                                text: time,
                                fontSize: 9.sp,
                                color: Color(0xff7B6F72)),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.more_vert,
                          color: Color(0xffada4a5),
                          size: 15.sp,
                        )
                      ],
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
    );
  }

  AppBar appWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 28.sp,
            color: CommonColor.themColor9295E2,
          )),
      centerTitle: true,
      title: CommonText.textBoldWight700(
          text: 'Notification', fontSize: 14.sp, color: Colors.black),
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
