import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/view/reusable_widgets/custom_button.dart';
import 'package:handmade_store/view/reusable_widgets/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    Key? key,
    required this.productId,
    required this.productImages,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
    required this.productQuantity,
    required this.productInFavorite,
  }) : super(key: key);
  final String productId;
  final List productImages;
  final String productTitle;
  final String productDescription;
  final String productPrice;
  final String productQuantity;
  final bool productInFavorite;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  final _productsData = FirebaseFirestore.instance.collection('products');
  final _currentUser = FirebaseAuth.instance.currentUser;
  final _cartData = FirebaseFirestore.instance.collection('users');

  _addAndRemoveFavorites(String productId, bool inFavorite) async {
    await _productsData.doc(productId).update({
      'inFavorite': !inFavorite,
    });
    print('Product updated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Product section
            StreamBuilder<DocumentSnapshot?>(
              stream: _productsData.doc(widget.productId).snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      // images & buttons
                      Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          // product images section
                          Hero(
                            tag: widget.productId,
                            child: Container(
                              margin: const EdgeInsets.only(top: 50.0),
                              height: 280.0,
                              child: CarouselSlider.builder(
                                itemCount: widget.productImages.length,
                                itemBuilder: (context, index, _) {
                                  return Card(
                                    elevation: 5.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: Colors.white, width: 1.5),
                                    ),
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: widget.productImages.isNotEmpty
                                            ? Image.network(
                                                widget.productImages[index],
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                'assets/images/mohandam_logo.jpg',
                                                fit: BoxFit.cover,
                                              )),
                                  );
                                },
                                options: CarouselOptions(
                                  height: 250,
                                  autoPlay: true,
                                  enableInfiniteScroll: true,
                                  enlargeCenterPage: true,
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 5000),
                                ),
                              ),
                            ),
                          ),
                          // back icon
                          Positioned(
                            top: 45.0,
                            child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 25.0,
                              ),
                            ),
                          ),
                          // favorite icon
                          Positioned(
                            top: 45.0,
                            right: 5.0,
                            child: IconButton(
                              onPressed: () {
                                _addAndRemoveFavorites(
                                  widget.productId,
                                  snapshot.data!.get('inFavorite'),
                                );
                              },
                              icon: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: SvgPicture.asset(
                                  'assets/icons/favorites_ic2.svg',
                                  color: snapshot.data!.get('inFavorite')
                                      ? Colors.orangeAccent
                                      : Colors.black,
                                  fit: BoxFit.cover,
                                  height: 20.0,
                                  width: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 530.0,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Theme(
                          data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.fromSwatch().copyWith(
                                  secondary: const Color(0xff096f77))),
                          child: ListView(
                            padding:
                                const EdgeInsets.only(top: 0.0, bottom: 10.0),
                            children: [
                              CustomText(
                                text: widget.productTitle,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const RoundedShapeInfo(
                                    title: 'Size',
                                    content: CustomText(
                                      text: 'XXL - X - M',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  RoundedShapeInfo(
                                    title: 'Color',
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color(0xffffc107),
                                          ),
                                        ),
                                        const SizedBox(width: 3.0),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(width: 3.0),
                                        Container(
                                          height: 20,
                                          width: 20,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: CustomText(
                                  text: 'Details',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomText(
                                text: widget.productDescription,
                                fontSize: 14.0,
                                height: 2.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff096f77),
                    ),
                  );
                }
              },
            ),
            // Price & Buy section
            Material(
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'PRICE',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: '\$${widget.productPrice}',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff096f77),
                        ),
                      ],
                    ),
                    // add button
                    SizedBox(
                      height: 60.0,
                      width: 146.0,
                      child: CustomButton(
                        'ADD',
                        () {
                          _addProductToCart(
                            productId: widget.productId,
                            productImages: widget.productImages,
                            productTitle: widget.productTitle,
                            productPrice: widget.productPrice,
                            productQuantity: widget.productQuantity,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _addProductToCart({
    required List productImages,
    required String productTitle,
    required String productId,
    required String productPrice,
    required String productQuantity,
  }) async {
    await _cartData
        .doc(_currentUser!.uid)
        .collection('cart')
        .doc(productId)
        .set({
      'image': productImages,
      'title': productTitle,
      'price': productPrice,
      'quantity': productQuantity,
      'productId': productId,
    }).then((value) {
      print('-----------------------');
      print('$productTitle is added to your cart.');
      print('-----------------------');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xff096f77),
        content: SizedBox(
          height: 50.0,
          child: Text(
            '"$productTitle" has been added to your cart successfully',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class RoundedShapeInfo extends StatelessWidget {
  final String title;
  final Widget content;

  const RoundedShapeInfo({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              fontSize: 14,
              alignment: Alignment.center,
            ),
            content,
          ],
        ),
      ),
    );
  }
}
