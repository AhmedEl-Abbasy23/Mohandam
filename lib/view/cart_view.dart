import 'dart:math';

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
  final _cartData = FirebaseFirestore.instance.collection('users');
  final _productsData = FirebaseFirestore.instance.collection('products');

  _addAndRemoveFavorites(String productId) async {
    await _productsData.doc(productId).update({
      'inFavorite': true,
    });
    print('Product in your favorite list now');
  }

  _deleteCartProducts() async{
    await _cartData.doc(_currentUser!.uid).collection('cart').get().then((snapshot) {
      for(DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  List<int> price = [];

  int _currentCount = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(right: 20.0, left: 20.0, top: 10.0, bottom: 0),
      child: StreamBuilder<QuerySnapshot?>(
          stream:
              _cartData.doc(_currentUser!.uid).collection('cart').snapshots(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Column(
                    children: [
                      // products
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
                                    _cartData
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
                      // order now
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
                                const Expanded(
                                  child: Text(
                                    '\$0', // todo solve it.
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Color(0xff096f77),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                              width: 150.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  List.generate(snapshot.data!.docs.length,
                                      (index) {
                                    orderNow(
                                      // todo pass an index instead of 0.
                                      sellerUid: snapshot.data!.docs[index]['sellerUid'],
                                      orderImages: [snapshot.data!.docs[index].get('images')[0]],
                                      productName: snapshot.data!.docs[index]['title'],
                                      productPrice: snapshot.data!.docs[index]['price'],
                                    );
                                  });
                                },
                                child:  Text(
                                  AppStrings.orderNow.tr().toUpperCase(),
                                  style: const TextStyle(fontSize: 16.0),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xff096f77),
                                ),
                              ),
                            ),
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
  }) async {
    final random = Random().nextInt(1500);
    var dateString = DateFormat.yMMMEd().format(DateTime.now());
    _cartData.doc(_currentUser!.uid).collection('orders').add({
      'title': 'ORDER -Code -$random\n$productName',
      'orderType': 'Buy',
      'orderTime': dateString,
      'status': 'In Transit',
      'totalPrice': productPrice,
      'orderImages': orderImages,
    }).then((value) {
      _cartData.doc(sellerUid).collection('orders').add({
        'title': 'REQUEST -Code -$random\n$productName',
        'orderType': 'Requests',
        'orderTime': dateString,
        'totalPrice': productPrice,
        'customerUid': _currentUser!.uid,
        'orderImages': orderImages,
      });
      _deleteCartProducts();
      print('-----------------------');
      print('Order Done');
      print('-----------------------');
    });
  }
}
