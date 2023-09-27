import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/widgets/normal_text.dart';

Widget coustomTextField({lable, hint, controller, isDec = false}) {
  return TextFormField(
    controller: controller,
    maxLines: isDec ? 4 : 1,
    decoration: InputDecoration(
        isDense: true,
        label: normalText(text: lable, color: fontGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: purpleColor,
            width: 2,
          ),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: fontGrey)),
  );
}
