import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/widgets/normal_text.dart';

Widget orderplaceDetails({title1, d1, title2, d2}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            boldText(text: "$title1", color: purpleColor),
            boldText(text: "$d1", color: red)
          ],
        ),
        SizedBox(
          width: 130,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              boldText(text: "$title2", color: purpleColor),
              boldText(text: "$d2", color: fontGrey)
            ],
          ),
        )
      ],
    ),
  );
}
