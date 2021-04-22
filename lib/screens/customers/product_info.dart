import 'package:buy_it/models/order.dart';
import 'package:buy_it/models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'add_to_cart.dart';

class Product_Info extends StatefulWidget {
  static String id = 'Product_Info';
  @override
  _Product_InfoState createState() => _Product_InfoState();
}

double discond;
double ratio;
String quantity;
var arr;
int selected=0;
bool choosed=false;

class _Product_InfoState extends State<Product_Info> {
  GlobalKey<ScaffoldState> scaffoldkey=GlobalKey<ScaffoldState>();
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    selected=0;
    choosed=false;
quantity=null;
}
  @override
  Widget build(BuildContext context) {
    Product product_info = ModalRoute.of(context).settings.arguments;
    String str = product_info.size;

    List<Widget> sizeproducts_radio_button=[];
    //split Size
     arr = str.split(',');
     for(int i=0;i<arr.length;i++){
       sizeproducts_radio_button.add(


             Row(
               children: <Widget>[

                 Radio(
                   activeColor: KMainColor,
                   hoverColor: Colors.white,
                   focusColor: Colors.white,
                   value: i,
                   groupValue: selected,
                   onChanged: ( value) {
                     setState(() {
                       selected = value;
                       print('radio$value');
                     });
                   },
                 ),
                 Text(arr[i].toString().toUpperCase(),style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold,color: Colors.white),),
               ],
             ),


       );
     }


    if (double.parse(product_info.pPrice) < 1000) {
      ratio = double.parse(product_info.offer) / 100;
    } else {
      ratio = double.parse(product_info.offer) / 1000;
    }

    discond = double.parse(product_info.pPrice) -
        (double.parse(product_info.pPrice) * ratio);

    return
        Scaffold(
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
                Stack(children: <Widget>[
                  IconButton(icon: Icon(Icons.add_shopping_cart), onPressed: () {
                    Navigator.pushNamed(context, Add_Cart.id);
                  }),
                  Positioned(
                    top: 2,
                    right: 6,
                    child: Container(width: 15,
                      child: Center(child: Text(Products_purchased.length.toString())),
                      decoration: BoxDecoration(color: Colors.red,
                          borderRadius: BorderRadius.circular(20)),),
                  )

                ],)
              ],
            ),
            body: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image:DecorationImage(
                          image: AssetImage('assets/images/main5.jpg'),
                          fit: BoxFit.cover

                      )
                  ),
                ), Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              product_info.pName.toUpperCase(),
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                            ),
                          ),
                        ),
                        Stack(
                          children: <Widget>[
                            Container(
                             // color: Colors.white.withOpacity(0.4),
                              //   width: MediaQuery.of(context).size.width * 0.95,
                              height: MediaQuery.of(context).size.height * 0.38,
                              child:  CarouselSlider(
                                options: CarouselOptions(
                                  //  height: 150,
                                    initialPage: 0,
                                    autoPlay: true,
                                    autoPlayInterval: Duration(seconds: 3),
                                    enlargeCenterPage: true

                                ),
                                items: product_info.pMediaUrl.map((value)=>Container(
                                  decoration: BoxDecoration(
    color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                          value,),)),
                                )) .toList(),

                              ),
                            ),
                            product_info.offer != '0'
                                ? Container(
                              color: Colors.red.withOpacity(0.5),
                              child: Text(
                                '  Offer ${product_info.offer} %  ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                                : Container(
                              color: Colors.red.withOpacity(0),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          product_info.pDiscription,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,
                              fontSize: 16),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "${discond.toStringAsFixed(2)} EGP",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        product_info.offer != '0'
                            ? Text(
                          "${product_info.pPrice} EGP",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey),
                        )
                            : Text(''),
                        product_info.offer != '0'
                            ? SizedBox(
                          height: 6,
                        )
                            : SizedBox(
                          height: 0,
                        ),

                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          ' Color: ${product_info.pcolor == null ? 'Yellow' : product_info.pcolor}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.white),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              ' Size :',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                            ),
                            SingleChildScrollView(scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Row(
                                  children:sizeproducts_radio_button,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              ' Quantity: ',
                              style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 19,color: Colors.white),
                            ),
                            DropdownButton<String>(
                              hint: Text('Please choose quantity',style: TextStyle(color: Colors.white,fontSize: 18),), // Not necessary for Option 1
                              value: quantity,


                              items: <String>[
                                '1',
                                '2',
                                '3',
                                '4',
                                '5',
                                '6',
                                '7',
                                '8',
                                '9',
                                '10',
                                '11',
                                '12',
                                '13',
                                '14',
                                '15'
                              ].map((String value) {
                                return new DropdownMenuItem<String>(
                                  value: value,
                                  child: new Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  choosed=true;
                                  quantity = value;
                                });
                              },
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 8,
                        ),
                        FlatButton(
                          onPressed: () {
                           

                            if(choosed==true){
                              print('if');
                              Products_purchased.add(Order(

                                  pName: product_info.pName,
                                  pPrice: discond.toString(),
                                  pMediaUrl: product_info.pMediaUrl[0],
                                  product_id: product_info.product_id_displa,
                                  pbackend_id: product_info.pbackend_id,
                                  quentity: quantity,
                                  color: product_info.pcolor,
                                  size: arr[selected],
                                  timestamp: product_info.timestamp,
                                  conf: product_info.conf

                              ));
                              SnackBar snackbar=SnackBar(content: Text('Product added to cart'),duration: Duration(seconds: 4),);
                              scaffoldkey.currentState.showSnackBar(snackbar);
                              Navigator.pushNamed(context, Add_Cart.id);

                            }
                            else if(choosed==false){
                              print('if else');

                              SnackBar snackbar=SnackBar(content: Text('Please choose quantity'));
                              scaffoldkey.currentState.showSnackBar(snackbar);
                            }

                          },
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Center(
                                child: Text(
                                  'ADD TO CART',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
        )
     ;
  }
}
