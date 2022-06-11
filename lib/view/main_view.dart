import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/my_colors.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/search_view.dart';
import 'package:handmade_store/view/sell_product_view.dart';
import 'package:handmade_store/view/account_view.dart';
import 'package:handmade_store/view/cart_view.dart';
import 'package:handmade_store/view/explore_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
        title: _currentIndex != 2 ? Container(width: 300.0, height: 60.0, color: Colors.white, padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: _textFieldWidget()) : null),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        showSelectedLabels: false,
        backgroundColor: Colors.white,
        elevation: 2.0,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: _currentIndex == 0
                ? Text(AppStrings.explore.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),)
                : SvgPicture.asset('assets/icons/explore_ic.svg', fit: BoxFit.cover, height: 22.0, width: 22.0,), label: '',),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? Text(AppStrings.cart.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),)
                : SvgPicture.asset('assets/icons/cart_ic.svg', fit: BoxFit.cover, height: 22.0, width: 22.0,), label: '',),
          BottomNavigationBarItem(icon: _currentIndex == 2
                ? Text(AppStrings.account.tr(), textAlign: TextAlign.center, style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold,),)
                : SvgPicture.asset('assets/icons/user_ic.svg', fit: BoxFit.cover, height: 22.0, width: 22.0,), label: '',),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.sell),
                  label: Text(AppStrings.sell.tr(),style: const TextStyle(fontSize: 18.0),),
              onPressed: () {
                navigatePush(context, const SellProductView());
              },
              backgroundColor: MyColors.primary, elevation: 3.0,
            ) : null,
    );}
  Widget _textFieldWidget() {
    return TextField(
      onChanged: (String? value) {navigatePush(context, SearchView(value));},
      cursorColor: const Color(0xff096f77),
      style: const TextStyle(fontSize: 12.0,),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade200,
        filled: true,
        prefixIcon: const Icon(Icons.search, color: Colors.black, size: 28),
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
    );
  }
}
