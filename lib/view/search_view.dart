import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/product_details_view.dart';
import 'package:handmade_store/view/reusable_widgets/custom_text.dart';
import 'package:handmade_store/view/reusable_widgets/product_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SearchView extends StatefulWidget {
  final String? searchValue;

  SearchView(this.searchValue);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _productsData = FirebaseFirestore.instance.collection('products');
  String? _searchValue;

  Stream<QuerySnapshot<Map<String, dynamic>>> _getSearchData() {
    return _productsData
        .where('title', isGreaterThanOrEqualTo: _searchValue)
        .where('title', isLessThanOrEqualTo: '$_searchValue\uf7ff')
        .orderBy('title')
        .startAt([_searchValue]).endAt(['$_searchValue\uf7ff']).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppStrings.search.tr(),
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
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xff096f77))),
        child: StreamBuilder<QuerySnapshot?>(
          stream: _getSearchData(),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: TextFormField(
                            cursorColor: const Color(0xff096f77),
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.black),
                            ),
                            initialValue: widget.searchValue,
                            onChanged: (String? value) {
                              setState(() {
                                _searchValue = value!;
                              });
                            },
                            onFieldSubmitted: (value) {
                              setState(() {
                                _searchValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 16, left: 16, bottom: 24),
                          child: GridView.builder(
                            padding: const EdgeInsets.all(0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                              crossAxisSpacing: 10.0,
                              mainAxisExtent: 280.0,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  navigatePush(
                                    context,
                                    ProductDetailsView(
                                      productId: snapshot.data!.docs[index].id,
                                      productImages: snapshot.data!.docs[index]
                                          ['images'],
                                      productTitle: snapshot.data!.docs[index]
                                          ['title'],
                                      productDescription: snapshot
                                          .data!.docs[index]['description'],
                                      productPrice: snapshot.data!.docs[index]
                                          ['price'],
                                      productQuantity: snapshot
                                          .data!.docs[index]['quantity'],
                                      productInFavorite: snapshot
                                          .data!.docs[index]['inFavorite'],
                                    ),
                                  );
                                },
                                child: Hero(
                                  tag: snapshot.data!.docs[index].id,
                                  child: ProductItem(
                                    imgUrl: snapshot.data!.docs[index]['images'][0],
                                    title: snapshot.data!.docs[index]['title'],
                                    description: snapshot.data!.docs[index]['description'],
                                    price: snapshot.data!.docs[index]['price'],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(color: Color(0xff096f77)));
          },
        ),
      ),
    );
  }
}
