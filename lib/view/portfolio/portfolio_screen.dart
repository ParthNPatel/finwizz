import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/get_user_res_model.dart';
import 'package:finwizz/Models/responseModel/stock_summary_res_model.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/view/portfolio/portfolio_news_screen.dart';
import 'package:finwizz/view/portfolio/search_screen.dart';
import 'package:finwizz/view/portfolio/single_stock_screen.dart';
import 'package:finwizz/viewModel/get_user_view_model.dart';
import 'package:finwizz/viewModel/stock_news_view_model.dart';
import 'package:finwizz/viewModel/stock_remove_view_model.dart';
import 'package:finwizz/viewModel/stock_summary_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/color_const.dart';
import '../../constant/text_styel.dart';
import '../../controllers/portfolio_controller.dart';
import 'insider_tab_screen.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  PortFolioController _portFolioController = Get.find();
  StockSummaryViewModel stockSummaryViewModel =
      Get.put(StockSummaryViewModel());
  RemoveStockViewModel removeStockViewModel = Get.put(RemoveStockViewModel());
  StockNewsViewModel stockNewsViewModel = Get.put(StockNewsViewModel());
  GetUserViewModel getUserViewModel = Get.put(GetUserViewModel());

  @override
  void initState() {
    getUserViewModel.getUserViewModel();
    tabController = TabController(length: 3, vsync: this);
    stockSummaryViewModel.stockSummaryViewModel();
    tabController!.animation!.addListener(tabListener);
    super.initState();
  }

  void tabListener() {
    if (_portFolioController.selected !=
        tabController!.animation!.value.round()) {
      _portFolioController.selected = tabController!.animation!.value.round();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PortFolioController>(
        builder: (controller) {
          return SafeArea(
              child: Column(children: [
            appWidget(controller),
            Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffDADEE3), width: 1),
                    ),
                  ),
                ),
                tabBarTitleWidget(),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  firstTabView(controller, context),
                  PortfolioNewsScreen(),
                  InsiderTabScreen()
                ],
              ),
            )
          ]));
        },
      ),
    );
  }

  firstTabView(PortFolioController controller, BuildContext context) {
    return GetBuilder<GetUserViewModel>(builder: (controllerUser) {
      if (controllerUser.getUserApiResponse.status == Status.LOADING) {
        return Center(child: CircularProgressIndicator());
      }
      if (controllerUser.getUserApiResponse.status == Status.COMPLETE) {
        GetUserResponseModel respUser = controllerUser.getUserApiResponse.data;

        return GetBuilder<StockSummaryViewModel>(
          builder: (stockController) {
            if (stockController.stockSummaryApiResponse.status ==
                Status.LOADING) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (stockController.stockSummaryApiResponse.status ==
                Status.ERROR) {
              return Center(
                child: Text('Something went wrong'),
              );
            }

            if (stockController.stockSummaryApiResponse.status ==
                Status.COMPLETE) {
              StockSummaryResponseModel responseModel =
                  stockController.stockSummaryApiResponse.data;
              controller.isDeleteAvailable =
                  responseModel.data!.length == 0 ? false : true;
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: responseModel.data!.length != 0
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  responseModel.data!.length > 0
                      ? Expanded(
                          child: ReorderableListView.builder(
                            itemCount: responseModel.data!.length,
                            shrinkWrap: true,
                            reverse: true,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                key: ValueKey(responseModel.data![index].name),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => SingleStockSceen(
                                            companyName:
                                                '${responseModel.data![index].name}',
                                            companyId: responseModel
                                                .data![index].id!));
                                      },
                                      // onLongPress: () {
                                      //   Get.dialog(AlertDialog(
                                      //     title:
                                      //         Text("Want to shuffle stocks ?"),
                                      //     shape: RoundedRectangleBorder(
                                      //         borderRadius:
                                      //             BorderRadius.circular(15)),
                                      //     actions: [
                                      //       TextButton(
                                      //           onPressed: () {
                                      //             stockController.wantShuffle();
                                      //             Get.back();
                                      //           },
                                      //           child: Text(
                                      //             "Yes",
                                      //             style: TextStyle(
                                      //                 color: CommonColor
                                      //                     .themColor9295E2),
                                      //           )),
                                      //       TextButton(
                                      //           onPressed: () {
                                      //             Get.back();
                                      //           },
                                      //           child: Text("No",
                                      //               style: TextStyle(
                                      //                   color: CommonColor
                                      //                       .themColor9295E2))),
                                      //     ],
                                      //   ));
                                      // },
                                      child: Row(
                                        children: [
                                          //assets/svg/empty_check_box.svg
                                          controller.isDelete
                                              ? InkWell(
                                                  onTap: () {
                                                    controller
                                                        .setListOfPortFolio(
                                                            shareName:
                                                                responseModel
                                                                    .data![
                                                                        index]
                                                                    .id!);
                                                  },
                                                  child: CommonWidget.commonSvgPitcher(
                                                      image: controller
                                                              .listOfDeletePortFolio
                                                              .contains(
                                                                  responseModel
                                                                      .data![
                                                                          index]
                                                                      .id)
                                                          ? 'assets/svg/check_box.svg'
                                                          : 'assets/svg/empty_check_box.svg'),
                                                )
                                              : SizedBox(),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: CommonText.textBoldWight400(
                                                text:
                                                    '${responseModel.data![index].name}'),
                                          ),
                                          Spacer(),

                                          responseModel.data![index].positive! >
                                                      0 &&
                                                  responseModel.data![index]
                                                          .positive !=
                                                      null
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: 30.sp,
                                                  height: 30.sp,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff2ECC71)
                                                          .withOpacity(.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffEBEEF2))),
                                                  child: CommonText
                                                      .textBoldWight400(
                                                          text:
                                                              '${responseModel.data![index].positive}'),
                                                )
                                              : SizedBox(),
                                          SizedBox(width: 15.sp),
                                          responseModel.data![index].negative! >
                                                      0 &&
                                                  responseModel.data![index]
                                                          .negative !=
                                                      null
                                              ? Container(
                                                  alignment: Alignment.center,
                                                  width: 30.sp,
                                                  height: 30.sp,
                                                  decoration: BoxDecoration(
                                                      color: Color(0xffF43737)
                                                          .withOpacity(.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Color(
                                                              0xffEBEEF2))),
                                                  child: CommonText
                                                      .textBoldWight400(
                                                          text:
                                                              '${responseModel.data![index].negative}'),
                                                )
                                              : SizedBox(
                                                  width: 30.sp,
                                                  height: 30.sp,
                                                ),

                                          SizedBox(width: 20.sp),

                                          /* listOfStocks[index]['updates'].length == 0
                                        ? CommonText.textBoldWight400(
                                            text: 'No recent updates ')
                                        :*/
                                          // Row(
                                          //   children: List.generate(
                                          //       listOfStocks[index]['updates'].length,
                                          //       (indexOf) {
                                          //     return Padding(
                                          //       padding: const EdgeInsets.all(8.0),
                                          //       child: Container(
                                          //         width: 30.sp,
                                          //         alignment: Alignment.center,
                                          //         padding: EdgeInsets.symmetric(
                                          //           vertical: 8,
                                          //         ),
                                          //         child: CommonText.textBoldWight400(
                                          //             text: listOfStocks[index]['updates']
                                          //                     [indexOf]
                                          //                 .toString()),
                                          //         decoration: BoxDecoration(
                                          //             borderRadius: BorderRadius.circular(8),
                                          //             color: listOfStocks[index]['updates']
                                          //                             .length ==
                                          //                         2 &&
                                          //                     indexOf == 0
                                          //                 ? CommonColor.greenColor2ECC71
                                          //                     .withOpacity(0.5)
                                          //                 : CommonColor.lightRedColor3D3D3D
                                          //                     .withOpacity(0.5)),
                                          //       ),
                                          //     );
                                          //   }),
                                          // )
                                        ],
                                      ),
                                    ),
                                    CommonWidget.commonSizedBox(height: 6),
                                    Divider(
                                      color: CommonColor.greyColorD1CDCD,
                                    ),
                                  ],
                                ),
                              );
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              final index =
                                  newIndex > oldIndex ? newIndex - 1 : newIndex;

                              final user =
                                  responseModel.data!.removeAt(oldIndex);
                              responseModel.data!.insert(index, user);
                            },
                          ),
                        )
                      : Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 70.sp),
                            child: CommonText.textBoldWight500(
                                fontSize: 12.sp,
                                text:
                                    "Please add your portfolio stocks and\nkeep updated with what’s happening\n                     in the company"),
                          ),
                        ),
                  // : SizedBox(),

                  respUser.data!.addedStocks!.length == 5 &&
                          respUser.data!.refferalCount! < 3 &&
                          !controller.isDelete
                      ? Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 50),
                                child: CommonText.textBoldWight700(
                                    text: 'ADD STOCKS',
                                    fontSize: 10.sp,
                                    color: Colors.white),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: CommonColor.greyColorD1CDCD
                                        .withOpacity(.7))),
                            Positioned(
                              bottom: 25,
                              left: -7,
                              child: Icon(Icons.lock_outline,
                                  color: CommonColor.primaryColor),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            if (controller.isDelete) {
                              showModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                context: context,
                                builder: (context) => Container(
                                  height: 150.sp,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff4f4f4),
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: CommonText.textBoldWight500(
                                            text:
                                                "Are you sure you want to delete ?"),
                                      ),
                                      CommonWidget.commonSizedBox(height: 30),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              controller.isDelete = false;

                                              Get.back();
                                            },
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 30),
                                                child:
                                                    CommonText.textBoldWight700(
                                                        text: "CANCEL",
                                                        fontSize: 10.sp,
                                                        color: Colors.white),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    color: CommonColor
                                                        .themColor9295E2)),
                                          ),
                                          SizedBox(
                                            width: 30,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await removeStockViewModel
                                                  .removeStockViewModel(body: {
                                                "stockId": controller
                                                    .listOfDeletePortFolio
                                              });

                                              if (removeStockViewModel
                                                      .removeStockApiResponse
                                                      .status ==
                                                  Status.COMPLETE) {
                                                Get.back();
                                                controller.listOfDeletePortFolio
                                                    .clear();

                                                CommonWidget.getSnackBar(
                                                    color: Colors.green,
                                                    duration: 2,
                                                    colorText: Colors.white,
                                                    title:
                                                        "Stock Removed successfully!",
                                                    message: 'Successfully');
                                              }
                                              if (removeStockViewModel
                                                      .removeStockApiResponse
                                                      .status ==
                                                  Status.ERROR) {
                                                Get.back();

                                                CommonWidget.getSnackBar(
                                                    color: Colors.red,
                                                    duration: 2,
                                                    colorText: Colors.white,
                                                    title: "Try again",
                                                    message: 'Failed');
                                              }
                                              controller.isDelete = false;
                                              await stockController
                                                  .stockSummaryViewModel(
                                                      isLoading: false);
                                              await controllerUser
                                                  .getUserViewModel(
                                                      isLoading: false);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 30),
                                              child:
                                                  CommonText.textBoldWight700(
                                                      text: "YES, DELETE",
                                                      fontSize: 10.sp,
                                                      color: Colors.white),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                color:
                                                    CommonColor.themColor9295E2,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      CommonWidget.commonSizedBox(height: 20),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              Get.to(() => SearchScreen());
                            }
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 50),
                              child: CommonText.textBoldWight700(
                                  text: controller.isDelete
                                      ? 'DELETE'
                                      : 'ADD STOCKS',
                                  fontSize: 10.sp,
                                  color: Colors.white),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: CommonColor.themColor9295E2)),
                        ),

                  respUser.data!.addedStocks!.length == 5 &&
                          respUser.data!.refferalCount! < 3 &&
                          !controller.isDelete
                      ? CommonWidget.commonSizedBox(height: 8.sp)
                      : CommonWidget.commonSizedBox(height: 13.sp),
                  respUser.data!.addedStocks!.length == 5 &&
                          respUser.data!.refferalCount! < 3 &&
                          !controller.isDelete
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height: 40.sp,
                                child: Text(
                                    "Please complete 3 referrals to\nadd more than 5 stocks")),
                            SizedBox(width: 5.sp),
                            InkWell(
                              onTap: () {
                                Get.dialog(referrals());
                              },
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Positioned(
                                    left: 4.sp,
                                    top: 5.sp,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 28.sp,
                                      width: 77.sp,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(80.sp),
                                          color: CommonColor.primaryColor),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30.sp,
                                    width: 80.sp,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(80.sp),
                                        color: Colors.black),
                                    child: Text("Refere now",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: 5.sp)
                ],
              );
            } else
              return SizedBox();
          },
        );
      } else
        return SizedBox();
    });
  }

  Widget referrals() {
    String link = "Referral Code";

    return Dialog(
      child: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: CommonText.textBoldWight500(
                  text: "Referrals", fontSize: 18.sp, color: Colors.black),
            ),
            CommonWidget.commonSizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    CommonText.textBoldWight400(
                        text: "Pending referrals",
                        fontSize: 10.sp,
                        color: Colors.black),
                    CommonText.textBoldWight400(
                        text: GetStorageServices.getReferralCount() >= 3
                            ? "0"
                            : "${3 - GetStorageServices.getReferralCount()}",
                        fontSize: 10.sp,
                        color: Colors.grey),
                  ],
                ),
                Column(
                  children: [
                    CommonText.textBoldWight400(
                        text: "Successful referrals",
                        fontSize: 10.sp,
                        color: Colors.black),
                    CommonText.textBoldWight400(
                        text: "${GetStorageServices.getReferralCount()}",
                        fontSize: 10.sp,
                        color: Colors.grey),
                  ],
                ),
              ],
            ),
            CommonWidget.commonSizedBox(height: 20.sp),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.lock_open_outlined,
                  color: CommonColor.primaryColor,
                ),
                SizedBox(
                  width: 3,
                ),
                CommonText.textBoldWight500(
                    text: "Unlock all features with 3 successful referrals",
                    fontSize: 8.sp,
                    color: Colors.black),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            CommonWidget.commonSizedBox(height: 20.sp),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText.textBoldWight600(
                    text: "${GetStorageServices.getReferralCode()}",
                    fontSize: 12.sp,
                    color: Colors.black),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.copy,
                  color: CommonColor.primaryColor,
                ),
              ],
            ),
            SizedBox(
              height: 7.sp,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await Share.share(
                      "${GetStorageServices.getReferralCode()}",
                      subject: link,
                    );
                  },
                  child: Image.asset(
                    ImageConst.whatsApp,
                    height: 20.sp,
                    width: 20.sp,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () async {
                    await Share.share(
                      "${GetStorageServices.getReferralCode()}",
                      subject: link,
                    );
                  },
                  child: Image.asset(
                    ImageConst.twitter,
                    height: 20.sp,
                    width: 20.sp,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.share,
                  color: CommonColor.primaryColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TabBar tabBarTitleWidget() {
    return TabBar(
      //isScrollable: true,
      controller: tabController,
      onTap: (value) {
        _portFolioController.selected = tabController!.index;
      },
      labelPadding: EdgeInsets.symmetric(vertical: 9.sp),
      unselectedLabelColor: Colors.black,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff9295E2), width: 4),
      ),
      //onTap: (index) => tabsModel.value = listTabsModel[index],
      tabs: [
        Text(
          'Summary',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
        Text(
          'News',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
        Text(
          'Insider',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp),
        ),
      ],
    );
  }

  Widget appWidget(PortFolioController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        children: [
          CommonText.textBoldWight700(text: 'Hello 🙌', fontSize: 16.sp),
          Spacer(),
          controller.selected == 0
              ? Row(
                  children: [
                    CommonWidget.commonSizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Get.to(() => SearchScreen());
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                          child: CommonWidget.commonSvgPitcher(
                            image: ImageConst.plusIcon,
                          )),
                    ),
                    CommonWidget.commonSizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        if (controller.isDeleteAvailable == true) {
                          if (!controller.isDelete) {
                            controller.isDelete = true;
                          } else {
                            controller.isDelete = false;
                          }
                        } else {
                          CommonWidget.getSnackBar(
                              title: 'Add Stock First',
                              message: '',
                              duration: 2);
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                          child: CommonWidget.commonSvgPitcher(
                              image: ImageConst.deleteIcon,
                              color: controller.isDelete
                                  ? CommonColor.themDarkColor6E5DE7
                                  : Colors.black)),
                    ),
                  ],
                )
              : controller.selected == 1
                  ? InkWell(
                      onTap: () {
                        showMenu(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                            ),
                          ),
                          color: Color(0xffE4E3E3),
                          context: context,
                          position: RelativeRect.fromLTRB(Get.width, 0, 0, 0.0),
                          items: [
                            PopupMenuItem(
                              child: Text("All"),
                              value: 0,
                              onTap: () {
                                stockNewsViewModel.newsFilter(0);
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Positive"),
                              value: 1,
                              onTap: () {
                                stockNewsViewModel.newsFilter(1);
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Negative"),
                              value: 2,
                              onTap: () {
                                stockNewsViewModel.newsFilter(2);
                              },
                            ),
                            PopupMenuItem(
                              child: Text("Neutral"),
                              value: 3,
                              onTap: () {
                                stockNewsViewModel.newsFilter(3);
                              },
                            ),
                          ],
                        );
                      },
                      child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.all(6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                          child: CommonWidget.commonSvgPitcher(
                              image: ImageConst.filterIcon,
                              color: controller.isDelete
                                  ? CommonColor.themDarkColor6E5DE7
                                  : Colors.black)),
                    )
                  : SizedBox(height: 45.sp, width: 45.sp),
        ],
      ),
    );
  }
}
