import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductByCategoryPage extends StatefulWidget {
  @override
  _ProductByCategoryPageState createState() => _ProductByCategoryPageState();
}

class _ProductByCategoryPageState extends State<ProductByCategoryPage> {
  Map<String, List<Map<String, dynamic>>> _productsByCategory = {};
  Map<String, String> _categories = {}; // Lưu danh mục với id -> name

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Lấy danh sách categories
      final categorySnapshot = await FirebaseFirestore.instance.collection(
          'categories').get();
      final categories = {
        for (var doc in categorySnapshot.docs) doc.id: doc['name'] as String
      };

      // Lấy danh sách products
      final productSnapshot = await FirebaseFirestore.instance.collection(
          'medicines').get();
      Map<String, List<Map<String, dynamic>>> groupedProducts = {};

      for (var doc in productSnapshot.docs) {
        final data = doc.data();
        final categoryId = data['category_id'] as String;

        // Kiểm tra xem category có tồn tại
        if (!categories.containsKey(categoryId)) continue;

        final product = {
          'id': doc.id,
          'name': data['name'],
          'price': data['price'],
        };

        if (groupedProducts[categoryId] == null) {
          groupedProducts[categoryId] = [];
        }
        groupedProducts[categoryId]!.add(product);
      }

      setState(() {
        _categories = categories;
        _productsByCategory = groupedProducts;
      });
    } catch (error) {
      print('Lỗi khi lấy dữ liệu: $error');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sản phẩm theo danh mục'),
      ),
      body: _categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _categories.keys.length,
        itemBuilder: (context, index) {
          final categoryId = _categories.keys.elementAt(index);
          final categoryName = _categories[categoryId]!;
          final products = _productsByCategory[categoryId] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  categoryName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              products.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Không có sản phẩm.'),
              )
                  : GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true, // Giới hạn chiều cao để phù hợp với ListView
                physics: NeverScrollableScrollPhysics(), // Không cuộn bên trong GridView
                padding: const EdgeInsets.all(8.0),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                children: products.map((product) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text('Giá: ${product['price']}'),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}
