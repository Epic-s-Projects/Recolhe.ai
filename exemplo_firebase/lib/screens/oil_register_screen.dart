import 'package:exemplo_firebase/controllers/oil_register_controller.dart';
import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:exemplo_firebase/screens/intern_screen_view.dart';
import 'package:flutter/material.dart';

import '../controllers/user_data.dart';

class OilRegisterScreen extends StatefulWidget {

  const OilRegisterScreen({super.key,});

  @override
  // ignore: library_private_types_in_public_api
  _OilRegisterScreenState createState() => _OilRegisterScreenState();
}

class _OilRegisterScreenState extends State<OilRegisterScreen> {
  // Instância do Controller
  final OilRegisterControllers _controller = OilRegisterControllers();
  final user = UserSession();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            decoration: const BoxDecoration(
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
              icon: const Icon(Icons.arrow_back, color: Colors.green, size: 50),
              onPressed: () {
                Navigator.pop(context); // Volta para a página anterior
              },
            ),
          ),
              Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: user.imagem!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(user.imagem!,
                          fit: BoxFit.cover, width: 300, height: 300))
                  : const Icon(Icons.person,
                      size: 50, color: Color(0xFF7B2CBF)),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Óleo usado",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/icongalao2.png',
                  width: 450,
                  height: 200,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Óleo usado (ml):",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller
                              .decrement(); // Chama o método de decremento no Controller
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.red.shade700,
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10)),
                        ),
                        child: const Icon(Icons.remove,
                            size: 30, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_controller.getOilAmount()}', // Exibe a quantidade de óleo usando o Controller
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller
                              .increment(); // Chama o método de incremento no Controller
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.green.shade700,
                          borderRadius: const BorderRadius.horizontal(
                              right: Radius.circular(10)),
                        ),
                        child: const Icon(Icons.add,
                            size: 30, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 130),
                ElevatedButton.icon(
                  onPressed: () async {
                    // Exemplo: tipo de óleo
                    const String tipo = "Óleo usado";
                    const String status = "Em processo";

                    await _controller.addRecycledData(tipo, status);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );

                    print("Avançar pressionado com ${_controller.getOilAmount()} ml de óleo usado.");
                  },
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Avançar",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
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
                print("Histórico pressionado");
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
