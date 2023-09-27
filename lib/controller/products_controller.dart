import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/home_controller.dart';
import 'package:srss_seller/models/category_model.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ProductsController extends GetxController {
  var isLoading = false.obs;
  RxSet<int> selectedColorIndices = <int>{}.obs;
  //text field controller
  var pnameController = TextEditingController();
  var pdescController = TextEditingController();
  var ppriceController = TextEditingController();
  var pquantityController = TextEditingController();

  var categotyList = <String>[].obs;
  var subcategoryList = <String>[].obs;

  List<Catagory> category = [];
  var pImagesLinks = [];
  var pImagesList = RxList<dynamic>.generate(3, (index) => null);
  var categoryvalue = ''.obs;
  var subcategoryvalue = ''.obs;
  var selectedColorIndex = 0.obs;

  // void dispose() {
  //   pnameController.dispose();
  //   pdescController.dispose();
  //   ppriceController.dispose();
  //   pquantityController.dispose();
  // }

  getCategories() async {
    var data = await rootBundle.loadString("lib/services/category_model.json");
    var cat = categoryModelFromJson(data);
    category = cat.catagories;
  }

  populateCategoryList() {
    categotyList.clear();
    for (var item in category) {
      categotyList.add(item.name);
    }
  }

  populateSubcategory(cat) {
    subcategoryList.clear();
    var data = category.where((element) => element.name == cat).toList();
    for (var i = 0; i < data.first.subcategory.length; i++) {
      subcategoryList.add(data.first.subcategory[i]);
    }
  }

  pickImage(index, context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);
      if (img == null) {
        return;
      } else {
        pImagesList[index] = File(img.path);
      }
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  void toggleColorSelection(int index) {
    if (selectedColorIndices.contains(index)) {
      selectedColorIndices.remove(index);
    } else {
      selectedColorIndices.add(index);
    }
  }

  uploadImages() async {
    pImagesLinks.clear();
    for (var item in pImagesList) {
      if (item != null) {
        var filename = basename(item.path);
        var destination = 'images/vendors/${currentUser!.uid}/$filename';

        Reference ref = FirebaseStorage.instance.ref().child(destination);
        await ref.putFile(item);
        var n = await ref.getDownloadURL();
        pImagesLinks.add(n);
      }
    }
  }

  uploadProduct(context) async {
    var store = firestore.collection(productsCollection).doc();
    await store.set({
      'is_featured': false,
      'p_category': categoryvalue.value,
      'p_subcategory': subcategoryvalue.value,
      'p_colors': selectedColorIndices
          .map((index) => getColorByIndex(index).value)
          .toList(), // Convert selectedColorIndices to color values
      'p_imgs': FieldValue.arrayUnion(pImagesLinks),
      'p_wishlist': FieldValue.arrayUnion([]),
      'p_desc': pdescController.text,
      'p_name': pnameController.text,
      'p_price': ppriceController.text,
      'p_quantity': pquantityController.text,
      'p_seller': Get.find<HomeController>().username,
      'p_rating': "5.0",
      'vendor_id': currentUser!.uid,
      'featured_id': ''
    });
    isLoading(false);
    VxToast.show(context, msg: "Product Uploaded");
  }

  Color getColorByIndex(int index) {
    // Define your list of colors here
    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.yellow,
      Colors.pink,
      Colors.cyan,
      Colors.black,
    ];

    // Ensure that the index is within the bounds of the colors list
    if (index >= 0 && index < colors.length) {
      return colors[index];
    }

    // Default to a fallback color if the index is out of bounds
    return Colors.grey;
  }

  addFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': currentUser!.uid,
      'is_featured': true,
    }, SetOptions(merge: true));
  }

  removeFeatured(docId) async {
    await firestore.collection(productsCollection).doc(docId).set({
      'featured_id': '',
      'is_featured': false,
    }, SetOptions(merge: true));
  }

  removeProduct(docId) async {
    await firestore.collection(productsCollection).doc(docId).delete();
  }
}
