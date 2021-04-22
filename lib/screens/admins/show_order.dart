import 'package:buy_it/models/main_info_customer_order.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/customers/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'admins_screen.dart';
import 'order_details.dart';

class Show_Order extends StatefulWidget {
  static String id='Show_Order';
  @override
  _Show_OrderState createState() => _Show_OrderState();
}

class _Show_OrderState extends State<Show_Order> {
  List<Main_info_Customer_order> main_info=[];
  @override
  Widget build(BuildContext context) {
    main_info=[];
    return Scaffold( appBar: AppBar(
      backgroundColor: Colors.black,
      title: Align(
        alignment: Alignment.center,
        child: Text(
          'Show Orders',
          style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'Pacifico'),
        ),
      ),
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
                image: AssetImage('assets/images/main1.jpg'),
                fit: BoxFit.cover
            )
        ),

        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection(kOrders).orderBy(ktimestamp).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('NO Oreder',style: TextStyle(fontWeight: FontWeight.bold,
                fontSize: 25),),);
              }
                else
             {
main_info=[];
for(var doc in snapshot.data.documents){
  main_info.add(Main_info_Customer_order(
    name: doc.data['customer name'],
    location: doc.data['location'],
    phonenumber: doc.data['phone number'],
    timestamp: doc.data[ktimestamp],
    key_details: doc.documentID


  ));
}

               return ListView.builder(itemCount:main_info.length
                   ,itemBuilder: (context,index){
                 String datetime;
                 DateTime myDateTime = DateTime.parse(
                     main_info[index].timestamp.toDate().toString());
                 datetime = f.format(myDateTime);
                 return Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: GestureDetector(
                     onTap: (){
                       Navigator.pushNamed(context, Order_Details.id,arguments: main_info[index].key_details);
                     },
                     child: Container(
                       width: MediaQuery.of(context).size.width * 0.8,
                       height: MediaQuery.of(context).size.height*0.2,
                       decoration: BoxDecoration(
                           color: KMainColor.withOpacity(0.5),
                           borderRadius: BorderRadius.circular(20)),
                       child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 6),
                         child: SingleChildScrollView(
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: <Widget>[

                               Padding(
                                 padding: const EdgeInsets.only(top: 1),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   children: <Widget>[
                                     Align(
                                       alignment: Alignment.center,
                                       child: Text(
                                         main_info[index].name.toUpperCase(),
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 20,
                                             fontWeight: FontWeight.bold),
                                       ),
                                     ),
                                     SizedBox(
                                       height: 1,
                                     ),
                                     Align(
                                       alignment: Alignment.bottomLeft,
                                       child: Text(
                                         'Phone Number :${main_info[index].phonenumber} ',
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 19,
                                             fontWeight: FontWeight.bold),
                                       ),
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
                                     MainAxisAlignment.start,
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: <Widget>[
                                       Text(
                                         "Loction:",
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 18,
                                             fontWeight: FontWeight.bold),
                                       ),
                                       Text(
                                         main_info[index].location,
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 18,
                                             fontWeight: FontWeight.bold,),overflow:TextOverflow.clip,
                                       ),

                                     ],
                                   )),
                               Padding(
                                   padding: const EdgeInsets.only(bottom: 5.0),
                                   child: Row(
                                     mainAxisAlignment:
                                     MainAxisAlignment.start,
                                     children: <Widget>[
                                       Text(
                                         "Date Order :",
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 18,
                                             fontWeight: FontWeight.bold),
                                       ),
                                       Text(
                                        datetime,
                                         style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 18,
                                             fontWeight: FontWeight.bold),
                                       ),

                                     ],
                                   )),
                             ],
                           ),
                         ),
                       ),
                     ),
                   ),
                 );

               });



              }
            }),
      ),
    );
  }
}
