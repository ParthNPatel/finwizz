import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:flutter/material.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                decoration: BoxDecoration(
                    color: CommonColor.whiteColorF4F6F9,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(
                  children: [
                    CommonText.textBoldWight400(text: 'Search'),
                    Spacer(),
                    Icon(Icons.search)
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
