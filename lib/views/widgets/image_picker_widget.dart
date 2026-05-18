import 'package:flutter/material.dart';
import 'package:onus2_flutter/views/add_product_controller.dart';
import 'package:provider/provider.dart';


class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AddProductController>();
    return GestureDetector(
      onTap: controller.pickImage,
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey[300]!),
          image: controller.image != null
              ? DecorationImage(
                  image: FileImage(controller.image!),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: controller.image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 50,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "اضغط لإضافة صورة المنتج",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
