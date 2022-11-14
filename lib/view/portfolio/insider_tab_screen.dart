import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';

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
  int? viewAllIndex;
  bool isViewAll = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listOfShareDetails.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
                                text: listOfShareDetails[index]['title']),
                            CommonWidget.commonSizedBox(height: 10),
                            CommonText.textBoldWight400(text: 'Shares sold'),
                            CommonWidget.commonSizedBox(height: 16),
                            Row(children: [
                              CommonText.textBoldWight400(
                                  text: listOfShareDetails[index]['time']),
                              CommonWidget.commonSizedBox(width: 7),
                              Expanded(
                                child: Container(
                                    height: 20,
                                    color: CommonColor.lightRedColorFD7E7E),
                              ),
                            ]),
                            CommonWidget.commonSizedBox(height: 10),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  CommonText.textBoldWight400(
                                      text: listOfShareDetails[index]
                                          ['followed']),
                                  CommonWidget.commonSizedBox(width: 5),
                                  CommonText.textBoldWight400(text: 'shares'),
                                  CommonWidget.commonSizedBox(width: 5),
                                  CommonWidget.commonSvgPitcher(
                                      image: ImageConst.personIconApp,
                                      height: 15,
                                      color: Colors.black),
                                  CommonWidget.commonSizedBox(width: 3),
                                  CommonText.textBoldWight400(
                                      text: listOfShareDetails[index]
                                          ['followed']),
                                  CommonWidget.commonSizedBox(width: 5),
                                  CommonWidget.commonSvgPitcher(
                                      image: ImageConst.postIconApp,
                                      height: 15,
                                      color: Colors.black),
                                  CommonWidget.commonSizedBox(width: 3),
                                  listOfShareDetails[index]['post'] == null
                                      ? SizedBox()
                                      : CommonText.textBoldWight400(
                                          text: listOfShareDetails[index]
                                                  ['post'] ??
                                              ''),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                              fontFamily: TextConst.fontFamily,
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Color(0xff043278)),
                                        ),
                                      ),
                                      CommonWidget.commonSizedBox(height: 10),
                                      CommonText.textBoldWight400(
                                          text: 'Shares sold'),
                                      CommonWidget.commonSizedBox(height: 16),
                                    ]),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      height: 20,
                                      width: 30,
                                      color: CommonColor.greenColor2ECC71),
                                ),
                                CommonWidget.commonSizedBox(height: 10),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CommonText.textBoldWight400(
                                          text: listOfShareDetails[index]
                                              ['followed']),
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
                                          text: listOfShareDetails[index]
                                              ['followed']),
                                      CommonWidget.commonSizedBox(width: 5),
                                      CommonWidget.commonSvgPitcher(
                                          image: ImageConst.postIconApp,
                                          height: 15,
                                          color: Colors.black),
                                      CommonWidget.commonSizedBox(width: 3),
                                      listOfShareDetails[index]['post'] == null
                                          ? SizedBox()
                                          : CommonText.textBoldWight400(
                                              text: listOfShareDetails[index]
                                                      ['post'] ??
                                                  ''),
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
                              child: Image.asset(ImageConst.tableImage),
                            )
                          : SizedBox()
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ]),
    );
  }
}
