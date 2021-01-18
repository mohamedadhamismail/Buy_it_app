import 'package:cloud_firestore/cloud_firestore.dart';

class Product{
  String pName;
  bool conf;
  String pPrice;
  String pDiscription;
  String pCatogery;
  String pMediaUrl;
  String offer;
  String pbackend_id;
  String pcolor;
  String size;
  var timestamp;
  String product_id_displa;
  String adminupload;
  String uidadminUpload;
  Product({this.pName,this.pPrice,this.pDiscription,this.pCatogery,this.conf,
    this.pMediaUrl,this.timestamp,this.adminupload,this.uidadminUpload,
    this.product_id_displa,this.offer,this.size,this.pbackend_id,this.pcolor});
}