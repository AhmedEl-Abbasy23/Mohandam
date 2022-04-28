import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CartProduct extends StatefulWidget {
  CartProduct({
    Key? key,
    this.onDismissed,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
    required this.counter,
  }) : super(key: key);

  final void Function(DismissDirection)? onDismissed;
  final String title;
  int price;
  final String image;
  final int quantity;
  int counter;
  late int totalPrice;

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
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
      onDismissed: widget.onDismissed,
      key: UniqueKey(),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        elevation: 5.0,
        child: SizedBox(
          height: 130.0,
          width: double.infinity,
          // margin:
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Image.network(
                  widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          widget.price.toString(),
                          style: const TextStyle(
                            color: Color(0xff096f77),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        // counter
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.zero,
                            width: 80.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: Colors.grey.shade300,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _createIncrementDecrementButton(
                                  Icons.add,
                                  () {
                                    _increment();
                                  },
                                ),
                                Text(widget.counter.toString()),
                                _createIncrementDecrementButton(
                                  Icons.remove,
                                  () {
                                    _decrement();
                                  },
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
  }

  _increment() {
    if (widget.counter < widget.quantity) {
      setState(() {
        widget.counter++;
        widget.totalPrice = widget.price *  widget.counter;
      });
    }
  }

  _decrement() {
    if (widget.counter > 1) {
      setState(() {
        {
          widget.counter--;
          widget.totalPrice = widget.price *  widget.counter;
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

/*
(DismissDirection direction) {
 if (direction ==
  DismissDirection.startToEnd) {
  _addAndRemoveFavorites(snapshot
      .data!.docs[index]['productId']);
  } else {
  _cartData
      .doc(_currentUser!.uid)
      .collection('cart')
      .doc(snapshot.data!.docs[index].id)
      .delete();
  }
},*/
