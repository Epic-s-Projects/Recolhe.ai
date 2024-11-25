import 'package:flutter/material.dart';
import 'home_adm_page.dart'; // Certifique-se de que o arquivo está na mesma pasta ou ajuste o caminho

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home ADM',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeAdmPage(),
    );
  }
}

