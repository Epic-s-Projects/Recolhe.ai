import 'package:exemplo_firebase/screens/historic_screen_view.dart';
import 'package:exemplo_firebase/screens/oil_register_screen.dart';
import 'package:flutter/material.dart';

class SelectionController {
  // Navegar para a página de coleta de óleo usado
  void navigateToOilUsed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OilRegisterScreen()),
    );
  }

  // Lidar com o botão de celular quebrado
  void handleSecondButtonPress() {
    print("Botão 2 pressionado");
  }

  // Navegação da barra inferior
  void handleBottomNavTap(BuildContext context, int index) {
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
  }
}
