import 'package:exemplo_firebase/controllers/oil_register_controller.dart';
import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:flutter/material.dart';

class OilRegisterScreen extends StatefulWidget {
  const OilRegisterScreen({super.key});

  @override
  _OilRegisterScreenState createState() => _OilRegisterScreenState();
}

class _OilRegisterScreenState extends State<OilRegisterScreen> {
  final OilRegisterControllers _controller = OilRegisterControllers();

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HistoricScreenView(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: screenWidth * 0.06,
                    ),
                    label: Text(
                      "Avançar",
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
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(0.8),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: screenWidth * 0.09,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: '',
            ),
          ],
          onTap: (index) {
            switch (index) {
              case 0:
                print("Home pressionado");
                break;
              case 1:
                print("Usuário pressionado");
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoricScreenView()),
                );
                break;
              case 3:
                print("Recompensa pressionado");
                break;
            }
          },
        ),
      ),
    );
  }
}
