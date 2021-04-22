import 'package:buy_it/models/order.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/customers/login_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

class Order_Details extends StatefulWidget {
  static String id = 'Order_Details';
  @override
  _Order_DetailsState createState() => _Order_DetailsState();
}

class _Order_DetailsState extends State<Order_Details> {
  List<Order> orders = [];
  String key;
  @override
  Widget build(BuildContext context) {
    key = ModalRoute.of(context).settings.arguments;
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
                image: AssetImage('assets/images/main5.jpg'),
                fit: BoxFit.cover
            )
        ),
        child: Stack(
          children: <Widget>[
            StreamBuilder(
                stream: Firestore.instance
                    .collection(kOrders)
                    .document(key)
                    .collection(kOrderDetails)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    orders = [];

                    for (var doc in snapshot.data.documents) {
                      orders.add(Order(
                          pName: doc.data[kProductName],
                          product_id: doc.data[kProductId],
                          pMediaUrl: doc.data[kProduct_MediaUrl],
                          pPrice: doc.data[kProductPrice],
                          color: doc.data[kProductColor],
                          quentity: doc.data[kProductQuantity],
                          docid: doc.documentID,

                          size: doc.data[kProductSize]));
                    }
                    return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 17, top: 8, bottom: 4, right: 2),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    height:
                                        MediaQuery.of(context).size.height * 0.3,
                                    decoration: BoxDecoration(
                                        color: KMainColor.withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 8),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            radius: 50,
                                            backgroundColor: Colors.grey,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    orders[index].pMediaUrl),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Text(
                                                  "Product Id :${orders[index].product_id}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "Product Name :${orders[index].pName}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "Product Quentity :${orders[index].quentity}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "Product Price :${orders[index].pPrice}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "Product Color :${orders[index].color}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Text(
                                                  "Product Size :${orders[index].size}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: <Widget>[
                                                  RaisedButton(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20)),
                                                    onPressed: () {
                                                      showmassage(context);
                                                    },
                                                    child: Text('Delete'),
                                                    color: Colors.white,
                                                  ),
                                                  SizedBox(width: 8,),
                                                  RaisedButton(
                                                      color: Colors.white,
                                                      onPressed: ()async {
                                                        await updateconf(orders[index].docid);


                                                      },
                                                      child: Text('Confirm'),
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(20)))
                                                ],)

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          );
                        });
                  } else {
                    return Center(
                      child: Text('Loading Oreder.....',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25)),
                    );
                  }
                }),

          ],
        ),
      ),
    );
  }

  showmassage(context) async {
    AlertDialog alertDialog = AlertDialog(
      title: Text('You are sure do delete for this product ?'),
      content: Container(
        height: 50,
        width: 200,
        child: Column(
          children: <Widget>[
            Divider(
              height: 2,
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Firestore.instance
                        .collection(kOrders)
                        .document(key)
                        .delete();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ok',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 2,
                  height: 30,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'cancel',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
    return await showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
  updateconf(String keydetalis)async{
    await  Firestore.instance.collection(kOrders).document(key).
    collection(kOrderDetails).document(keydetalis).updateData(
        {

          'conf':true
        });

  }
}
