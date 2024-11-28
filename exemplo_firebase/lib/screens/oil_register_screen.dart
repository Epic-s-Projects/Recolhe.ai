import 'package:exemplo_firebase/controllers/oil_register_controller.dart';
import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:exemplo_firebase/screens/intern_screen_view.dart';
import 'package:flutter/material.dart';

import '../controllers/user_data.dart';

class OilRegisterScreen extends StatefulWidget {
  const OilRegisterScreen({super.key});

  @override
  _OilRegisterScreenState createState() => _OilRegisterScreenState();
}

class _OilRegisterScreenState extends State<OilRegisterScreen> {
  final OilRegisterControllers _controller = OilRegisterControllers();
  final user = UserSession();


  Widget _buildLoadingView() {
    return Center(
      child: Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF795548)), // Brown progress indicator
            ),
            SizedBox(height: 16),
            Text(
              'Confirmando quantidade de óleo...',
              style: TextStyle(color: Color(0xFF795548), fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Botão de voltar
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.green,
                size: screenWidth * 0.1,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Avatar do usuário
          Positioned(
            top: screenHeight * 0.05,
            right: screenWidth * 0.05,
            child: CircleAvatar(
              radius: screenWidth * 0.1,
              backgroundColor: Colors.white,
              child: user.imagem!.isNotEmpty
                  ? ClipOval(
                child: Image.network(
                  user.imagem!,
                  fit: BoxFit.cover,
                  width: screenWidth * 0.2,
                  height: screenWidth * 0.2,
                ),
              )
                  : Icon(
                Icons.person,
                size: screenWidth * 0.1,
                color: const Color(0xFF7B2CBF),
              ),
            ),
          ),
          // Conteúdo central
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Óleo usado",
                    style: TextStyle(
                      fontSize: screenWidth * 0.08,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Image.asset(
                    'assets/icongalao2.png',
                    width: screenWidth * 0.6,
                    height: screenHeight * 0.25,
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Óleo usado (ml):",
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.decrement();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(screenWidth * 0.02),
                            ),
                          ),
                          child: Icon(
                            Icons.remove,
                            size: screenWidth * 0.07,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.02),
                        ),
                        child: Text(
                          '${_controller.getOilAmount()}',
                          style: TextStyle(
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.increment();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(screenWidth * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.green.shade700,
                            borderRadius: BorderRadius.horizontal(
                              right: Radius.circular(screenWidth * 0.02),
                            ),
                          ),
                          child: Icon(
                            Icons.add,
                            size: screenWidth * 0.07,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.2),
                  ElevatedButton.icon(
                    onPressed: () async {
                      const String tipo = "Óleo usado";
                      const String status = "Em processo";

                      await _controller.addRecycledData(tipo, status, context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        )
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                    label: Text(
                      "Adicionar Item",
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.6),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1,
                        vertical: screenHeight * 0.02,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
