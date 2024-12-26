import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/main.dart';
import 'package:group13_mobileprograming/pages/Cart/Order/OrderHistory.dart';
import 'package:group13_mobileprograming/pages/Category/Category.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Cart/CartHome.dart';
import 'package:group13_mobileprograming/pages/Home/Home.dart';
import 'package:group13_mobileprograming/pages/Home/admin/AdminHome.dart';
import 'package:group13_mobileprograming/pages/Personal/AccountSetting/EditProfile.dart';
import 'package:group13_mobileprograming/pages/Personal/Support/SupportPage.dart';

import '../Auth/LoginScreen.dart';

class Personalhome extends StatefulWidget {
  @override
  _PersonalhomeState createState() => _PersonalhomeState();
}

class _PersonalhomeState extends State<Personalhome> {

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

  late Future<DocumentSnapshot?> _userData;


  @override
  void initState() {
    super.initState();
    // Gọi phương thức async để truy vấn dữ liệu
    _userData = _fetchUserData();
    _loadUserRole();
  }
  final user = FirebaseAuth.instance.currentUser;

  Future<DocumentSnapshot?> _fetchUserData() async {
    try {
      // Truy vấn Firestore với điều kiện `where`, chỉ lấy 1 bản ghi
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: user?.uid)
          .limit(1)  // Giới hạn chỉ lấy 1 document
          .get();

      // Nếu có document, trả về document đầu tiên, nếu không, trả về null
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs[0];
      } else {
        return null;
      }
    } catch (e) {
      // Nếu có lỗi trong quá trình truy vấn
      print('Error fetching user data: $e');
      return null;
    }
  }
  String? role;
  Future<String?> getRoleFromUser(String userId) async {
    try {
      // Truy vấn collection 'users' với điều kiện where 'user_id' == userId
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: userId)  // Lọc theo user_id
          .get();

      // Kiểm tra xem có tài liệu nào trả về không
      if (snapshot.docs.isNotEmpty) {
        // Lấy giá trị của trường 'role' từ tài liệu đầu tiên trong kết quả
        return snapshot.docs[0]['role'];
      } else {
        return null;  // Nếu không tìm thấy tài liệu nào
      }
    } catch (e) {
      print('Error fetching role: $e');
      return null;  // Trả về null nếu có lỗi
    }
  }

  // Hàm lấy role của người dùng
  Future<void> _loadUserRole() async {
    String? userRole = await getRoleFromUser(user!.uid);
    setState(() {
      role = userRole;
    });
  }


  @override
  Widget build(BuildContext context) {
    final userid = user?.uid;
    getRoleFromUser(userid!).then((role) {
      if (role == 'admin') {
        // Người dùng có quyền admin
        final user_role="admin";
      }
      if (role == 'staff'){
        final user_role="staff";
      }

    });

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
          // Phần hiển thị thông tin tài khoản
          FutureBuilder<DocumentSnapshot?>(
            future: _userData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Something went wrong!'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                // Nếu không có document, hiển thị thông báo không có thông tin
                return Container(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EditProfilePage()),
                      );
                    },
                    child: Text('Update Profile'),
                  ),
                );
              } else {
                // Truy xuất dữ liệu từ document
                var userData = snapshot.data!;
                var name = userData['Name'] ?? 'No name';
                var phone = userData['phone'] ?? 'No phone';
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.teal,
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Số điện thoại: ${phone}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Email: ${user?.email}',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),


          SizedBox(height: 20),

          // Các chức năng quản lý
          Text(
            'Quản lý',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            leading: Icon(Icons.receipt_long, color: Colors.teal),
            title: Text('Đơn thuốc của tôi'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => Carthome()),
              );
            },
          ),
          Divider(),

          ListTile(
            leading: Icon(Icons.shopping_bag, color: Colors.teal),
            title: Text('Đơn hàng đã mua'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => OrderHistoryPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.teal),
            title: Text('Cài đặt tài khoản'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help_outline, color: Colors.teal),
            title: Text('Hỗ trợ'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SupportPage()),
              );
            },
          ),
          if(role=='admin')
            ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.teal),
              title: Text('Chức năng admin'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Adminhome()),
                );
              },
            ),
          if(role=='admin'||role=='staff')
            ListTile(
              leading: Icon(Icons.shopping_bag, color: Colors.teal),
              title: Text('Quản lý đơn hàng'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                );
              },
            ),
          SizedBox(height: 20),

          // Nút đăng xuất
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Đăng xuất',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
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
        currentIndex: 4,
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
          child: Image.asset(image,height: 100,width: 100,fit: BoxFit.cover,),
        ),
        SizedBox(height: 4,),
        Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}