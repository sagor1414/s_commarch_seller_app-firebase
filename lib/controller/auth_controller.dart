import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';

class AuthController extends GetxController {
  var isloading = false.obs;
  //text controller
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var nameController = TextEditingController();

  //login method

  Future<UserCredential?> loginMethod({context}) async {
    UserCredential? userCredential;

    try {
      userCredential = await auth.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
    } on FirebaseAuthException catch (e) {
      VxToast.show(context, msg: e.toString());
    }
    return userCredential;
  }

  //storeing data to database
  storeUserData({name, password, email}) async {
    DocumentReference store =
        firestore.collection(vendorsllection).doc(currentUser!.uid);
    store.set({
      'password': password,
      'email': email,
      'imageUrl': '',
      'id': currentUser!.uid,
      'vendor_name': name,
    });
  }

  signoutMethod(context) async {
    try {
      await auth.signOut();
    } catch (e) {
      VxToast.show(context, msg: e.toString());
    }
  }
}
