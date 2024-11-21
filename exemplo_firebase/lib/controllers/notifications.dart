import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

void showAlert(BuildContext context) {
  QuickAlert.show(
      context: context,
      title: "Task em branco!",
      text: "Escreva algo, não é permitido adicionar tarefas em branco!",
      type: QuickAlertType.error);
}

void showAlertRemove(BuildContext context) {
  QuickAlert.show(
      context: context,
      title: "ITEM EXCLUÍDO!",
      text: "O item selecionado foi deletado!",
      type: QuickAlertType.info);
}

void showAlertExist(BuildContext context) {
  QuickAlert.show(
      context: context,
      title: "Tarefa Existente!",
      text: "Já existe uma tarefa com esse nome!",
      type: QuickAlertType.warning);
}

void showAlertSucess(BuildContext context) {
  QuickAlert.show(
      context: context,
      title: "Tarefa Adicionada!",
      text: "Tarefa Adicionada com Sucesso!",
      type: QuickAlertType.success);
}