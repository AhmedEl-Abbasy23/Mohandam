import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  var name, mobileNumber, shippingAddress;

  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final _usersData = FirebaseFirestore.instance.collection('users');
  final _userStorage = FirebaseStorage.instance;

  String noImage =
      'https://st.depositphotos.com/2010753/1970/v/600/depositphotos_19705093-stock-illustration-hand-colorful-vector-design.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 24, color: Colors.black),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _usersData.doc(_currentUser!.uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 90.0,
                        backgroundImage: snapshot.data!.get('imgUrl') != ''
                            ? NetworkImage(snapshot.data!.get('imgUrl'))
                            : NetworkImage(noImage),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Name'),
                    TextFormField(
                      initialValue: snapshot.data!.get('name'),
                      cursorColor: const Color(0xff096f77),
                      maxLength: 20,
                      onSaved: (String? value) {
                        name = value;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        } else if (value.length < 6) {
                          return 'Invalid name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                        // on open form
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff096f77)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Mobile number'),
                    TextFormField(
                      initialValue: snapshot.data!.get('mobileNumber'),
                      cursorColor: const Color(0xff096f77),
                      onSaved: (String? value) {
                        mobileNumber = value;
                      },
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your mobile number';
                        } else if (value.length < 11) {
                          return 'Invalid mobile number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        // on open form
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff096f77)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text('Shipping address'),
                    TextFormField(
                      onSaved: (String? value) {
                        shippingAddress = value;
                      },
                      initialValue: snapshot.data!.get('shippingAddress'),
                      cursorColor: const Color(0xff096f77),
                      maxLines: 3,
                      maxLength: 120,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Please enter your address';
                        } else if (value.length < 6) {
                          return 'Invalid address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.streetAddress,
                      decoration: const InputDecoration(
                        // on open form
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xff096f77)),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(vertical: 15.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                      child: GestureDetector(
                        child: _getMediaWidget(),
                        onTap: () {
                          _showPicker(context);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20.0),
                      height: 60.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          _updateProfile(context, snapshot.data!.get('imgUrl'));
                        },
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xff096f77),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xff096f77)));
            }
          },
        ),
      ),
    );
  }

  final ImagePicker _picker = ImagePicker();
  File? _file;
  var _imageName;

  _pickImage(ImageSource source) async {
    var pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      var rand = Random().nextInt(100000);
      setState(() {
        _file = File(pickedImage.path);
        // to get image-name
        _imageName = "$rand" + basename(pickedImage.path);
      });
    }
  }

  _showPicker(BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            // like a column
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Wrap(
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.camera,
                      color: Color(0xff096f77),
                      size: 30.0,
                    ),
                    title: const Text('Import From Gallery', style: TextStyle(fontWeight: FontWeight.w600),),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _pickImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt_rounded,
                      color: Color(0xff096f77),
                      size: 30.0,
                    ),
                    title: const Text('Import From Camera', style: TextStyle(fontWeight: FontWeight.w600),),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      _pickImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _pickedImageByUser(File? image) {
    if (image != null && image.path.isNotEmpty) {
      return Image.file(image);
    } else {
      return Container();
    }
  }

  Widget _getMediaWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Flexible(
            child: Text(
              'Update picture',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          // show the picked image if it exists.
          Flexible(child: _pickedImageByUser(_file)),
          Flexible(
            child: SvgPicture.asset(
              'assets/icons/camera_ic.svg',
              height: 45.0,
              width: 45.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  _updateProfile(BuildContext context, String _currentImageUrl) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // edit task without update image.
      if (_file == null) {
        await _usersData.doc(_currentUser!.uid).update({
          'name': name,
          'mobileNumber': mobileNumber,
          'shippingAddress': shippingAddress,
        }).then((value) {
          Navigator.of(context).pop();
          print("Profile updated");
        }).catchError((error) => print("Failed to update profile: $error"));
      } else {
        // delete current image
        if (_currentImageUrl != '') {
          await _userStorage.refFromURL(_currentImageUrl).delete();
        }
        // upload new image
        await _userStorage.ref('users/').child(_imageName).putFile(_file!);
        var imgUrl =
            await _userStorage.ref('users/').child(_imageName).getDownloadURL();
        print('image Url is : $imgUrl ------------');
        await _usersData.doc(_currentUser!.uid).update({
          'name': name,
          'mobileNumber': mobileNumber,
          'shippingAddress': shippingAddress,
          'imgUrl': imgUrl,
        }).then((value) {
          Navigator.of(context).pop();
          print("Profile updated");
        }).catchError((error) => print("Failed to update profile: $error"));
      }
    }
  }
}
