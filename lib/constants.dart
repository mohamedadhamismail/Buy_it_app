import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'models/order.dart';
import 'models/product.dart';
bool addproduct_errormassage=false;
final auth=FirebaseAuth.instance;
final customersref = Firestore.instance.collection("customers");
final adminsref = Firestore.instance.collection("admins");
DateTime timestamp = DateTime.now();
const KMainColor=Color(0xFFFFC12F);
const KTextfield=Color(0xFFFFE6AC);
final String mediaUrl_default="https://lh4.googleusercontent.com/-GTavOKaD1hg/AAAAAAAAAAI/AAAAAAAAAAA"
    "/AMZuucnzmPGuMykLs--yKR7tA4bWRzWL1w/s96-c/photo.jpg";

const ktimestamp='timestap';
const kProductName = 'productName';
const kProduct_backend_id = 'product packend id';

const kProductPrice = 'productPrice';
const kProductDescription = 'productDescription';
const kProduct_MediaUrl = 'productMediaUrl';
const kadminuploadEmail = 'adminuploadEmail';
final Firestore firestore=Firestore.instance;

const kadminUid = 'IDproduct';
List<Product> products=[];

const kProductuploadtime = 'Productuploadtime';
const kProductColor = 'Product Color';

const kProductId = 'productid';
const kProductoffer = 'Product offer';
const kProductSize = 'Product size';
final f = new DateFormat('yyyy-MM-dd  hh:mm');

const kProductCategory = 'productCategory';
const kProductsCollection = 'Products';
const kUnActiveColor = Color(0xFFC1BDB8);
const kJackets = 'jackets';
const kTrousers = 'trousers';
const kTshirts = 't-shirts';
const kShoes = 'shoes';
const kOrders = 'Orders';
const kOrderDetails = 'OrderDetails';
const kTotallPrice = 'TotallPrice';
const kAddress = 'Address';
const kProductQuantity = 'Quantity';
const kKeepMeLoggedIn = 'KeepMeLoggedIn';
File file;
String postid = Uuid().v4();
String pbackend_id = Uuid().v4();

//make delte or updata
String operation;
String updata_Key;
List<Product> stordata_for_updata_screen=[];


List<Order> Products_purchased=[];
List<double> total_all_product_price=[];
double totalprice=0;



void KeepUserLoggOut() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();

  preferences.setBool(kKeepMeLoggedIn, false);



}
bool errormessage_makeorder=false;




