import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/main.dart';
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
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16.0),
                  Container(

                    padding: EdgeInsets.only(left: 8),
                    child: Text('Thực phẩm chức năng',style: TextStyle(fontSize: 18,),),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),
                  Divider(),
                  SizedBox(height: 16.0,),
                  Container(
                    padding: EdgeInsets.only(left: 8),
                    child: Text('Thực phẩm chức năng',style: TextStyle(fontSize: 18,),),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                        SizedBox(height: 8.0,),
                        _buildCategoryItem('Dành cho trẻ em', 'assets/pharmacity.jpg'),
                      ],
                    ),
                  ),
                ],
              ),
            )

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
          child: Image.asset(image,height: 100,width: 100,fit: BoxFit.cover,),
        ),
        SizedBox(height: 4,),
        Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}