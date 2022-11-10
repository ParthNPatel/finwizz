import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:sizer/sizer.dart';
import 'package:flutter_svg/svg.dart';

import '../constant/color_const.dart';
import '../constant/text_const.dart';
import '../constant/text_styel.dart';

class CommonWidget {
  static SizedBox commonSizedBox({double? height, double? width}) {
    return SizedBox(height: height, width: width);
  }

  static Widget textFormField(
      {String? hintText,
      List<TextInputFormatter>? inpuFormator,
      required TextEditingController controller,
      int? maxLength,
      TextInputType? keyBoardType,
      bool isObscured = false,
      Widget? prefix,
      Widget? suffix}) {
    return SizedBox(
      height: 43.sp,
      child: TextFormField(
        obscureText: isObscured,
        inputFormatters: inpuFormator,
        maxLength: maxLength,
        controller: controller,
        keyboardType: keyBoardType,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontFamily: TextConst.fontFamily,
        ),
        cursorColor: Colors.black,
        decoration: InputDecoration(
            prefixIcon: prefix,
            contentPadding: EdgeInsets.only(top: 7.sp, left: 12.sp),
            suffixIcon: suffix,
            filled: true,
            //fillColor: CommonColor.textFiledColorFAFAFA,
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: TextConst.fontFamily,
              fontWeight: FontWeight.w500,
              // color: CommonColor.hinTextColor
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  static commonButton({required VoidCallback onTap, required String text}) {
    return MaterialButton(
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: CommonColor.themColor9295E2,
      height: 40.sp,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CommonText.textBoldWight600(
              text: text, color: Colors.white, fontSize: 12.sp)
        ]),
      ),
    );
  }

  static getSnackBar(
      {required String title,
      required String message,
      Color color = const Color(0xff9295E2),
      Color colorText = Colors.white,
      int duration = 1}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      colorText: colorText,
      duration: Duration(seconds: duration),
      backgroundColor: color,
    );
  }

  static Widget commonSvgPitcher(
      {required String image, required double height, required double width}) {
    return SvgPicture.asset(
      image,
      height: height,
      width: width,
    );
  }
}
