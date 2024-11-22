import 'package:flutter/material.dart';
import 'package:testpaginas/Controller/TelaQuantidadeController.dart';// Importa o Controller
import 'package:testpaginas/View/TelaHistoricoView.dart';

class TelaQuantidadePage extends StatefulWidget {
  @override
  _TelaQuantidadePageState createState() => _TelaQuantidadePageState();
}

class _TelaQuantidadePageState extends State<TelaQuantidadePage> {
  // Instância do Controller
  TelaQuantidadeController _controller = TelaQuantidadeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.green, size: 50),
              onPressed: () {
                Navigator.pop(context); // Volta para a página anterior
              },
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'),
              radius: 35,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Óleo usado",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/icongalao2.png',
                  width: 450,
                  height: 200,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Óleo usado (ml):",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.decrement(); // Chama o método de decremento no Controller
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                        ),
                        child: Icon(Icons.remove, size: 30, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_controller.getOilAmount()}', // Exibe a quantidade de óleo usando o Controller
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.increment(); // Chama o método de incremento no Controller
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                        ),
                        child: Icon(Icons.add, size: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 130),
                ElevatedButton.icon(
                  onPressed: () {
                    print("Avançar pressionado com ${_controller.getOilAmount()} ml de óleo usado.");
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    "Avançar",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 25),
                  ),
                ),
              ],
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
          iconSize: 45,
          items: [
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
                print("Histórico pressionado");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TelaHistoricoView()),
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
