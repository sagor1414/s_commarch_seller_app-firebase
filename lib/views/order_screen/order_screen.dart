import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/orders_controller.dart';
import 'package:srss_seller/services/store_services.dart';
import 'package:srss_seller/views/order_screen/order_details.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var controller = Get.put(OrdersController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: whitecolor,
        automaticallyImplyLeading: false,
        title: boldText(text: orders, color: purpleColor, size: 16.0),
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
        stream: StoreServices.getOrders(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingIndicator(),
            );
            // } else if (snapshot.data!.docs.isEmpty) {
            //   return "No order yet".text.color(purpleColor).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: List.generate(data.length, (index) {
                    var time = data[index]['order_date'].toDate();
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onTap: () {
                        Get.to(() => OrderDetails(
                              data: data[index],
                            ));
                      },
                      tileColor: textfieldGrey,
                      title: boldText(
                          text: "${data[index]['order_code']}",
                          color: purpleColor),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_month_outlined,
                                color: purpleColor,
                              ),
                              10.widthBox,
                              normalText(
                                  text:
                                      intl.DateFormat().add_yMd().format(time),
                                  color: darkGrey),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.payment,
                                color: purpleColor,
                              ),
                              10.widthBox,
                              normalText(text: unpaid, color: red)
                            ],
                          ),
                        ],
                      ),
                      trailing: "${data[index]['total_amount']}"
                          .numCurrency
                          .text
                          .bold
                          .color(purpleColor)
                          .make(),
                    ).box.margin(const EdgeInsets.only(bottom: 4)).make();
                  }),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
