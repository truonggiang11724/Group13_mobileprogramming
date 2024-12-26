import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/main.dart';
import 'package:group13_mobileprograming/pages/Category/MedicineDetailPage.dart';
import 'package:group13_mobileprograming/pages/Home/Home.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Cart/CartHome.dart';
import 'package:group13_mobileprograming/pages/Personal/PersonalHome.dart';

class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Category()),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Advisehome()),
      );
    }
    if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Carthome()),
      );
    }
    if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Personalhome()),
      );
    }
  }

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
      final categorySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      final categories = {
        for (var doc in categorySnapshot.docs) doc.id: doc['name'] as String
      };

      // Lấy danh sách products
      final productSnapshot =
          await FirebaseFirestore.instance.collection('medicines').get();
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
          'image_url': data['image_url'],
          'description': data['description'],
          'quantity': data['quantity'],
          'promote': data['promote'],
          'total_price': data['price']*(1-data['promote']*0.01),
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
        elevation: 0,
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Icon(Icons.account_circle, color: Colors.white),
            SizedBox(width: 5),
            Text("Xin chào ",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: _categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Danh mục sản phẩm',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            ..._categories.keys.map((categoryId) {
              final categoryName = _categories[categoryId]!;
              final products = _productsByCategory[categoryId] ?? [];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      categoryName,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  products.isEmpty
                      ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Không có sản phẩm.'),
                  )
                      : Container(
                    height: 280, // Chiều cao của ListView ngang
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Container(
                          width: 150, // Chiều rộng của mỗi sản phẩm
                          margin: const EdgeInsets.only(right: 8.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                product['image_url'],
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                product['name'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text('Giá: ${product['price']}đ'),
                              if(product['promote']!=0) Text('Giá km: ${product['total_price']}đ'),
                              SizedBox(height: 4.0),
                              ElevatedButton(
                                onPressed: () {
                                  // Điều hướng đến trang chi tiết sản phẩm
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailPage(product: product),
                                    ),
                                  );
                                },
                                child: Text('Xem chi tiết'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Danh mục',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset_mic),
            label: 'Tư vấn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
        currentIndex: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  // Phương thức tạo itemcategory
  Widget _buildCategoryItem(String title, String image) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          child: Image.asset(
            image,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          height: 4,
        ),
        Text(title,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
