import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Tên thuốc, triệu chứng, v...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Text(
            'Góc sức khỏe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ChoiceChip(label: Text('Bài viết nổi bật'), selected: true),
              ChoiceChip(label: Text('Sống khỏe'), selected: false),
              ChoiceChip(label: Text('Tin tức'), selected: false),
              ChoiceChip(label: Text('Mẹ và bé'), selected: false),
            ],
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/event_banner.png'), // Thêm ảnh banner vào assets
          SizedBox(height: 8.0),
          Text(
            'Dược sĩ Pharmacycity tham gia tập huấn tư vấn điều trị Rối loạn cương dương và Rối loạn lo âu',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            'Ngày 17/10, hơn 150 dược sĩ Nhà Thuốc Pharmacycity đã có mặt tại Hội thảo khoa học...',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
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
            icon: Icon(Icons.assignment),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}
