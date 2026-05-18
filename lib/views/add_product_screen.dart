import 'package:flutter/material.dart';
import 'package:onus2_flutter/views/add_product_controller.dart';
import 'package:provider/provider.dart';
import '../core/constants/colors.dart';

import 'widgets/custom_text_field.dart';
import 'widgets/image_picker_widget.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddProductController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("إضافة منتج جديد", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Consumer<AddProductController>(
          builder: (context, controller, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ImagePickerWidget(),
                    const SizedBox(height: 25),
                    CustomTextField(
                      label: "اسم المنتج",
                      controller: controller.nameController,
                      icon: Icons.shopping_bag_outlined,
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "الفئة",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      items: controller.categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                      onChanged: (val) => controller.selectedCategory = val,
                      validator: (val) => val == null ? 'مطلوب' : null,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "السعر",
                      controller: controller.priceController,
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 15),
                    CustomTextField(
                      label: "الوصف",
                      controller: controller.descriptionController,
                      icon: Icons.description_outlined,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: controller.isLoading 
                          ? null 
                          : () async {
                              final success = await controller.uploadProduct(context);
                              if (success && context.mounted) Navigator.pop(context);
                            },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("حفظ المنتج", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}