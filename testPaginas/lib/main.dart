import 'package:flutter/material.dart';
import 'package:testpaginas/telaQuatindade.dart';
import 'package:testpaginas/telaHistorico.dart';
import 'package:testpaginas/View/SelecaoView.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SelecaoView(),
  ));
}

class BackgroundWithButtons extends StatelessWidget {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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
          // Texto "Olá, João!" e bolinha de perfil
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Olá, João!',
              style: TextStyle(
                fontSize: 30,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/user_avatar.png'), // Substitua pela imagem do avatar
              radius: 35,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Ajusta a altura
            left: 0,
            right: 0,
            child: Text(
              'Selecione o tipo de coleta:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Botões lado a lado sobre a imagem
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  imagePath: 'assets/icongalao.png',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OilUsedPage()),
                    );
                  },
                  label: '',
                ),
                SizedBox(width: 20), // Espaçamento entre os botões
                CustomButton(
                  imagePath: 'assets/iconcelularquebrado.png',
                  label: '',
                  onPressed: () {
                    print("Botão 2 pressionado");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black.withOpacity(0.8), // Fundo preto transparente
        type: BottomNavigationBarType.fixed, // Garante que todos os ícones estejam visíveis
        selectedItemColor: Colors.green, // Cor do ícone selecionado
        unselectedItemColor: Colors.white, // Cor dos ícones não selecionados
        showSelectedLabels: false, // Remove o rótulo dos ícones
        showUnselectedLabels: false, // Remove o rótulo dos ícones
        iconSize: 45, // Tamanho dos ícones ajustável pela variável
        items: const [
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
    );
  }
}

class CustomButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    required this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.brown.withOpacity(0.5), // Fundo com transparência
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imagePath,
            width: 150, // Largura da imagem
            height: 200, // Altura da imagem
          ),
        ],
      ),
    );
  }
}