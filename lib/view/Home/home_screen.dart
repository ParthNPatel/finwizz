import 'package:carousel_slider/carousel_slider.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../components/indicatorWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _submitController = TextEditingController();
  int pagerIndex = 0;

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

  bool isOpen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      key: globalKey,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CommonWidget.commonSizedBox(height: 10),
          appWidget(),
          isOpen
              ? scrollWidget()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      margin: EdgeInsets.only(left: 60, right: 30, top: 40),
                      child: CommonText.textBoldWight400(
                          text:
                              'Invite 3 friends to FinWizz and unlock all features for free'),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(4, 6),
                                spreadRadius: 1)
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: CommonColor.lightBlueColorCADCF8),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.dialog(SimpleDialog(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              children: [
                                CommonWidget.commonSizedBox(height: 12),
                                CommonText.textBoldWight600(
                                    text: 'Your opinion matters!',
                                    fontSize: 16.sp),
                                CommonWidget.commonSizedBox(height: 9),
                                RatingBar(
                                  initialRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemSize: 28,
                                  itemCount: 5,
                                  ratingWidget: RatingWidget(
                                    full: Icon(Icons.star,
                                        color: CommonColor.yellowColorFFC633),
                                    half: Icon(Icons.star_half,
                                        color: CommonColor.yellowColorFFC633),
                                    empty: Icon(
                                      Icons.star_border_outlined,
                                    ),
                                  ),
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  onRatingUpdate: (rating) {
                                    print(rating);
                                  },
                                ),
                                CommonWidget.commonSizedBox(height: 9),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CommonText.textBoldWight400(
                                      text:
                                          'Please tell us how we can improve ',
                                    ),
                                    CommonText.textBoldWight400(
                                        text: '*',
                                        color: CommonColor.redColorFF2950),
                                  ],
                                ),
                                CommonWidget.commonSizedBox(height: 9),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: TextFormField(
                                    maxLines: 3,
                                    controller: _submitController,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: TextConst.fontFamily,
                                    ),
                                    cursorColor: Colors.black,
                                    decoration: InputDecoration(
                                      fillColor: Colors.white,
                                      contentPadding: EdgeInsets.only(
                                          top: 7.sp, left: 12.sp),
                                      filled: true,
                                      //fillColor: CommonColor.textFiledColorFAFAFA,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: CommonColor.geryColorC9C5C5),
                                        borderRadius:
                                            new BorderRadius.circular(25.7),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: CommonColor.geryColorC9C5C5),
                                        borderRadius:
                                            new BorderRadius.circular(25.7),
                                      ),
                                      // border: OutlineInputBorder(
                                      //     borderSide: BorderSide.none,
                                      //     borderRadius:
                                      //         BorderRadius.circular(10))
                                    ),
                                  ),
                                ),
                                CommonWidget.commonSizedBox(height: 20),
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 9),
                                    child: CommonText.textBoldWight400(
                                        text: 'Submit', color: Colors.white),
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                              color: CommonColor
                                                  .themDarkColor6E5DE7,
                                              //blurRadius: 10,
                                              offset: Offset(3, 5),
                                              spreadRadius: 1)
                                        ],
                                        borderRadius:
                                            BorderRadius.circular(1010),
                                        color: Colors.black),
                                  ),
                                ),
                                CommonWidget.commonSizedBox(height: 12),
                              ],
                            )
                          ],
                        ));
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 13),
                        margin: EdgeInsets.only(left: 60, top: 40),
                        child: CommonText.textBoldWight400(
                            text: 'Refer now', color: Colors.white),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: CommonColor.themDarkColor6E5DE7,
                                  //blurRadius: 10,
                                  offset: Offset(3, 5),
                                  spreadRadius: 1)
                            ],
                            borderRadius: BorderRadius.circular(1010),
                            color: Colors.black),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText.textBoldWight600(
                              text: 'Your opinion matters!', fontSize: 16.sp),
                          CommonWidget.commonSizedBox(height: 9),
                          CommonText.textBoldWight400(
                            text: 'Are you enjoying FinWizz?',
                          ),
                          CommonWidget.commonSizedBox(height: 9),
                          RatingBar(
                            initialRating: 0,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemSize: 28,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(Icons.star,
                                  color: CommonColor.yellowColorFFC633),
                              half: Icon(Icons.star_half,
                                  color: CommonColor.yellowColorFFC633),
                              empty: Icon(
                                Icons.star_border_outlined,
                              ),
                            ),
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            onRatingUpdate: (rating) {
                              print(rating);
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )
        ]),
      ),
    );
  }

  Expanded scrollWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidget.commonSizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: CommonText.textBoldWight600(
                  text: TextConst.latestMovers,
                  fontSize: 16.sp,
                  color: CommonColor.themDarkColor6E5DE7),
            ),
            CommonWidget.commonSizedBox(height: 30),
            bannerWidget(),
            CommonWidget.commonSizedBox(height: 35),
            PageIndicator(pagerIndex: pagerIndex, totalPages: 3),
            CommonWidget.commonSizedBox(height: 30),
            ListView.builder(
              itemCount: listOfNews.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: CommonColor.greyColorEFEDF2),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CommonWidget.commonSizedBox(width: 15),
                        SizedBox(
                          height: 90.sp,
                          width: 50.sp,
                          child: Image.asset(
                            listOfNews[index]['image'],
                            fit: index == 0 ? BoxFit.cover : BoxFit.contain,
                            scale: 5,
                          ),
                        ),
                        CommonWidget.commonSizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.textBoldWight600(
                                  text: listOfNews[index]['title'],
                                  fontSize: 16.sp),
                              CommonWidget.commonSizedBox(height: 8),
                              CommonText.textBoldWight400(
                                  text: listOfNews[index]['text']),
                            ],
                          ),
                        )
                      ],
                    ));
              },
            )
          ],
        ),
      ),
    );
  }

  CarouselSlider bannerWidget() {
    return CarouselSlider(
        items: List.generate(3, (index) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: CommonColor.themColor9295E2,
                borderRadius: BorderRadius.circular(14)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CommonText.textBoldWight400(
                  text: 'Frame 8', color: Colors.white60),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonText.textBoldWight700(
                      text: 'TANLA PLATFORMS', color: Colors.white),
                ),
                Spacer(),
                Column(children: [
                  Row(
                    children: [
                      Image.asset(
                        ImageConst.upArrow,
                        scale: 2.8,
                      ),
                      CommonText.textBoldWight400(
                          text: '30%', color: Colors.white)
                    ],
                  ),
                  Row(
                    children: [
                      CommonText.textBoldWight400(
                          text: '28 JUL -',
                          color: Colors.white,
                          fontSize: 8.sp),
                      CommonText.textBoldWight400(
                          text: '5 AUG', color: Colors.white, fontSize: 8.sp),
                    ],
                  )
                ]),
              ]),
              CommonWidget.commonSizedBox(height: 20),
              CommonText.textBoldWight600(
                  color: Colors.white,
                  fontSize: 10.sp,
                  text:
                      "✅ Company will consider a proposal for buybac of Equity Shares on Thursday September 08, 2022"),
              CommonWidget.commonSizedBox(height: 6),
              CommonText.textBoldWight600(
                  fontSize: 10.sp,
                  color: Colors.white,
                  text:
                      "ℹ️ Buyback reflects confidence of investors and is generally  positive for stock price")
            ]),
          );
        }),
        options: CarouselOptions(
          //  height: 180,
          aspectRatio: 16 / 9,
          viewportFraction: 0.85,
          pageSnapping: true,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: false,
          autoPlayInterval: Duration(seconds: 3),
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: true,
          onPageChanged: (index, reason) {
            setState(() {
              pagerIndex = index;
            });
          },
          scrollDirection: Axis.horizontal,
        ));
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
        CommonText.textBoldWight700(text: 'Good evening  🙌', fontSize: 16.sp),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: CommonText.textBoldWight400(text: 'Login'),
          decoration: BoxDecoration(
              border: Border.all(color: CommonColor.themDarkColor6E5DE7),
              borderRadius: BorderRadius.circular(100)),
        ),
        CommonWidget.commonSizedBox(width: 10),
        Container(
            padding: EdgeInsets.all(10),
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

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);

  List drawerDataList = [
    {'icon': ImageConst.bellIcon, 'text': 'Notifications'},
    {'icon': ImageConst.userPlus, 'text': 'Referrals'},
    {'icon': ImageConst.googlePlayIcon, 'text': 'Rate us on play \nstore'},
    {'icon': ImageConst.chatIcon, 'text': 'Contact us'},
    {'icon': ImageConst.shareIcon, 'text': 'Share with a \nfriend'},
    {'icon': ImageConst.signOutICON, 'text': 'Logout'},
  ];

  List platFormIcon = [
    ImageConst.twiterIcon,
    ImageConst.linkedinIcon,
    ImageConst.telegramIcon
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 220,
        color: Colors.white,
        child: SafeArea(
          child: Column(children: [
            CommonWidget.commonSizedBox(height: 10),
            Image.asset(
              ImageConst.iconWidget,
              scale: 3,
            ),
            CommonText.textBoldWight600(text: 'FinWizz', fontSize: 18.sp),
            CommonWidget.commonSizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Divider(color: CommonColor.amberBlackColor072D4B),
            ),
            Spacer(),
            Column(
              children: List.generate(
                  drawerDataList.length,
                  (index) => Padding(
                        padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                                height: 24.sp,
                                width: 24.sp,
                                child:
                                    Image.asset(drawerDataList[index]['icon'])),
                            CommonWidget.commonSizedBox(width: 10),
                            CommonText.textBoldWight400(
                                text: drawerDataList[index]['text'])
                          ],
                        ),
                      )),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 20),
              child: Divider(color: CommonColor.amberBlackColor072D4B),
            ),
            CommonText.textBoldWight400(
                text: 'Follow us on', color: CommonColor.amberBlackColor072D4B),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  platFormIcon.length,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 24.sp,
                          height: 24.sp,
                          child: Image.asset(platFormIcon[index]),
                        ),
                      )),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, bottom: 10),
              child: Divider(color: CommonColor.amberBlackColor072D4B),
            ),
            CommonText.textBoldWight400(
                text: '2022 FinWizz', color: CommonColor.amberBlackColor072D4B),
            CommonWidget.commonSizedBox(height: 20),
          ]),
        ));
  }
}
