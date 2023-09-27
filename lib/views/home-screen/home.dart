import 'package:get/get.dart';
import 'package:srss_seller/const/const.dart';
import 'package:srss_seller/controller/home_controller.dart';
import 'package:srss_seller/views/home-screen/home_screen.dart';
import 'package:srss_seller/views/order_screen/order_screen.dart';
import 'package:srss_seller/views/products_screen/products_screen.dart';
import 'package:srss_seller/views/profile_screen/profile_screen.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    var navScreens = [
      const HomeScreen(),
      const ProductScreen(),
      const OrderScreen(),
      const ProfileScreen()
    ];

    var bottomnavbar = [
      const BottomNavigationBarItem(icon: Icon(Icons.home), label: dashbord),
      BottomNavigationBarItem(
        icon: Image.asset(icproducts, color: darkGrey, width: 24),
        label: products,
      ),
      BottomNavigationBarItem(
          icon: Image.asset(icorder, color: darkGrey, width: 24),
          label: orders),
      BottomNavigationBarItem(
          icon: Image.asset(icsetting, color: darkGrey, width: 24),
          label: settings),
    ];
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            onTap: (index) {
              controller.navIndex.value = index;
            },
            currentIndex: controller.navIndex.value,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: purpleColor,
            unselectedItemColor: darkGrey,
            items: bottomnavbar),
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(child: navScreens.elementAt(controller.navIndex.value))
          ],
        ),
      ),
    );
  }
}
