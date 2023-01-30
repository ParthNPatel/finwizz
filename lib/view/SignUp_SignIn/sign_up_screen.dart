import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/color_const.dart';
import 'package:finwizz/constant/text_const.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/get_storage_services/get_storage_service.dart';
import 'package:finwizz/services/app_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Models/repo/login_repo.dart';
import '../../Models/responseModel/country_model.dart';
import '../BottomNav/bottom_nav_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/png/stack_bubel.png", scale: 4.2),
            Center(
              child: CommonText.textBoldWight500(
                  text:
                      "To receive updates of your portfolio\n                stocks, please login"),
            ),
            CommonWidget.commonSizedBox(height: 20),
            CommonWidget.commonSizedBox(height: 20),
            CreateAccount(),
            CommonWidget.commonSizedBox(height: 40.sp),
            // InkWell(
            //   splashColor: Colors.transparent,
            //   highlightColor: Colors.transparent,
            //   onTap: () {
            //     GetStorageServices.setUserLoggedIn();
            //     Get.off(() => SignInScreen());
            //   },
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       CommonText.textBoldWight500(
            //           text: "Already have an account? ", fontSize: 11.sp),
            //       CommonText.textBoldWight600(
            //         text: "Sign In",
            //         color: Color(0xff0865D3),
            //         fontSize: 11.sp,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  final referralController = TextEditingController();

  bool isChecked = false;
  bool addReferral = false;

  String? verificationCode;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String? countryCode = "91";

  Country? selectedCountry;

  CountryModel? seletedCountry;

  Future<String> _loadAStudentAsset() async {
    return await rootBundle.loadString('assets/country.JSON');
  }

  Future<List<CountryModel>> loadCountry() async {
    String jsonString = await _loadAStudentAsset();
    final jsonResponse = json.decode(jsonString);

    List<CountryModel> listData = jsonResponse
        .map<CountryModel>((json) => CountryModel.fromJson(json))
        .toList();
    return listData;
  }

  Future sendOtp(final progress) async {
    print("Country Code===>>${countryCode}");
    progress.show();

    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: "+$countryCode" + phoneController.text,
      codeSent: (String verificationId, int? forceResendingToken) {
        setState(() {});
        verificationCode = verificationId;
        progress.dismiss();
      },
      verificationFailed: (FirebaseAuthException verificationFailed) {
        print('----verificationFailed---${verificationFailed.message}');
        CommonWidget.getSnackBar(
          message: verificationFailed.message!,
          title: 'Failed',
          duration: 2,
          color: Colors.red,
        );
        progress.dismiss();
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
        print('Done');
        progress.dismiss();
      },
    );
  }

  Future enterOtp(final progress) async {
    try {
      await AppNotificationHandler.getFcmToken();

      PhoneAuthCredential phoneAuthProvider =
          await PhoneAuthProvider.credential(
              verificationId: verificationCode!,
              smsCode: otpController.text.trim());

      log("getFcm ======= > up ${GetStorageServices.getFcm()}");

      firebaseAuth.signInWithCredential(phoneAuthProvider).catchError((e) {
        progress.dismiss();
        CommonWidget.getSnackBar(
          message: '',
          title: 'Enter valid Otp',
          duration: 2,
          color: Colors.red,
        );
      }).then((value) async {
        if (phoneAuthProvider.verificationId!.isEmpty) {
          log("Enter Valid OTP");
        } else {
          try {
            await LoginRepo.loginUserRepo(
                model: referralController.text.isNotEmpty &&
                        referralController.text != ""
                    ? {
                        "phone": "${phoneController.text.trim()}",
                        "fcm_token": "${GetStorageServices.getFcm()}",
                        "referralCode": "${referralController.text.trim()}",
                      }
                    : {
                        "phone": "${phoneController.text.trim()}",
                        "fcm_token": "${GetStorageServices.getFcm()}"
                      },
                progress: progress);
            GetStorageServices.setUserLoggedIn();
            Get.offAll(() => BottomNavScreen(selectedIndex: 0));
          } catch (e) {
            progress.dismiss();

            CommonWidget.getSnackBar(
              message: 'Ops',
              title: 'Something went wrong',
              duration: 2,
              color: Colors.red,
            );
          }
        }
      });
    } catch (e) {
      progress.dismiss();
      CommonWidget.getSnackBar(
        message: 'Ops',
        title: 'Enter valid OTP',
        duration: 2,
        color: Colors.red,
      );
    }
  }

  @override
  void initState() {
    loadCountry();
    seletedCountry = CountryModel("India", "🇮🇳", "IN", "+91");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
        barrierEnabled: false,
        child: Builder(
          builder: (context) {
            final progress = ProgressHUD.of(context);
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonWidget.commonSizedBox(height: 10.sp),
                  Center(
                    child: CommonText.textBoldWight600(
                        text: 'Welcome!', fontSize: 22.sp),
                  ),
                  CommonWidget.commonSizedBox(height: 15.sp),
                  CommonWidget.textFormField(
                      prefix: SizedBox(
                        width: 60.sp,
                        child: InkWell(
                          onTap: () {
                            // _displayDialog(context);
                            showCountryPicker(
                              context: context,
                              showPhoneCode:
                                  true, // optional. Shows phone code before the country name.
                              onSelect: (Country country) {
                                print('Select country: ${country.displayName}');
                                setState(() {
                                  selectedCountry = country;
                                });
                                countryCode = country.phoneCode;
                              },
                            );
                          },
                          child: Container(
                              margin:
                                  const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              alignment: Alignment.center,
                              height: 50,
                              width: 100,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    selectedCountry != null
                                        ? "+ ${selectedCountry!.phoneCode}"
                                        : "+91",
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              )),
                        ),
                      ),
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
                            InkWell(
                              onTap: () async {
                                if (phoneController.text.isNotEmpty) {
                                  await sendOtp(progress);
                                } else {
                                  CommonWidget.getSnackBar(
                                      color: Colors.red,
                                      colorText: Colors.white,
                                      title: "Required!",
                                      message: "Please enter Phone No");
                                }
                              },
                              child: CommonText.textBoldWight400(
                                text: "Get OTP",
                                color: Color(0xff0865D3),
                              ),
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
                  addReferral
                      ? CommonWidget.commonSizedBox(height: 25.sp)
                      : SizedBox(),
                  addReferral
                      ? CommonWidget.textFormField(
                          keyBoardType: TextInputType.text,
                          controller: referralController,
                          hintText: "Enter Referral Code")
                      : SizedBox(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: CommonText.textBoldWight400(
                            text: " Resend OTP",
                            color: Color(0xff0865D3),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              addReferral = !addReferral;
                            });
                          },
                          child: CommonText.textBoldWight400(
                            text: " Add Referral Code",
                            color: Color(0xff0865D3),
                          ),
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
                        onPressed: () async {
                          if (phoneController.text.isNotEmpty &&
                              otpController.text.isNotEmpty) {
                            if (isChecked == true) {
                              await enterOtp(progress);
                            } else {
                              CommonWidget.getSnackBar(
                                  color: Colors.red,
                                  colorText: Colors.white,
                                  title: "Required!",
                                  message:
                                      "Please check FinWizz terms and condition");
                            }
                          } else {
                            CommonWidget.getSnackBar(
                                color: Colors.red,
                                colorText: Colors.white,
                                title: "Required!",
                                message: "Please enter Phone No or OTP");
                          }
                        },
                        color: phoneController.text.length == 10 &&
                                otpController.text.length == 6 &&
                                isChecked
                            ? CommonColor.themColor9295E2
                            : Color(0xffcecef0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 55.sp, vertical: 12.sp),
                          child: CommonText.textBoldWight600(
                              text: "Create Account", color: Colors.white),
                        )),
                  ),
                ],
              ),
            );
          },
        ));
  }

  Widget textFormField(
      {String? hintText,
      List<TextInputFormatter>? inpuFormator,
      required TextEditingController controller,
      int? maxLength,
      TextInputType? keyBoardType,
      bool isObscured = false,
      Widget? prefix,
      Widget? suffix}) {
    return SizedBox(
      height: 45.sp,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          obscureText: isObscured,
          inputFormatters: inpuFormator,
          maxLength: maxLength,
          controller: controller,
          keyboardType: keyBoardType,
          onChanged: (val) {
            setState(() {});
          },
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontFamily: TextConst.fontFamily,
          ),
          cursorColor: Colors.black,
          decoration: InputDecoration(
              counterText: "",
              prefixIcon: prefix,
              contentPadding: EdgeInsets.only(top: 7.sp, left: 12.sp),
              suffixIcon: suffix,
              filled: true,
              //fillColor: CommonColor.textFiledColorFAFAFA,
              hintText: hintText,
              hintStyle: TextStyle(
                fontFamily: TextConst.fontFamily,
                fontWeight: FontWeight.w400,
                // color: CommonColor.hinTextColor
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
