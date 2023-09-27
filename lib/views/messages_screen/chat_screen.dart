// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/chatss_controller.dart';
import 'package:srss_seller/services/store_services.dart';
import 'package:srss_seller/views/messages_screen/component/chat_buble.dart';
import 'package:srss_seller/widgets/loading_indicator.dart';
import 'package:srss_seller/widgets/normal_text.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ChatsController());
    ScrollController scrollController = ScrollController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: fontGrey,
            )),
        title: boldText(
            text: "${controller.friendName}", size: 16.0, color: black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
              () => controller.isLoading.value
                  ? Center(
                      child: loadingIndicator(),
                    )
                  : Expanded(
                      child: StreamBuilder(
                          stream: StoreServices.getChatMessages(
                              controller.chatDocId.toString()),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              print("Error fetching data: ${snapshot.error}");
                              return Center(
                                child: normalText(
                                    text: "Error fetching data",
                                    color: Colors.red),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: loadingIndicator(),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              print(controller.chatDocId.toString());
                              return Center(
                                child: normalText(
                                    text: "No messages", color: purpleColor),
                              );
                            } else {
                              return ListView.builder(
                                controller: scrollController,
                                reverse: false, // Start from the end
                                itemCount: snapshot.data!.docs.length + 1,
                                itemBuilder: (context, index) {
                                  if (index == snapshot.data!.docs.length) {
                                    return Container(
                                      height: 30,
                                    );
                                  }
                                  var data = snapshot.data!.docs[index];
                                  return Align(
                                    alignment: data['uid'] == currentUser!.uid
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: chatBuble(data),
                                  );
                                },
                              );
                            }
                          }),
                    ),
            ),
            10.heightBox,
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        labelText: messages,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 2,
                            )),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: purpleColor,
                              width: 2,
                            )),
                        prefixIcon: const Icon(
                          Icons.message,
                          color: purpleColor,
                        ),
                        hintText: "Type a message",
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      scrollController.animateTo(
                          scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut);
                      controller.sendMsg(controller.messageController.text);
                      controller.messageController.clear();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: purpleColor,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
