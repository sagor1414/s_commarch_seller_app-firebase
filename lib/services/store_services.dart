import 'package:srss_seller/const/const.dart';

class StoreServices {
  static getProfile(uid) {
    return firestore
        .collection(vendorsllection)
        .where('id', isEqualTo: uid)
        .get();
  }

  //get all messages
  static getMessages(uid) {
    return firestore
        .collection(chatsCollection)
        .where('toId', isEqualTo: uid)
        .snapshots();
  }

  //Get all orders
  static getOrders(uid) {
    return firestore
        .collection(ordersCollection)
        .where('vendors', arrayContains: uid)
        .snapshots();
  }

  static getChatMessages(docId) {
    return firestore
        .collection(chatsCollection)
        .doc(docId)
        .collection(messagescollection)
        .orderBy('created_on', descending: false)
        .snapshots();
  }

  static getProducts(uid) {
    return firestore
        .collection(productsCollection)
        .where('vendor_id', isEqualTo: uid)
        .snapshots();
  }
}
