// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/profile_controller.dart';
import 'package:srss_seller/views/home-screen/home.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';

class EditProfile extends StatefulWidget {
  final String? username;
  const EditProfile({super.key, this.username});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var controller = Get.find<ProfileController>();
  @override
  void initState() {
    controller.nameController.text = widget.username!;
    super.initState();
  }

  bool isSecurepassword = true;
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: purpleColor,
        appBar: AppBar(
          title: boldText(text: editProfile, size: 16.0),
          actions: [
            controller.isloading.value
                ? Center(child: loadingIndicator(circlecolor: whitecolor))
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);

                      //if image is not selected
                      if (controller.profileImagepath.value.isNotEmpty) {
                        await controller.uploadProfileImage();
                      } else {
                        controller.profileImageLink =
                            controller.snapshotData['imageUrl'];
                      }

                      //if old password math the database password
                      if (controller.snapshotData['password'] ==
                          controller.oldpassController.text) {
                        await controller.changeAuthpassword(
                            email: controller.snapshotData['email'],
                            password: controller.oldpassController.text,
                            newpassword: controller.newpassController.text);
                        await controller.updateProfileDocument(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.newpassController.text);
                        VxToast.show(context, msg: "Updated Complete");
                      } else if (controller
                              .oldpassController.text.isEmptyOrNull &&
                          controller.newpassController.text.isEmptyOrNull) {
                        await controller.updateProfileDocument(
                            imgUrl: controller.profileImageLink,
                            name: controller.nameController.text,
                            password: controller.snapshotData['password']);
                        VxToast.show(context, msg: "Updated");
                        Get.offAll(() => const Home());
                      } else {
                        VxToast.show(context, msg: "some Error occur");
                        controller.isloading(false);
                      }
                    },
                    child: normalText(text: save)),
            20.widthBox
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              //if data image url and controller path is empty then show this
              controller.snapshotData['imageUrl'] == '' &&
                      controller.profileImagepath.isEmpty
                  ? Image.asset(
                      icprofile,
                      width: 100,
                      fit: BoxFit.cover,
                    ).box.roundedFull.clip(Clip.antiAlias).make()
                  //if data is not empty but controller is empty
                  : controller.snapshotData['imageUrl'] != '' &&
                          controller.profileImagepath.isEmpty
                      ? Image.network(controller.snapshotData['imageUrl'],
                              width: 100, fit: BoxFit.cover)
                          .box
                          .roundedFull
                          .clip(Clip.antiAlias)
                          .make()
                      //if both are empty
                      : Image.file(
                          File(controller.profileImagepath.value),
                          width: 100,
                          fit: BoxFit.cover,
                        ).box.roundedFull.clip(Clip.antiAlias).make(),
              10.heightBox,
              ElevatedButton(
                  onPressed: () {
                    controller.changeImage(context);
                  },
                  child: normalText(text: "Change images")),
              10.heightBox,
              const Divider(
                color: whitecolor,
              ),
              20.heightBox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        Icons.email,
                        color: purpleColor,
                      ),
                      hintText: "NameHint",
                    ),
                  ),
                  20.heightBox,
                  boldText(text: "Change your password", color: darkGrey),
                  10.heightBox,
                  TextFormField(
                    controller: controller.oldpassController,
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
                  20.heightBox,
                  TextFormField(
                    controller: controller.newpassController,
                    obscureText: isSecurepassword,
                    decoration: InputDecoration(
                      labelText: "Confirm password",
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
                ],
              )
                  .box
                  .white
                  .rounded
                  .outerShadowMd
                  .padding(const EdgeInsets.all(12))
                  .make(),
            ],
          ),
        ),
      ),
    );
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
