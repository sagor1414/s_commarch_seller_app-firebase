import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/profile_controller.dart';
import 'package:srss_seller/widgets/coustom_text_field.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';

class ShopSettings extends StatelessWidget {
  const ShopSettings({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProfileController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: fontGrey,
              )),
          title: boldText(text: shopsettings, color: fontGrey, size: 16.0),
          actions: [
            controller.isloading.value
                ? Center(
                    child: loadingIndicator(),
                  )
                : TextButton(
                    onPressed: () async {
                      controller.isloading(true);
                      await controller.updateShop(
                          shopaddress: controller.shopAddressController.text,
                          shopname: controller.shopNameController.text,
                          shopmobile: controller.shopMobileController.text,
                          shopwebsite: controller.shopWevsiteController.text,
                          shopdesc: controller.shopDesController.text);
                      // ignore: use_build_context_synchronously
                      VxToast.show(context, msg: "Shop details updated");
                      controller.isloading(false);
                    },
                    child: normalText(text: save, color: fontGrey)),
            20.widthBox
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              coustomTextField(
                controller: controller.shopNameController,
                lable: "Shop Name",
                hint: nameHint,
              ),
              10.heightBox,
              coustomTextField(
                controller: controller.shopAddressController,
                lable: address,
                hint: shopAddressHint,
              ),
              10.heightBox,
              coustomTextField(
                controller: controller.shopMobileController,
                lable: mobile,
                hint: shopMobileHint,
              ),
              10.heightBox,
              coustomTextField(
                controller: controller.shopWevsiteController,
                lable: website,
                hint: shopwebsiteHint,
              ),
              10.heightBox,
              coustomTextField(
                controller: controller.shopDesController,
                isDec: true,
                lable: description,
                hint: shopDescHint,
              ),
              10.heightBox,
            ],
          ),
        ),
      ),
    );
  }
}
