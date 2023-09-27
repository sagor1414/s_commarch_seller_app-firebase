import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/services/store_services.dart';

class OrdersController extends GetxController {
  var orders = [];

  var confirmed = false.obs;
  var ondelivery = false.obs;
  var delivered = false.obs;
  var orderCount = 0.obs;

  getOrders(data) {
    orders.clear();
    for (var item in data['orders']) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
  }

  fetchOrderCount() async {
    // Fetch your order data from Firestore here
    var data = await StoreServices.getOrders(currentUser!.uid);
    orders.clear();
    for (var item in data.docs) {
      if (item['vendor_id'] == currentUser!.uid) {
        orders.add(item);
      }
    }
    orderCount.value = orders.length; // Update the order count
  }

  int getOrderCount() {
    return orders.length;
  }

  changeStatus({title, status, docId}) async {
    var store = firestore.collection(ordersCollection).doc(docId);
    await store.set({
      title: status,
    }, SetOptions(merge: true));
  }
}
