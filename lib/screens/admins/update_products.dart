import 'package:buy_it/constants.dart';
import 'package:buy_it/models/product.dart';
import 'package:buy_it/services/auth.dart';
import 'package:buy_it/services/store.dart';
import 'package:buy_it/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'admins_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Updata extends StatefulWidget {
  static String id = "Updata";
  @override
  _Add_productState createState() => _Add_productState();
}

class _Add_productState extends State<Updata> {
  List<File> fileimages = [];

  final store = Store();
  DateTime timestamp = DateTime.now();
  TextEditingController product_offer = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController p_color = TextEditingController();
  TextEditingController product_size = TextEditingController();
  TextEditingController product_id_admin = TextEditingController();
  TextEditingController addproductname_admin = TextEditingController();
  TextEditingController productprice_admin = TextEditingController();
  TextEditingController productdescription_admin = TextEditingController();
  TextEditingController productcategory_admin = TextEditingController();
  GlobalKey<ScaffoldState> scaffol_addproduct_dkey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> form_addproduct_key = GlobalKey<FormState>();
  String MediaUrlProduct;
  bool isloading = false;
  String currentadminemail;
  String currentadminuid;
  String product_image_Url;
  String productkey_backend;
  Auth auth = Auth();
  FirebaseUser currentuser;
  getcurrntadmin() async {
    currentuser = await auth.getUser();
    setState(() {
      currentadminemail = currentuser.email;
      currentadminuid = currentuser.uid;
      print(currentadminuid + currentadminemail);
    });
  }

  handleGrallery() async {
    print('++++++++++++++++++++++++++++++*******ffff');
    final imagefile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (imagefile == null) return null;
    print('start');

    file = File(imagefile.path);
    print(file);

    await compressImage();

    print('end');
  }

  handleCamera() async {
    print('++++++++++++++++++++++++++++++*******ffff');

    final imagefile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    if (imagefile == null) return null;

    print('start');

    file = File(imagefile.path);
    print("file ahooo$file");

    await compressImage();
    print('end');
  }

  compressImage() async {
    print('inside compresse');

    Directory tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(file.readAsBytesSync());
    final compressImageFile = File('$path/img_$postid.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile));

    file = compressImageFile;
    print("last$file");

    fileimages.add(file);
    print('inside compresse$fileimages');
  }

  uploadImage(imageFile) async {
    StorageUploadTask uploadTask =
        storageref.child("post_$postid.jpg").putFile(imageFile);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String dwonloadUrl = await storageSnap.ref.getDownloadURL();
    print('inside upload++++');

    return dwonloadUrl;
  }

  chooseImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text('Choose photo'),
            children: <Widget>[
              Divider(
                height: 2,
                color: Colors.grey,
              ),
              SizedBox(
                height: 5,
              ),
              SimpleDialogOption(
                child: Text('photo with camera'),
                onPressed: () {
                  Navigator.pop(context);
                  handleCamera();
                },
              ),
              SimpleDialogOption(
                child: Text('photo from Gallery'),
                onPressed: () {
                  Navigator.pop(context);

                  handleGrallery();
                },
              ),
              Divider(
                height: 2,
                color: Colors.grey,
              ),
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
          );
        });
  }

  final StorageReference storageref = FirebaseStorage.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      addproduct_errormassage = true;
    });
    getcurrntadmin();
    setState(() {

      product_size.text = stordata_for_updata_screen[0].size;
      product_offer.text = stordata_for_updata_screen[0].offer;
      productprice_admin.text = stordata_for_updata_screen[0].pPrice;
      productcategory_admin.text = stordata_for_updata_screen[0].pCatogery;
      productdescription_admin.text =
          stordata_for_updata_screen[0].pDiscription;
      addproductname_admin.text = stordata_for_updata_screen[0].pName;
      product_offer.text = stordata_for_updata_screen[0].offer;
      url_Images_Prodect = stordata_for_updata_screen[0].pMediaUrl;
      productkey_backend = stordata_for_updata_screen[0].pbackend_id;
      id.text = stordata_for_updata_screen[0].product_id_displa;
      print("fristsssss$url_Images_Prodect");
    });
    print("mmmmmmmmmmmm${productkey_backend}");
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    fileimages = [];
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        key: scaffol_addproduct_dkey,
        backgroundColor: KMainColor,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Center(
            child: Text(
              'Buy It',
              style: TextStyle(
                  fontSize: 20, color: Colors.white60, fontFamily: 'Pacifico'),
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async {
                  await auth.signOut();
                  Navigator.pushNamed(context, Admins.id);
                }),
          ],
        ),
        body: SingleChildScrollView(
          child: Form(
            key: form_addproduct_key,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: height * 0.015,
                ),
                SizedBox(
                  width: 250.0,
                  child: TextLiquidFill(
                    text: 'Buy it',
                    waveColor: Colors.white,
                    boxBackgroundColor: Colors.orange,
                    textStyle: TextStyle(
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pacifico'),
                    boxHeight: 100.0,
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Product id",
                  icon: Icons.description,
                  textEditingController: id,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.01501,
                ),
                Custom_TextField(
                  hient: "Product Name",
                  icon: Icons.add_shopping_cart,
                  textEditingController: addproductname_admin,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Product price",
                  icon: Icons.markunread_mailbox,
                  textEditingController: productprice_admin,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Product Discription",
                  icon: Icons.description,
                  textEditingController: productdescription_admin,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Product Category",
                  icon: Icons.add_comment,
                  textEditingController: productcategory_admin,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.01501,
                ),
                Custom_TextField(
                  hient: "Product Offer",
                  icon: Icons.do_not_disturb_on,
                  textEditingController: product_offer,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                Custom_TextField(
                  hient: "Product Size",
                  icon: Icons.score,
                  textEditingController: product_size,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.01501,
                ),
                Custom_TextField(
                  hient: "Product Color",
                  icon: Icons.add_shopping_cart,
                  textEditingController: p_color,
                  onclick: (value) {},
                ),
                SizedBox(
                  height: height * 0.015,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.black,
                  onPressed: () {
                    chooseImage(context);
                  },
                  child: Container(
                    width: width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Add Product Image',
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(
                          Icons.add_a_photo,
                          size: 15,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: Colors.black,
                  onPressed: () async {

                    print("dafile ahooo out$fileimages");

                    if (fileimages.length!=0) {
                      print("dafile ahooo$fileimages");
                      print('gooooooooooahiooooo');
                      setState(() {
                        url_Images_Prodect = [];
                      });
                      print('start*************${fileimages.length}');

                      for (var i in fileimages) {
                        url_Images_Prodect.add(await uploadImage(i));

                        print('end***********${url_Images_Prodect.length}');
                      }
                    }
                    if (form_addproduct_key.currentState.validate()) {
                      setState(() {
                        isloading = true;
                      });

                      print("ahooooooooooooo${url_Images_Prodect}");
                      store.updataProducts(
                          Product(
                              offer: product_offer.text,
                              pName: addproductname_admin.text,
                              pPrice: productprice_admin.text,
                              pDiscription: productdescription_admin.text,
                              pCatogery: productcategory_admin.text,
                              pMediaUrl: url_Images_Prodect,
                              timestamp: timestamp,
                              adminupload: currentadminemail,
                              uidadminUpload:
                                  product_id_admin.text, //product id
                              product_id_displa: id.text,
                              size: product_size.text,
                              pbackend_id: productkey_backend,
                              pcolor: p_color.text),
                          productkey_backend);
                      setState(() {
                        isloading = false;
                        print('end valides');
                      });
                      Navigator.pop(context);
                    } else if (form_addproduct_key.currentState.validate() &&
                        MediaUrlProduct == null) {
                      SnackBar snackbar = SnackBar(
                          content: Text('Please choose prodect image'));
                      scaffol_addproduct_dkey.currentState
                          .showSnackBar(snackbar);
                    }
                  },
                  child: Text(
                    'Update Product',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
