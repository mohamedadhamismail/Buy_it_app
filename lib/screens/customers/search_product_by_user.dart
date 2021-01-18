import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/customers/product_info.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
String nameproduct;
String formattedDateTime;

class Search_product_by_user extends StatefulWidget {
  static String id='Search_product_by_user';
  String productname;
  Search_product_by_user(){
    nameproduct=this.productname;
  }
  @override
  _Search_product_by_userState createState() => _Search_product_by_userState();
}

class _Search_product_by_userState extends State<Search_product_by_user> {
  @override
  Widget build(BuildContext context) {
    nameproduct=ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.yellow,),
            onPressed: (){
          Navigator.pop(context);}
          ),
        title: Text('Discover',style: TextStyle(fontWeight: FontWeight.bold
            ,color: Colors.yellow,fontSize: 20),),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Icon(Icons.shopping_cart,color: Colors.yellow,),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore
              .collection(kProductsCollection)
              .where(kProductName, isEqualTo: nameproduct.toLowerCase())
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {

              List<Product> products_result = [];
              stordata_for_updata_screen=[];

              for (var doc in snapshot.data.documents) {
                var data = doc.data;




                products_result.add(
                    Product(
                        pPrice: data[kProductPrice],
                        pName: data[kProductName],
                        timestamp: data[kProductuploadtime],
                        pDiscription: data[kProductDescription],
                        pMediaUrl: data[kProduct_MediaUrl],
                        pCatogery: data[kProductCategory],
                        offer: data[kProductoffer],
                        size: data[kProductSize],
                        pbackend_id: data[kProduct_backend_id]
                    ));
                print(products_result.length);
                DateTime myDateTime = DateTime.parse(
                    products_result[0].timestamp.toDate().toString());
                formattedDateTime = f.format(myDateTime);
                stordata_for_updata_screen.add(  Product(
                    pPrice: data[kProductPrice],
                    pName: data[kProductName],
                    timestamp: data[kProductuploadtime],
                    pDiscription: data[kProductDescription],
                    pMediaUrl: data[kProduct_MediaUrl],
                    pCatogery: data[kProductCategory],
                    offer: data[kProductoffer],
                    size: data[kProductSize],
                    pbackend_id: data[kProduct_backend_id],
                    product_id_displa: data[kadminUid]
                ));

              }

              return Stack(
                children: <Widget>[

                  ListView.builder(

                      itemCount: products_result.length,
                      itemBuilder: (context, index) => Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 5,
                              ),

                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.pushNamed(context, Product_Info.id,arguments: products_result[index]);
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      // color: Colors.orange,
                                      //   width: MediaQuery.of(context).size.width * 0.95,
                                      height:
                                      MediaQuery.of(context).size.height * 0.35,
                                      decoration: BoxDecoration(
                                          color: Colors.orange,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: CachedNetworkImageProvider(
                                                  products_result[index]
                                                      .pMediaUrl))),
                                    ),
                                    products_result[index].offer!='0'?Container(
                                      color: Colors.red.withOpacity(0.5),
                                      child: Text('Offer ${products_result[index].offer} %',style: TextStyle(color: Colors.white,
                                          fontSize: 15,fontWeight: FontWeight.bold),),
                                    ):
                                    Container(
                                      color: Colors.red.withOpacity(0),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),



                            ],
                          ),
                        ),
                      )),
                ],
              );
            }
            else {


              return CircularProgressIndicator();




            }
          }),
    );
  }
}
