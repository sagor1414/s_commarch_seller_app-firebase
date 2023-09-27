import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/home_controller.dart';

class ChatsController extends GetxController {
  @override
  void onInit() {
    getChatId();
    super.onInit();
  }

  var chats = firestore.collection(chatsCollection);
  var friendName = Get.arguments[0];
  var friendId = Get.arguments[1];

  var senderName = Get.find<HomeController>().username;
  var currentId = currentUser!.uid;

  var messageController = TextEditingController();

  dynamic chatDocId;
  var isLoading = false.obs;

  getChatId() async {
    isLoading(true);
    await chats
        .where('users', isEqualTo: {friendId: null, currentId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot snapshot) {
            if (snapshot.docs.isNotEmpty) {
              chatDocId = snapshot.docs.single.id;
            }
          },
        );
    isLoading(false);
  }

  sendMsg(String msg) async {
    if (msg.trim().isNotEmpty) {
      chats.doc(chatDocId).update({
        'created_on': FieldValue.serverTimestamp(),
        'last_msg': msg,
        'toId': friendId,
        'fromId': currentId,
      });
      chats.doc(chatDocId).collection(messagescollection).doc().set({
        'created_on': FieldValue.serverTimestamp(),
        'msg': msg,
        'uid': currentId,
      });
    }
  }
}
