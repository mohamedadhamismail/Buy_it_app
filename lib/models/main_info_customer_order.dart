import 'package:cloud_firestore/cloud_firestore.dart';

class Main_info_Customer_order{
  String name;
  String key_details;
  String location;
  String phonenumber;
  Timestamp timestamp;
  Main_info_Customer_order({this.name,this.location,this.phonenumber,this.timestamp,
  this.key_details})
;
}