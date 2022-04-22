import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/models/cart_model.dart';

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

  int _currentCount = 1;

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          // products
          StreamBuilder<QuerySnapshot?>(
              stream: _cartData
                  .doc(_currentUser!.uid)
                  .collection('cart')
                  .snapshots(),
              builder: (context, snapshot) {

                return SizedBox(
                  height: 700.0,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSwatch()
                          .copyWith(secondary: const Color(0xff096f77)),
                    ),
                    child: snapshot.hasData
                        ? ListView.builder(
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              int productQuantity = int.parse(snapshot.data!.docs[index]['quantity']);
                              return Dismissible(
                                secondaryBackground: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  alignment: Alignment.centerRight,
                                  color: const Color(0xffff3d00),
                                  width: double.infinity,
                                  child: SvgPicture.asset(
                                    'assets/icons/delete_ic.svg',
                                    color: Colors.white,
                                    height: 50.0,
                                    width: 50.0,
                                  ),
                                ),
                                background: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40.0),
                                  alignment: Alignment.centerLeft,
                                  color: const Color(0xffffc107),
                                  width: double.infinity,
                                  child: SvgPicture.asset(
                                    'assets/icons/favorites_ic3.svg',
                                    color: Colors.white,
                                    height: 50.0,
                                    width: 50.0,
                                  ),
                                ),
                                onDismissed: (DismissDirection direction) {
                                  if (direction == DismissDirection.startToEnd) {
                                    _addAndRemoveFavorites(snapshot.data!.docs[index]['productId']);
                                  } else {
                                    _cartData
                                        .doc(_currentUser!.uid)
                                        .collection('cart')
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                  }
                                },
                                key: UniqueKey(),
                                child: Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  elevation: 5.0,
                                  child: SizedBox(
                                    height: 130.0,
                                    width: double.infinity,
                                    // margin:
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Image.network(
                                            snapshot.data!.docs[index]['image']
                                                [0],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20.0,
                                                      vertical: 10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['title'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8.0),
                                                  Text(
                                                    '\$${snapshot.data!.docs[index]['price']}',
                                                    style: const TextStyle(
                                                      color: Color(0xff096f77),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 30.0),
                                                  // counter
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.zero,
                                                      width: 80.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0),
                                                        color: Colors
                                                            .grey.shade300,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          _createIncrementDecrementButton(
                                                            Icons.add,
                                                            () {
                                                              _increment(productQuantity);
                                                            },
                                                          ),
                                                          Text('$_currentCount'),
                                                          _createIncrementDecrementButton(
                                                            Icons.remove,
                                                            () {
                                                              _decrement();
                                                            }
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xff096f77)),
                          ),
                  ),
                );
              }),
          // order now
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$4500',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color(0xff096f77),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'ORDER NOW',
                      style: TextStyle(fontSize: 16.0),
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
      ),
    );
  }

  _increment(int productQuantity) {
    if (_currentCount < productQuantity) {
      setState(() {
        _currentCount++;
      });
    }
  }

  _decrement() {
    if (_currentCount > 1) {
      setState(() {
        {
          _currentCount--;
        }
      });
    }
  }

  Widget _createIncrementDecrementButton(IconData icon, Function onPressed) {
    return RawMaterialButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      constraints: const BoxConstraints(minWidth: 30.0, minHeight: 32.0),
      onPressed: () {
        onPressed();
      },
      elevation: 0.0,
      fillColor: Colors.grey.shade300,
      child: Icon(
        icon,
        color: Colors.black,
        size: 15.0,
      ),
      // shape: const CircleBorder(),
    );
  }
}
