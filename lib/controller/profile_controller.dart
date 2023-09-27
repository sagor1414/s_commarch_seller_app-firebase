import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:srss_seller/const/const.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class ProfileController extends GetxController {
  late QueryDocumentSnapshot snapshotData;
  var profileImagepath = ''.obs;
  var profileImageLink = '';
  var isloading = false.obs;

  //text field
  var nameController = TextEditingController();
  var oldpassController = TextEditingController();
  var newpassController = TextEditingController();

  //shop controller
  var shopNameController = TextEditingController();
  var shopAddressController = TextEditingController();
  var shopMobileController = TextEditingController();
  var shopWevsiteController = TextEditingController();
  var shopDesController = TextEditingController();

  changeImage(context) async {
    try {
      final img = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (img == null) return;
      profileImagepath.value = img.path;
    } on PlatformException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }

  //upload profile image
  uploadProfileImage() async {
    var filename = basename(profileImagepath.value);
    var destination = 'images/${currentUser!.uid}/$filename';

    Reference ref = FirebaseStorage.instance.ref().child(destination);
    await ref.putFile(File(profileImagepath.value));
    profileImageLink = await ref.getDownloadURL();
  }

  //update document
  updateProfileDocument({name, password, imgUrl}) async {
    var store = firestore.collection(vendorsllection).doc(currentUser!.uid);
    await store.set(
        {'vendor_name': name, 'password': password, 'imageUrl': imgUrl},
        SetOptions(merge: true));
    isloading(false);
  }

  //pasword change controller
  changeAuthpassword({email, password, newpassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await currentUser!.reauthenticateWithCredential(cred).then((value) {
      currentUser!.updatePassword(newpassword);
    }).catchError((error) {
      (error.toString());
    });
  }

  //Update shop details
  updateShop({shopname, shopaddress, shopmobile, shopwebsite, shopdesc}) async {
    var store = firestore.collection(vendorsllection).doc(currentUser!.uid);
    await store.set({
      'shop_name': shopname,
      'shop_address': shopaddress,
      'shop_mobile': shopmobile,
      'shop_website': shopwebsite,
      'shop_desc': shopdesc
    }, SetOptions(merge: true));
    isloading(false);
  }
}
