import 'package:exemplo_firebase/controllers/selection_controller.dart';
import 'package:flutter/material.dart';

import '../controllers/app_bar.dart';
import '../controllers/user_data.dart';

class SelectionScreenView extends StatelessWidget {
  final SelectionController controller = SelectionController();
  final user = UserSession();

  SelectionScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
        user: user,
        showBackButton: true,
      ),
      body: Stack(
        children: [
          // Imagem de fundo principal
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Fundo principal
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.05,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: screenWidth * 0.15,
                height: screenWidth * 0.15,
                decoration: const BoxDecoration(
                  color: Colors.white, // Fundo branco para contraste
                  shape: BoxShape.circle, // Botão circular
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, // Sombra suave
                      blurRadius: 8,
                      offset: Offset(2, 2), // Posição da sombra
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.green, // Cor da seta
                    size: screenWidth * 0.08, // Tamanho da seta
                  ),
                ),
              ),
            ),
          ),

          // Título
          Positioned(
            top: screenHeight * 0.15, // Ajusta a altura do título
            left: 0,
            right: 0,
            child: const Text(
              'Selecione o tipo de coleta:',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                shadows: [],
              ),
            ),
          ),

          // Botões centralizados
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  imagePath: 'assets/icongalao.png',
                  label: 'Óleo Usado',
                  onPressed: () => controller.navigateToOilUsed(context),
                ),
                const SizedBox(width: 20), // Espaçamento entre os botões
                CustomButton(
                  imagePath: 'assets/iconcelularquebrado.png',
                  label: 'Eletrônicos',
                  onPressed: controller.handleSecondButtonPress,
                ),
              ],
            ),
          ),

          // Botão flutuante para ajuda
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton.extended(
              onPressed: () {
                // Lógica para o botão de ajuda
              },
              backgroundColor: Colors.green,
              icon: const Icon(Icons.help_outline, color: Colors.white),
              label: const Text(
                "Ajuda",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
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
        elevation: 8, // Elevação para efeito de sombra
        backgroundColor: Colors.white, // Fundo branco
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        shadowColor: Colors.black45, // Sombra escura
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Ícone ou imagem
          Image.asset(
            imagePath,
            width: 100, // Largura da imagem
            height: 100, // Altura da imagem
          ),
          const SizedBox(height: 10),
          // Texto do botão
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
