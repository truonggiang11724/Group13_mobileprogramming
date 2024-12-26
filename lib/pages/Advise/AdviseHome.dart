import 'package:flutter/material.dart';
import 'package:group13_mobileprograming/main.dart';
import 'package:group13_mobileprograming/pages/Home/Home.dart';
import 'package:group13_mobileprograming/pages/Category/Category.dart';
import 'package:group13_mobileprograming/pages/Cart/CartHome.dart';
import 'package:group13_mobileprograming/pages/Personal/PersonalHome.dart';

class Advisehome extends StatefulWidget {
  @override
  _AdvisehomeState createState() => _AdvisehomeState();
}

class _AdvisehomeState extends State<Advisehome> {

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

  final List<String> messages = [
    'Xin chào, cảm ơn bạn đã liên hệ với nhà thuốc. Chúng tôi có thể giúp gì cho bạn hôm nay?' // Tin nhắn mặc định từ nhà thuốc
  ];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages.add(_controller.text.trim());
      });
      _controller.clear();
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
      body: Column(
        children: [

          // Danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              reverse: true, // Để tin nhắn mới nhất hiển thị ở dưới cùng
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isSentByUser = index % 2 == 0; // Mẫu phân biệt tin nhắn gửi đi
                return Align(
                  alignment:
                  isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isSentByUser ? Colors.green[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[messages.length - 1 - index],
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              },
            ),
          ),
          // Ô nhập liệu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
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
        currentIndex: 2,
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
