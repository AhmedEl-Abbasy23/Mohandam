import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/product_details_view.dart';
import 'package:handmade_store/view/reusable_widgets/product_item.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'category_products_view.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  final _exploreData = FirebaseFirestore.instance.collection('main').doc('explore');
  final _productsData = FirebaseFirestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff096f77))),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // banners & categories
            StreamBuilder<DocumentSnapshot>(
                stream: _exploreData.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    List banners = snapshot.data!['banners'];
                    List categoryTitles = translator.activeLanguageCode != 'ar' ? snapshot.data!['categories'] : snapshot.data!['categoriesAr'];
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
                                child: ClipRRect(borderRadius: BorderRadius.circular(12.0), child: Image.network(banners[index], fit: BoxFit.cover,),),),);},
                          options: CarouselOptions(
                            height: 220.0,
                            autoPlay: true,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            autoPlayAnimationDuration: const Duration(milliseconds: 500),
                          ),),
                        const SizedBox(height: 15.0),
                        Text(AppStrings.categories.tr(), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),), // categories section
                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(vertical: 15.0),
                          child: ListView.builder(
                            itemCount: categoryImages.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  navigatePush( context,
                                      CategoryProductsView(
                                        categoryName: categoryTitles[index], // to show in appBar
                                        category: snapshot.data!['categories'][index], // for filed name when getting data
                                       ));},
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(
                                        color: Colors.white, width: 1.5),
                                  ),
                                  child: Column(
                                    children: [
                                      Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(15.0), child: Image.network(categoryImages[index], fit: BoxFit.contain, width: 80.0, height: 80.0,),),),
                                      Padding(padding: const EdgeInsets.symmetric(vertical: 5.0), child: Align(alignment: Alignment.center, child: Text(categoryTitles[index], textAlign: TextAlign.center,),),),],),),
                              );}, scrollDirection: Axis.horizontal,),),],);
                  } else { return const Center(child: CircularProgressIndicator(color: MyColors.primary), ); } } ),
            // recommended section
            StreamBuilder<QuerySnapshot?>(
              stream: _productsData.where('category', isEqualTo: 'Recommended').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot?> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppStrings.recommended.tr(), style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                    ],
                  );
                } else {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: MyColors.primary));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
