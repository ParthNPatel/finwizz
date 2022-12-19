import 'dart:convert';
import 'dart:developer';

import 'package:country_picker/country_picker.dart';
import 'package:finwizz/components/common_widget.dart';
import 'package:finwizz/constant/text_styel.dart';
import 'package:finwizz/services/app_notification.dart';
import 'package:finwizz/view/BottomNav/bottom_nav_screen.dart';
import 'package:finwizz/view/SignUp_SignIn/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../Models/repo/login_repo.dart';
import '../../Models/responseModel/country_model.dart';
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

      log("getFcm ======= > in ${GetStorageServices.getFcm()}");

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
            await LoginRepo.loginUserRepo(model: {
              "phone": "${phoneController.text.trim()}",
              "fcm_token": "${GetStorageServices.getFcm()}"
            }, progress: progress);
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ProgressHUD(
        child: Builder(
          builder: (context) {
            final progress = ProgressHUD.of(context);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/png/stack_bubel.png", scale: 4.2),
                CommonWidget.commonSizedBox(height: 20),
                Center(
                  child: CommonText.textBoldWight600(
                      text: 'Welcome to FinWizz!', fontSize: 22.sp),
                ),
                CommonWidget.commonSizedBox(height: 40.sp),
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
                            height: 50.0,
                            width: 100,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      onPressed: () async {
                        if (phoneController.text.isNotEmpty &&
                            otpController.text.isNotEmpty) {
                          await enterOtp(progress);
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 55.sp, vertical: 12.sp),
                        child: CommonText.textBoldWight600(
                            text: "Sign In", color: Colors.white),
                      )),
                ),
                CommonWidget.commonSizedBox(height: 40.sp),
                // InkWell(
                //   splashColor: Colors.transparent,
                //   highlightColor: Colors.transparent,
                //   onTap: () {
                //     Get.off(() => SignUpScreen());
                //   },
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       CommonText.textBoldWight500(
                //           text: "Don’t have an account? ", fontSize: 11.sp),
                //       CommonText.textBoldWight600(
                //         text: "Sign Up",
                //         color: Color(0xff0865D3),
                //         fontSize: 11.sp,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          },
        ),
      ),
    );
  }
}
