import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  PageController _pageController = PageController(initialPage: 0);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Align(
          //alignment: Alignment.topCenter,
          child: Text(
            "Message",
            style: TextStyle(color: Colors.white,fontFamily: 'RobotoCondensed'),
          ),
        ),
        backgroundColor: Color(0xFF9294cc),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTabButton('Trò chuyện', 0),
                _buildTabButton('Thông báo', 1),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                _buildChatPage(),
                _buildNotificationPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 40.0), // Adjusted to fit better
        margin: EdgeInsets.symmetric(horizontal: 5.0), // Adjusted to fit better
        decoration: BoxDecoration(
          color: _selectedIndex == index
              ? Color(0xFF6667AB)
              : Color(0xFF9294cc),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'RobotoCondensed',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildChatPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/support_agent.png',
            height: 150.0, // Adjusted to fit better
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Xem cuộc trò chuyện của bạn với nhân viên hỗ trợ tại đây!',
              style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Bạn cũng có thể yêu cầu hỗ trợ thông qua Trung tâm trợ giúp.',
              style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 15.0,
                  fontWeight: FontWeight.normal),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/notication.png',
            height: 150.0, // Adjusted to fit better
            width: 150.0,
          ),
          SizedBox(height: 20.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Xem thông báo tại đây!',
              style: TextStyle(
                  fontFamily: 'RobotoCondensed',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
