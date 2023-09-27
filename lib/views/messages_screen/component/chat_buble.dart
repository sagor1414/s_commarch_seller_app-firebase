import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/widgets/normal_text.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart' as intl;

Widget chatBuble(DocumentSnapshot data) {
  var t =
      data['created_on'] == null ? DateTime.now() : data['created_on'].toDate();
  var time = intl.DateFormat("h:mma").format(t);
  return Directionality(
    textDirection:
        data['uid'] == currentUser!.uid ? TextDirection.rtl : TextDirection.ltr,
    child: Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: data['uid'] == currentUser!.uid ? purpleColor : Colors.red,
          borderRadius: data['uid'] == currentUser!.uid
              ? const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )
              : const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          normalText(text: "${data['msg']}"),
          10.heightBox,
          normalText(text: time)
        ],
      ),
    ),
  );
}
