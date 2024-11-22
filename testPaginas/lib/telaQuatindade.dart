import 'package:flutter/material.dart';
import 'package:testpaginas/telaHistorico.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OilUsedPage(),

  ));
}

class OilUsedPage extends StatefulWidget {
  @override
  _OilUsedPageState createState() => _OilUsedPageState();

}

class _OilUsedPageState extends State<OilUsedPage> {
  int oilAmount = 0; // Valor inicial do contador

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Caminho da imagem
                fit: BoxFit.cover, // Ajusta a imagem ao tamanho da tela
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
          // Texto "Olá, João!" e bolinha de perfil
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'), // Substitua pela imagem do avatar
              radius: 35,
            ),
          ),
          // Conteúdo principal

            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                // Título "Óleo usado (ml):"
                Text(
                "Óleo usado",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

                  SizedBox(height: 20),
                  // Imagem central
                  Image.asset(
                    'assets/icongalao2.png', // Substitua pelo caminho da imagem
                    width: 450, // Largura da imagem
                    height: 200, // Altura da imagem
                  ),
                  SizedBox(height: 20), // Espaçamento abaixo da imagem
                  // Título e contador
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Título "Óleo usado (ml):"
                      Text(
                        "Óleo usado (ml):",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10), // Espaçamento entre o título e os botões
                      // Botão de diminuição
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (oilAmount > 0) oilAmount -= 500; // Diminui 500 no contador
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
                      // Campo de texto com + e -
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // Fundo do campo de texto
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$oilAmount', // Exibe o valor do contador
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ),
                    // Botão de incremento
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          oilAmount += 500; // Acrescenta 500 no contador
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
                SizedBox(height: 130), // Espaçamento abaixo do contador
                // Botão "Avançar"
                ElevatedButton.icon(
                  onPressed: () {
                    // Ação ao pressionar o botão
                    print("Avançar pressionado com $oilAmount ml de óleo usado.");
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text(
                    "Avançar",

                    style: TextStyle(fontSize: 24, color: Colors.white,),
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
      // Barra de navegação inferior com ícones PNG
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(0.8), // Fundo semi-transparente ajustado
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
              label: '', // Rótulo vazio
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '', // Rótulo vazio
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: '', // Rótulo vazio
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard),
              label: '', // Rótulo vazio
            ),
          ],
          onTap: (index) {
            // Ação ao clicar em cada item da barra de navegação
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
                  MaterialPageRoute(builder: (context) => HistoryPage()),
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
