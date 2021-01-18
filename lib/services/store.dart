
import 'package:buy_it/models/order.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
class Store{
String getker(){
  return Uuid().v4();

}

  addData(Product product,String productkey){
  String key=getker();
firestore.collection(kProductsCollection).document(key).setData(
    {
      kProductName: product.pName,
      kProductPrice: product.pPrice,
      kProductDescription: product.pDiscription,
      kProductCategory: product.pCatogery,
      kProduct_MediaUrl: product.pMediaUrl,
      kadminUid:product.uidadminUpload,
      kProductuploadtime:product.timestamp,
      kadminuploadEmail:product.adminupload,
      kProductId:product.product_id_displa,
      kProduct_backend_id:key,
      kProductoffer:product.offer,
      kProductSize:product.size,
      kProductColor:product.pcolor,

    }
    );
  }
Stream<QuerySnapshot>  loadProducts(){
     return firestore.collection(kProductsCollection).snapshots();


  }


  updataProducts(Product product,String product_key)async {
     await firestore.collection(kProductsCollection).document(product_key).updateData(
       {
         kProductName: product.pName,
         kProductPrice: product.pPrice,
         kProductDescription: product.pDiscription,
         kProductCategory: product.pCatogery,
         kProduct_MediaUrl: product.pMediaUrl,
         kProductuploadtime:product.timestamp,
         kadminuploadEmail:product.adminupload,
         kProductId:product.product_id_displa,
         kProductoffer:product.offer,
         kProductSize:product.size,
         kProduct_backend_id:product.pbackend_id,
         kProductColor:product.pcolor


       }

     );




  }
  storeOrder(user_data,List<Order> orders){
    DateTime timestamp=DateTime.now();

    var documentref=firestore.collection(kOrders).document();
  documentref.setData(user_data);
  for(var order in orders){
    documentref.collection(kOrderDetails).document().setData(
      {
        kProductName:order.pName,
        kProductSize:order.size,
        kProductPrice:order.pPrice,
        kProductColor:order.color,
        kProductQuantity:order.quentity,
        kProduct_MediaUrl:order.pMediaUrl,
        kProductId:order.product_id,
        kProduct_backend_id:order.pbackend_id,
          ktimestamp:timestamp,
          'conf':false
      }
    );
  }

  }
}