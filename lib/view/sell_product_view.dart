import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SellProductView extends StatefulWidget {
  const SellProductView({Key? key}) : super(key: key);

  @override
  State<SellProductView> createState() => _SellProductViewState();
}

class _SellProductViewState extends State<SellProductView> {
  final _formKey = GlobalKey<FormState>();
  final _productsData = FirebaseFirestore.instance.collection('products');
  final _productsStorage = FirebaseStorage.instance;
  final _currentUser = FirebaseAuth.instance.currentUser!;

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> categories = const [
      DropdownMenuItem(child: Text("Accessories"), value: "Accessories"),
      DropdownMenuItem(child: Text("Jewelery"), value: "Jewelery"),
      DropdownMenuItem(child: Text("Antiques"), value: "Antiques"),
      DropdownMenuItem(child: Text("Glass"), value: "Glass"),
      DropdownMenuItem(child: Text("Pottery"), value: "Pottery"),
      DropdownMenuItem(child: Text("Crochet"), value: "Crochet"),
      DropdownMenuItem(child: Text("Embroidery"), value: "Embroidery"),
      DropdownMenuItem(child: Text("Decorations"), value: "Decorations"),
      DropdownMenuItem(child: Text("Clay"), value: "Clay"),
      DropdownMenuItem(child: Text("Paint Art"), value: "Paint Art"),
      DropdownMenuItem(child: Text("Leathers"), value: "Leathers"),
      DropdownMenuItem(child: Text("Macrames"), value: "Macrames"),
      DropdownMenuItem(child: Text("Gifts"), value: "Gifts"),
      // DropdownMenuItem(child: Text("General"), value: "general"),
    ];
    return categories;
  }

  var _productTitle,
      _productSubtitle,
      _productCategory = 'Recommended',
      _productDescription,
      _productPrice,
      _productQuantity;

  String? _currentCategory;

  final ImagePicker _picker = ImagePicker();
  List<XFile> _images = [];

  _selectImages() async {
    final List<XFile>? _selectedImages = await _picker.pickMultiImage(
      imageQuality: 10,
    );
    if (_selectedImages!.isNotEmpty) {
      setState(() {
        _images = [];
        _images.addAll(_selectedImages);
      });
      print("Image List Length: " + _images.length.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Sell a product',
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
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: const Color(0xff096f77))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            children: [
              // product details
              Expanded(
                flex: 13,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // product images section
                        CarouselSlider.builder(
                          itemCount: _images.length,
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
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: _images.isNotEmpty
                                        ? Image.file(
                                            File(_images[index].path),
                                            fit: BoxFit.cover,
                                          )
                                        : Image.asset(
                                            'assets/images/mohandam_logo.jpg',
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 190,
                            autoPlay: true,
                            enableInfiniteScroll: true,
                            enlargeCenterPage: true,
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 500),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Product Category'),
                                  Container(
                                    height: 60.0,
                                    width: 200.0,
                                    margin: const EdgeInsets.only(
                                        top: 15.0, bottom: 30.0),
                                    child: DropdownButtonFormField(
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff096f77),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff096f77),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color(0xff096f77),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xff096f77),
                                      ),
                                      dropdownColor: const Color(0xff096f77),
                                      elevation: 5,
                                      iconSize: 20.0,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_circle_outlined,
                                        color: Colors.white,
                                      ),
                                      hint: const Text(
                                        'Choose Category',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                        color: Colors.white,
                                      ),
                                      value: _currentCategory,
                                      isExpanded: true,
                                      borderRadius: BorderRadius.circular(15.0),
                                      autofocus: true,
                                      items: dropdownItems,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _currentCategory = value;
                                        });
                                      },
                                      onSaved: (String? value) {
                                        setState(() {
                                          _currentCategory = value;
                                        });
                                      },
                                      autovalidateMode: AutovalidateMode.always,
                                      /*validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Please choose product category';
                                        }
                                        return null;
                                      },*/
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Product Images'),
                                  Container(
                                    height: 60.0,
                                    width: 200.0,
                                    margin: const EdgeInsets.only(
                                        top: 15.0, bottom: 30.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _selectImages();
                                        },
                                        child: const Text(
                                          'Choose Images',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(0xff096f77),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Text('Product Title'),
                        TextFormField(
                          // initialValue: snapshot.data!.get('name'),
                          cursorColor: const Color(0xff096f77),
                          maxLength: 20,
                          onSaved: (String? value) {
                            _productTitle = value;
                          },
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter the product name';
                            } else if (value.length < 6) {
                              return 'Invalid product name';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            // on open form
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff096f77)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text('Product Subtitle'),
                        TextFormField(
                          cursorColor: const Color(0xff096f77),
                          onSaved: (String? value) {
                            _productSubtitle = value;
                          },
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter the product subtitle';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          maxLength: 35,
                          decoration: const InputDecoration(
                            // on open form
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff096f77)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        const Text('Product Description'),
                        TextFormField(
                          onSaved: (String? value) {
                            _productDescription = value;
                          },
                          // initialValue: snapshot.data!.get('shippingAddress'),
                          cursorColor: const Color(0xff096f77),
                          maxLines: 6,
                          maxLength: 800,
                          validator: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please enter the product description';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            // on open form
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xff096f77)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        // price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // price
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Product Price'),
                                  TextFormField(
                                    // initialValue: snapshot.data!.get('name'),
                                    cursorColor: const Color(0xff096f77),
                                    onSaved: (String? value) {
                                      _productPrice = value!;
                                    },
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the product price';
                                      } else if (value.startsWith('0')) {
                                        return 'Type a valid product price';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      // on open form
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff096f77)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 60.0),
                            // quantity
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Product Quantity'),
                                  TextFormField(
                                    // initialValue: snapshot.data!.get('name'),
                                    cursorColor: const Color(0xff096f77),
                                    onSaved: (String? value) {
                                      _productQuantity = value!;
                                    },
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter the product quantity';
                                      } else if (value.startsWith('0')) {
                                        return 'Type a valid product quantity';
                                      }
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      // on open form
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff096f77)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Upload product
              Container(
                margin: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                height: 60.0,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    _uploadProduct(context);
                  },
                  child: const Text(
                    'Upload Product',
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
      ),
    );
  }

  _uploadProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // edit task without update image.
      // upload product images
      List<String> _imagesUrls = [];
      var rand = Random().nextInt(100000);
      if (_images.isNotEmpty) {
        AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                headerAnimationLoop: true,
                animType: AnimType.BOTTOMSLIDE,
                title: 'Uploading product now ...',
                dismissOnBackKeyPress: false,
                dismissOnTouchOutside: false)
            .show()
            .then((value) {
          Navigator.of(context).pop();
        });
        for (var imageFile in _images) {
          var reference = _productsStorage.ref('products/${_currentCategory ?? _productCategory}/')
              .child('$rand' + basename(imageFile.path));
          var uploadImages = reference.putFile(File(imageFile.path));
          print('---------------------------');
          print('$rand' + basename(imageFile.path) + ' is uploaded');
          print('---------------------------');
          var downloadUrl = await uploadImages.whenComplete(() => {});
          await downloadUrl.ref.getDownloadURL().then((value) {
            _imagesUrls.add(value);

            print('---------------------------');
            print(_imagesUrls);
            print('---------------------------');
          });
        }
        if (_imagesUrls.length == _images.length) {
          _productsData.add({
            'category': _currentCategory ?? _productCategory,
            'description': _productDescription,
            'price': _productPrice,
            'title': _productTitle,
            'subtitle': _productSubtitle,
            'quantity': _productQuantity,
            'images': _imagesUrls,
            'inFavorite': false,
            'ownProduct': true,
          }).then((value) async {
            // to upload seller information inside product.
            print(value.id);
            var _userInfo = await FirebaseFirestore.instance
                .collection('users')
                .doc(_currentUser.uid)
                .get();
            await _productsData
                .doc(value.id)
                .collection('seller info')
                .doc(_currentUser.uid)
                .set({
              'sellerName': _userInfo.get('name'),
              'sellerImg': _userInfo.get('imgUrl'),
              'sellerUid': _currentUser.uid,
            });
            print("Product Uploaded");
            Navigator.of(context).pop();
          }).catchError((error) => print("Failed to upload product: $error"));
        }
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.NO_HEADER,
          headerAnimationLoop: true,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Alert',
          desc: 'Please add the product images',
          buttonsTextStyle: const TextStyle(color: Colors.white),
          btnOkColor: const Color(0xff096f77),
          showCloseIcon: false,
          btnOkOnPress: () {},
        ).show();
      }
    }
  }
}
