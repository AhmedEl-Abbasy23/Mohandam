import 'package:flutter/material.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int _currentCount = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          // products
          SizedBox(
            height: 700.0,
            child: Theme(
              data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xff096f77)),
              ),
              child: ListView.builder(
                physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (direction) {},
                      key: UniqueKey(),
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        elevation: 4.0,
                        child: SizedBox(
                          height: 110.0,
                          width: double.infinity,
                          // margin:
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image.asset(
                                  'assets/images/item1.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'BeoPlay Speaker',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        const Text(
                                          '\$758',
                                          style: TextStyle(
                                            color: Color(0xff096f77),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20.0),
                                        // counter
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.zero,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: Colors.grey.shade300,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                _createIncrementDecrementButton(
                                                    Icons.add,
                                                    () => _increment()),
                                                Text(_currentCount.toString()),
                                                _createIncrementDecrementButton(
                                                    Icons.remove,
                                                    () => _decrement()),
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
                  }),
            ),
          ),
          // order now
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$4500',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Color(0xff096f77),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                  width: 150.0,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text(
                      'ORDER NOW',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff096f77),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _increment() {
    setState(() {
      _currentCount++;
    });
  }

  _decrement() {
    if (_currentCount > 0) {
      setState(() {
        {
          _currentCount--;
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
