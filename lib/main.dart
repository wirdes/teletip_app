import 'package:flutter/material.dart';
import 'package:teletip_app/pages/homePage/home_page.dart';
import 'package:teletip_app/pages/loginPage/login_page.dart';
import 'package:teletip_app/pages/messagePage/message_page.dart';
import 'package:teletip_app/pages/registerPage/register_page.dart';

import 'package:teletip_app/services/shared_service.dart';

Widget _default = const LoginPage();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool _result = await SharedService.isLoggedIn();

  if (_result) {
    _default = const HomePage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tele Tıp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => _default,
        '/home': (context) => const HomePage(),
        '/userLogin': (context) => const LoginPage(),
        '/userRegister': (context) => const RegisterPage(),
        '/details': (context) => const MessagePage(),
      },
    );
  }
}
