import 'package:buy_it/constants.dart';
import 'package:buy_it/screens/admins/add_product.dart';
import 'package:buy_it/screens/admins/admin_home_screen.dart';
import 'package:buy_it/screens/admins/mainadmin_BaddnewadminS_BhomeS.dart';
import 'package:buy_it/screens/admins/admins_screen.dart';
import 'package:buy_it/screens/admins/create_admin.dart';
import 'package:buy_it/screens/admins/order_details.dart';
import 'package:buy_it/screens/admins/show_order.dart';
import 'package:buy_it/screens/admins/update_products.dart';
import 'package:buy_it/screens/admins/view_all_products.dart';
import 'package:buy_it/screens/admins/search_and_update.dart';
import 'package:buy_it/screens/customers/add_to_cart.dart';
import 'package:buy_it/screens/customers/home_screen.dart';
import 'package:buy_it/screens/customers/login_screen.dart';
import 'package:buy_it/screens/customers/make_order.dart';
import 'package:buy_it/screens/customers/product_info.dart';
import 'package:buy_it/screens/customers/signup_screen.dart';
import 'package:buy_it/screens/customers/search_product_by_user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/progressindicator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isloading;

  getAllowsNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      setState(() {
        isloading = prefs.getBool(kKeepMeLoggedIn) == null
            ? false
            : prefs.getBool(kKeepMeLoggedIn);
      }
      );
    } catch (e) {
      setState(() {
        isloading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllowsNotifications();

  }

  @override
  Widget build(BuildContext context) {
    print(isloading);
    if (isloading == null){
    MaterialApp(
      home:Scaffold(
           body: Container(
             child: Center(child: CircularProgressIndicator()),
           )),

      );
    }
  else  {
   return   MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: isloading ? Home.id : Login_Screen.id,
        routes: {
          Login_Screen.id: (context) => Login_Screen(),
          Signup_Screen.id: (context) => Signup_Screen(),
          Home.id: (context) => Home(),
          Admins.id: (context) => Admins(),
          Admin_Home_Screen.id: (context) => Admin_Home_Screen(),
          Admin_Main_Add_Home.id: (context) => Admin_Main_Add_Home(),
          Create_Admin.id: (context) => Create_Admin(),
          Add_product.id: (context) => Add_product(),
          Order_Details.id: (context) => Order_Details(),
          Search_delet_update.id: (context) => Search_delet_update(),
          Show_Order.id: (context) => Show_Order(),
          Updata.id: (context) => Updata(),
          Search.id: (context) => Search(),
          Add_Cart.id: (context) => Add_Cart(),
          Make_Order.id: (context) => Make_Order(),
          Product_Info.id: (context) => Product_Info(),
          Search_product_by_user.id: (context) => Search_product_by_user(),
        },
      );
  }
  return Container();
  }
}
