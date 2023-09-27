import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/orders_controller.dart';
import 'package:srss_seller/views/order_screen/components/order_place.dart';
import 'package:srss_seller/widgets/normal_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

class OrderDetails extends StatefulWidget {
  final dynamic data;
  const OrderDetails({super.key, this.data});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  var controller = Get.find<OrdersController>();

  @override
  void initState() {
    controller.getOrders(widget.data);
    super.initState();
    controller.confirmed.value = widget.data['order_confirmed'];
    controller.ondelivery.value = widget.data['order_on_delivery'];
    controller.delivered.value = widget.data['order_delivered'];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: boldText(text: "Order details", color: fontGrey, size: 16.0),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: fontGrey,
              )),
        ),
        bottomNavigationBar: Visibility(
          visible: !controller.confirmed.value,
          child: SizedBox(
            height: 60,
            width: context.screenWidth,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: purpleColor),
                onPressed: () {
                  controller.confirmed(true);
                  controller.changeStatus(
                      title: "order_confirmed",
                      status: true,
                      docId: widget.data.id);
                },
                child: "Confirm Order".text.make()),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                //order delivery process
                Visibility(
                  visible: controller.confirmed.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      boldText(
                          text: "Order status", color: fontGrey, size: 16.0),
                      SwitchListTile(
                        activeColor: purpleColor,
                        value: true,
                        onChanged: (value) {},
                        title: boldText(text: "Placed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: purpleColor,
                        value: controller.confirmed.value,
                        onChanged: (value) {
                          controller.confirmed.value = value;
                        },
                        title: boldText(text: "Confirmed", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: purpleColor,
                        value: controller.ondelivery.value,
                        onChanged: (value) {
                          controller.ondelivery.value = value;
                          controller.changeStatus(
                              title: "order_on_delivery",
                              status: value,
                              docId: widget.data.id);
                        },
                        title: boldText(text: "On Delivery", color: fontGrey),
                      ),
                      SwitchListTile(
                        activeColor: purpleColor,
                        value: controller.delivered.value,
                        onChanged: (value) {
                          controller.delivered.value = value;
                          controller.changeStatus(
                              title: "order_delivered",
                              status: value,
                              docId: widget.data.id);
                        },
                        title: boldText(text: "Delivered", color: fontGrey),
                      ),
                    ],
                  )
                      .box
                      .padding(const EdgeInsets.all(6))
                      .outerShadowMd
                      .white
                      .border(color: lightGrey)
                      .roundedSM
                      .make(),
                ),

                //order details
                orderplaceDetails(
                    d1: "${widget.data['order_code']}",
                    d2: "${widget.data['shipping_method']}",
                    title1: "Order Code",
                    title2: "Shipping Method"),
                orderplaceDetails(
                    d1: intl.DateFormat()
                        .add_yMd()
                        .format(widget.data['order_date'].toDate()),
                    d2: "${widget.data['payment_method']}",
                    title1: "Order Date",
                    title2: "Payment Method"),
                orderplaceDetails(
                    d1: "Unpaid",
                    d2: "Order placed",
                    title1: "Payment status",
                    title2: "Delivery Status"),
                10.heightBox,
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // "Shipping Address".text.fontFamily(semibold).make(),
                              boldText(
                                  text: "Shipping Address", color: purpleColor),
                              "${widget.data['order_by_name']}".text.make(),
                              "${widget.data['order_by_email']}".text.make(),
                              "${widget.data['order_by_address']}".text.make(),
                              "${widget.data['order_by_city']}".text.make(),
                              "${widget.data['order_by_state']}".text.make(),
                              "${widget.data['order_by_phone']}".text.make(),
                              "${widget.data['order_by_postalcode']}"
                                  .text
                                  .make(),
                            ],
                          ),
                          SizedBox(
                            width: 130,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                boldText(
                                    text: "${widget.data['total_amount']}",
                                    color: purpleColor),
                                boldText(text: "3000", color: red, size: 16.0),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
                    .box
                    .outerShadowMd
                    .white
                    .border(color: lightGrey)
                    .roundedSM
                    .make(),
                10.heightBox,
                const Divider(),
                boldText(text: "Ordered Products", color: fontGrey, size: 16.0),
                10.heightBox,
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(controller.orders.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        orderplaceDetails(
                          title1: "${controller.orders[index]['title']}",
                          title2: "${controller.orders[index]['tprice']}",
                          d1: "${controller.orders[index]['qty']}x",
                          d2: "Refundable",
                        ),
                        "Color"
                            .text
                            .make()
                            .box
                            .padding(const EdgeInsets.symmetric(horizontal: 16))
                            .make(),
                        5.heightBox,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                              width: 30,
                              height: 30,
                              color: Color(controller.orders[index]['color'])),
                        )
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.symmetric(vertical: 8))
                        .make();
                  }).toList(),
                )
                    .box
                    .shadowMd
                    .margin(const EdgeInsets.only(bottom: 4))
                    .white
                    .make(),
                10.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
