import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handmade_store/view/sell_product_view.dart';
import 'package:handmade_store/view/account_view.dart';
import 'package:handmade_store/view/cart_view.dart';
import 'package:handmade_store/view/explore_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ExploreView(),
    CartView(),
    AccountView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: _currentIndex != 2
              ? Container(
                  width: 300.0,
                  height: 50.0,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    cursorColor: const Color(0xff096f77),
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.black, size: 28),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                )
              : null),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // selectedLabelStyle: const TextStyle(fontSize: 29.0, color: Colors.black),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 0.0,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? const Text(
                    'Explore',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                : SvgPicture.asset(
                    'assets/icons/explore_ic.svg',
                    fit: BoxFit.cover,
                    height: 22.0,
                    width: 22.0,
                  ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? const Text(
                    'Cart',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                : SvgPicture.asset(
                    'assets/icons/cart_ic.svg',
                    fit: BoxFit.cover,
                    height: 22.0,
                    width: 22.0,
                  ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 2
                ? const Text(
                    'Account',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  )
                : SvgPicture.asset(
                    'assets/icons/user_ic.svg',
                    fit: BoxFit.cover,
                    height: 22.0,
                    width: 22.0,
                  ),
            label: '',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              child: Image.asset('assets/icons/sell_product_ic.png'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const SellProductView()),
                );
              },
              backgroundColor: Colors.transparent,
        elevation: 0.0,
              // backgroundColor: const Color(0xff096f77),
            )
          : null,
    );
  }
}
