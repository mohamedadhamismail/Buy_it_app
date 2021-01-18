import 'package:buy_it/screens/customers/home_screen.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../../constants.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/provider/model_hud.dart';



class Signup_Screen extends StatefulWidget {
  static String id = 'Signup_Screen';

  @override
  _Sigup_ScreenState createState() => _Sigup_ScreenState();
}

class _Sigup_ScreenState extends State<Signup_Screen> {
  TextEditingController text_createcustomer_password=TextEditingController();
  TextEditingController text_createcustomer_email=TextEditingController();
  TextEditingController text_createcustomer_confirm=TextEditingController();
  TextEditingController text_createcustomer_name=TextEditingController();
  GlobalKey<ScaffoldState> scaffol_Signup_dkey=  GlobalKey<ScaffoldState>();
  GlobalKey<FormState> form_signup_key=GlobalKey<FormState>();
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
      key: scaffol_Signup_dkey,
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
            key: form_signup_key,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 200,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.1,
                          left: MediaQuery.of(context).size.width * 0.35,
                          child: Image(
                              image: AssetImage("assets/images/icons/buyicon.png")),
                        ),
                        Positioned(
                            top: MediaQuery.of(context).size.height * 0.25,
                            left: MediaQuery.of(context).size.width * 0.43,
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
                  hient: "Enter Your Name",
                  icon: Icons.account_box,
                  textEditingController: text_createcustomer_name,
                  onclick: (value){
                    name=value;
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Enter Your Email",
                  icon: Icons.email,
                  textEditingController:text_createcustomer_email,
                  onclick: (value){
                    email=value;
                  },
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Enter Your password",
                  icon: Icons.lock,
                  textEditingController: text_createcustomer_password,
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
                  textEditingController: text_createcustomer_confirm,
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

                        if (form_signup_key.currentState.validate()) {
                          //do some thing
                          form_signup_key.currentState.save();
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
                                await  customersref.document(newuser.uid).setData({
                                  "name": name,
                                  "id": newuser.uid,
                                  "password": password,
                                  "email": email,
                                  "admin":false,
                                  "timestamp": timestamp,
                                  "photourl":mediaUrl_default,
                                  "login":false
                                });
                                text_createcustomer_confirm.clear();
                                text_createcustomer_email.clear();
                                text_createcustomer_password.clear();
                                text_createcustomer_name.clear();
                                Navigator.pushNamed(context, Home.id);
                              }
                            }catch(e)
                            {
                              setState(() {
                                isLoading=false;
                              });
                              text_createcustomer_email.clear();
                              text_createcustomer_password.clear();
                              text_createcustomer_confirm.clear();
                              SnackBar snackbar=SnackBar(content: Text(e.message));
                              scaffol_Signup_dkey.currentState.showSnackBar(snackbar);
                            }
                          }
                          else{

                            print('error');
                            SnackBar snackbar=SnackBar(content: Text('enter password and cpnfirm password again'));
                            scaffol_Signup_dkey.currentState.showSnackBar(snackbar);
                            text_createcustomer_password.clear();
                            text_createcustomer_confirm.clear();
                            form_signup_key.currentState.validate();

                          }
                        }

                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Do have an account?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
