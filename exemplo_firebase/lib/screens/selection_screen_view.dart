import 'package:exemplo_firebase/controllers/selection_controller.dart';
import 'package:flutter/material.dart';

import '../controllers/user_data.dart';

class SelectionScreenView extends StatelessWidget {
  final SelectionController controller = SelectionController();
  final user = UserSession();


  SelectionScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fundo com a imagem
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Caminho da imagem
                fit: BoxFit.cover, // Ajusta a imagem ao tamanho da tela
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Text(
              'Olá, ${user.name}!',
              style: const TextStyle(
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
              radius: 45,
              backgroundColor: Colors.white,
              child: (user.imagem != null && user.imagem!.isNotEmpty)
                  ? ClipOval(
                child: Image.network(
                  user.imagem!,
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                ),
              )
                  : const Icon(
                Icons.person,
                size: 30,
                color: Color(0xFF7B2CBF),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2, // Ajusta a altura
            left: 0,
            right: 0,
            child: const Text(
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
                  onPressed: () => controller.navigateToOilUsed(context),
                  label: '',
                ),
                const SizedBox(width: 20), // Espaçamento entre os botões
                CustomButton(
                  imagePath: 'assets/iconcelularquebrado.png',
                  label: '',
                  onPressed: controller.handleSecondButtonPress,
                ),
              ],
            ),
          ),
        ],
      ),
      // Barra de navegação inferior
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor:
            Colors.black.withOpacity(0.8), // Fundo preto transparente
        type: BottomNavigationBarType
            .fixed, // Garante que todos os ícones estejam visíveis
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
        onTap: (index) => controller.handleBottomNavTap(context, index),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.brown.withOpacity(0.5), // Fundo com transparência
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
