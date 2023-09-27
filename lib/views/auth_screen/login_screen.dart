// ignore_for_file: use_build_context_synchronously

import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/auth_controller.dart';
import 'package:srss_seller/views/home-screen/home.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';
import 'package:srss_seller/widgets/our_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.put(AuthController());
  bool isSecurepassword = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                50.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    normalText(text: welcome, size: 18.0),
                    2.widthBox,
                    boldText(text: appname, size: 18.0)
                  ],
                ),
                20.heightBox,
                Image.asset(
                  iclogo,
                  width: 80,
                  height: 80,
                )
                    .box
                    .border(color: whitecolor)
                    .rounded
                    .padding(const EdgeInsets.all(8))
                    .make(),
                20.heightBox,
                Obx(
                  () => Column(
                    children: [
                      5.heightBox,
                      normalText(text: loginto, color: purpleColor),
                      10.heightBox,
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          labelText: "Name",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: purpleColor,
                                width: 2,
                              )),
                          prefixIcon: const Icon(
                            Icons.person,
                            color: purpleColor,
                          ),
                          hintText: "Please enter your name",
                        ),
                      ),
                      10.heightBox,
                      TextFormField(
                        controller: controller.emailcontroller,
                        decoration: InputDecoration(
                          labelText: email,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: purpleColor,
                                width: 2,
                              )),
                          prefixIcon: const Icon(
                            Icons.email,
                            color: purpleColor,
                          ),
                          hintText: emailHint,
                        ),
                      ),
                      20.heightBox,
                      TextFormField(
                        controller: controller.passwordcontroller,
                        obscureText: isSecurepassword,
                        decoration: InputDecoration(
                          labelText: password,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 2,
                              )),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: purpleColor,
                                width: 2,
                              )),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: purpleColor,
                          ),
                          hintText: passwordHint,
                          suffixIcon: togglepassword(),
                        ),
                      ),
                      10.heightBox,
                      Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                              onPressed: () {},
                              child: normalText(
                                  text: forgotPassword, color: purpleColor))),
                      10.heightBox,
                      SizedBox(
                        width: context.screenWidth - 100,
                        child: controller.isloading.value
                            ? Center(child: loadingIndicator())
                            : ourButton(
                                titlle: login,
                                onPress: () async {
                                  controller.isloading(true);
                                  try {
                                    final loginResult = await controller
                                        .loginMethod(context: context);

                                    if (loginResult != null) {
                                      await controller.storeUserData(
                                        name: controller
                                            .nameController.value.text,
                                        email: controller
                                            .emailcontroller.value.text,
                                        password: controller
                                            .passwordcontroller.value.text,
                                      );

                                      VxToast.show(context,
                                          msg: "login successed");
                                      controller.isloading(false);
                                      Get.offAll(() => const Home());
                                    } else {
                                      controller.isloading(false);
                                    }
                                  } catch (e) {
                                    // Handle any errors that occur during login or data storage
                                    VxToast.show(context, msg: "$e");
                                    controller.isloading(false);
                                  }
                                },
                              ),
                      ),
                      5.heightBox,
                      normalText(
                          text: "Dont have an account contuct with us",
                          color: fontGrey)
                    ],
                  )
                      .box
                      .white
                      .rounded
                      .outerShadowMd
                      .padding(const EdgeInsets.all(12))
                      .make(),
                ),
                20.heightBox,
                Center(child: normalText(text: anyProblem)),
                const Spacer(),
                Center(child: boldText(text: credit)),
                20.heightBox
              ],
            ),
          ),
        ));
  }

  Widget togglepassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          isSecurepassword = !isSecurepassword;
        });
      },
      icon: isSecurepassword
          ? const Icon(Icons.visibility_off)
          : const Icon(Icons.visibility),
      color: Colors.grey,
    );
  }
}
