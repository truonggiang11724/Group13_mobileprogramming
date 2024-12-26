import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/pages/Category/Category.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Cart/CartHome.dart';
import 'package:group13_mobileprograming/pages/Category/MedicineDetailPage.dart';
import 'package:group13_mobileprograming/pages/Home/ListProduct.dart';
import 'package:group13_mobileprograming/pages/Personal/PersonalHome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group13_mobileprograming/firebase_options.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<String> bannerImages = [
    'assets/banner3.jpg',
    'assets/banner2.jpg',
    'assets/banner1.jpg',
  ];

  // Hàm lấy danh sách sản phẩm có promote != 0 từ Firestore
  Future<List<Map<String, dynamic>>> getPromotedProducts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Truy vấn các sản phẩm có promote != 0
    QuerySnapshot querySnapshot = await firestore
        .collection('medicines') // Tên collection chứa sản phẩm
        .where('promote', isNotEqualTo: 0)
        .get();

    List<Map<String, dynamic>> products = [];
    for (var doc in querySnapshot.docs) {
      products.add(doc.data() as Map<String, dynamic>);

    }
    return products;
  }

  Future<List<Map<String, dynamic>>> get5Productslatest() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // Truy vấn các sản phẩm có promote != 0
    QuerySnapshot querySnapshot = await firestore
        .collection('medicines') // Tên collection chứa sản phẩm
        .orderBy('created_at',descending: true).limit(5)
        .get();

    List<Map<String, dynamic>> products = [];
    for (var doc in querySnapshot.docs) {
      products.add(doc.data() as Map<String, dynamic>);
    }
    return products;
  }

  // Xử lý navigator
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


  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phần tìm kiếm
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Tên thuốc, triệu chứng, vitamin và t...',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Phần lưới các tính năng
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                children: <Widget>[
                  buildFeatureCard(Icons.phone_android, 'Tư vấn thuốc'),
                  buildFeatureCard(Icons.local_pharmacy, 'Đặt thuốc theo đơn'),
                  buildFeatureCard(Icons.support_agent, 'Liên hệ dược sĩ'),
                  buildFeatureCard(Icons.favorite, 'Kiểm tra sức khỏe'),
                  buildFeatureCard(Icons.discount, 'Mã giảm giá'),
                  buildFeatureCard(Icons.store, 'Hệ thống nhà thuốc'),
                ],
              ),
            ),

            // Phần banner quảng cáo carousel với PageView
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    height: 160.0,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: bannerImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(bannerImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(bannerImages.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.blue
                              : Colors.grey.shade400,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            // Phần sản phẩm giảm giá
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: getPromotedProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có sản phẩm khuyến mãi.'));
                  } else {
                    List<Map<String, dynamic>> products = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề phần sản phẩm khuyến mãi
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Sản phẩm khuyến mãi',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // ListView.builder với thanh trượt ngang
                        Container(
                          height: 250, // Chiều cao của ListView ngang
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              var product = products[index];
                              return ProductItem(product: product);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: get5Productslatest(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Không có sản phẩm.'));
                  } else {
                    List<Map<String, dynamic>> products = snapshot.data!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tiêu đề phần sản phẩm mới
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            'Sản phẩm mới',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        // ListView.builder với thanh trượt ngang
                        Container(
                          height: 250, // Chiều cao của ListView ngang
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              var product = products[index];
                              return ProductItem(product: product);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Container(
              height: 720,
              child: Column(

                children: [
                  Text(
                    'Góc sức khỏe',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ChoiceChip(label: Text('Bài viết nổi bật'), selected: true),
                        SizedBox(width: 8.0),
                        ChoiceChip(label: Text('Sống khỏe'), selected: false),
                        SizedBox(width: 8.0),
                        ChoiceChip(label: Text('Tin tức'), selected: false),
                        SizedBox(width: 8.0),
                        ChoiceChip(label: Text('Mẹ và bé'), selected: false),
                        SizedBox(width: 8.0),
                        ChoiceChip(label: Text('Dinh dưỡng'), selected: false),
                        SizedBox(width: 8.0),
                        ChoiceChip(label: Text('Làm đẹp'), selected: false),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Image.asset('assets/news1.jpg'), // Thêm ảnh banner vào assets
                  SizedBox(height: 8.0),
                  Text(
                    'Tổ chức Lễ phát động Chiến dịch truyền thông phòng, chống dịch COVID-19 trong tình hình mới với chủ đề “Vì một Việt Nam vững vàng, khỏe mạnh” ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Đây là nội dung của Kế hoạch số 180/KH-UBND ngày 16/9 của UBND tỉnh...',
                  ),
                  Divider(),
                  // Danh sách bài viết tin tức
                  NewsItem(
                    title: 'Cục Y tế dự phòng (Bộ Y tế) vừa có công văn đề nghị các địa phương khẩn trương xây dựng kế hoạch và tổ chức ngay chiến dịch tiêm vaccine phòng sởi.',
                    date: 'Để tiếp tục nâng cao hiệu quả chiến dịch tiêm vaccine phòng sởi...',
                    imageUrl: 'assets/news2.jpg', // Thêm hình ảnh vào assets
                  ),
                  Divider(),
                  NewsItem(
                    title: 'Bảo Hiểm Y Tế - Vì Sức Khỏe, Hạnh Phúc Của Mọi Gia Đình',
                    date: 'Bảo hiểm y tế (BHYT) là chính sách quan trọng trong hệ thống an sinh xã hội...',
                    imageUrl: 'assets/news3.jpg', // Thêm hình ảnh vào assets
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Thanh điều hướng dưới
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  // Phương thức xây dựng một ô tính năng
  Widget buildFeatureCard(IconData icon, String title, [bool isNew = false]) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blue.shade50,
              child: Icon(icon, color: Colors.blue, size: 30),
            ),
            if (isNew)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "NEW",
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 4),
        Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

// Tạo phương thức menu tin tức
class NewsItem extends StatelessWidget {
  final String title;
  final String date;
  final String imageUrl;

  NewsItem({required this.title, required this.date, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(

        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(

        children: [
          Image.asset(
            imageUrl,
            width: 80,
            height: 80,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'Tin tức',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                SizedBox(height: 4.0),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.0),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


