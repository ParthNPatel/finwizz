import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:share_plus/share_plus.dart';
import '../../constant/color_const.dart';
import '../../constant/image_const.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<String> categories = [
    'Company\nupdates',
    'Results',
    'Sectoral',
    'Economic',
  ];

  int selected = 0;

  List listOfNews = [
    {
      'image': ImageConst.newsIcon,
      'title': 'News',
      'text': 'News that moves stocks'
    },
    {
      'image': ImageConst.bagIcon,
      'title': 'Portfolio protection',
      'text': 'Invest on information. Sell on information'
    }
  ];
  List listOfNews1 = [
    {
      'image': ImageConst.calender,
      'title': 'Today',
    },
    {
      'image': ImageConst.calender,
      'title': 'Yesterday',
    },
    {
      'image': ImageConst.calender,
      'title': 'Wed, 05 Sep 2022',
    }
  ];

  bool isFavourite = true;
  bool isFavourite1 = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: [
          CommonWidget.commonSizedBox(height: 20),
          SizedBox(
            height: 40.sp,
            child: ListView.builder(
              padding: EdgeInsets.only(left: 30),
              itemCount: categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) => InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    selected = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  height: 40.sp,
                  width: 80.sp,
                  decoration: BoxDecoration(
                    color: selected == index
                        ? Color(0xffdddef6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffdddef6), width: 1),
                  ),
                  child: Center(
                    child: CommonText.textBoldWight500(
                        text: categories[index], fontSize: 10.sp),
                  ),
                ),
              ),
            ),
          ),
          CommonWidget.commonSizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    children: [
                      Divider(
                        color: Color(0xffD1CDCD),
                        height: 0,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          CommonWidget.commonSvgPitcher(
                              image: ImageConst.calender,
                              height: 20.sp,
                              width: 20.sp),
                          SizedBox(
                            width: 10,
                          ),
                          CommonText.textBoldWight500(
                              text: listOfNews1[index]['title'])
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Color(0xffD1CDCD),
                        height: 0,
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffD1CDCD),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonWidget.commonSizedBox(height: 10),
                        CommonText.textBoldWight700(
                            text: 'TANLA PLATFORMS considers equity buyback',
                            color: Colors.black),
                        CommonWidget.commonSizedBox(height: 15),
                        CommonText.textBoldWight400(
                            text: 'TANLA', color: Colors.black),
                        CommonWidget.commonSizedBox(height: 15),
                        CommonText.textBoldWight500(
                            color: Color(0xff394452),
                            fontSize: 10.sp,
                            text:
                                "✅ Company will consider a proposal for buybac of Equity Shares on Thursday September 08, 2022"),
                        CommonWidget.commonSizedBox(height: 6),
                        CommonText.textBoldWight500(
                            fontSize: 10.sp,
                            color: Color(0xff394452),
                            text:
                                "ℹ️ ️️ Buyback reflects confidence of investors and is generally  positive for stock price"),
                        CommonWidget.commonSizedBox(height: 10),
                        Row(
                          children: [
                            InkResponse(
                              onTap: () {
                                setState(() {
                                  isFavourite = !isFavourite;
                                });
                              },
                              child: Icon(
                                isFavourite == true
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: CommonColor.yellowColorFFB800,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CommonText.textBoldWight400(
                                text: '120.1K', color: Colors.black),
                            Spacer(),
                            InkResponse(
                              onTap: () {
                                setState(() {
                                  isFavourite1 = !isFavourite1;
                                });
                              },
                              child: Icon(
                                isFavourite1 == true
                                    ? Icons.bookmark
                                    : Icons.bookmark_outline_sharp,
                                color: CommonColor.yellowColorFFB800,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            InkResponse(
                              onTap: () {
                                Share.share("Test");
                              },
                              child: Icon(
                                Icons.share,
                                color: CommonColor.yellowColorFFB800,
                              ),
                            ),
                          ],
                        ),
                        CommonWidget.commonSizedBox(height: 10),
                        CommonText.textBoldWight400(
                            text: 'Sep 7,  12:38 ·| Source : BSE',
                            color: Colors.black),
                        CommonWidget.commonSizedBox(height: 10),
                      ]),
                ),
              ],
            ),
            itemCount: 3,
          )
        ],
      ),
    );
  }
}