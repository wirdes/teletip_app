import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:teletip_app/app_colors.dart';
import 'package:teletip_app/config.dart';
import 'package:teletip_app/pages/doctorPage/doctor_page.dart';
import 'package:teletip_app/pages/messages/message_page.dart';
import 'package:teletip_app/pages/profilePage/profile_page.dart';

import 'package:teletip_app/services/api_service.dart';
import 'package:teletip_app/services/shared_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    DoctorPage(),
    MessagePage(),
    Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.flip,
        backgroundColor: const Color(0xff1F3C53),
        color: Colors.white,
        items: const [
          TabItem(icon: Icons.home, title: "Anasayfa"),
          TabItem(icon: Icons.mail, title: "Mesajlar"),
          TabItem(icon: Icons.person, title: "Kampanya"),
        ],
        initialActiveIndex: _selectedIndex != 5 ? _selectedIndex : 4,
        onTap: (int i) => _onItemTapped(i),
      ),
    );
  }
}
