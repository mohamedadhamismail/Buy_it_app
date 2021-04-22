import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../../constants.dart';

class Search extends StatefulWidget {
  static String id = 'Search';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool hasdata = false;
  bool isloading = false;
  Store store = Store();
  List<Product> products_result = [];

  List<Text> searchdata = [];
  TextEditingController textsearch = TextEditingController();

  AppBar buildsearchfield() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
        child: TextFormField(
          controller: textsearch,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search for a user',
              prefixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    textsearch.clear();
                  });
                },
              ),
              suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                    setState(() {
                      isloading = false;
                    });
                  })),
        ),
      ),
    );
  }

  Container bulidnocontent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            SvgPicture.asset(
              'assets/images/search.svg',
              height: orientation == Orientation.portrait ? 300 : 200,
            ),
            Text(
              'Search about product ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildsearchfield(),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection(kProductsCollection).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Product> products_result = [];

              for (var doc in snapshot.data.documents) {
                var data = doc.data;
                products_result.add(Product(
                  pPrice: data[kProductPrice],
                  pName: data[kProductName],
                  timestamp: data[kProductuploadtime],
                  pDiscription: data[kProductDescription],
                  pMediaUrl: data[kProduct_MediaUrl],
                  pCatogery: data[kProductCategory],
                  offer: data[kProductoffer],
                    size: data[kProductSize]
                ));
                print(products_result.length);
              }

              return GridView.builder(
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                childAspectRatio: 0.88,
                  crossAxisSpacing: 2
                ),
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
                              Stack(
                                children: <Widget>[
                                  Container(
                                    // color: Colors.orange,
                                    width: MediaQuery.of(context).size.width *
                                        0.95,
                                    height:
                                        MediaQuery.of(context).size.height *
                                            0.3,
                                    child: CarouselSlider(
                                      options: CarouselOptions(
                                        height: 150,
                                        initialPage: 0,
                                        autoPlay: true,
                                        autoPlayInterval: Duration(seconds: 3),
                                        enlargeCenterPage: true

                                      ),
                                      items:url_Images_Prodect.map((value)=>Container(
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: CachedNetworkImageProvider(
                                                   value,),)),
                                      )) .toList(),

                                    ),
                                  ),

                                  Positioned(
                                    top: 0,
                                    left: 0,

                                    child: Container(
                                      color: Colors.red.withOpacity(0.9),
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child:  Text('Offer ${products_result[index].offer} %',style: TextStyle(color: Colors.white,
                                            fontSize: 15,fontWeight: FontWeight.bold),),
                                      ),
                                    ),
                                  ),
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          color: Colors.green.withOpacity(0.4),
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Text(
                                              products_result[index].pName,
                                              style: TextStyle(
                                                  color: Colors.white60,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      ),

                                ],
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 4,
                              ),
                              Divider(
                                height: 2,
                                color: Colors.black45,
                              )
                            ],
                          ),
                        ),
                      ));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
