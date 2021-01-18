import 'package:buy_it/screens/admins/mainadmin_BaddnewadminS_BhomeS.dart';
import 'package:buy_it/screens/customers/signup_screen.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:buy_it/constants.dart';
import 'package:buy_it/services/auth.dart';
import 'package:provider/provider.dart';

import 'admin_home_screen.dart';
import '../customers/home_screen.dart';

class Admins extends StatefulWidget {
  static String id = "Admins";
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Admins> {
  String password;
  String email;
  final auth = Auth();
  TextEditingController textpassword_admins = TextEditingController();
  TextEditingController textemail_admins = TextEditingController();
  GlobalKey<ScaffoldState> scaffol_Admins_dkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> form_Admins_key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffol_Admins_dkey,
      backgroundColor: KMainColor,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/main5.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Form(
          key: form_Admins_key,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                  height: 200,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        top: height * 0.1,
                        left: width * 0.35,
                        child: Image(
                            image: AssetImage("assets/images/icons/buyicon.png")),
                      ),
                      Positioned(
                          top: height * 0.25,
                          left: width * 0.41,
                          child: Text(
                            'Buy It',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontFamily: 'Pacifico'),
                          )),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.015,
              ),
              Custom_TextField(
                hient: "Enter Your Admin Email",
                icon: Icons.email,
                textEditingController: textemail_admins,
                onclick: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: height * 0.02,
              ),
              Custom_TextField(
                hient: "Enter Your password",
                icon: Icons.lock,
                textEditingController: textpassword_admins,
                onclick: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: FlatButton(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () async {
                      if (form_Admins_key.currentState.validate()) {
                        //do some thing
                        form_Admins_key.currentState.save();
                        print('+++++++++++++++++');
                        try {

                          FirebaseUser user = await auth.signin(email, password);
                          print("+++++++++++++++${user.uid}");


                          if (user.uid != null) {

                            if (email == "admin@gmail.com" && password == '12345678') {
                              Navigator.pushNamed(
                                  context, Admin_Main_Add_Home.id);

                              textpassword_admins.clear();
                              textemail_admins.clear();
                            }

                           else {
                              DocumentSnapshot admin_data =
                              await adminsref.document(user.uid).get();
                              if(admin_data.data==null)
                                {

                                    SnackBar snackbar = SnackBar(
                                      content: Padding(
                                          padding: EdgeInsets.all(5),
                                          child: Text("this account not admin")),
                                      backgroundColor: Colors.grey,
                                    );
                                    scaffol_Admins_dkey.currentState.showSnackBar(
                                        snackbar);
                                    textpassword_admins.clear();
                                    textemail_admins.clear();

                                }
                              if (admin_data.data["admin"] == true&&admin_data.exists) {

                                print("+++++++++++++++${admin_data.data["admin"]}");
                                Navigator.pushNamed(context, Admin_Home_Screen.id);
                                textpassword_admins.clear();
                                textemail_admins.clear();
                              }

                              }

                          }
                        } catch (e) {
                          SnackBar snackbar = SnackBar(
                            content: Padding(
                                padding: EdgeInsets.all(5),
                                child: Text(e.message)),
                            backgroundColor: Colors.grey,
                          );
                          scaffol_Admins_dkey.currentState.showSnackBar(snackbar);
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
