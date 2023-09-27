import 'package:srss_seller/const/const.dart';

Widget loadingIndicator({circlecolor = purpleColor}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(circlecolor),
  );
}
