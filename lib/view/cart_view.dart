import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/models/cart_model.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/reusable_widgets/cart_item.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final _currentUser = FirebaseAuth.instance.currentUser;
  final CollectionReference _userData =
      FirebaseFirestore.instance.collection('users');
  final _productsData = FirebaseFirestore.instance.collection('products');

  _addAndRemoveFavorites(String productId) async {
    await _productsData.doc(productId).update({
      'inFavorite': true,
    });
    print('Product in your favorite list now');
  }

  _deleteCartProducts() async {
    await _userData
        .doc(_currentUser!.uid)
        .collection('cart')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  List<int> price = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 0),
      child: StreamBuilder<QuerySnapshot?>(
          stream:
              _userData.doc(_currentUser!.uid).collection('cart').snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    children: [
                      // Products
                      Expanded(
                        flex: 12,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.fromSwatch()
                                .copyWith(secondary: const Color(0xff096f77)),
                          ),
                          child: ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              CartModel _cartModel = CartModel(
                                productId:
                                    snapshot.data!.docs[index].get('productId'),
                                title: snapshot.data!.docs[index].get('title'),
                                images:
                                    snapshot.data!.docs[index].get('images'),
                                price: int.parse(
                                    snapshot.data!.docs[index].get('price')),
                                quantity: int.parse(
                                    snapshot.data!.docs[index].get('quantity')),
                              );
                              return CartProduct(
                                title: _cartModel.title,
                                image: _cartModel.images[0],
                                counter: 1,
                                price: _cartModel.price,
                                quantity: _cartModel.quantity,
                                onDismissed: (DismissDirection direction) {
                                  if (direction ==
                                      DismissDirection.startToEnd) {
                                    _addAndRemoveFavorites(snapshot
                                        .data!.docs[index]['productId']);
                                  } else {
                                    _userData
                                        .doc(_currentUser!.uid)
                                        .collection('cart')
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      // Buy now
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppStrings.totalPrice.tr(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '0 ${AppStrings.egp.tr()}', // todo solve it.
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Color(0xff096f77),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder<DocumentSnapshot>(
                                stream: _userData
                                    .doc(_currentUser!.uid)
                                    .snapshots(),
                                builder: (context, userSnapshot) {
                                  return SizedBox(
                                    height: 50.0,
                                    width: 150.0,
                                    child: ElevatedButton(
                                      onPressed: userSnapshot
                                                      .data!['mobileNumber'] ==
                                                  '' ||
                                              userSnapshot.data![
                                                      'shippingAddress'] ==
                                                  ''
                                          ? () {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.NO_HEADER,
                                          headerAnimationLoop: true,
                                          animType: AnimType.BOTTOMSLIDE,
                                          title: AppStrings.alert.tr(),
                                          desc: AppStrings.updateYourInfo.tr(),
                                          buttonsTextStyle: const TextStyle(color: Colors.white),
                                          btnOkColor: const Color(0xff096f77),
                                          showCloseIcon: false,
                                          btnOkOnPress: () {},
                                        ).show();
                                            }
                                          : () {
                                              List.generate(
                                                  snapshot.data!.docs.length,
                                                  (int index) {
                                                orderNow(
                                                  sellerUid: snapshot.data!
                                                      .docs[index]['sellerUid'],
                                                  orderImages: [
                                                    snapshot.data!.docs[index]
                                                        .get('images')[0]
                                                  ],
                                                  productName: snapshot.data!
                                                      .docs[index]['title'],
                                                  productPrice: snapshot.data!
                                                      .docs[index]['price'],
                                                  // current user info
                                                  customerName: userSnapshot
                                                      .data!['name'],
                                                  customerPhone: userSnapshot
                                                      .data!['mobileNumber'],
                                                  customerAddress: userSnapshot
                                                      .data!['shippingAddress'],
                                                );
                                              });
                                            },
                                      child: Text(
                                        AppStrings.orderNow.tr().toUpperCase(),
                                        style: const TextStyle(fontSize: 16.0),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: const Color(0xff096f77),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Color(0xff096f77)),
                  );
          }),
    );
  }

  orderNow({
    required String sellerUid,
    required List orderImages,
    required String productName,
    required String productPrice,
    required String customerName,
    required String customerPhone,
    required String customerAddress,
  }) async {
    final random = Random().nextInt(1500);
    var dateString = DateFormat.yMMMEd().format(DateTime.now());
    _userData.doc(_currentUser!.uid).collection('Listings').add({
      'title': 'ORDER Code-$random\n$productName',
      'orderType': 'My Purchases',
      'orderTime': dateString,
      'status': 'In Transit',
      'totalPrice': productPrice,
      'orderImages': orderImages,
    }).then((value) {
      _userData.doc(sellerUid).collection('Listings').add({
        'title': 'REQUEST Code-$random\n$productName',
        'orderType': 'Orders',
        'orderTime': dateString,
        'totalPrice': productPrice,
        // todo replace with product total price
        'orderQuantity': '',
        // todo replace with product total quantity
        'customerUid': _currentUser!.uid,
        'customerName': customerName,
        'customerPhone': customerPhone,
        'customerAddress': customerAddress,
        'orderImages': orderImages,
      });
      _deleteCartProducts();
      print('-----------------------');
      print('Order Done');
      print('-----------------------');
    });
  }
}
