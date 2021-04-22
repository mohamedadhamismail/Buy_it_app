import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/customers/login_screen.dart';
import 'package:buy_it/screens/customers/product_info.dart';
import 'package:buy_it/screens/customers/search_product_by_user.dart';
import 'package:buy_it/services/store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import"package:flutter/material.dart";
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/constants.dart';

import '../admins/search_and_update.dart';
class Home extends StatefulWidget {
  static String id='Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController textsearch = TextEditingController();
  Store store=Store();
  String formattedDateTime;

  int tabbarindex=0;
  final auth = Auth();

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 4,

          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
backgroundColor: Colors.transparent,
bottom: TabBar(
  onTap: (value){
    setState(() {
      tabbarindex=value;
    });

  },
    tabs: <Widget>[
      Text('Jackets',style:
      TextStyle(color: tabbarindex==0?Colors.black:Colors.grey
          ,fontSize:  tabbarindex==0?18:null,fontWeight: FontWeight.bold

      ),),
      Text('Trousers',style:
      TextStyle(color: tabbarindex==1?Colors.black:Colors.grey,fontWeight: FontWeight.bold
        ,fontSize:  tabbarindex==1?16:null,),),
      Text('T-shirts',style:
      TextStyle(color: tabbarindex==2?Colors.black:Colors.grey,fontWeight: FontWeight.bold
        ,fontSize:  tabbarindex==2?18:null,),),
      Text('Shoes',style:
      TextStyle(color: tabbarindex==3?Colors.black:Colors.grey,fontWeight: FontWeight.bold,
        fontSize:  tabbarindex==3?19:null,),
      ),

],
  indicatorColor:KMainColor,
),
            ),
            body: TabBarView(
              children: <Widget>[

                productView('jacket'),
                productView('trouser'),
                productView('t-shirt'),
                productView('shoes'),

              ],
              
            ),
          ),
        ),
        Material(
          child: Container(color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.only(top: 65,left: 10,right: 10,bottom: 10),
              child: Container(
                decoration: BoxDecoration(


                    color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                  controller: textsearch,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'DICOVER',
                      hintStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.clear,color: Colors.black,),
                        onPressed: () {
                          setState(() {
                            textsearch.clear();
                            setState(() {
                            });
                          });
                        },
                      ),
                      suffixIcon: IconButton(

                          disabledColor: Colors.indigo,
                          color:Colors.indigo ,
                          hoverColor: Colors.lightBlue,


                          icon: Icon(Icons.search,color: Colors.black),
                          onPressed: () {
                            Navigator.pushNamed(context, Search_product_by_user.id,arguments: textsearch.text);
                            setState(() {
                            });
                          })),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

Widget productView(String nameproduct) {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection(kProductsCollection)
            .where(kProductCategory, isEqualTo: nameproduct)
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
                      pbackend_id: data[kProduct_backend_id],
                      pcolor: data[kProductColor],
                    product_id_displa: data[kadminUid],

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
                  product_id_displa: data[kadminUid],
                pcolor: data[kProductColor],

              ));

            }

            return Stack(
              children: <Widget>[

                GridView.builder(
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount
                      (
                  //    childAspectRatio: 3/2,
                        crossAxisCount: 2
                      ,mainAxisSpacing: 0,
                      crossAxisSpacing: 0


                    ),

                    itemCount: products_result.length,
                    itemBuilder: (context, index) =>
                        Container(
                     // height: MediaQuery.of(context).size.height*0.27,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3,vertical: 4),
                        child: Column(
                         mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[



                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, Product_Info.id,arguments: products_result[index]);

                              },
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                     //color: Colors.black,
                                    //   width: MediaQuery.of(context).size.width * 0.95,
                                    height: MediaQuery.of(context).size.height * 0.24,
                                   child: CarouselSlider(
                                     options: CarouselOptions(
                                       //  height: 150,
                                         initialPage: 0,
                                         autoPlay: true,
                                         scrollDirection: Axis.vertical,
                                         autoPlayInterval: Duration(seconds: 3),
                                         enlargeCenterPage: true

                                     ),
                                     items: products_result[index].pMediaUrl.map((value)=>Container(
                                       decoration: BoxDecoration(
                                           color: Colors.orange,
                                           image: DecorationImage(
                                             fit: BoxFit.cover,
                                             image: CachedNetworkImageProvider(
                                               value,),)),
                                     )) .toList(),

                                   ),
                                  ),
                                  Container(color: Colors.white,height: 10,),

                                  products_result[index].offer!='0'?
                                  Container(
                                    color: Colors.red.withOpacity(0.5),
                                    child: Text('  Offer ${products_result[index].offer} %  ',style: TextStyle(color: Colors.white,
                                        fontSize: 15,fontWeight: FontWeight.bold),),
                                  ):
                                  Container(
                                    color: Colors.red.withOpacity(0),
                                  ),
                                  Positioned(
                                      bottom: 0,
                                      left: 0,right: 0,
                                      child: Container(color: Colors.white,height: 10,)),
                                     Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors.green.withOpacity(0.8),
                                        child: Center(
                                            child: Text(products_result[0].pName.toUpperCase(),
                                              style: TextStyle(fontWeight: FontWeight.bold,
                                                  fontSize: 18,color: Colors.black.withOpacity(0.7)),)),
                                      ),
                                    ),



                                ],
                              ),
                            ),




                          ],
                        ),
                      ),
                    )
                ),
              ],
            );
          }
          else {


            return CircularProgressIndicator(strokeWidth: 5,);




          }
        });
  }

}
