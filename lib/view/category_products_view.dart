import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/product_details_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class CategoryProductsView extends StatefulWidget {
  const CategoryProductsView({
    Key? key,
    required this.categoryName,
    required this.category,
  }) : super(key: key);

  final String categoryName;
  final String category;

  @override
  State<CategoryProductsView> createState() => _CategoryProductsViewState();
}

class _CategoryProductsViewState extends State<CategoryProductsView> {
  final _productsData = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontSize: 24, color: Colors.black),
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
        stream: _productsData
            .where('category', isEqualTo: widget.category)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
          if (snapshot.hasData) {
            return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSwatch()
                      .copyWith(secondary: const Color(0xff096f77))),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Text(
                      'Here you will see all handmade ${widget.categoryName}',
                      style: const TextStyle(fontSize: 20.0),
                    ),*/
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
                              navigatePush(context, ProductDetailsView(
                                productId: snapshot.data!.docs[index].id,
                                productImages: snapshot.data!.docs[index]['images'],
                                productDescription: snapshot.data!.docs[index]['description'],
                                productPrice: snapshot.data!.docs[index]['price'],
                                productTitle: snapshot.data!.docs[index]['title'],
                                productInFavorite: snapshot.data!.docs[index]['inFavorite'],
                                productQuantity: snapshot.data!.docs[index]['quantity'],
                              ));
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
                                    // Texts
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5.0, vertical: 2.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]['title'],
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
                                            '${snapshot.data!.docs[index]['price']} ${AppStrings.egp.tr()}',
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
                ),
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
