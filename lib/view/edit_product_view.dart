import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class EditProductView extends StatefulWidget {
  const EditProductView({Key? key, required this.productId}) : super(key: key);

  final String productId;

  @override
  State<EditProductView> createState() => _EditProductViewState();
}

class _EditProductViewState extends State<EditProductView> {
  final _formKey = GlobalKey<FormState>();
  final _productsData = FirebaseFirestore.instance.collection('products');
  final _productsStorage = FirebaseStorage.instance;
  final _currentUser = FirebaseAuth.instance.currentUser!;

  var _productTitle,
      _productDescription,
      _productPrice,
      _productQuantity;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  _selectImages() async {
    final List<XFile>? _selectedImages = await _picker.pickMultiImage(
      imageQuality: 50,
    );
    if (_selectedImages!.isNotEmpty) {
      setState(() {
        _images = [];
        _images.addAll(_selectedImages);
      });
      print("Image List Length: " + _images.length.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppStrings.editProduct.tr(),
          style: const TextStyle(fontSize: 24.0, color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: MyColors.primary)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: StreamBuilder<DocumentSnapshot?>(
            stream: _productsData.doc(widget.productId).snapshots(),
            builder: (context, snapshot) {
              List productImages = snapshot.data!['images'];
              return snapshot.hasData? Column(
                children: [
                  // product details
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // product images section
                            CarouselSlider.builder(
                              itemCount: productImages.isEmpty
                                  ? _images.length
                                  : productImages.length,
                              itemBuilder: (context, index, _) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 1.5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12.0),
                                      side: const BorderSide(
                                          color: Colors.white,
                                          width: 1.5),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(12.0),
                                        child: _images.isEmpty
                                            ? Image.network(
                                          productImages[index],
                                          fit: BoxFit.cover,
                                        ) : Image.file(File(_images[index].path))),
                                  ),
                                );
                              },
                              options: CarouselOptions(
                                height: 190,
                                autoPlay: true,
                                enableInfiniteScroll: true,
                                enlargeCenterPage: true,
                                autoPlayAnimationDuration:
                                const Duration(milliseconds: 500),
                              ),
                            ),
                            const SizedBox(height: 30.0),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(AppStrings.productImages
                                          .tr()),
                                      Container(
                                        height: 60.0,
                                        width: 200.0,
                                        margin: const EdgeInsets.only(
                                            top: 15.0, bottom: 30.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              10.0),
                                        ),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              _selectImages();
                                            },
                                            child: Text(
                                              AppStrings.chooseImages
                                                  .tr(),
                                              style: const TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 16.0,
                                                color: Colors.white,
                                              ),
                                            ),
                                            style: ElevatedButton
                                                .styleFrom(
                                              primary: const Color(
                                                  0xff096f77),
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10.0),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                // Delete Product
                                Flexible(
                                  child: Container(
                                    height: 60.0,
                                    width: 200.0,
                                    margin: const EdgeInsets.only(
                                        top: 43.0, bottom: 30.0),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(10.0),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        _deleteProduct(context, snapshot.data!['images']);
                                      },
                                      icon: SvgPicture.asset(
                                        'assets/icons/delete_ic.svg',
                                        color: MyColors.redAccent,
                                        fit: BoxFit.contain,
                                        height: 45.0,
                                        width: 45.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(AppStrings.productTitle.tr()),
                            TextFormField(
                              initialValue: snapshot.data!.get('title'),
                              cursorColor: MyColors.primary,
                              maxLength: 20,
                              onSaved: (String? value) {
                                _productTitle = value;
                              },
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppStrings
                                      .pleaseEnterProductName
                                      .tr();
                                } else if (value.length < 2) {
                                  return AppStrings.invalidProductName
                                      .tr();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                // on open form
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Text(AppStrings.productDescription.tr()),
                            TextFormField(
                              onSaved: (String? value) {
                                _productDescription = value;
                              },
                              initialValue:
                              snapshot.data!.get('description'),
                              cursorColor: MyColors.primary,
                              maxLines: 3,
                              maxLength: 800,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return AppStrings
                                      .pleaseEnterProductDescription
                                      .tr();
                                }
                                return null;
                              },
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                // on open form
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: MyColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            // price
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                // price
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          AppStrings.productPrice.tr()),
                                      TextFormField(
                                        initialValue:
                                        snapshot.data!.get('price'),
                                        cursorColor: MyColors.primary,
                                        onSaved: (String? value) {
                                          _productPrice = value!;
                                        },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return AppStrings
                                                .pleaseEnterProductPrice
                                                .tr();
                                          } else if (value
                                              .startsWith('0')) {
                                            return AppStrings
                                                .invalidProductPrice
                                                .tr();
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                        TextInputType.phone,
                                        decoration:
                                        const InputDecoration(
                                          // on open form
                                          focusedBorder:
                                          UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                MyColors.primary),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 60.0),
                                // quantity
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(AppStrings.productQuantity
                                          .tr()),
                                      TextFormField(
                                        initialValue: snapshot.data!
                                            .get('quantity'),
                                        cursorColor: MyColors.primary,
                                        onSaved: (String? value) {
                                          _productQuantity = value!;
                                        },
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return AppStrings
                                                .pleaseEnterProductQuantity
                                                .tr();
                                          } else if (value
                                              .startsWith('0')) {
                                            return AppStrings
                                                .invalidProductQuantity
                                                .tr();
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                        TextInputType.phone,
                                        decoration:
                                        const InputDecoration(
                                          // on open form
                                          focusedBorder:
                                          UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                MyColors.primary),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Upload product
                  Container(
                    margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
                    height: 60.0,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        _updateProduct(context, snapshot.data!['images'], snapshot.data!['category']);
                      },
                      child: Text(
                        AppStrings.updateProduct.tr(),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: MyColors.primary,
                      ),
                    ),
                  ),
                ],
              ) : const Center(child: CircularProgressIndicator(color: MyColors.primary),);
            }
          ),
        ),
      ),
    );
  }

  _deleteProduct(BuildContext context,  List<dynamic> currentImages) async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.NO_HEADER,
        headerAnimationLoop: true,
        animType: AnimType.BOTTOMSLIDE,
        title: AppStrings.alert.tr(),
        desc: AppStrings.confirmDeleteProduct.tr(),
        buttonsTextStyle: const TextStyle(color: Colors.white),
        btnOkColor: const Color(0xff096f77),
        btnOkText: AppStrings.yes.tr(),
        btnOkOnPress: () async {
          await _productsData.doc(widget.productId).delete();
          Navigator.of(context).pop();
          List.generate(currentImages.length, (index) {
            _productsStorage.refFromURL(currentImages[index]).delete();
            print('---------------------------');
            print('${currentImages[index]} is deleted');
            print('---------------------------');
          });
        },
        showCloseIcon: true,
        btnCancelText: AppStrings.cancel.tr(),
        btnCancelOnPress: () {
          Navigator.of(context).pop();
        }).show();
  }

  _updateProduct(BuildContext context, List<dynamic> currentImages, String productCategory) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // edit product without update image.
      // upload product images
      List<String> _imagesUrls = [];
      var rand = Random().nextInt(100000);
      if (_images.isNotEmpty) {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          headerAnimationLoop: true,
          animType: AnimType.BOTTOMSLIDE,
          title: AppStrings.updatingProduct.tr(),
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        ).show().then((value) {
          Navigator.of(context).pop();
        });
        for(var imageFile in _images) {
          var reference = _productsStorage.ref('products/$productCategory/').child('$rand' + basename(imageFile.path));
          var uploadImages = reference.putFile(File(imageFile.path));
          print('---------------------------');
          print('$rand' + basename(imageFile.path) + ' is uploaded');
          print('---------------------------');
          var downloadUrl = await uploadImages.whenComplete(() => {});
          await downloadUrl.ref.getDownloadURL().then((value) {
            _imagesUrls.add(value);
          });
        }
        if (_imagesUrls.length == _images.length) {
          List.generate(currentImages.length, (index) {
            _productsStorage.refFromURL(currentImages[index]).delete();
          });
          var dateString = DateFormat.d().format(DateTime.now()) + DateFormat.Hms().format(DateTime.now());
          _productsData.doc(widget.productId).update({
            'description': _productDescription,
            'price': _productPrice, 'title': _productTitle, 'quantity': _productQuantity, 'images': _imagesUrls, 'inFavorite': false, 'sellerUid': _currentUser.uid, 'uploadTime': int.parse(dateString.replaceAll(':','')),
          }).then((value) async {
            // to upload seller information inside product.
            print(widget.productId);
            var _userInfo = await FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).get();
            await _productsData.doc(widget.productId).collection('seller info').doc(_currentUser.uid).update({
              'sellerName': _userInfo.get('name'), 'sellerImg': _userInfo.get('imgUrl'), 'sellerUid': _currentUser.uid,
            });
            print("Product Updated");
            Navigator.of(context).pop();
          }).catchError((error) => print("Failed to update product: $error"));
        }
      }else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.INFO,
          headerAnimationLoop: true,
          animType: AnimType.BOTTOMSLIDE,
          title: AppStrings.updatingProduct.tr(),
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
        ).show().then((value) {Navigator.of(context).pop();});
        var dateString = DateFormat.d().format(DateTime.now()) + DateFormat.Hms().format(DateTime.now());
          _productsData.doc(widget.productId).update({
            'description': _productDescription, 'price': _productPrice, 'title': _productTitle, 'quantity': _productQuantity, 'inFavorite': false, 'sellerUid': _currentUser.uid, 'uploadTime': int.parse(dateString.replaceAll(':','')),
          }).then((value) async {
            // to upload seller information inside product.
            print(widget.productId);
            var _userInfo = await FirebaseFirestore.instance.collection('users').doc(_currentUser.uid).get();
            await _productsData.doc(widget.productId).collection('seller info').doc(_currentUser.uid).update({
              'sellerName': _userInfo.get('name'), 'sellerImg': _userInfo.get('imgUrl'), 'sellerUid': _currentUser.uid,
            });
            print("Product Updated");
            Navigator.of(context).pop();
          }).catchError((error) => print("Failed to update product: $error"));
        }
    }
  }
}
