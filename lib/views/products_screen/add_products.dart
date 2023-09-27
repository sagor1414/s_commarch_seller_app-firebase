import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/products_controller.dart';
import 'package:srss_seller/views/products_screen/components/product_dropdown.dart';
import 'package:srss_seller/views/products_screen/components/product_images.dart';
import 'package:srss_seller/widgets/coustom_text_field.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';

class Addproducts extends StatelessWidget {
  const Addproducts({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<ProductsController>();
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: boldText(text: "Add new product", color: fontGrey, size: 16.0),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: fontGrey,
              )),
        ),
        bottomNavigationBar: SizedBox(
          height: 60,
          width: context.screenWidth,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
              onPressed: () async {
                if (controller.pnameController.text.isNotEmpty &&
                    controller.pdescController.text.isNotEmpty &&
                    controller.ppriceController.text.isNotEmpty &&
                    controller.pquantityController.text.isNotEmpty &&
                    controller.categoryvalue.isNotEmpty &&
                    controller.subcategoryvalue.isNotEmpty &&
                    controller.pImagesList.isNotEmpty) {
                  if (controller.pImagesList.any((image) => image != null)) {
                    controller.isLoading(true);
                    await controller.uploadImages();
                    // ignore: use_build_context_synchronously
                    await controller.uploadProduct(context);
                    Get.back();
                    controller.pnameController.clear();
                    controller.pdescController.clear();
                    controller.ppriceController.clear();
                    controller.pquantityController.clear();
                  } else {
                    VxToast.show(context,
                        msg: "Please select at least one image");
                  }
                } else {
                  VxToast.show(context, msg: "Please fill all the field");
                }
              },
              child: controller.isLoading.value
                  ? Center(child: loadingIndicator(circlecolor: whitecolor))
                  : boldText(text: "Upload Product")),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                coustomTextField(
                    hint: "Enter your product name",
                    lable: "Product name",
                    controller: controller.pnameController),
                10.heightBox,
                coustomTextField(
                    hint: "good table",
                    lable: "Description",
                    isDec: true,
                    controller: controller.pdescController),
                10.heightBox,
                coustomTextField(
                    hint: "1000",
                    lable: "Price",
                    controller: controller.ppriceController),
                10.heightBox,
                coustomTextField(
                    hint: "21",
                    lable: "Quantity",
                    controller: controller.pquantityController),
                20.heightBox,
                productDropdown("Category", controller.categotyList,
                    controller.categoryvalue, controller),
                10.heightBox,
                productDropdown("Subcategory", controller.subcategoryList,
                    controller.subcategoryvalue, controller),
                10.heightBox,
                const Divider(),
                boldText(text: "Chose your images", color: fontGrey),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      3,
                      (index) => controller.pImagesList[index] != null
                          ? Image.file(
                              controller.pImagesList[index],
                              width: 100,
                              height: 100,
                            ).onTap(() {
                              controller.pickImage(index, context);
                            })
                          : productImages(lebel: "${index + 1}").onTap(() {
                              controller.pickImage(index, context);
                            }),
                    ),
                  ),
                ),
                5.heightBox,
                normalText(
                    text: "First image will be your display images",
                    color: darkGrey),
                const Divider(),
                10.heightBox,
                boldText(text: "Chose Product colors", color: fontGrey),
                10.heightBox,
                Obx(
                  () => Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: List.generate(
                      9,
                      (index) => Stack(
                        alignment: Alignment.center,
                        children: [
                          VxBox()
                              .color(controller.getColorByIndex(index))
                              .roundedFull
                              .size(65, 65)
                              .make()
                              .onTap(() {
                            // Toggle the selected state for the tapped color
                            controller.toggleColorSelection(index);
                          }),
                          controller.selectedColorIndices.contains(index)
                              ? const Icon(
                                  Icons.done,
                                  color: Colors
                                      .white, // Use Colors.white instead of whitecolor
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
