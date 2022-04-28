import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handmade_store/shared/cache_helper.dart';
import 'package:handmade_store/shared/functions.dart';
import 'package:handmade_store/shared/localization.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:handmade_store/view/edit_profile_view.dart';
import 'package:handmade_store/view/favorites_view.dart';
import 'package:handmade_store/view/login_view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'orders_view.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final _auth = FirebaseAuth.instance;

  final CollectionReference _userData =
      FirebaseFirestore.instance.collection('users');
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final String _appLogoUrl =
      'https://firebasestorage.googleapis.com/v0/b/handmade-49991.appspot.com/o/mohandam_logo.jpg?alt=media&token=15f1d4be-0af1-47f1-b66f-a5b4d0ed903f';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // information
          StreamBuilder<DocumentSnapshot>(
            stream: _userData.doc(_currentUser!.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  height: 180.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0x10096f77),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          backgroundColor: const Color(0xff096f77),
                          radius: 68.0,
                          child: CircleAvatar(
                            radius: 65.0,
                            backgroundImage: snapshot.data!.get('imgUrl') != ''
                                ? NetworkImage(snapshot.data!.get('imgUrl'))
                                : NetworkImage(_appLogoUrl),
                          ),
                        ),
                      ),
                      // name & email
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.get('name'),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                snapshot.data!.get('email'),
                                // 'ahmed.elabbasy23@gmail.com',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 25.0),
            child: Column(
              children: [
                _getListTile(
                  leadingImg: 'assets/icons/edit_profile_ic.svg',
                  title: AppStrings.editProfile.tr(),
                  onTap: () {
                    navigatePush(context, const EditProfile());
                  },
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/favorites_ic2.svg',
                  title: AppStrings.favorites.tr(),
                  onTap: () {
                    navigatePush(context, const FavoritesView());
                  },
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/orders_ic.svg',
                  title: AppStrings.orders.tr(),
                  onTap: () {
                    navigatePush(context, OrdersView());
                  },
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/language_ic.svg',
                  title: AppStrings.changeLanguage.tr(),
                  onTap: () {
                    MyLocalization.changeLanguage(context);
                    // CacheHelper.saveData(key: 'lang', value: translator.activeLanguageCode);
                  },
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/logout_ic.svg',
                  title: AppStrings.logout.tr(),
                  onTap: () async {
                    _auth.signOut().then((value) {
                      navigatePushReplacement(context, const LoginView());
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getListTile(
      {required String leadingImg,
      required String title,
      required Function onTap}) {
    return ListTile(
      minLeadingWidth: 30.0,
      leading: Container(
        color: const Color(0x1f096f77),
        child: SvgPicture.asset(
          leadingImg,
          fit: BoxFit.cover,
          height: 22.0,
          width: 22.0,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        onTap();
      },
    );
  }
}
