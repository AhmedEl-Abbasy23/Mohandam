import 'package:flutter/material.dart';
import 'package:handmade_store/shared/strings_manager.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
    required this.imgUrl,
    required this.title,
    required this.description,
    required this.price,
  }) : super(key: key);

  final String imgUrl;
  final String title;
  final String description;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Texts
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 5.0, vertical: 2.0),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2.0),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  '$price ${AppStrings.egp.tr()}',
                  style: const TextStyle(
                    color: Color(0xff096f77),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
