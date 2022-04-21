import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:handmade_store/view/edit_profile_view.dart';
import 'package:handmade_store/view/login_view.dart';

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

  String noImage = 'https://st.depositphotos.com/2010753/1970/v/600/depositphotos_19705093-stock-illustration-hand-colorful-vector-design.jpg';

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
                return SizedBox(
                  height: 120.0,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage:
                          snapshot.data!.get('imgUrl') != '' ?
                          NetworkImage(snapshot.data!.get('imgUrl')) : NetworkImage(noImage),
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
                            children:  [
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
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const EditProfile()));
                  },
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/location_ic.svg',
                  title: 'Shipping Address',
                  onTap: () {},
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/favorites_ic2.svg',
                  title: 'Favorites',
                  onTap: () {},
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/orders_ic.svg',
                  title: 'Orders',
                  onTap: () {},
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/language_ic.svg',
                  title: 'Change Language',
                  onTap: () {},
                ),
                const Divider(),
                _getListTile(
                  leadingImg: 'assets/icons/logout_ic.svg',
                  title: 'Logout',
                  onTap: () async {
                    _auth.signOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginView()));
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
