import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/orders_controller.dart';
import 'package:srss_seller/services/store_services.dart';
import 'package:srss_seller/views/products_screen/product_details.dart';
import 'package:srss_seller/widgets/dashboard_button.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersController = Get.find<OrdersController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: boldText(text: dashbord, color: purpleColor, size: 16.0),
        actions: [
          Center(
            child: normalText(
              text: intl.DateFormat('EEE, MMM d, ' 'yy').format(DateTime.now()),
              color: purpleColor,
            ),
          ),
          23.widthBox,
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              dashboardButton(context,
                  title: products, count: 4, icon: icproducts),
              Obx(() => dashboardButton(context,
                  title: orders,
                  count: "${ordersController.orderCount}",
                  icon: icorder)),
            ],
          ),
          20.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              dashboardButton(context,
                  title: rating, count: "4.6", icon: icstar),
              dashboardButton(context,
                  title: totalsales,
                  count: "${ordersController.orderCount}",
                  icon: icshopSetting),
            ],
          ),
          30.heightBox,
          StreamBuilder(
            stream: StoreServices.getProducts(currentUser?.uid),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: loadingIndicator(),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return "No popular product yet"
                    .text
                    .color(purpleColor)
                    .makeCentered();
              } else {
                var data = snapshot.data!.docs;
                data = data.sortedBy((a, b) =>
                    b['p_wishlist'].length.compareTo(a['p_wishlist'].length));

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.heightBox,
                      const Divider(),
                      10.heightBox,
                      boldText(text: popular, color: purpleColor, size: 16.0)
                          .box
                          .padding(const EdgeInsets.symmetric(horizontal: 18))
                          .make(),
                      20.heightBox,
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(
                            data.length,
                            (index) => data[index]['p_wishlist'].length == 0
                                ? const SizedBox()
                                : ListTile(
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
                                        text: "${data[index]['p_name']}",
                                        color: purpleColor),
                                    subtitle: normalText(
                                        text: "\$${data[index]['p_price']}",
                                        color: darkGrey),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
