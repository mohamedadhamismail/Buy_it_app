import 'package:buy_it/services/auth.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';
import 'admin_home_screen.dart';
import 'admins_screen.dart';

class Create_Admin extends StatefulWidget {
  static String id="Create_Admin";
  @override
  _Create_AdminState createState() => _Create_AdminState();
}

class _Create_AdminState extends State<Create_Admin> {
  TextEditingController textpassword_admin=TextEditingController();
  TextEditingController textconfirm_admin=TextEditingController();
  TextEditingController textemail_admin=TextEditingController();
  TextEditingController textname_admin=TextEditingController();
  GlobalKey<ScaffoldState> scaffol_Createadmin_dkey=  GlobalKey<ScaffoldState>();
  GlobalKey<FormState> form_Createadmin_key=GlobalKey<FormState>();
  String name;
  String email;
  String password;
  String conf_password;
  bool isLoading=false;
  final _auth=Auth();
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            'Add Admin',
            style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontFamily: 'Pacifico'),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                await auth.signOut();
                Navigator.pushNamed(context, Admins.id);
              }),
        ],
      ),
      key: scaffol_Createadmin_dkey,
      backgroundColor: KMainColor,
      body: ModalProgressHUD(
        inAsyncCall:isLoading,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/main5.jpg'),
                  fit: BoxFit.cover
              )
          ),
          child: Form(
            key: form_Createadmin_key,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: height * 0.07,
                          left: width * 0.35,
                          child: Image(
                              image: AssetImage("assets/images/icons/buyicon.png")),
                        ),
                        Positioned(
                            top: height * 0.21,
                            left: width * 0.43,
                            child: Text(
                              'Buy It',
                              style: TextStyle(
                                  color: Colors.black, fontFamily: 'Pacifico'),
                            )),
                      ],
                    ),
                  ),
                ),
                Custom_TextField(
                  hient: "Enter Admin Name",
                  icon: Icons.account_box,
                  textEditingController: textname_admin,
                  onclick: (value){
                    name=value;
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Enter Admin Email",
                  icon: Icons.email,
                  textEditingController:textemail_admin,
                  onclick: (value){
                    email=value;
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Enter Admin password",
                  icon: Icons.lock,
                  textEditingController: textpassword_admin,
                  onclick: (value){
                    password=value;
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Confirm Password",
                  icon: Icons.lock,
                  textEditingController: textconfirm_admin,
                  onclick: (value){
                    conf_password=value;
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
                      onPressed: () async{

                        if (form_Createadmin_key.currentState.validate()) {
                          //do some thing
                          form_Createadmin_key.currentState.save();
                          if(password==conf_password){
                            print('create+++++++++++++++++');
                            print(password+name+email);
                            print('nnnn+++++++++++++++++');

                            try {
                              setState(() {
                                isLoading=true;
                              });

                              FirebaseUser newuser = await _auth.signup(email, password);

                              if (newuser.uid != null) {
                              await  adminsref.document(newuser.uid).setData({
                                  "name": name,
                                  "id": newuser.uid,
                                  "password": password,
                                  "admin":true,
                                  "email": email,
                                  "timestamp": timestamp,
                                  "photourl":mediaUrl_default,
                                "login":false
                                });
                                Navigator.pushNamed(context, Admin_Home_Screen.id);
                              }
                            }catch(e)
                            {
                              setState(() {
                                isLoading=false;
                              });
                              SnackBar snackbar=SnackBar(content: Text(e.message));
                              scaffol_Createadmin_dkey.currentState.showSnackBar(snackbar);
                            }
                          }
                          else{

                            print('error');
                            SnackBar snackbar=SnackBar(content: Text('enter password and cpnfirm password again'));
                            scaffol_Createadmin_dkey.currentState.showSnackBar(snackbar);
                            textpassword_admin.clear();
                            textconfirm_admin.clear();
                            form_Createadmin_key.currentState.validate();

                          }
                        }

                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
