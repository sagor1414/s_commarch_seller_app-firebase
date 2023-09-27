import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:srss_seller/controller/orders_controller.dart';
import 'package:srss_seller/views/auth_screen/login_screen.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/views/home-screen/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Register the OrdersController once in the app's root
  Get.put(OrdersController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final dynamic data;
  const MyApp({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: appname,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      home: const MyAppRoot(),
    );
  }
}

class MyAppRoot extends StatefulWidget {
  const MyAppRoot({super.key});

  @override
  State<MyAppRoot> createState() => _MyAppRootState();
}

class _MyAppRootState extends State<MyAppRoot> {
  @override
  void initState() {
    final ordersController = Get.find<OrdersController>();
    ordersController.fetchOrderCount();
    checkUser();
    super.initState();
  }

  var isLogedin = false;

  checkUser() async {
    auth.authStateChanges().listen((User? user) {
      if (user == null && mounted) {
        isLogedin = false;
      } else {
        isLogedin = true;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogedin ? const Home() : const LoginScreen();
  }
}
