import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/search_movers_res_model.dart';
import 'package:finwizz/Models/responseModel/search_news_res_model.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/controller/handle_screen_controller.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/view/notification/notification_screen.dart';
import 'package:finwizz/viewModel/search_movers_view_model.dart';
import 'package:finwizz/viewModel/search_news_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/image_const.dart';
import '../Home/home_screen.dart';
import '../SignUp_SignIn/sign_in_screen.dart';
import 'movers_screen.dart';
import 'news_screen.dart';

class NewsMainScreen extends StatefulWidget {
  final String? newsId;
  bool isNoti = false;

  NewsMainScreen({Key? key, this.newsId, required this.isNoti})
      : super(key: key);

  @override
  State<NewsMainScreen> createState() => _NewsMainScreenState();
}

class _NewsMainScreenState extends State<NewsMainScreen>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey<ScaffoldState>();
  TabController? tabController;
  TextEditingController _searchController = TextEditingController();

  SearchNewsViewModel searchNewsViewModel = Get.put(SearchNewsViewModel());
  SearchMoversViewModel searchMoversViewModel =
      Get.put(SearchMoversViewModel());
  HandleScreenController controller = Get.find();
  SearchNewsResponseModel? response;
  SearchMoversResponseModel? moversResponse;

  bool catVisible = true;
  bool catMoversVisible = true;
  bool isLoading = false;
  int tag = 0;

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
    if (widget.isNoti) {
      searchNewsViewModel.searchNewsViewModel(companyId: "${widget.newsId}");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      drawer: DrawerWidget(),
      body: SafeArea(
        child: Column(
          children: [
            CommonWidget.commonSizedBox(height: 10),
            appWidget(),
            CommonWidget.commonSizedBox(height: 10),
            tag == 0 ? searchWidget() : searchMoversWidget(),
            Stack(
              fit: StackFit.passthrough,
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xffDADEE3), width: 4),
                    ),
                  ),
                ),
                TabBar(
                  //isScrollable: true,
                  controller: tabController,
                  labelPadding: EdgeInsets.symmetric(vertical: 9.sp),
                  unselectedLabelColor: Colors.black,
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Color(0xff9295E2), width: 4),
                  ),
                  onTap: (value) {
                    setState(() {
                      tag = value;
                      _searchController.clear();
                    });
                  },
                  tabs: [
                    Text(
                      'News',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp),
                    ),
                    Text(
                      'Movers',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  NewsScreen(
                      isCategoryVisible: catVisible,
                      response: response,
                      isLoading: isLoading),
                  MoversScreen(
                      isCategoryVisible: catMoversVisible,
                      response: moversResponse,
                      isLoading: isLoading),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  GetBuilder searchWidget() {
    return GetBuilder<SearchNewsViewModel>(builder: (controller) {
      return Container(
          height: 44,
          padding: EdgeInsets.only(top: 11, bottom: 11, left: 30, right: 15),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: CommonColor.whiteColorF4F6F9,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: _searchController,
            onChanged: (value) async {
              if (_searchController.text.isNotEmpty &&
                  _searchController.text != "") {
                setState(() {
                  catVisible = false;
                });
              } else {
                setState(() {
                  catVisible = true;
                });
              }

              await controller.searchNewsViewModel(
                  searchText: _searchController.text.trim(), isLoading: false);

              if (controller.searchNewsApiResponse.status == Status.LOADING) {
                setState(() {
                  isLoading = true;
                });
              }

              if (controller.searchNewsApiResponse.status == Status.COMPLETE) {
                setState(() {
                  isLoading = false;
                  response = controller.searchNewsApiResponse.data;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(top: 2),
              hintText: 'Search',
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xff858C94),
              ),
              border: InputBorder.none,
            ),
          ));
    });
  }

  GetBuilder searchMoversWidget() {
    return GetBuilder<SearchMoversViewModel>(builder: (controller) {
      return Container(
          height: 44,
          padding: EdgeInsets.only(top: 11, bottom: 11, left: 30, right: 15),
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          decoration: BoxDecoration(
            color: CommonColor.whiteColorF4F6F9,
            borderRadius: BorderRadius.circular(30),
          ),
          child: TextFormField(
            controller: _searchController,
            onChanged: (value) async {
              if (_searchController.text.isNotEmpty &&
                  _searchController.text != "") {
                setState(() {
                  catMoversVisible = false;
                });
              } else {
                setState(() {
                  catMoversVisible = true;
                });
              }

              await controller.searchMoversViewModel(
                  searchText: _searchController.text.trim(), isLoading: false);

              if (controller.searchMoversApiResponse.status == Status.LOADING) {
                setState(() {
                  isLoading = true;
                });
              }

              if (controller.searchMoversApiResponse.status ==
                  Status.COMPLETE) {
                setState(() {
                  isLoading = false;
                  moversResponse = controller.searchMoversApiResponse.data;
                });
              }
            },
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.only(top: 2),
              hintText: 'Search',
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xff858C94),
              ),
              border: InputBorder.none,
            ),
          ));
    });
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
          ),
        ),
        GetStorageServices.getUserLoggedInStatus() == true
            ? CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 14.sp)
            : CommonText.textBoldWight700(
                text: 'Good evening  🙌', fontSize: 14.sp),
        Spacer(),
        GetStorageServices.getUserLoggedInStatus() == true
            ? GetBuilder<HandleScreenController>(
                builder: (controller) => InkWell(
                  onTap: () {
                    setState(() {});

                    controller.changeTapped(true);
                  },
                  child: CommonWidget.commonSvgPitcher(
                    image: ImageConst.bookMark,
                  ),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Get.to(() => SignInScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: CommonText.textBoldWight400(text: 'Login'),
                  decoration: BoxDecoration(
                    border: Border.all(color: CommonColor.themDarkColor6E5DE7),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
        CommonWidget.commonSizedBox(width: 10),
        GestureDetector(
          onTap: () {
            GetStorageServices.getUserLoggedInStatus() == true
                ? Get.to(NotificationScreen())
                : Get.to(() => SignInScreen());
          },
          child: Container(
            // padding: EdgeInsets.all(8),
            // alignment: Alignment.center,
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
