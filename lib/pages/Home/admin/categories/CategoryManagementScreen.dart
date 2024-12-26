import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryManagementScreen extends StatefulWidget {
  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _addOrUpdateCategory({String? categoryId}) async {
    if (_formKey.currentState!.validate()) {
      try {
        final collection = FirebaseFirestore.instance.collection('categories');
        final data = {
          'name': _nameController.text,
          'description': _descriptionController.text,
          'created_at': FieldValue.serverTimestamp(),
        };
        if (categoryId == null) {
          // Add new category
          await collection.add(data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Loại thuốc đã được thêm.')),
          );
        } else {
          // Update existing category
          await collection.doc(categoryId).update(data);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Loại thuốc đã được cập nhật.')),
          );
        }
        _nameController.clear();
        _descriptionController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _deleteCategory(String categoryId) async {
    try {
      await FirebaseFirestore.instance.collection('categories').doc(categoryId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Loại thuốc đã được xóa.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý loại thuốc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Tên loại thuốc'),
                    validator: (value) =>
                    value!.isEmpty ? 'Vui lòng nhập tên loại thuốc' : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Mô tả (không bắt buộc)'),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _addOrUpdateCategory(),
                    child: Text('Thêm loại thuốc'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('Chưa có loại thuốc nào.'));
                  }
                  final categories = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return ListTile(
                        title: Text(category['name']),
                        subtitle: Text(category['description'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _nameController.text = category['name'];
                                _descriptionController.text =
                                    category['description'] ?? '';
                                _addOrUpdateCategory(categoryId: category.id);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteCategory(category.id),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
