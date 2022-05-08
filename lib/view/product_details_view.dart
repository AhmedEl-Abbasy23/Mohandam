import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/reusable_widgets/custom_button.dart';
import 'package:handmade_store/view/reusable_widgets/custom_text.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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

  final String appLogo =
      'https://firebasestorage.googleapis.com/v0/b/handmade-49991.appspot.com/o/mohandam_logo.jpg?alt=media&token=15f1d4be-0af1-47f1-b66f-a5b4d0ed903f';

  _getProductDetails() {
    return _productsData.doc(widget.productId).snapshots();
  }
  _getSellerUid() {
    return _productsData
        .doc(widget.productId)
        .collection('seller info')
        .snapshots();
  }

  List<dynamic> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme:
                ColorScheme.fromSwatch().copyWith(secondary: MyColors.primary)),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 20.0, right: 20.0, top: 20.0, bottom: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product section
              Expanded(
                child: SingleChildScrollView(
                    child: StreamBuilder<DocumentSnapshot?>(
                        stream: _getProductDetails(),
                        builder: (BuildContext context, snapshot) {
                          List productImages = snapshot.data!['images'];
                          if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // images & buttons
                                Container(
                                  margin: const EdgeInsets.only(top: 20.0),
                                  height: 320.0,
                                  child: Stack(
                                    children: [
                                      // product images section
                                      Hero(
                                        tag: widget.productId,
                                        child: CarouselSlider.builder(
                                          itemCount:
                                              snapshot.data!['images'].length,
                                          itemBuilder: (context, index, _) {
                                            return Card(
                                              elevation: 5.0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                side: const BorderSide(
                                                  color: Colors.white,
                                                  width: 1.5,
                                                ),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: productImages
                                                          .isNotEmpty
                                                      ? Image.network(
                                                          productImages[index],
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'assets/images/mohandam_logo.jpg',
                                                          fit: BoxFit.cover,
                                                        )),
                                            );
                                          },
                                          options: CarouselOptions(
                                            height: 300,
                                            autoPlay: true,
                                            enableInfiniteScroll: true,
                                            enlargeCenterPage: true,
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds: 5000),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // back icon
                                          IconButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            icon: const CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                color: Colors.black,
                                                size: 22.0,
                                              ),
                                            ),
                                          ),
                                          // favorite icon
                                          IconButton(
                                            onPressed: () {
                                              _addAndRemoveFavorites(
                                                widget.productId,
                                                snapshot.data!['inFavorite'],
                                              );
                                            },
                                            icon: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: SvgPicture.asset(
                                                'assets/icons/favorites_ic2.svg',
                                                color:
                                                    snapshot.data!['inFavorite']
                                                        ? Colors.orangeAccent
                                                        : Colors.black,
                                                fit: BoxFit.cover,
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                // title & product images
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CustomText(
                                      text: snapshot.data!['title'],
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    const Spacer(),
                                    Flexible(
                                      child: SizedBox(
                                        height: 40.0,
                                        child: ListView(
                                          scrollDirection: Axis.horizontal,
                                          children: [
                                            MultiSelectContainer(
                                              itemsPadding:
                                                  const EdgeInsets.all(2.0),
                                              itemsDecoration:
                                                  MultiSelectDecorations(
                                                decoration: BoxDecoration(
                                                    color: MyColors.primary
                                                        .withOpacity(0.4)),
                                                selectedDecoration:
                                                    BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      MyColors.primary,
                                                      MyColors.primary
                                                          .withOpacity(0.6)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              items: List.generate(
                                                  productImages.length,
                                                  (int index) {
                                                return MultiSelectCard(
                                                  value: productImages[index],
                                                  child: getChild(imagePath: productImages[index]),
                                                );
                                              }),
                                              listViewSettings:
                                                  const ListViewSettings(
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                              onChange: (List<dynamic> selectedItems, selectedItem) {
                                                setState(() {
                                                  selectedImages = selectedItems;
                                                });
                                                print(selectedItems);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // subtitle & quantity
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomText(
                                        text: AppStrings.details.tr(),
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      RoundedShapeInfo(
                                        title: AppStrings.quantity.tr(),
                                        content: snapshot.data!['quantity'],
                                      ),
                                    ],
                                  ),
                                ),
                                CustomText(
                                  text: snapshot.data!['description'],
                                  textAlign: TextAlign.start,
                                  fontSize: 14.0,
                                  height: 2.0,
                                ),
                                const SizedBox(height: 20.0),
                                StreamBuilder<QuerySnapshot?>(
                                    stream: _getSellerUid(),
                                    builder: (context, snapshot) {
                                      return snapshot.hasData
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircleAvatar(
                                                    radius: 26.0,
                                                    backgroundColor:
                                                        MyColors.primary,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        snapshot.data!.docs[0]['sellerImg'] != ''
                                                            ? snapshot.data!.docs[0]['sellerImg']
                                                            : appLogo,
                                                      ),
                                                      radius: 25.0,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10.0),
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      CustomText(
                                                        text: AppStrings.seller
                                                            .tr(),
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      CustomText(
                                                        text: snapshot.data!.docs[0]['sellerName'],
                                                        fontSize: 16.0,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container();
                                    }),
                              ],
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xff096f77),
                              ),
                            );
                          }
                        })),
              ),
              // Price & Add section
              Container(
                height: 80.0,
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: AppStrings.price.tr().toUpperCase(),
                          fontSize: 15.0,
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: '${widget.productPrice} ${AppStrings.egp.tr()}',
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primary,
                        ),
                      ],
                    ),
                    // add button
                    StreamBuilder<QuerySnapshot?>(
                        stream: _getSellerUid(),
                        builder: (context, sellerSnapshot) {
                          return sellerSnapshot.hasData
                              ? SizedBox(
                                  height: 60.0,
                                  width: 145.0,
                                  child: sellerSnapshot.data!.docs[0]['sellerUid'] !=
                                          _currentUser!.uid
                                      ? StreamBuilder<DocumentSnapshot>(
                                        stream: _getProductDetails(),
                                        builder: (context, snapshot) {

                                          return CustomButton(
                                              AppStrings.add.tr().toUpperCase(),
                                              () {
                                                _addProductToCart(
                                                  productId: widget.productId,
                                                  productImages: snapshot.data!['images'],
                                                  productTitle: snapshot.data!['title'],
                                                  productPrice: snapshot.data!['price'],
                                                  productQuantity:snapshot.data!['quantity'],
                                                  sellerUid: sellerSnapshot.data!.docs[0]['sellerUid'],
                                                );
                                              },
                                            );
                                        }
                                      )
                                      : null,
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xff096f77),
                                  ),
                                );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addProductToCart({
    required List<dynamic> productImages,
    required String productTitle,
    required String productId,
    required String productPrice,
    required String productQuantity,
    required String sellerUid,
  }) async {
    await _cartData
        .doc(_currentUser!.uid)
        .collection('cart')
        .doc(productId)
        .set({
      'images': selectedImages.isNotEmpty ? selectedImages : productImages,
      'title': productTitle,
      'price': productPrice,
      'quantity': productQuantity,
      'productId': productId,
      'sellerUid': sellerUid,
    }).then((value) {
      print('-----------------------');
      print('$productTitle is added to your cart.');
      print('-----------------------');
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: MyColors.primary,
        content: SizedBox(
          height: 30.0,
          child: Text(
            '"$productTitle" ${AppStrings.addToCart.tr()}',
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }

  Widget getChild({required String imagePath}) {
    return SizedBox(
      height: 30.0,
      width: 30.0,
      child: Image.network(
        imagePath,
        fit: BoxFit.cover,
      ),
    );
  }
}

class RoundedShapeInfo extends StatelessWidget {
  final String title, content;

  const RoundedShapeInfo({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      width: 115.0,
      decoration: BoxDecoration(
        border: Border.all(color: MyColors.primary.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 2,
              child: CustomText(
                text: title,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Flexible(
              child: CustomText(
                text: content,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
