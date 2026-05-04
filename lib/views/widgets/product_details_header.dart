import 'package:flutter/material.dart';
import 'package:onus2_flutter/core/constants/colors.dart';

class ProductDetailsHeader extends StatelessWidget {
  const ProductDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.textMain),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
