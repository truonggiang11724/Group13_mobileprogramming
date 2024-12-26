import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddMedicineScreen extends StatefulWidget {
  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imagepathController = TextEditingController();
  String? _selectedCategoryId;
  final _promoteController = TextEditingController();
  List<QueryDocumentSnapshot> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Lấy danh sách các loại thuốc từ Firestore
  Future<void> _fetchCategories() async {
    try {
      final categorySnapshot = await FirebaseFirestore.instance.collection('categories').get();
      setState(() {
        _categories = categorySnapshot.docs;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }


  Future<void> _saveMedicine() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Save medicine data to Firestore
        await FirebaseFirestore.instance.collection('medicines').add({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'quantity': int.parse(_quantityController.text),
          'description': _descriptionController.text,
          'image_url': _imagepathController.text,
          'category_id': _selectedCategoryId,
          'promote': int.parse(_promoteController.text),
          'created_at': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thuốc đã được thêm thành công!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Có lỗi xảy ra: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thêm thuốc mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Tên thuốc'),
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập tên thuốc' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Giá bán'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập giá bán' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Số lượng tồn kho'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập số lượng' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Mô tả'),
              ),
              TextFormField(
                controller: _imagepathController,
                decoration: InputDecoration(labelText: 'Đường dẫn ảnh'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedCategoryId,
                onChanged: (value) => setState(() => _selectedCategoryId = value),

                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category.id,
                    child: Text(category['name']),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Loại thuốc'),
              ),
              TextFormField(
                controller: _promoteController,
                decoration: InputDecoration(labelText: 'Khuyến mãi (%)'),
                keyboardType: TextInputType.number,
                validator: (value) =>
                value!.isEmpty ? 'Vui lòng nhập khuyến mãi' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveMedicine,
                child: Text('Lưu thuốc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
