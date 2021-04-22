import 'package:buy_it/models/product.dart';
import 'package:buy_it/screens/admins/update_products.dart';
import 'package:buy_it/services/store.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:buy_it/constants.dart';

import '../../constants.dart';

class Search_delet_update extends StatefulWidget {
  static String id = 'Search_delet_update';
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search_delet_update> {
  String formattedDateTime;
  bool hasdata = false;
  bool isloading = false;
  Store store = Store();
  List<Product> products_result = [];

  List<Text> searchdata = [];
  TextEditingController textsearch = TextEditingController();
  confirmmessage_delete(parentContext,String keyproduct) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Are you sure to delete this product?'),
            children: <Widget>[
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(height: 30,),
                SimpleDialogOption(
                  child: Text('Delete'),
                  onPressed: () {
                    firestore
                        .collection(kProductsCollection).
                    document(keyproduct).delete();
                    Navigator.pop(context);

                  },
                ),
SizedBox(child: Container(color: Colors.grey,),
 width: 2, height: 30),
                SimpleDialogOption(
                  child: Text(
                    'Cancel',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            )
            ],
          );
        });
  }
  build_shoedialog(parentcontext){
    return showDialog(
        context: parentcontext,
        builder: (context)=>
         SimpleDialog(
        title: Text('Please enter deffrent id this id not found?'),
    children: <Widget>[
    Divider(
    height: 2,
    color: Colors.grey,
    ),
    SizedBox(
    height: 5,
    ),



    SimpleDialogOption(
    child: Text(
    'Ok',
    style: TextStyle(),
    textAlign: TextAlign.center,
    ),
    onPressed: () {
    Navigator.pop(context);
    },
    )

    ],
    )

    );

  }
  AppBar buildsearchfield() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(icon: Icon(Icons.arrow_back_ios,color: Colors.grey,), onPressed: (){
        Navigator.pop(context);
      }),
      title: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100], borderRadius: BorderRadius.circular(30)),
        child: TextFormField(
          controller: textsearch,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search for products by Id',
              hintStyle: TextStyle(fontSize: 14),
              prefixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    textsearch.clear();
                    setState(() {
                      isloading = false;
                    });
                  });
                },
              ),
              suffixIcon: IconButton(

                disabledColor: Colors.indigo,
                  color:Colors.indigo ,
                  hoverColor: Colors.lightBlue,


                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      isloading = true;
                    });
                  })),
        ),
      ),
    );
  }

  Container bulidnocontent() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
                  color: Colors.grey,

      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[


            Image(
                image: AssetImage( 'assets/images/search_product.jpg'),fit: BoxFit.scaleDown),

            Text(
              'Search For Products ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            )
          ],
        ),
      ),
    );
  }

  buildbody() {
    return StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection(kProductsCollection)
            .where("IDproduct", isEqualTo: textsearch.text)
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
                Container(
                  // color: Colors.orange,
                  //   width: MediaQuery.of(context).size.width * 0.95,
                  height:
                  MediaQuery.of(context).size.height * 0.43,
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(
                              products_result[0]
                                  .pMediaUrl[0]))),
                ),
                Container(
                  color: Colors.red.withOpacity(0.5),
                  child: Text('Offer ${products_result[0].offer} %',style: TextStyle(color: Colors.white,
                      fontSize: 15,fontWeight: FontWeight.bold),),
                ),
                CustomPaint(painter: Background(),
                    child:Container()),
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
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                products_result[index].pCatogery,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height:MediaQuery.of(context).size.height*0.38,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[



                              ],
                            ),


                            Text(
                              'Prouduct Information :',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              products_result[index].pDiscription,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.white54),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Product Price :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 19,color: Colors.white),
                                ),
                                Text(
                                  products_result[index].pPrice,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white60),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'EGP',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white60),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${products_result[index].pName} Size :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                                ),
                                Text(
                                  products_result[index].size,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white54),
                                ),


                              ],
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  'Upload date:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20,color: Colors.white),
                                ),
                                Text(
                                  formattedDateTime,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 17,color: Colors.white54),
                                ),

                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),

                            operation=="delete"?     Container(

                              child: Center(
                                child: FlatButton(


                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    color: Colors.black,
                                    onPressed: () {
                                      confirmmessage_delete(context,products_result[index].pbackend_id);


                                    },
                                    child: Text(
                                      ' Delete Prodect',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ) :
                            Container(
                              child: Center(
                                child: FlatButton(

                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20)),
                                    color: Colors.black,
                                    onPressed: () {
                                      setState(() {
                                        updata_Key=products_result[index].pbackend_id;
                                      });
                                      Navigator.pushNamed(context,Updata.id);


                                    },
                                    child: Text(
                                      ' Update Prodect',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                            ),

                          ],
                        ),
                      ),
                    )),
              ],
            );
          }
          else {


            return  SimpleDialog(
              title: Text('Please enter deffrent id this id not found?'),
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 5,
                ),



                SimpleDialogOption(
                  child: Text(
                    'Ok',
                    style: TextStyle(),
                    textAlign: TextAlign.center,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )

              ],
            );




          }
        });
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
      body: isloading == false ? bulidnocontent() : buildbody(),
    );
  }
}
class Background extends CustomPainter {
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();
    paint.color = Colors.white;
    Rect rect=Rect.fromLTWH(0,size.height*0.35, size.width, size.height);
    Gradient gradient=LinearGradient(colors: [
      Color(0xFFFF3181),

      Color(0xFFFA7537),
    ],stops:
    [0.2,
      0.8]);

    paint.shader=gradient.createShader(rect);
    path.lineTo(0,size.height*0.3);
    path.lineTo(0,size.height);
    path.lineTo(size.width,size.height);
    path.lineTo(size.width,size.height*0.38);
    path.lineTo(size.width*0.6,size.height*0.5);
    path.lineTo(0,size.height*0.3);

    path.close();
    canvas.drawPath(path, paint);
    // canvas.drawColor(Colors.white, BlendMode.color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
