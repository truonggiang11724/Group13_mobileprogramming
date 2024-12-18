import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/pages/Category/Category.dart';
import 'package:group13_mobileprograming/pages/Advise/AdviseHome.dart';
import 'package:group13_mobileprograming/pages/Cart/CartHome.dart';
import 'package:group13_mobileprograming/pages/Personal/PersonalHome.dart';

void main() {
  runApp(PharmacityApp());
}

class PharmacityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pharmacity App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  final List<String> bannerImages = [
    'assets/pharmacity.jpg',
    'assets/pharmacity.jpg',
    'assets/pharmacity.jpg',
  ];

  final List<Map<String, dynamic>> discountProducts = [
    {
      "image": "assets/pharmacity.jpg",
      "name": "Thuốc A",
      "oldPrice": 50000,
      "newPrice": 40000,
      "discount": 20,
    },
    {
      "image": "assets/pharmacity.jpg",
      "name": "Thuốc B",
      "oldPrice": 100000,
      "newPrice": 80000,
      "discount": 20,
    },
    {
      "image": "assets/pharmacity.jpg",
      "name": "Thuốc C",
      "oldPrice": 70000,
      "newPrice": 56000,
      "discount": 20,
    },
  ];
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

              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(

                    child: Text(
                      "Sản phẩm đang giảm giá",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightGreen,
                    padding: EdgeInsets.only(top: 10,left: 10),
                  ),

                  SizedBox(height: 8,child: Container(color: Colors.lightGreen,),),
                  Container(
                    color: Colors.lightGreen,
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discountProducts.length,
                      itemBuilder: (context, index) {
                        final product = discountProducts[index];
                        return Container(
                          width: 200,

                          margin: EdgeInsets.only(right: 8,bottom: 8,left: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(product['image'], height: 80, fit: BoxFit.cover),
                              SizedBox(height: 8),
                              Text(
                                product['name'],
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${product['oldPrice']}đ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${product['newPrice']}đ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(

                                "-${product['discount']}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),

                            ],

                          ),

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
            ),
            Padding(

              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(

                    child: Text(
                      "Bán chạy nhất ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightGreen,
                    padding: EdgeInsets.only(top: 10,left: 10),
                  ),

                  SizedBox(height: 8,child: Container(color: Colors.lightGreen,),),
                  Container(
                    color: Colors.lightGreen,
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discountProducts.length,
                      itemBuilder: (context, index) {
                        final product = discountProducts[index];
                        return Container(
                          width: 200,

                          margin: EdgeInsets.only(right: 8,bottom: 8,left: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(product['image'], height: 80, fit: BoxFit.cover),
                              SizedBox(height: 8),
                              Text(
                                product['name'],
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${product['oldPrice']}đ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${product['newPrice']}đ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(

                                "-${product['discount']}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),

                            ],

                          ),

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(

              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(

                    child: Text(
                      "Sản phầm mới",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightGreen,
                    padding: EdgeInsets.only(top: 10,left: 10),
                  ),

                  SizedBox(height: 8,child: Container(color: Colors.lightGreen,),),
                  Container(
                    color: Colors.lightGreen,
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discountProducts.length,
                      itemBuilder: (context, index) {
                        final product = discountProducts[index];
                        return Container(
                          width: 200,

                          margin: EdgeInsets.only(right: 8,bottom: 8,left: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(product['image'], height: 80, fit: BoxFit.cover),
                              SizedBox(height: 8),
                              Text(
                                product['name'],
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${product['oldPrice']}đ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${product['newPrice']}đ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(

                                "-${product['discount']}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),

                            ],

                          ),

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(

              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(

                    child: Text(
                      "Thương hiệu nổi bật",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                    ),
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightGreen,
                    padding: EdgeInsets.only(top: 10,left: 10),
                  ),

                  SizedBox(height: 8,child: Container(color: Colors.lightGreen,),),
                  Container(
                    color: Colors.lightGreen,
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: discountProducts.length,
                      itemBuilder: (context, index) {
                        final product = discountProducts[index];
                        return Container(
                          width: 200,

                          margin: EdgeInsets.only(right: 8,bottom: 8,left: 8),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.network(product['image'], height: 80, fit: BoxFit.cover),
                              SizedBox(height: 8),
                              Text(
                                product['name'],
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${product['oldPrice']}đ",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                "${product['newPrice']}đ",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(

                                "-${product['discount']}%",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,

                                ),
                              ),

                            ],

                          ),

                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
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
                  Image.asset('assets/pharmacity.jpg'), // Thêm ảnh banner vào assets
                  SizedBox(height: 8.0),
                  Text(
                    'Dược sĩ Pharmacycity tham gia tập huấn tư vấn điều trị Rối loạn cương dương và Rối loạn lo âu',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    'Ngày 17/10, hơn 150 dược sĩ Nhà Thuốc Pharmacycity đã có mặt tại Hội thảo khoa học...',
                  ),
                  Divider(),
                  // Danh sách bài viết tin tức
                  NewsItem(
                    title: 'Pharmacycity đồng hành cùng bệnh viện Đại Học Y Dược mang kiến thức...',
                    date: 'Sáng 19/10, nhằm hưởng ứng Ngày Đột quỵ...',
                    imageUrl: 'assets/pharmacity.jpg', // Thêm hình ảnh vào assets
                  ),
                  Divider(),
                  NewsItem(
                    title: 'Pharmacycity hỗ trợ sức khỏe người dân ở vùng bị ảnh hưởng sau bão lũ',
                    date: 'Sáng 17/9, Tổng giám đốc Công ty Cổ phần Dược phẩm Pharmacycity đã để...',
                    imageUrl: 'assets/pharmacity.jpg', // Thêm hình ảnh vào assets
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


