import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../components/common_widget.dart';
import '../../constant/color_const.dart';
import '../../constant/text_styel.dart';
import '../../get_storage_services/get_storage_service.dart';
import '../SignUp_SignIn/sign_up_screen.dart';

class MoversScreen extends StatefulWidget {
  const MoversScreen({Key? key}) : super(key: key);

  @override
  State<MoversScreen> createState() => _MoversScreenState();
}

class _MoversScreenState extends State<MoversScreen> {
  bool isFavourite = true;
  bool isFavourite1 = true;

  @override
  Widget build(BuildContext context) {
    return GetStorageServices.getUserLoggedInStatus() == true
        ? SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                CommonWidget.commonSizedBox(height: 30),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  itemCount: 3,
                ),
              ],
            ),
          )
        : Padding(
            padding: EdgeInsets.only(top: 30),
            child: CreateAccount(),
          );
  }
}
