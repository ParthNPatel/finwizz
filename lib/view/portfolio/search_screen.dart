import 'package:finwizz/Models/apis/api_response.dart';
import 'package:finwizz/Models/responseModel/search_stock_res_model.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/viewModel/add_stock_view_model.dart';
import 'package:finwizz/viewModel/search_stock_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../constant/color_const.dart';
import '../../controllers/portfolio_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _searchController = TextEditingController();

  SearchStockViewModel searchStockViewModel = Get.put(SearchStockViewModel());
  AddStockViewModel addStockViewModel = Get.put(AddStockViewModel());
  List listOfStocks = [
    {
      'title': 'TANLA',
      'updates': [1, 5]
    },
    {
      'title': 'TATA MOTORS',
      'updates': [2]
    },
    {
      'title': 'RELIANCE',
      'updates': [],
    }
  ];
  PortFolioController _portFolioController = Get.find();
  @override
  void initState() {
    searchStockViewModel.searchStockViewModel();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            CommonWidget.commonSizedBox(height: 10),
            appBarWidget(),
            CommonWidget.commonSizedBox(height: 10),
            searchBarWidget(),
            CommonWidget.commonSizedBox(height: 12),
            GetBuilder<SearchStockViewModel>(
              builder: (controller) {
                if (controller.searchStockApiResponse.status ==
                    Status.LOADING) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.searchStockApiResponse.status ==
                    Status.COMPLETE) {
                  SearchStockResponseModel searchStock =
                      controller.searchStockApiResponse.data;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            CommonText.textBoldWight600(
                                text: 'Search result for '),
                            CommonText.textBoldWight400(text: "'to'"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: CommonColor.greyColorD1CDCD,
                        ),
                      ),
                      searchStock.data!.length == 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              child: CommonText.textBoldWight400(
                                  text:
                                      'No results found. We are constantly working '
                                      'on adding support for more stocks. Please check again after sometime.'),
                            )
                          : ListView.builder(
                              itemCount: searchStock.data!.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () async {
                                    await addStockViewModel.addStockViewModel(
                                        body: {
                                          "stockId":
                                              "${searchStock.data![index].id}"
                                        });
                                    if (addStockViewModel
                                            .addStockApiResponse.status ==
                                        Status.COMPLETE) {
                                      _portFolioController.isAddShare = true;
                                      CommonWidget.getSnackBar(
                                          color: Colors.green,
                                          duration: 2,
                                          colorText: Colors.white,
                                          title: "Stock Added successfully!",
                                          message: 'Successfully');

                                      Get.off(() => BottomNavScreen(
                                            selectedIndex: 2,
                                          ));
                                    }
                                    if (addStockViewModel
                                            .addStockApiResponse.status ==
                                        Status.ERROR) {
                                      CommonWidget.getSnackBar(
                                          color: Colors.red,
                                          duration: 2,
                                          colorText: Colors.white,
                                          title: "Try again",
                                          message: 'Failed');
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: CommonText.textBoldWight400(
                                                    text:
                                                        '${searchStock.data![index].name}'),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.star_border,
                                                color:
                                                    CommonColor.greyColorA3A3A3,
                                              )
                                            ],
                                          ),
                                        ),
                                        CommonWidget.commonSizedBox(height: 6),
                                        Divider(
                                          color: CommonColor.greyColorD1CDCD,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  );
                }
                return Center(
                  child: Text('Something went wrong'),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Padding appBarWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 20),
      child: Row(
        children: [
          CommonText.textBoldWight600(text: 'Add Stocks', fontSize: 18.sp),
          Spacer(),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CommonColor.greyColorB0A7A7.withOpacity(0.2)),
                child: Icon(Icons.close)),
          )
        ],
      ),
    );
  }

  Row searchBarWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44,
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 15),
            margin: EdgeInsets.only(left: 14, right: 10, bottom: 10, top: 10),
            decoration: BoxDecoration(
              color: CommonColor.whiteColorF4F6F9,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextFormField(
              controller: _searchController,
              onChanged: (value) async {
                await searchStockViewModel.searchStockViewModel(
                    searchText: _searchController.text.trim(),
                    isLoading: false);
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
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            await searchStockViewModel.searchStockViewModel(
                searchText: _searchController.text.trim(), isLoading: false);
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: CommonText.textBoldWight700(
              text: 'SEARCH',
              fontSize: 10.sp,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CommonColor.themColor9295E2,
            ),
          ),
        ),
      ],
    );
  }
}

// No results found. We are constantly working on adding support for more stocks. Please check again after sometime.
