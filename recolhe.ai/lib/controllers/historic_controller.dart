import 'package:flutter/material.dart';

class HistoricController {
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
        break;
      case 3:
        print("Recompensa pressionado");
        break;
    }
  }
}
