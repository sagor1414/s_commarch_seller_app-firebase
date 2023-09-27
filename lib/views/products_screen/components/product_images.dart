import 'package:srss_seller/const/const.dart';

Widget productImages({required lebel, onPress}) {
  return "$lebel"
      .text
      .bold
      .color(fontGrey)
      .makeCentered()
      .box
      .size(100, 100)
      .roundedSM
      .color(lightGrey)
      .make();
}
