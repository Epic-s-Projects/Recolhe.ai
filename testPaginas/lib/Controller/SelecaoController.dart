import 'package:flutter/material.dart';
import 'package:testpaginas/View/TelaQuantidadeView.dart'; // Importa a tela de quantidade de óleo
import 'package:testpaginas/View/TelaHistoricoView.dart'; // Importa a tela de histórico


class SelecaoController {
  // Navegar para a página de coleta de óleo usado
  void navigateToOilUsed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TelaQuantidadePage()),
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
          MaterialPageRoute(builder: (context) => TelaHistoricoView()),
        );
        break;
      case 3:
        print("Recompensa pressionado");
        break;
    }
  }
}
