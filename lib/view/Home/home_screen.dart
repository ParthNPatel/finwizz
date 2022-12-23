import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/repo/contact_us_repo.dart';
import 'package:finwizz/Models/responseModel/contact_us_res_model.dart';
import 'package:finwizz/Models/responseModel/get_all_news_data.dart';
import 'package:finwizz/Models/responseModel/get_user_res_model.dart';
import 'package:finwizz/Models/responseModel/update_user_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/image_const.dart';
import 'package:finwizz/constant/text_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/view/SignUp_SignIn/sign_in_screen.dart';
import 'package:finwizz/viewModel/get_all_news_view_model.dart';
import 'package:finwizz/viewModel/get_user_view_model.dart';
import 'package:finwizz/viewModel/update_user_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../components/indicatorWidget.dart';
import '../notification/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _submitController = TextEditingController();
  int pagerIndex = 0;
  GetAllNewsViewModel getAllNewsViewModel = Get.put(GetAllNewsViewModel());
  GetUserViewModel getUserViewModel = Get.put(GetUserViewModel());

  List colors = [
    Color(0xffEB7777),
    CommonColor.themColor9295E2,
    Color(0xff7AA0DA),
  ];

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

  @override
  void initState() {
    getUserData();
    getAllNewsViewModel.getNewsViewModel(catId: "");
    super.initState();
  }

  getUserData() async {
    if (GetStorageServices.getUserLoggedInStatus() == true) {
      await getUserViewModel.getUserViewModel();

      if (getUserViewModel.getUserApiResponse.status == Status.COMPLETE) {
        GetUserResponseModel response =
            getUserViewModel.getUserApiResponse.data;

        GetStorageServices.setReferralCode(response.data!.refferalCode ?? "");
        GetStorageServices.setReferralCount(response.data!.refferalCount ?? 0);

        print('====== > ${GetStorageServices.getReferralCount()}');
        print('====== > ${GetStorageServices.getReferralCode()}');
      }
    }
  }

  // bool isOpen = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerWidget(),
      key: globalKey,
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CommonWidget.commonSizedBox(height: 10),
          appWidget(),
          scrollWidget()
        ]),
      ),
    );
  }

  SimpleDialog buildSimpleDialog() {
    return SimpleDialog(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CommonWidget.commonSizedBox(height: 12),
            CommonText.textBoldWight600(
                text: 'Your opinion matters!', fontSize: 16.sp),
            CommonWidget.commonSizedBox(height: 9),
            RatingBar(
              initialRating: 0,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemSize: 28,
              itemCount: 5,
              ratingWidget: RatingWidget(
                full: Icon(Icons.star, color: CommonColor.yellowColorFFC633),
                half:
                    Icon(Icons.star_half, color: CommonColor.yellowColorFFC633),
                empty: Icon(
                  Icons.star_border_outlined,
                ),
              ),
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            CommonWidget.commonSizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText.textBoldWight400(
                  text: 'Please tell us how we can improve ',
                ),
                CommonText.textBoldWight400(
                    text: '*', color: CommonColor.redColorFF2950),
              ],
            ),
            CommonWidget.commonSizedBox(height: 9),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                  contentPadding: EdgeInsets.only(top: 7.sp, left: 12.sp),
                  filled: true,
                  //fillColor: CommonColor.textFiledColorFAFAFA,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: CommonColor.geryColorC9C5C5),
                    borderRadius: new BorderRadius.circular(25.7),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        new BorderSide(color: CommonColor.geryColorC9C5C5),
                    borderRadius: new BorderRadius.circular(25.7),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 9),
                child: CommonText.textBoldWight400(
                    text: 'Submit', color: Colors.white),
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
            CommonWidget.commonSizedBox(height: 12),
          ],
        )
      ],
    );
  }

  Expanded scrollWidget() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonWidget.commonSizedBox(height: 30),
            GetBuilder<GetAllNewsViewModel>(
              builder: (controller) {
                if (controller.getNewsApiResponse.status == Status.LOADING) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.getNewsApiResponse.status == Status.COMPLETE) {
                  GetAllNewsModel getAllNews =
                      controller.getNewsApiResponse.data;
                  return getAllNews.data!.length == 0
                      ? SizedBox()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: CommonText.textBoldWight600(
                                  text: TextConst.latestMovers,
                                  fontSize: 16.sp,
                                  color: CommonColor.themDarkColor6E5DE7),
                            ),
                            CommonWidget.commonSizedBox(height: 30),
                            bannerWidget(getAllNews),
                            CommonWidget.commonSizedBox(height: 35),
                            PageIndicator(
                                pagerIndex: pagerIndex,
                                totalPages: getAllNews.data!.length > 3
                                    ? 3
                                    : getAllNews.data!.length),
                            CommonWidget.commonSizedBox(height: 30),
                          ],
                        );
                }
                return SizedBox();
              },
            ),
            ListView.builder(
              itemCount: listOfNews.length,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // isOpen = false;
                    setState(() {
                      if (index == 0) {
                        Get.offAll(() => BottomNavScreen(selectedIndex: 1));
                      } else {
                        Get.offAll(() => BottomNavScreen(selectedIndex: 2));
                      }
                    });
                  },
                  child: Container(
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
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  CarouselSlider bannerWidget(GetAllNewsModel getAllNews) {
    return CarouselSlider(
        items: List.generate(
          getAllNews.data!.length > 3 ? 3 : getAllNews.data!.length,
          (index) {
            return Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: colors[index],
                  borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.textBoldWight400(
                      text: 'Frame 8', color: Colors.white60),
                  Row(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CommonText.textBoldWight700(
                          text: '${getAllNews.data![index].title}',
                          color: Colors.white),
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
                              text: '5 AUG',
                              color: Colors.white,
                              fontSize: 8.sp),
                        ],
                      )
                    ]),
                  ]),
                  CommonWidget.commonSizedBox(height: 20),
                  // CommonText.textBoldWight600(
                  //     color: Colors.white,
                  //     fontSize: 10.sp,
                  //     text:
                  //         "✅ Company will consider a proposal for buybac of Equity Shares on Thursday September 08, 2022"),
                  // CommonWidget.commonSizedBox(height: 6),
                  CommonText.textBoldWight600(
                      fontSize: 10.sp,
                      color: Colors.white,
                      text: "${getAllNews.data![index].description}")
                ],
              ),
            );
          },
        ),
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
        GetStorageServices.getUserLoggedInStatus() == true
            ? CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 14.sp)
            : CommonText.textBoldWight700(
                text: 'Good evening  🙌', fontSize: 14.sp),
        Spacer(),
        GetStorageServices.getUserLoggedInStatus() == true
            ? SizedBox()
            : GestureDetector(
                onTap: () {
                  Get.to(() => SignInScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: CommonText.textBoldWight400(text: 'Login'),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: CommonColor.themDarkColor6E5DE7),
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
        CommonWidget.commonSizedBox(width: 10),
        GestureDetector(
          onTap: () {
            Get.to(NotificationScreen());
          },
          child: Container(
            //padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //         begin: Alignment.center,
            //         end: Alignment.bottomCenter,
            //         colors: [
            //           Color(0xff6E5DE7).withOpacity(0.8),
            //           Color(0xff6E5DE7).withOpacity(0.8),
            //         ]),
            //     shape: BoxShape.circle,
            //     color: CommonColor.themColor9295E2),
            child: Image.asset(
              'assets/png/notification.png',
              scale: 3.3,
            ),
          ),
        ),
        CommonWidget.commonSizedBox(width: 10)
      ],
    );
  }
}

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  List drawerDataList = [
    {'icon': ImageConst.bellIcon, 'text': 'Notifications'},
    {'icon': ImageConst.userPlus, 'text': 'Referrals'},
    {'icon': ImageConst.googlePlayIcon, 'text': 'Rate us on play \nstore'},
    {'icon': ImageConst.chatIcon, 'text': 'Contact us'},
    {'icon': ImageConst.shareIcon, 'text': 'Share with a \nfriend'},
    {'icon': ImageConst.signOutICON, 'text': 'Logout'},
  ];
  List drawerWithoutLogin = [
    {'icon': ImageConst.googlePlayIcon, 'text': 'Rate us on play \nstore'},
    {'icon': ImageConst.chatIcon, 'text': 'Contact us'},
    {'icon': ImageConst.shareIcon, 'text': 'Share with a \nfriend'},
    {'icon': ImageConst.signOutICON, 'text': 'Login'},
  ];
  List platFormIcon = [
    ImageConst.twiterIcon,
    ImageConst.linkedinIcon,
    ImageConst.telegramIcon
  ];

  final name = TextEditingController();

  final email = TextEditingController();

  final message = TextEditingController();

  bool isCheckedNews = GetStorageServices.getNewsAlerts() ?? false;

  bool isCheckedPortfolio = GetStorageServices.getPortfolioAlerts() ?? false;

  UpdateUserViewModel updateUserViewModel = Get.put(UpdateUserViewModel());
  bool emailCheck = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Column(children: [
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
              ]),
              Column(
                children: GetStorageServices.getUserLoggedInStatus() == true
                    ? withLogin()
                    : withoutLogin(),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    child: Divider(color: CommonColor.amberBlackColor072D4B),
                  ),
                  CommonText.textBoldWight400(
                      text: 'Follow us on',
                      color: CommonColor.amberBlackColor072D4B),
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
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 10),
                    child: Divider(color: CommonColor.amberBlackColor072D4B),
                  ),
                  CommonText.textBoldWight400(
                      text: '2022 FinWizz',
                      color: CommonColor.amberBlackColor072D4B),
                  CommonWidget.commonSizedBox(height: 20),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> withLogin() {
    return List.generate(
        drawerDataList.length,
        (index) => Padding(
              padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  if (index == 1) {
                    Get.back();
                    Get.dialog(referrals());
                  } else if (index == 3) {
                    Get.back();

                    Get.dialog(contactUs());
                  } else if (index == 0) {
                    Get.back();

                    Get.dialog(GetBuilder<UpdateUserViewModel>(
                        builder: (controllerUser) {
                      return StatefulBuilder(
                        builder: (context, setState) => Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(40.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: CommonText.textBoldWight600(
                                      text: "Notifications",
                                      fontSize: 18.sp,
                                      color: Colors.black),
                                ),
                                CommonWidget.commonSizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 100.sp,
                                      child: CommonText.textBoldWight500(
                                          text: "News",
                                          fontSize: 13.sp,
                                          color: Colors.black),
                                    ),
                                    Spacer(),
                                    CupertinoSwitch(
                                      activeColor: CommonColor.themColor9295E2,
                                      value: isCheckedNews,
                                      onChanged: (value) async {
                                        setState(() {
                                          isCheckedNews = value;
                                        });
                                        // log("check ========= > $isCheckedNews");

                                        await controllerUser
                                            .updateUserViewModel(body: {
                                          "newsAlerts": isCheckedNews,
                                        });
                                        // log("status ===== > ${controllerUser.updateUserApiResponse.status}");

                                        if (controllerUser
                                                .updateUserApiResponse.status ==
                                            Status.COMPLETE) {
                                          UpdateUserResponseModel resp =
                                              controllerUser
                                                  .updateUserApiResponse.data;

                                          // log("isCheckedNews ------ > ${resp.data!.newsAlerts!}");

                                          GetStorageServices.setNewsAlerts(
                                              resp.data!.newsAlerts!);

                                          // CommonWidget.getSnackBar(
                                          //     color: Colors.green,
                                          //     duration: 2,
                                          //     colorText: Colors.white,
                                          //     title: "isCheckedNews",
                                          //     message: 'Updated successfully');
                                        }

                                        if (controllerUser
                                                .updateUserApiResponse.status ==
                                            Status.ERROR) {
                                          // CommonWidget.getSnackBar(
                                          //     color: Colors.red,
                                          //     duration: 2,
                                          //     colorText: Colors.white,
                                          //     title:
                                          //         "Something went wrong isCheckedNews",
                                          //     message: 'Try Again.');
                                        }
                                      },
                                    ),
                                    Icon(
                                      Icons.lock_outline,
                                      color: Colors.transparent,
                                    )
                                  ],
                                ),
                                CommonWidget.commonSizedBox(height: 20.sp),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 100.sp,
                                      child: CommonText.textBoldWight500(
                                          text: "Portfolio alerts ",
                                          fontSize: 13.sp,
                                          color: Colors.black),
                                    ),
                                    Spacer(),
                                    CupertinoSwitch(
                                      activeColor: CommonColor.themColor9295E2,
                                      value: isCheckedPortfolio,
                                      onChanged: (value) async {
                                        setState(() {
                                          isCheckedPortfolio = value;
                                        });

                                        await controllerUser
                                            .updateUserViewModel(body: {
                                          "portfolioAlerts": isCheckedPortfolio
                                        });

                                        if (controllerUser
                                                .updateUserApiResponse.status ==
                                            Status.COMPLETE) {
                                          UpdateUserResponseModel resp =
                                              controllerUser
                                                  .updateUserApiResponse.data;

                                          GetStorageServices.setPortfolioAlerts(
                                              resp.data!.portfolioAlerts!);

                                          // CommonWidget.getSnackBar(
                                          //     color: Colors.green,
                                          //     duration: 2,
                                          //     colorText: Colors.white,
                                          //     title: "isCheckedPortfolio",
                                          //     message: 'Updated successfully');
                                        }
                                        if (controllerUser
                                                .updateUserApiResponse.status ==
                                            Status.ERROR) {
                                          // CommonWidget.getSnackBar(
                                          //     color: Colors.red,
                                          //     duration: 2,
                                          //     colorText: Colors.white,
                                          //     title: "Something went wrong",
                                          //     message: 'Try Again.');
                                        }
                                      },
                                    ),
                                    Icon(
                                      Icons.lock_outline,
                                      color: CommonColor.primaryColor,
                                    )
                                  ],
                                ),
                                CommonWidget.commonSizedBox(height: 20.sp),
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
                  } else if (index == 5) {
                    GetStorageServices.logOut();
                    Get.offAll(() => BottomNavScreen(selectedIndex: 0));
                  }
                },
                child: Row(
                  children: [
                    SizedBox(
                        height: 24.sp,
                        width: 24.sp,
                        child: Image.asset(
                          drawerDataList[index]['icon'],
                          scale: 2,
                        )),
                    CommonWidget.commonSizedBox(width: 10),
                    CommonText.textBoldWight400(
                        text: drawerDataList[index]['text'])
                  ],
                ),
              ),
            ));
  }

  List<Widget> withoutLogin() {
    return List.generate(
        drawerWithoutLogin.length,
        (index) => Padding(
              padding: EdgeInsets.only(left: 24, top: 8, bottom: 8),
              child: InkWell(
                onTap: () {
                  print('indexindex   $index');
                  if (index == 1) {
                    Get.back();
                  } else if (index == 3) {
                    Get.back();
                    Get.to(() => SignInScreen());
                  } else if (index == 0) {
                    Get.back();
                  } else if (index == 4) {
                    // GetStorageServices.logOut();

                  } else if (index == 2) {
                    Get.back();
                  }
                },
                child: Row(
                  children: [
                    SizedBox(
                        height: 24.sp,
                        width: 24.sp,
                        child: Image.asset(drawerWithoutLogin[index]['icon'])),
                    CommonWidget.commonSizedBox(width: 10),
                    CommonText.textBoldWight400(
                        text: drawerWithoutLogin[index]['text'])
                  ],
                ),
              ),
            ));
  }

  Dialog contactUs() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: CommonText.textBoldWight500(
                  text: "Contact Us", fontSize: 18.sp, color: Colors.black),
            ),
            CommonWidget.commonSizedBox(height: 20),
            CommonText.textBoldWight500(
                text: "Name", fontSize: 12.sp, color: Colors.black),
            CommonWidget.commonSizedBox(height: 10),
            SizedBox(
              height: 35.sp,
              width: 130.sp,
              child: SizedBox(
                child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: 3, left: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Color(0xffC9C5C5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Color(0xffC9C5C5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CommonWidget.commonSizedBox(height: 20),
            CommonText.textBoldWight500(
                text: "Email", fontSize: 12.sp, color: Colors.black),
            CommonWidget.commonSizedBox(height: 10),
            SizedBox(
              height: 35.sp,
              child: SizedBox(
                child: TextFormField(
                  controller: email,
                  onChanged: (value) {
                    setState(() {
                      emailCheck = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email.text);
                    });
                  },
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6.sp),
                      child: CircleAvatar(
                        radius: 5.sp,
                        backgroundColor:
                            emailCheck ? Colors.green : Colors.grey.shade300,
                        child: Icon(Icons.done,
                            color: emailCheck ? Colors.white : Colors.grey,
                            size: 8.sp),
                      ),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 3, left: 15),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Color(0xffC9C5C5),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide(
                        color: Color(0xffC9C5C5),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            CommonWidget.commonSizedBox(height: 20),
            CommonText.textBoldWight500(
                text: "Message", fontSize: 12.sp, color: Colors.black),
            CommonWidget.commonSizedBox(height: 10),
            TextFormField(
              maxLines: 7,
              controller: message,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(bottom: 3, left: 15),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xffC9C5C5),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: Color(0xffC9C5C5),
                  ),
                ),
              ),
            ),
            CommonWidget.commonSizedBox(height: 20),
            Center(
              child: MaterialButton(
                  elevation: 0,
                  onPressed: () async {
                    log("Pressed ");

                    if (name.text.isNotEmpty &&
                        email.text.isNotEmpty &&
                        message.text.isNotEmpty) {
                      if (RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email.text)) {
                        ContactUsResponseModel response =
                            await ContactUsRepo.contactUsRepo(body: {
                          "name": "${name.text.trim()}",
                          "email": "${email.text.trim()}",
                          "message": "${message.text.trim()}"
                        });
                        Get.back();

                        if (response.flag == true) {
                          CommonWidget.getSnackBar(
                              color: Colors.green.withOpacity(.5),
                              duration: 2,
                              colorText: Colors.white,
                              title: "${response.flag}",
                              message: 'Your query delivered successfully');
                        } else {
                          CommonWidget.getSnackBar(
                              color: Colors.red.withOpacity(.5),
                              duration: 2,
                              colorText: Colors.white,
                              title: "${response.flag}",
                              message: 'Something went wrong');
                        }
                      } else {
                        CommonWidget.getSnackBar(
                            color: Colors.red.withOpacity(.5),
                            duration: 2,
                            colorText: Colors.white,
                            title: "Email not valid",
                            message: 'Please enter valid email address');
                      }
                    }
                  },
                  color: Color(0xff9295E2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 55.sp, vertical: 8.sp),
                    child: CommonText.textBoldWight600(
                      text: "SUBMIT",
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
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
}
