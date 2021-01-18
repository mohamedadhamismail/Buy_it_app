import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buy_it/screens/admins/admins_screen.dart';
import 'package:buy_it/screens/admins/show_order.dart';
import 'package:buy_it/screens/admins/view_all_products.dart';
import 'package:buy_it/screens/admins/search_and_update.dart';
import 'package:buy_it/services/auth.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../customers/login_screen.dart';
import 'add_product.dart';

class Admin_Home_Screen extends StatefulWidget {
  static String id = 'Admin_Home_Screen';
  @override
  _Admin_Home_ScreenState createState() => _Admin_Home_ScreenState();
}

class _Admin_Home_ScreenState extends State<Admin_Home_Screen> {
  final auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KMainColor,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Home',
            style: TextStyle(
                fontSize: 24, color: Colors.white, fontFamily: 'Pacifico'),
          ),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async{
                await KeepUserLoggOut();
                Navigator.pushNamed(context, Login_Screen.id);
              }),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/main5.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Padding(
          padding: const EdgeInsets.only(top:15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image(image: AssetImage("assets/images/icons/buyicon.png")),
              SizedBox(
                width: 150.0,

                child: ScaleAnimatedTextKit(
                  onTap: () {
                    print("Tap Event");
                  },
                  text: ["Buy", "it", "Buy it"],
                  textStyle: TextStyle(fontSize: 30.0, fontFamily: "Pacifico",color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
                width: double.infinity,
              ),
              FlatButton(
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  Navigator.pushNamed(context, Add_product.id);
                },
                child: Text(
                  '  Add Prodect  ',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
              ),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      operation = 'updata';
                    });
                    Navigator.pushNamed(context, Search_delet_update.id,
                        arguments: operation);
                  },
                  child: Text(
                    'Updata Prodect',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.black,
                  onPressed: () {
                    setState(() {
                      operation = 'delete';
                    });
                    Navigator.pushNamed(context, Search_delet_update.id,
                        arguments: operation);
                  },
                  child: Text(
                    ' Delete Prodect',
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pushNamed(context, Show_Order.id);
                  },
                  child: Text(
                    '    Show Order  ',
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
