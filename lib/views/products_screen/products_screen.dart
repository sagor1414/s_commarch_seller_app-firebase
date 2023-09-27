// ignore_for_file: sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/products_controller.dart';
import 'package:srss_seller/services/store_services.dart';
import 'package:srss_seller/views/products_screen/add_products.dart';
import 'package:srss_seller/views/products_screen/product_details.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controller = Get.put(ProductsController());
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: purpleColor,
        onPressed: () async {
          await controller.getCategories();
          controller.populateCategoryList();
          Get.to(() => const Addproducts());
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: whitecolor,
        automaticallyImplyLeading: false,
        title: boldText(text: products, color: purpleColor, size: 16.0),
        actions: [
          Center(
              child: normalText(
                  text: intl.DateFormat('EEE, MMM d, ' 'yy')
                      .format(DateTime.now()),
                  color: purpleColor)),
          23.widthBox,
        ],
      ),
      body: StreamBuilder(
        stream: StoreServices.getProducts(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No Product yet".text.color(purpleColor).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(
                    data.length,
                    (index) => ListTile(
                      onTap: () {
                        Get.to(() => ProductDetails(
                              data: data[index],
                            ));
                      },
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          data[index]['p_imgs'][0],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: boldText(
                          text: "${data[index]['p_name']}", color: purpleColor),
                      subtitle: Row(
                        children: [
                          normalText(
                              text: "\$${data[index]['p_price']}",
                              color: darkGrey),
                          10.widthBox,
                          boldText(
                              text: data[index]['is_featured'] == true
                                  ? "Featured"
                                  : "",
                              color: Colors.blue)
                        ],
                      ),
                      trailing: VxPopupMenu(
                          arrowSize: 0.0,
                          child: const Icon(Icons.more_vert_rounded),
                          menuBuilder: () => Column(
                                children: List.generate(
                                  popupMenuTitles.length,
                                  (i) => Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          popupMenuIcons[i],
                                          color: data[index]['featured_id'] ==
                                                      currentUser!.uid &&
                                                  i == 0
                                              ? green
                                              : fontGrey,
                                        ),
                                        10.widthBox,
                                        normalText(
                                            text: data[index]['featured_id'] ==
                                                        currentUser!.uid &&
                                                    i == 0
                                                ? "Remove Featured"
                                                : popupMenuTitles[i],
                                            color: darkGrey)
                                      ],
                                    ).onTap(() {
                                      switch (i) {
                                        case 0:
                                          if (data[index]['is_featured'] ==
                                              true) {
                                            controller
                                                .removeFeatured(data[index].id);
                                            VxToast.show(context,
                                                msg: "Removed to featured");
                                          } else {
                                            controller
                                                .addFeatured(data[index].id);
                                            VxToast.show(context,
                                                msg: "Added to featured");
                                          }

                                          break;
                                        case 1:
                                          break;
                                        case 2:
                                          controller
                                              .removeProduct(data[index].id);
                                          VxToast.show(context,
                                              msg: "product removed");
                                          break;
                                        default:
                                      }
                                    }),
                                  ),
                                ),
                              ).box.white.roundedSM.width(200).make(),
                          clickType: VxClickType.singleClick),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
