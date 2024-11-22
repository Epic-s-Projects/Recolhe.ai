import 'package:exemplo_firebase/screens/login_screen_view.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Aguarde 3 segundos e navegue para a página HomePage
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(), // Navega para a HomePage
        ),);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5E6CC), Color(0xFFF1D9B4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Centralizar a primeira imagem (aumentada)
            Center(
              child: Image.asset(
                'assets/recycle_icon.png', // Substitua pelo caminho do ícone no seu projeto
                width: 300, // Tamanho aumentado
                height: 300,
              ),
            ),
            // Posicionar a segunda imagem um pouco acima da base
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                ), // Ajusta a posição vertical
                child: Image.asset(
                  'assets/folhas.png', //
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}