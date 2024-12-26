import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/main.dart';
import 'package:group13_mobileprograming/pages/Home/Home.dart';
import 'package:group13_mobileprograming/pages/Category/Category.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Personal/PersonalHome.dart';
import 'package:provider/provider.dart';

import 'CartProvider.dart';

class Carthome extends StatefulWidget {
  @override
  _CarthomeState createState() => _CarthomeState();
}

class _CarthomeState extends State<Carthome> {

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(index==0){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    if(index==1){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Category()),
      );
    }
    if(index==2){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Advisehome()),
      );
    }
    if(index==3){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Carthome()),
      );
    }
    if(index==4){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Personalhome()),
      );
    }
  }

  Future<void> addOrder(List<Map<String, dynamic>> cartItems) async {
    try {
      // Lấy user_id từ Firebase Auth
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Tạo bản ghi cho collection 'order'
      DocumentReference orderRef = await FirebaseFirestore.instance.collection('orders').add({
        'user_id': userId,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Thêm sản phẩm vào collection 'order_item'
      for (var item in cartItems) {
        await FirebaseFirestore.instance.collection('order_items').add({
          'order_id': orderRef.id,
          'product_id': item['id'],
          'quantity': item['quantity'],
          'price': item['price']*item['quantity'],
        });
      }

      print('Đơn hàng đã được tạo thành công');
    } catch (e) {
      print('Lỗi khi thêm đơn hàng: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: Row(
          children: [
            Icon(Icons.account_circle, color: Colors.white),
            SizedBox(width: 5),
            Text("Xin chào ", style: TextStyle(color: Colors.white,fontSize: 16)),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Danh sách sản phẩm',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cart.items.length,
                  itemBuilder: (ctx, index) {
                    final item = cart.items.values.toList()[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: ListTile(
                        leading: Image.network('${item.image_url}'),
                        title: Text(
                          item.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng: ${item.price * item.quantity}đ',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle, color: Colors.red),
                                  onPressed: () {
                                    if (item.quantity > 1) {
                                      cart.decreaseQuantity(item.id);
                                    }
                                  },
                                ),
                                Text('${item.quantity}', style: TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: Icon(Icons.add_circle, color: Colors.green),
                                  onPressed: () {
                                    cart.addItem(item.id);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            cart.removeItem(item.id);
                          },
                        ),
                      ),
                    );
                  },
                ),

              ),
              SizedBox(height: 20),
              Divider(color: Colors.teal, thickness: 1),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tổng cộng:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${cart.totalAmount}đ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    List<Map<String, dynamic>> cartItemsMap = cart.cartItemList.map((item) => item.toMap()).toList();
                    addOrder(cartItemsMap);
                    cart.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đặt hàng thành công!'),
                        backgroundColor: Colors.teal,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Đặt hàng',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
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
        currentIndex: 3,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }


}  // Phương thức tạo itemcategory
Widget _buildCategoryItem(String title, String image) {
  return Column(
    children: [
      Container(

        padding: EdgeInsets.all(8),
        child: Image.asset(image,height: 100,width: 100,fit: BoxFit.cover,),
      ),
      SizedBox(height: 4,),
      Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
    ],
  );
}