import 'package:buy_it/models/order.dart';
import 'package:buy_it/screens/customers/login_screen.dart';
import 'package:buy_it/services/auth.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'make_order.dart';

class Add_Cart extends StatefulWidget {
  static String id = 'Add_Cart';
  @override
  _Add_CartState createState() => _Add_CartState();
}

class _Add_CartState extends State<Add_Cart> {
  Auth auth=Auth();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total_all_product_price = [];
  }

  @override
  Widget build(BuildContext context) {
    total_all_product_price = [];
    totalprice=0;

    return Scaffold(
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
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/main4.jpg'),
                fit: BoxFit.cover
            )
        ),

        child: Stack(
          children: <Widget>[
            ListView.builder(
                itemCount: Products_purchased.length,
                itemBuilder: (context, index) {
                  print("++++++++++++${Products_purchased[index].conf}");
                  Products_purchased[index].color==null?
                  Products_purchased[index].color='green':Colors.black;
                  total_all_product_price.add(
                      double.parse(Products_purchased[index].pPrice) *
                          int.parse(Products_purchased[index].quentity));
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height*0.13,
                      decoration: BoxDecoration(
                          color: KMainColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: CircleAvatar(
                              radius: 38,
                              backgroundColor: Colors.grey,
                              backgroundImage: CachedNetworkImageProvider(
                                  Products_purchased[index].pMediaUrl),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  Products_purchased[index].pName.toUpperCase(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                Text(
                                  'Quintity :${Products_purchased[index].quentity} ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Text(
                                    "Total price :",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${total_all_product_price[index].toStringAsFixed(2)} EGP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                               Container(

                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: <Widget>[
                                     Padding(
                                       padding: const EdgeInsets.only(right: 10.0),
                                       child: RaisedButton(
                                         onPressed: () {
                                           print("index$index");
                                           setState(() {
                                             Products_purchased.removeAt(index);
                                           });
                                         },
                                         shape: RoundedRectangleBorder(
                                             borderRadius:
                                             BorderRadius.circular(15)),
                                         child: Text('Delete'),
                                         color: Colors.white,
                                       ),
                                     ),
                                     SizedBox(width: 10,),
                                     Icon(Products_purchased[index].conf==true?Icons.done_all:Icons.done,
                                       color:Products_purchased[index].conf==true?Colors.blue:Colors.grey ,),
                                   ],
                                 ),
                               )

                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                }),
            Positioned(
              bottom: 5,
              left: MediaQuery.of(context).size.width*0.3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: RaisedButton(
                  color: Colors.black.withOpacity(0),
                      child: Text(
                        '   ORDER  ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        showmassage(context);
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  gettotalprice() {
    double price=0;
    for(var i in total_all_product_price){
setState(() {
  totalprice+=i;

});      print("prices$i");
    }
    return totalprice;
  }
  showmassage(context) async {
    gettotalprice();
    AlertDialog alertDialog=AlertDialog(
      title: Text('total price:  ${totalprice.toStringAsFixed(2)} EGP'),
      content: Container(height: 50,
        width: 200,
        child: Column(
          children: <Widget>[
            Divider(height: 2,color: Colors.grey,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(onPressed: (){
                  Navigator.pop(context);

                  Navigator.pushNamed(context, Make_Order.id);

                }, child: Text('ok', style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),),),
                SizedBox(width: 2,height: 30,child: Container(color: Colors.grey,),),
                FlatButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text('cancel', style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),))

              ],),
          ],
        ),
      ),
    );
    return await showDialog(context: context,builder:(context){
      return alertDialog;
    });
  }
  
}
