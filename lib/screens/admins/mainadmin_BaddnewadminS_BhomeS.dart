import 'package:buy_it/screens/admins/admin_home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'create_admin.dart';


class Admin_Main_Add_Home extends StatefulWidget {
  static String id = 'Admin_Main_Add_Home';
  
  @override
  _Auth_ScreenState createState() => _Auth_ScreenState();

}

class _Auth_ScreenState extends State<Admin_Main_Add_Home> {

  TabController _controller;

  PageController _pageController = new PageController();
  int pageIndex = 0;
  //ontap for pageview
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }
  void onTap(int pageindex) {
    _pageController.animateToPage(pageindex,
        duration: Duration(microseconds: 400), curve: Curves.bounceOut);
  }

  //onpagechenged for pageview
  void onPageChanged(int pageindex) {
    setState(() {
      this.pageIndex = pageindex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.redAccent,
      body: PageView(

        children: <Widget>[
          Admin_Home_Screen(),
          Create_Admin(),


        ],
        controller: _pageController,
        onPageChanged: onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.black,
        activeColor: Colors.white,
        inactiveColor: Colors.blueGrey,
        onTap: onTap,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,size: pageIndex==0?30:20,)),
          BottomNavigationBarItem(icon: Icon(Icons.group_add,size: pageIndex==1?30:20)),

        ],
        currentIndex: pageIndex,
      ),
    );
  }
}
