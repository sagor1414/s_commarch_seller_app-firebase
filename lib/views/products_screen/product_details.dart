import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/widgets/normal_text.dart';

class ProductDetails extends StatelessWidget {
  final dynamic data;
  const ProductDetails({super.key, this.data});

  @override
  Widget build(BuildContext context) {
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
        title: boldText(text: "${data['p_name']}", color: fontGrey, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VxSwiper.builder(
              autoPlay: true,
              height: 350,
              aspectRatio: 16 / 9,
              viewportFraction: 1.0,
              itemCount: data['p_imgs'].length,
              itemBuilder: (context, index) {
                return Image.network(
                  data['p_imgs'][index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.heightBox,
                  boldText(
                      text: "${data['p_name']}", color: fontGrey, size: 16.0),
                  10.heightBox,
                  Row(
                    children: [
                      boldText(text: "Category : ", color: fontGrey),
                      10.widthBox,
                      normalText(text: "${data['p_category']}", color: fontGrey)
                    ],
                  ),
                  Row(
                    children: [
                      boldText(text: "Sub Category :", color: fontGrey),
                      10.widthBox,
                      normalText(
                          text: "${data['p_subcategory']}", color: fontGrey)
                    ],
                  ),
                  10.heightBox,
                  VxRating(
                    isSelectable: false,
                    value: double.parse(data['p_rating']),
                    onRatingUpdate: (value) {},
                    normalColor: textfieldGrey,
                    selectionColor: golden,
                    maxRating: 5,
                    count: 5,
                    size: 25,
                  ),
                  10.heightBox,
                  boldText(
                      text: "\$${data['p_price']}", color: red, size: 18.0),
                  18.heightBox,
                  //color section
                  Column(
                    children: [
                      Row(
                        children: [
                          SizedBox(
                              width: 100,
                              child:
                                  boldText(text: "Colos :", color: fontGrey)),
                          Row(
                            children: List.generate(
                              data['p_colors'].length,
                              (index) => VxBox()
                                  .size(40, 40)
                                  .roundedFull
                                  .color(Color(int.parse(
                                      data['p_colors'][index].toString())))
                                  .margin(
                                      const EdgeInsets.symmetric(horizontal: 6))
                                  .make()
                                  .onTap(() {}),
                            ),
                          )
                        ],
                      ).box.padding(const EdgeInsets.all(8)).make(),
                    ],
                  ).box.white.shadow.make(),
                  10.heightBox,
                  //quantity row
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: boldText(text: "Quantity", color: fontGrey)),
                      normalText(text: "${data['p_quantity']}", color: fontGrey)
                    ],
                  ),
                  20.heightBox,
                  boldText(text: "Descprition", color: fontGrey),
                  10.heightBox,
                  normalText(text: "${data['p_desc']}", color: fontGrey)
                ],
              ).box.white.padding(const EdgeInsets.all(8)).make(),
            )
          ],
        ),
      ),
    );
  }
}
