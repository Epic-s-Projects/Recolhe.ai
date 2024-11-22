// lib/controller/auth_controller.dart
import 'package:exemplo_firebase/screens/login_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/auth_service.dart';


class AuthController {
  final AuthService _authService = AuthService();

  // Função para validar email
  bool validarEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Função para validar CPF
  bool validarCPF(String cpf) {
    cpf = cpf.replaceAll(RegExp(r'[^0-9]'), '');

    if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
      return false;
    }

    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpf[i]) * (10 - i);
    }
    int resto = soma % 11;
    int digito1 = (resto < 2) ? 0 : 11 - resto;

    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpf[i]) * (11 - i);
    }
    resto = soma % 11;
    int digito2 = (resto < 2) ? 0 : 11 - resto;

    return cpf[9] == digito1.toString() && cpf[10] == digito2.toString();
  }


  Future<void> registrar({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String cpf,
  }) async {
    // Validação de campos vazios
    if (email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        name.isEmpty ||
        cpf.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
        ),
      );
      return;
    }

    // Validação de email
    if (!validarEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um email válido.'),
        ),
      );
      return;
    }

    // Validação de CPF
    if (!validarCPF(cpf)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira um CPF válido.'),
        ),
      );
      return;
    }

    // Validação de senhas
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A senha deve ter pelo menos 6 caracteres.'),
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('As senhas não conferem.'),
        ),
      );
      return;
    }

    try {
      // Tentar registrar o usuário
      final user = await _authService.registerWithEmail(
        email,
        password,
        name,
        cpf,
      );

      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        ); // Navega para a tela de login
      } else {
        throw 'Erro ao registrar. Tente novamente.';
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        // Verifica se o erro é de email já em uso
        if (e.code == 'email-already-in-use') {
          // Exibe a mensagem de erro de e-mail já em uso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Este e-mail já está em uso.'),
            ),
          );
        } else {
          // Caso o erro seja diferente
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao registrar: ${e.message}'),
            ),
          );
        }
      } else {
        // Tratar outros tipos de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Este e-mail já está em uso: $e'),
          ),
        );
      }
    }
  }
}