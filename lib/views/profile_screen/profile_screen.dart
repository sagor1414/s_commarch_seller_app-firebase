import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/auth_controller.dart';
import 'package:srss_seller/controller/profile_controller.dart';
import 'package:srss_seller/services/store_services.dart';
import 'package:srss_seller/views/auth_screen/login_screen.dart';
import 'package:srss_seller/views/messages_screen/mesages_screen.dart';
import 'package:srss_seller/views/profile_screen/edit_profile.dart';
import 'package:srss_seller/views/shop_setting_screen/shop_setting_screen.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';

class ProfileScreen extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const ProfileScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: settings, size: 16.0),
        actions: [
          TextButton(
              onPressed: () async {
                await Get.find<AuthController>().signoutMethod(context);
                Get.offAll(() => const LoginScreen());
              },
              child: normalText(text: logout)),
          20.widthBox
        ],
      ),
      body: FutureBuilder(
        future: StoreServices.getProfile(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: loadingIndicator(circlecolor: whitecolor));
          } else {
            controller.snapshotData = snapshot.data!.docs[0];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 20, bottom: 10),
                  child: Row(
                    children: [
                      controller.snapshotData['imageUrl'] == ''
                          ? Image.asset(
                              icprofile,
                              width: 90,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make()
                          : Image.network(
                              controller.snapshotData['imageUrl'],
                              width: 90,
                              fit: BoxFit.cover,
                            ).box.roundedFull.clip(Clip.antiAlias).make(),
                      10.widthBox,
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "${controller.snapshotData['vendor_name']}"
                              .text
                              .bold
                              .white
                              .make(),
                          5.heightBox,
                          "${controller.snapshotData['email']}"
                              .text
                              .size(10)
                              .white
                              .make(),
                        ],
                      )),
                      //edit button
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: whitecolor,
                          ),
                        ),
                        onPressed: () {
                          Get.to(() => EditProfile(
                                username:
                                    controller.snapshotData['vendor_name'],
                              ));
                        },
                        child: const Icon(Icons.edit),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                10.heightBox,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: List.generate(
                      profileButtonsTitles.length,
                      (index) => ListTile(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Get.to(() => const ShopSettings());
                              break;
                            case 1:
                              Get.to(() => const MessageScreen());
                              break;
                            default:
                          }
                        },
                        leading: Icon(
                          profileButtonsIcons[index],
                          color: whitecolor,
                        ),
                        title: normalText(text: profileButtonsTitles[index]),
                      ),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
