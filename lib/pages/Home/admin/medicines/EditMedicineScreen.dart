import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMedicineScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> medicineData;

  EditMedicineScreen({required this.docId, required this.medicineData});

  @override
  _EditMedicineScreenState createState() => _EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late TextEditingController _descriptionController;
  late TextEditingController _imagepathController;
  late TextEditingController _promoteController;
  String? _selectedCategoryId;
  List<QueryDocumentSnapshot> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _nameController = TextEditingController(text: widget.medicineData['name']);
    _priceController =
        TextEditingController(text: widget.medicineData['price'].toString());
    _quantityController =
        TextEditingController(text: widget.medicineData['quantity'].toString());
    _descriptionController =
        TextEditingController(text: widget.medicineData['description']);
    _imagepathController =
        TextEditingController(text: widget.medicineData['image_url']);
    _promoteController =
        TextEditingController(text: widget.medicineData['promote'].toString());
  }

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

  Future<void> _updateMedicine() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('medicines')
            .doc(widget.docId)
            .update({
          'name': _nameController.text,
          'price': double.parse(_priceController.text),
          'quantity': int.parse(_quantityController.text),
          'description': _descriptionController.text,
          'image_url': _imagepathController.text,
          'category_id': _selectedCategoryId,
          'promote': int.parse(_promoteController.text),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Thuốc đã được cập nhật thành công!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chỉnh sửa thuốc')),
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
                onPressed: _updateMedicine,
                child: Text('Cập nhật thuốc'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
