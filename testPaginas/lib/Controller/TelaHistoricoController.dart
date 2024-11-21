import 'package:flutter/material.dart';
import 'package:testpaginas/telaQuatindade.dart';
import 'package:testpaginas/telaHistorico.dart';

class TelaHistoricoController {
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
