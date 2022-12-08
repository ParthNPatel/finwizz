import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../components/common_widget.dart';
import '../../constant/image_const.dart';
import '../../controller/handle_screen_controller.dart';
import '../Home/home_screen.dart';
import '../SignUp_SignIn/sign_up_screen.dart';
import '../news/news_screen.dart';
import 'package:share_plus/share_plus.dart';

class BookMarkScreen extends StatefulWidget {
  const BookMarkScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkScreen> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends State<BookMarkScreen>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey<ScaffoldState>();

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

  HandleScreenController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.changeTapped(false);
        return false;
      },
      child: Scaffold(
        key: globalKey,
        drawer: DrawerWidget(),
        body: SafeArea(
          child: Column(
            children: [
              CommonWidget.commonSizedBox(height: 10),
              appWidget(),
              CommonWidget.commonSizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) => Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                                  text:
                                      'TANLA PLATFORMS considers equity buyback',
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row appWidget() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              globalKey.currentState!.openDrawer();
            },
            icon: Icon(
              Icons.menu_outlined,
              size: 28.sp,
              color: CommonColor.themColor9295E2,
            )),
        CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 14.sp),
        Spacer(),
        CommonWidget.commonSvgPitcher(
          image: ImageConst.bookMarkFilled,
        ),
        CommonWidget.commonSizedBox(width: 10),
        Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff6E5DE7).withOpacity(0.8),
                      Color(0xff6E5DE7).withOpacity(0.8),
                    ]),
                shape: BoxShape.circle,
                color: CommonColor.themColor9295E2),
            child: Image.asset(
              'assets/png/notification.png',
              scale: 2.6,
            )),
        CommonWidget.commonSizedBox(width: 10)
      ],
    );
  }
}
