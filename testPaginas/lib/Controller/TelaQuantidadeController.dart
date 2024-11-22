import 'package:flutter/material.dart';

class TelaQuantidadeController {
  // Variável para armazenar a quantidade de óleo
  int oilAmount = 0;

  // Função para incrementar a quantidade de óleo
  void increment() {
    oilAmount += 500;
  }

  // Função para decrementar a quantidade de óleo
  void decrement() {
    if (oilAmount > 0) oilAmount -= 500;
  }

  // Função para retornar a quantidade de óleo
  int getOilAmount() {
    return oilAmount;
  }
}
