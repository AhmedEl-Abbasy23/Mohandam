import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/view/edit_product_view.dart';
import 'package:handmade_store/view/product_details_view.dart';
import 'package:handmade_store/view/reusable_widgets/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../shared/strings_manager.dart';

class ListingsView extends StatelessWidget {
  ListingsView({Key? key}) : super(key: key);

  final _currentUser = FirebaseAuth.instance.currentUser;
  final _usersData = FirebaseFirestore.instance.collection('users');
  final _productsData = FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot<Map<String, dynamic>>> _getListings(String orderType) {
    return _usersData.doc(_currentUser!.uid).collection('Listings').where('orderType', isEqualTo: orderType).snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(AppStrings.listings.tr(), style: const TextStyle(fontSize: 22.0, color: Colors.black),),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () {Navigator.of(context).pop();},),
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: TabBar(
            indicatorColor: const Color(0xff096f77),
            labelColor: const Color(0xff096f77),
            labelStyle: TextStyle( fontSize: 18.0, fontWeight: FontWeight.bold,
                fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular"),
            unselectedLabelStyle: TextStyle( fontSize: 16.0, fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular"),
            tabs: [
              Tab(child: Text(AppStrings.myPurchases.tr())),
              Tab(child: Text(AppStrings.myProducts.tr())),
              Tab(child: Text(AppStrings.orders.tr())),
            ],
          ),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff096f77))),
          child: TabBarView(
            children: [
              Padding(  // My Purchases
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: StreamBuilder<QuerySnapshot?>(
                    stream: _getListings('My Purchases'),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(snapshot.data!.docs[index]['orderTime'], style: const TextStyle(fontSize: 16.0, color: Colors.grey,),),
                                    Card(
                                      margin: const EdgeInsets.symmetric(vertical: 15.0), elevation: 5.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                        height: 180.0, width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Flexible(child: Text(snapshot.data!.docs[index]['title'], style: const TextStyle(fontSize: 18.0),),),
                                                  const SizedBox(height: 5.0),
                                                  Text('${snapshot.data!.docs[index]['totalPrice']} ${AppStrings.egp.tr()}',
                                                    style: const TextStyle(fontSize: 18.0, color: Color(0xff096f77),),),
                                                  const SizedBox(height: 5.0),
                                                  Container(
                                                    height: 40.0, width: 125.0,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: snapshot.data!.docs[index]['status'] == 'In Transit'
                                                          ? MyColors.yellow
                                                          : MyColors.primary,
                                                      borderRadius: BorderRadius.circular(5.0),),
                                                    child: Text( snapshot.data!.docs[index]['status'],
                                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20.0),),),],),),
                                            SizedBox(height: 150.0, width: 140.0, child: Image.network(snapshot.data!.docs[index]['orderImages'][0], fit: BoxFit.cover,),),],),),),],);})
                          : const Center(child: CircularProgressIndicator(color: Color(0xff096f77)));}),
              ),
              // My Products
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                  child: StreamBuilder<QuerySnapshot?>(
                      stream: _productsData.where('sellerUid', isEqualTo: _currentUser!.uid).snapshots(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                                  itemBuilder: (BuildContext context, int index) {
                                    return InkWell( // product item
                                      onTap: () {
                                        navigatePush(  // navigate to product details screen.
                                            context,
                                            ProductDetailsView(
                                              productId: snapshot.data!.docs[index].id,
                                              productImages: snapshot.data!.docs[index]['images'],
                                              productDescription: snapshot.data!.docs[index]['description'],
                                              productPrice: snapshot.data!.docs[index]['price'],
                                              productTitle: snapshot.data!.docs[index]['title'],
                                              productInFavorite: snapshot.data!.docs[index]['inFavorite'],
                                              productQuantity: snapshot.data!.docs[index]['quantity'],
                                            ));},
                                      child: Hero(
                                        tag: snapshot.data!.docs[index].id,
                                        child: Card(
                                          elevation: 4.0,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Image.network(
                                                  snapshot.data!.docs[index]['images'][0],
                                                  fit: BoxFit.cover, width: double.infinity, height: double.infinity,),),
                                              // Texts
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(snapshot.data!.docs[index]['title'],
                                                      style: const TextStyle( fontWeight: FontWeight.bold),),
                                                    const SizedBox(height: 2.0),
                                                    Text(snapshot.data!.docs[index]['description'],
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle( fontWeight: FontWeight.w300, color: Colors.grey),),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Flexible(
                                                          child: Text('${snapshot.data!.docs[index]['price']} ${AppStrings.egp.tr()}',
                                                            style: const TextStyle(color: Color(0xff096f77)),),),
                                                        IconButton(
                                                          onPressed: () {
                                                            navigatePush(context, EditProductView(  // edit product
                                                              productId: snapshot.data!.docs[index].id,));},
                                                          icon: const Icon(Icons.edit,),
                                                          iconSize: 22.0, color: MyColors.primary, splashRadius: 25.0,),],),],),),],),),),);},),)
                            : const Center(child: CircularProgressIndicator(color: MyColors.primary,),);
                      })),
              // Orders
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                child: StreamBuilder<QuerySnapshot?>(
                    stream: _getListings('Orders'),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text( snapshot.data!.docs[index]['orderTime'],
                                      style: const TextStyle(fontSize: 16.0, color: Colors.grey,),),
                                    Card(
                                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                                      elevation: 5.0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                        height: translator.activeLanguageCode == 'en' ? 360.0 : 450.0,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox( // Product Order Details
                                              height: 180.0,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['title'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18.0),
                                                          ),
                                                        ),
                                                        const SizedBox(height: 5.0),
                                                        Text(
                                                          '${snapshot.data!.docs[index]['totalPrice']} ${AppStrings.egp.tr()}',
                                                          style: const TextStyle(fontSize: 18.0, color: MyColors.primary,),),
                                                        const SizedBox(height: 10.0),
                                                        Container(
                                                          height: 50.0, width: 125.0,
                                                          alignment: Alignment.center,
                                                          decoration: BoxDecoration(color: MyColors.primary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5.0),
                                                          ),
                                                          child: CustomButton(
                                                            'Done',
                                                            () {
                                                              var docId = _usersData.doc(snapshot.data!.docs[index]['customerUid']).collection('Listings').doc().id;
                                                              var customerUidDoc = snapshot.data!.docs[index]['customerUid'];
                                                              var currentRequestUid = snapshot.data!.docs[index].id;
                                                              print(docId);
                                                              _updateStatus( customerUidDoc, docId, currentRequestUid,);},),),],),),
                                                  SizedBox(
                                                    height: 150.0, width: 140.0,
                                                    child: Image.network(
                                                      snapshot.data!.docs[index]['orderImages'][0],
                                                      fit: BoxFit.cover, ),),],),),
                                            const SizedBox(height: 10.0),
                                            const Divider(thickness: 2.0),
                                            const SizedBox(height: 10.0),
                                            Flexible( // Customer information
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  RichText( text: TextSpan(style: TextStyle(fontSize: 15.0, color: Colors.black,
                                                          fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular",),
                                                        children: [
                                                          TextSpan(text: AppStrings.customerName.tr(),
                                                            style: const TextStyle(color: MyColors.primary, fontSize: 17.0,),),
                                                          TextSpan(text: '${snapshot.data!.docs[index]['customerName']}',),]),),
                                                  const SizedBox(height: 5.0),
                                                  RichText(
                                                    text: TextSpan(style: TextStyle(fontSize: 15.0, color: Colors.black, fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular",),
                                                        children: [
                                                          TextSpan(text: AppStrings.customerNumber.tr(),
                                                            style: const TextStyle(color: MyColors.primary, fontSize: 17.0,),),
                                                          TextSpan(text: '${snapshot.data!.docs[index]['customerPhone']}',),]),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  RichText(
                                                    text: TextSpan(style: TextStyle(fontSize: 15.0, color: Colors.black, fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular",),
                                                        children: [TextSpan(text: AppStrings.customerAddress.tr(), style: const TextStyle(color: MyColors.primary, fontSize: 17.0,),),
                                                          TextSpan(text: '\n${snapshot.data!.docs[index]['customerAddress']}',),]),),
                                                  const SizedBox(height: 5.0),
                                                  SizedBox(
                                                    height: translator.activeLanguageCode == 'en' ? 20.0 : 40.0,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        RichText(
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                fontSize: 15.0, color: Colors.black,
                                                                fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular",),
                                                              children: [
                                                                TextSpan(
                                                                  text: AppStrings.orderRequiredQuantity.tr(),
                                                                  style: const TextStyle(color: MyColors.primary, fontSize: 17.0,),),
                                                                TextSpan(
                                                                  text: '${snapshot.data!.docs[index]['orderQuantity']}',),]),),
                                                        RichText(
                                                          text: TextSpan(
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: Colors.black,
                                                                fontFamily: translator.activeLanguageCode == 'en' ? 'SFP-REGULAR' : "CairoRegular",
                                                              ),
                                                              children: [
                                                                TextSpan(text: AppStrings.orderTotalPrice.tr(),
                                                                  style: const TextStyle(color: MyColors.primary, fontSize: 17.0,),),
                                                                TextSpan(text: '${snapshot.data!.docs[index]['totalPrice']}',),]),),],),),],),)],),),),],);},)
                          : const Center(child: CircularProgressIndicator(color: MyColors.primary,),); }),),],),),),); }
  _updateStatus(
      String customerUidDoc, String docId, String currentRequestUid) async {
    await _usersData.doc(customerUidDoc).collection('Listings').doc(docId).update({
      'status':'Delivered',
    }).then((value) { _usersData.doc(_currentUser!.uid).collection('Listings').doc(currentRequestUid).delete(); });
  }
}
