import 'package:srss_seller/const/const.dart';

Widget ourButton({titlle, color = purpleColor, onPress}) {
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: color,
          padding: const EdgeInsets.all(10)),
      onPressed: onPress,
      child: "$titlle".text.make());
}
