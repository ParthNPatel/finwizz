import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/controller/handle_screen_controller.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../components/common_widget.dart';
import '../../constant/image_const.dart';
import '../BookMark/book_mark_screen.dart';
import '../Home/home_screen.dart';
import '../SignUp_SignIn/sign_up_screen.dart';
import 'movers_screen.dart';
import 'news_screen.dart';
import 'package:get/get.dart';

class NewsMainScreen extends StatefulWidget {
  const NewsMainScreen({Key? key}) : super(key: key);

  @override
  State<NewsMainScreen> createState() => _NewsMainScreenState();
}

class _NewsMainScreenState extends State<NewsMainScreen>
    with SingleTickerProviderStateMixin {
  final globalKey = GlobalKey<ScaffoldState>();
  TabController? tabController;

  HandleScreenController controller = Get.find();

  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
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
            Container(
                padding:
                    EdgeInsets.only(top: 11, bottom: 11, left: 30, right: 15),
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                decoration: BoxDecoration(
                  color: CommonColor.whiteColorF4F6F9,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    CommonText.textBoldWight400(text: 'Search'),
                    Spacer(),
                    Icon(
                      Icons.search,
                      color: Color(0xff858C94),
                    )
                  ],
                )),
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
                  //onTap: (index) => tabsModel.value = listTabsModel[index],
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
                  NewsScreen(),
                  MoversScreen(),
                ],
              ),
            )
          ],
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
          ),
        ),
        GetStorageServices.getUserLoggedInStatus() == true
            ? CommonText.textBoldWight700(text: 'Hello  🙌', fontSize: 16.sp)
            : CommonText.textBoldWight700(
                text: 'Good evening  🙌', fontSize: 16.sp),
        Spacer(),
        GetStorageServices.getUserLoggedInStatus() == true
            ? InkWell(
                onTap: () {
                  controller.changeTapped(true);
                },
                child: CommonWidget.commonSvgPitcher(
                  image: ImageConst.bookMark,
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: CommonText.textBoldWight400(text: 'Login'),
                decoration: BoxDecoration(
                  border: Border.all(color: CommonColor.themDarkColor6E5DE7),
                  borderRadius: BorderRadius.circular(100),
                ),
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
