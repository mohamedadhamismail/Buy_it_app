import 'package:buy_it/constants.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'login_screen.dart';

class Make_Order extends StatefulWidget {
  static String id='Make_Order';
  @override
  _Make_OrderState createState() => _Make_OrderState();
}

class _Make_OrderState extends State<Make_Order> {
  GlobalKey<FormState> form_signup_key=GlobalKey<FormState>();

  TextEditingController textphone=TextEditingController();
  TextEditingController textlocate=TextEditingController();
  GlobalKey<ScaffoldState> scaffoldkey=GlobalKey<ScaffoldState>();
  Store store=Store();
  String name;
  DateTime timestamp=DateTime.now();
  bool isloading=false;

  getuserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String fullAddress = "${placemark.locality}" + "," + "${placemark.country}";
    setState(() {
      textlocate.text = fullAddress;

    });    print("Address is $fullAddress");
  }
  getcurrentcustomer()async{
    FirebaseUser currentuser=await auth.currentUser();
    DocumentSnapshot doc=await customersref.document(currentuser.uid).get();
    name=doc.data["name"];
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentcustomer();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Buy it",
            style: TextStyle(
                fontSize: 25.0, color: Colors.white, fontFamily: "Pacifico"),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async{
              await KeepUserLoggOut();
                Navigator.pushNamed(context, Login_Screen.id);
              })
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: isloading,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/main1.jpg'),
                  fit: BoxFit.cover
              )
          ),

          child: Center(
            child: Form(
              key: form_signup_key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 10,),

                  Custom_TextField(
                    hient: "Enter Your Phone Number",
                    icon: Icons.phone_iphone,
                    textEditingController: textphone,
                    onclick: (value) {

                    },
                  ),
SizedBox(height: 30,),
                  Custom_TextField(
                    hient: "Enter delivery place",
                    icon: Icons.location_on,
                    textEditingController: textlocate,
                    onclick: (value) {

                    },
                  ),
                  SizedBox(height: 20,),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    onPressed: (){
                    getuserLocation();

                  },
                    color: KMainColor
                      ,child: Text('Get Current Location',
                    style: TextStyle(color: Colors.white),),)
                  ,
                  SizedBox(height: MediaQuery.of(context).size.height*0.3,),

                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    onPressed: (){
                      setState(() {
                        errormessage_makeorder=true;

                      }
                      );
                  if(form_signup_key.currentState.validate())
                  {
                    form_signup_key.currentState.save();



                    setState(() {
                      isloading=true;
                    }
                    );

                    DateTime timestamp=DateTime.now();

                    store.storeOrder(
                        {
                      'phone number':textphone.text,
                      'location':textlocate.text,
                      'customer name':name,
                      ktimestamp:timestamp

                    },Products_purchased );

                    setState(() {
                      isloading=false;
                    });
                    SnackBar snackbar=SnackBar(content: Text("Thank you for using  buy it. Your request is being processed"),
                      duration: Duration(seconds: 4),);
                    scaffoldkey.currentState.showSnackBar(snackbar);
                  }
                    },
                    color: Colors.black.withOpacity(0.6)
                    ,child: Text('  Confirm  ',
                    style: TextStyle(color: Colors.white),),)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
