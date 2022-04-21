import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/view/product_details_view.dart';

import 'category_products_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _exploreData =
      FirebaseFirestore.instance.collection('main').doc('explore');
  final _productsData = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xff096f77))),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // banners & categories
            StreamBuilder<DocumentSnapshot>(
                stream: _exploreData.snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List banners = snapshot.data!['banners'];
                    List categoryTitles = snapshot.data!['categories'];
                    List categoryImages = snapshot.data!['categoryImages'];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // banners section
                        CarouselSlider.builder(
                          itemCount: banners.length,
                          itemBuilder: (context, index, _) {
                            return SizedBox(
                              width: double.infinity,
                              child: Card(
                                elevation: 1.5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(
                                      color: Colors.white, width: 1.5),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    banners[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
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
                        const SizedBox(height: 12.0),
                        // categories section
                        const Text(
                          'Categories',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 12.0),
                          child: ListView.builder(
                            itemCount: categoryImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryProductsView(
                                            categoryName: categoryTitles[index],
                                          )));
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                        color: Colors.white, width: 1.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: Image.network(
                                            categoryImages[index],
                                            fit: BoxFit.contain,
                                            width: 80,
                                            height: 80,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            categoryTitles[index],
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xff096f77)));
                  }
                }),
            // recommended section
            StreamBuilder<QuerySnapshot?>(
              stream: _productsData
                  .where('category', isEqualTo: 'Recommended')
                  .snapshots(), // todo order by.
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot?> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommended',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 1 / 1.40,
                          ),
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            // product item
                            return InkWell(
                              onTap: () {
                                // navigate to product details screen.
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsView(
                                      productId: snapshot.data!.docs[index].id,
                                      productImages: snapshot.data!.docs[index]
                                          ['images'],
                                      productDescription: snapshot
                                          .data!.docs[index]['description'],
                                      productPrice: snapshot.data!.docs[index]
                                          ['price'],
                                      productTitle: snapshot.data!.docs[index]
                                          ['title'],
                                      productInFavorite: snapshot.data!.docs[index]
                                      ['inFavorite'],
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: snapshot.data!.docs[index].id,
                                child: Card(
                                  elevation: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Image.network(
                                          snapshot.data!.docs[index]['images']
                                              [0],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: double.infinity,
                                        ),
                                      ),
                                      // Texts
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 2.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['title'],
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 2.0),
                                            Text(
                                              snapshot.data!.docs[index]
                                                  ['subtitle'],
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 8.0),
                                            Text(
                                              '\$${
                                                  snapshot.data!.docs[index]
                                                  ['price']
                                              }',
                                              style: const TextStyle(
                                                color: Color(0xff096f77),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xff096f77)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
