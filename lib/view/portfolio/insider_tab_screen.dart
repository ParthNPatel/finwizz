import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/insider_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/viewModel/insider_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constant/color_const.dart';
import '../../constant/image_const.dart';
import '../../constant/text_const.dart';

class InsiderTabScreen extends StatefulWidget {
  const InsiderTabScreen({Key? key}) : super(key: key);

  @override
  State<InsiderTabScreen> createState() => _InsiderTabScreenState();
}

class _InsiderTabScreenState extends State<InsiderTabScreen> {
  List<Map> listOfShareDetails = [
    {
      'title': 'TANLA PLATFORMS',
      'status': 'Shares sold',
      'time': '0-3 months',
      'shares': '19727',
      'followed': '3',
      'post': '0'
    },
    {
      'title': 'TATA MOTORS',
      'status': 'Shares bought',
      'time': '0-3 months',
      'shares': '19727',
      'followed': '3',
      'post': null
    },
  ];
  List<Map> listOfShareDetailsView = [
    {'status': 'Shares bought', 'shares': '5000', 'followed': '2', 'post': '1'},
    {
      'status': 'Shares bought',
      'shares': '5000',
      'followed': '3',
      'post': null
    },
  ];

  InsiderViewModel insiderViewModel = Get.put(InsiderViewModel());

  @override
  void initState() {
    super.initState();
    insiderViewModel.getInsiderViewModel();
  }

  int? viewAllIndex;
  bool isViewAll = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<InsiderViewModel>(builder: (controller) {
        if (controller.getInsidersApiResponse.status == Status.LOADING) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.getInsidersApiResponse.status == Status.COMPLETE) {
          InsiderResponseModel response =
              controller.getInsidersApiResponse.data;

          return Column(children: [
            Expanded(
              child: SingleChildScrollView(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: response.data!.length,
                  itemBuilder: (context, index) {
                    if (response.data![index].insiders != null) {
                      double bought = response
                              .data![index].insiders!.sharesBought!.shares! /
                          (response.data![index].insiders!.sharesBought!
                                  .shares! +
                              response
                                  .data![index].insiders!.sharesSold!.shares!) *
                          100;
                      double sold =
                          response.data![index].insiders!.sharesSold!.shares! /
                              (response.data![index].insiders!.sharesBought!
                                      .shares! +
                                  response.data![index].insiders!.sharesSold!
                                      .shares!) *
                              100;

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CommonWidget.commonDivider(),
                            Row(children: [
                              Expanded(
                                  child: Container(
                                height: 120,
                                child: Column(children: [
                                  CommonText.textBoldWight600(
                                      text: response.data![index].name!),
                                  CommonWidget.commonSizedBox(height: 10),
                                  CommonText.textBoldWight400(
                                      text: 'Shares sold'),
                                  CommonWidget.commonSizedBox(height: 16),
                                  Row(children: [
                                    CommonText.textBoldWight400(
                                        text:
                                            "0${response.data![index].createdAt!.difference(DateTime.now()).inDays} Days"),
                                    CommonWidget.commonSizedBox(width: 7),
                                    Spacer(),
                                    Container(
                                        height: 20,
                                        width: sold.w / 2.7,
                                        color: CommonColor.lightRedColorFD7E7E),
                                  ]),
                                  CommonWidget.commonSizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        CommonText.textBoldWight400(
                                            text:
                                                "${response.data![index].insiders!.sharesSold!.shares}"),
                                        CommonWidget.commonSizedBox(width: 5),
                                        CommonText.textBoldWight400(
                                            text: 'shares'),
                                        CommonWidget.commonSizedBox(width: 5),
                                        CommonWidget.commonSvgPitcher(
                                            image: ImageConst.personIconApp,
                                            height: 15,
                                            color: Colors.black),
                                        CommonWidget.commonSizedBox(width: 3),
                                        CommonText.textBoldWight400(
                                            text:
                                                "${response.data![index].insiders!.sharesSold!.person}"),
                                        CommonWidget.commonSizedBox(width: 5),
                                        CommonWidget.commonSvgPitcher(
                                            image: ImageConst.postIconApp,
                                            height: 15,
                                            color: Colors.black),
                                        CommonWidget.commonSizedBox(width: 3),
                                        // response.data![index]['post'] ==
                                        //         null
                                        //     ? SizedBox()
                                        //     : CommonText.textBoldWight400(
                                        //         text: response.data![index]
                                        //                 ['post'] ??
                                        //             ''),
                                        CommonText.textBoldWight400(text: "0")
                                      ]),
                                ]),
                              )),
                              SizedBox(
                                height: 50,
                                child: VerticalDivider(color: Colors.black),
                              ),
                              Container(
                                height: 120,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            // CommonText.textBoldWight600(
                                            //     text:View all),
                                            GestureDetector(
                                              onTap: () {
                                                isViewAll = !isViewAll;
                                                viewAllIndex = index;
                                                setState(() {});
                                              },
                                              child: Text(
                                                'View all',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    // fontSize: fontSize,
                                                    fontFamily:
                                                        TextConst.fontFamily,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: Color(0xff043278)),
                                              ),
                                            ),
                                            CommonWidget.commonSizedBox(
                                                height: 10),
                                            CommonText.textBoldWight400(
                                                text: 'Shares Bought'),
                                            CommonWidget.commonSizedBox(
                                                height: 16),
                                          ]),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                            height: 20,
                                            width: bought.w / 2.7,
                                            color:
                                                CommonColor.greenColor2ECC71),
                                      ),
                                      CommonWidget.commonSizedBox(height: 10),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            CommonText.textBoldWight400(
                                                text:
                                                    "${response.data![index].insiders!.sharesBought!.shares}"),
                                            CommonWidget.commonSizedBox(
                                                width: 5),
                                            CommonText.textBoldWight400(
                                                text: 'shares'),
                                            CommonWidget.commonSizedBox(
                                                width: 5),
                                            CommonWidget.commonSvgPitcher(
                                                image: ImageConst.personIconApp,
                                                height: 15,
                                                color: Colors.black),
                                            CommonWidget.commonSizedBox(
                                                width: 3),
                                            CommonText.textBoldWight400(
                                                text:
                                                    "${response.data![index].insiders!.sharesBought!.person}"),
                                            CommonWidget.commonSizedBox(
                                                width: 5),
                                            CommonWidget.commonSvgPitcher(
                                                image: ImageConst.postIconApp,
                                                height: 15,
                                                color: Colors.black),
                                            CommonWidget.commonSizedBox(
                                                width: 3),
                                            // response.data![index]['post'] ==
                                            //         null
                                            //     ? SizedBox()
                                            //     : CommonText
                                            //         .textBoldWight400(
                                            //             text: response.data![
                                            //                         index]
                                            //                     ['post'] ??
                                            //                 ''),
                                            CommonText.textBoldWight400(
                                                text: "0")
                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                            CommonWidget.commonDivider(),
                            viewAllIndex == index && isViewAll == true
                                ? Container(
                                    padding: EdgeInsets.only(top: 30),
                                    child: DataTable(
                                      columnSpacing: 7.sp,
                                      horizontalMargin: 5.sp,
                                      dataTextStyle: TextStyle(
                                          fontSize: 10.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: TextConst.fontFamily),
                                      border: TableBorder.symmetric(
                                          inside: BorderSide(
                                              width: 1,
                                              color: Color(0xffD1CDCD)),
                                          outside: BorderSide(
                                              width: 1,
                                              color: Color(0xffD1CDCD))),
                                      columns: [
                                        DataColumn(
                                            label: CommonText.textBoldWight400(
                                                text: 'Category of\nperson',
                                                fontSize: 10.sp)),
                                        DataColumn(
                                            label: CommonText.textBoldWight400(
                                                text: 'Shares',
                                                fontSize: 10.sp)),
                                        DataColumn(
                                            label: CommonText.textBoldWight400(
                                                text: 'Value',
                                                fontSize: 10.sp)),
                                        DataColumn(
                                            label: CommonText.textBoldWight400(
                                                text: 'Transaction\ntype',
                                                fontSize: 10.sp)),
                                        DataColumn(
                                            label: CommonText.textBoldWight400(
                                                text: 'Mode of\nacquisition',
                                                fontSize: 10.sp)),
                                      ],
                                      rows: List.generate(
                                          response.data![index].insiders!.table!
                                              .length,
                                          (indexRow) =>
                                              DataRow(selected: false, cells: [
                                                DataCell(Text(
                                                    '${response.data![index].insiders!.table![indexRow].personCategory}')),
                                                DataCell(Text(
                                                    '${response.data![index].insiders!.table![indexRow].shares}')),
                                                DataCell(Text(
                                                    '${response.data![index].insiders!.table![indexRow].value}')),
                                                DataCell(Text(
                                                    '${response.data![index].insiders!.table![indexRow].transactionType}')),
                                                DataCell(Text(
                                                    '${response.data![index].insiders!.table![indexRow].mode}')),
                                              ])),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      );
                    } else
                      return SizedBox();
                  },
                ),
              ),
            )
          ]);
        } else
          return SizedBox();
      }),
    );
  }
}
