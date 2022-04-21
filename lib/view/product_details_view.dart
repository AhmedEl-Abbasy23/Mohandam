import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_store/view/reusable_widgets/custom_button.dart';
import 'package:handmade_store/view/reusable_widgets/custom_text.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({
    Key? key,
    required this.productId,
    required this.productImage,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
  }) : super(key: key);
  final String productId;
  final String productImage;
  final String productTitle;
  final String productDescription;
  final String productPrice;

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Product section
            Column(
              children: [
                // images & buttons
                Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    // image
                    Hero(
                      tag: widget.productId,
                      child: SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: Image.network(
                          widget.productImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // back icon
                    Positioned(
                      top: 45.0,
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                          size: 25.0,
                        ),
                      ),
                    ),
                    // favorite icon
                    Positioned(
                      top: 45.0,
                      right: 5.0,
                      child: IconButton(
                        onPressed: () {
                          // Navigator.of(context).pop();
                        },
                        icon: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: SvgPicture.asset(
                              'assets/icons/favorites_ic2.svg'),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 510.0,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.fromSwatch()
                            .copyWith(secondary: const Color(0xff096f77))),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      children: [
                        CustomText(
                          text: widget.productTitle,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const RoundedShapeInfo(
                              title: 'Size',
                              content: CustomText(
                                text: 'XXL - X - M',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                alignment: Alignment.center,
                              ),
                            ),
                            RoundedShapeInfo(
                              title: 'Color',
                              content: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 3.0),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 3.0),
                                  Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: CustomText(
                            text: 'Details',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomText(
                          text: widget.productDescription,
                          fontSize: 14.0,
                          height: 2.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Price & Buy section
            Material(
              elevation: 10,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 20.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomText(
                          text: 'PRICE',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        CustomText(
                          text: '\$${widget.productPrice}',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff096f77),
                        ),
                      ],
                    ),
                    // add button
                    SizedBox(
                      height: 60.0,
                      width: 146.0,
                      child: CustomButton('ADD', () {
                        /*controller.addProduct(
                      // CartModel(
                      //   name: _productModel.name,
                      //   image: _productModel.image,
                      //   price: _productModel.price,
                      //   productId: _productModel.productId,
                      // ),
                    );*/
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedShapeInfo extends StatelessWidget {
  final String title;
  final Widget content;

  const RoundedShapeInfo({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 150,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: title,
              fontSize: 14,
              alignment: Alignment.center,
            ),
            content,
          ],
        ),
      ),
    );
  }
}
