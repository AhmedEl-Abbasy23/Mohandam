import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/view/product_details_view.dart';

class FavoritesView extends StatefulWidget {
  const FavoritesView({Key? key}) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  final _productsData = FirebaseFirestore.instance.collection('products');

  _addAndRemoveFavorites(String productId, bool inFavorite) async {
    await _productsData.doc(productId).update({
      'inFavorite': !inFavorite,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(fontSize: 24, color: Colors.black),
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
      // recommended section
      body: StreamBuilder<QuerySnapshot?>(
        stream: _productsData.where('inFavorite', isEqualTo: true).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
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
                                  productDescription: snapshot.data!.docs[index]
                                      ['description'],
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      snapshot.data!.docs[index]['images'][0],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  // Texts & favorite icon
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // title - subtitle - price
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
                                              '\$${snapshot.data!.docs[index]['price']}',
                                              style: const TextStyle(
                                                color: Color(0xff096f77),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // favorite icon
                                      Flexible(
                                        child: IconButton(
                                          onPressed: () {
                                            _addAndRemoveFavorites(
                                                snapshot.data!.docs[index].id,
                                                snapshot.data!.docs[index]
                                                    ['inFavorite']);
                                          },
                                          icon: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            child: SvgPicture.asset(
                                              'assets/icons/favorites_ic2.svg',
                                              color: snapshot.data!
                                                  .docs[index]['inFavorite']
                                                  ? Colors.orangeAccent : Colors.black,
                                              fit: BoxFit.cover,
                                              height: 20.0,
                                              width: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
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
              ),
            );
          } else {
            return const Center(
                child: CircularProgressIndicator(color: Color(0xff096f77)));
          }
        },
      ),
    );
  }
}
