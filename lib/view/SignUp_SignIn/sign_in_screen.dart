import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/view/SignUp_SignIn/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:get/get.dart';

import '../../get_storage_services/get_storage_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset("assets/png/stack_bubel.png", scale: 4.2),
          CommonWidget.commonSizedBox(height: 20),
          Center(
            child: CommonText.textBoldWight600(
                text: 'Welcome Back!', fontSize: 25.sp),
          ),
          CommonWidget.commonSizedBox(height: 40.sp),
          CommonWidget.textFormField(
              maxLength: 10,
              keyBoardType: TextInputType.number,
              controller: phoneController,
              hintText: "Phone Number"),
          CommonWidget.commonSizedBox(height: 25.sp),
          CommonWidget.textFormField(
              suffix: InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText.textBoldWight400(
                      text: "Get OTP",
                      color: Color(0xff0865D3),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                  ],
                ),
              ),
              maxLength: 6,
              keyBoardType: TextInputType.number,
              controller: otpController,
              hintText: "OTP"),
          CommonWidget.commonSizedBox(height: 5.sp),
          InkWell(
            onTap: () {},
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                ),
                CommonText.textBoldWight400(
                  text: " Resend OTP",
                  color: Color(0xff0865D3),
                ),
                SizedBox(
                  width: 12,
                ),
              ],
            ),
          ),
          CommonWidget.commonSizedBox(height: 25.sp),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Checkbox(
                value: isChecked,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.5),
                ),
                onChanged: (value) {
                  setState(() {
                    isChecked = value!;
                  });
                },
              ),
              CommonText.textBoldWight400(
                  text: "I agree to the FinWizz ", fontSize: 9.sp),
              CommonText.textBoldWight400(
                text: "Terms and Conditions",
                color: Color(0xff0865D3),
                fontSize: 9.sp,
              ),
            ],
          ),
          CommonWidget.commonSizedBox(height: 25.sp),
          Center(
            child: MaterialButton(
                elevation: 0,
                onPressed: () {
                  if (phoneController.text.isNotEmpty &&
                      otpController.text.isNotEmpty) {
                    GetStorageServices.setUserLoggedIn();
                  } else {
                    CommonWidget.getSnackBar(
                        color: Colors.red,
                        colorText: Colors.white,
                        title: "Required!",
                        message: "Please enter Phone No or OTP");
                  }
                },
                color: Color(0xffcecef0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 55.sp, vertical: 12.sp),
                  child: CommonText.textBoldWight600(
                      text: "Sign In", color: Colors.white),
                )),
          ),
          CommonWidget.commonSizedBox(height: 40.sp),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Get.off(() => SignUpScreen());
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CommonText.textBoldWight500(
                    text: "Don’t have an account? ", fontSize: 11.sp),
                CommonText.textBoldWight600(
                  text: "Sign Up",
                  color: Color(0xff0865D3),
                  fontSize: 11.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
