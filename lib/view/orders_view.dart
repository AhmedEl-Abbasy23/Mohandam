import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handmade_store/view/reusable_widgets/custom_button.dart';

class OrdersView extends StatelessWidget {
  OrdersView({Key? key}) : super(key: key);

  final _currentUser = FirebaseAuth.instance.currentUser;
  final _ordersData = FirebaseFirestore.instance.collection('users');
  final _productsData = FirebaseFirestore.instance.collection('products');

  Stream<QuerySnapshot<Map<String, dynamic>>> _getOrders(String orderType) {
    return _ordersData
        .doc(_currentUser!.uid)
        .collection('orders')
        .where('orderType', isEqualTo: orderType)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _getSellProducts() {
    return _productsData.snapshots();
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
          title: const Text(
            'Orders',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: const TabBar(
            indicatorColor: Color(0xff096f77),
            labelColor: Color(0xff096f77),
            labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 16.0),
            tabs: [
              Tab(child: Text('Buy')),
              Tab(child: Text('Sell')),
              Tab(
                  child: Text(
                'Requests',
                style: TextStyle(color: Color(0x99096f77)),
              )),
            ],
          ),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: const Color(0xff096f77))),
          child: TabBarView(
            children: [
              // Buy
              Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSwatch()
                        .copyWith(secondary: const Color(0xff096f77))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: StreamBuilder<QuerySnapshot?>(
                      stream: _getOrders('Buy'),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['orderTime'],
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        elevation: 3.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 20.0),
                                          height: 180.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          ['title'],
                                                      style: const TextStyle(
                                                          fontSize: 20.0),
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    Text(
                                                      '\$${snapshot.data!.docs[index]['totalPrice']}',
                                                      style: const TextStyle(
                                                        fontSize: 20.0,
                                                        color:
                                                            Color(0xff096f77),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 35.0),
                                                    Flexible(
                                                      child: Container(
                                                        height: 50.0,
                                                        width: 125.0,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      'status'] ==
                                                                  'In Transit'
                                                              ? const Color(
                                                                  0xffffc107)
                                                              : const Color(
                                                                  0xff096f77),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                        ),
                                                        child: Text(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['status'],
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 20.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 150.0,
                                                width: 140.0,
                                                child: Image.network(
                                                  snapshot.data!.docs[index]
                                                      ['orderImages'][0],
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                })
                            : const Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xff096f77)));
                      }),
                ),
              ),
              // Sell
              Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSwatch()
                        .copyWith(secondary: const Color(0xff096f77))),
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 20.0),
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'April 23, 2022',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Card(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 15.0),
                                  elevation: 3.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 20.0),
                                    height: 180.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'OD - 424923192 - N',
                                          style: TextStyle(fontSize: 20.0),
                                        ),
                                        const SizedBox(height: 5.0),
                                        const Text(
                                          '\$700',
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: Color(0xff096f77),
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Container(
                                          height: 50.0,
                                          width: 125.0,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color(0xffffc107),
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                          ),
                                          child: const Text(
                                            'In Transit',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        })),
              ),
              // Requests
              Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.fromSwatch()
                        .copyWith(secondary: const Color(0xff096f77))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 20.0),
                  child: StreamBuilder<QuerySnapshot?>(
                      stream: _getOrders('Requests'),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data!.docs[index]['orderTime'],
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Card(
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        elevation: 3.0,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15.0, horizontal: 20.0),
                                          height: 180.0,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data!.docs[index]
                                                        ['title'],
                                                    style: const TextStyle(
                                                        fontSize: 20.0),
                                                  ),
                                                  const SizedBox(height: 5.0),
                                                  Text(
                                                    '\$${snapshot.data!.docs[index]['totalPrice']}',
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      color: Color(0xff096f77),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 15.0),
                                                  Container(
                                                    height: 50.0,
                                                    width: 125.0,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffffc107),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                    ),
                                                    child: CustomButton('Done',
                                                        () {
                                                      var docId = _ordersData
                                                          .doc(snapshot.data!
                                                                  .docs[index]
                                                              ['customerUid'])
                                                          .collection('orders')
                                                          .doc()
                                                          .id;
                                                      var customerUidDoc =
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['customerUid'];
                                                      var currentRequestUid =
                                                          snapshot.data!
                                                              .docs[index].id;
                                                      print(docId);
                                                      _updateStatus(
                                                          customerUidDoc,
                                                          docId,
                                                          currentRequestUid);
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                })
                            : const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xff096f77),
                                ),
                              );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _updateStatus(
      String customerUidDoc, String docId, String currentRequestUid) async {
    await _ordersData
        .doc(customerUidDoc)
        .collection('orders')
        .doc(docId)
        .update({
      'status': 'Delivered',
    }).then((value) {
      _ordersData
          .doc(_currentUser!.uid)
          .collection('orders')
          .doc(currentRequestUid)
          .delete();
    });
  }
}
