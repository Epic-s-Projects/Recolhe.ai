import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/screens/intern_screen_view.dart';
import 'package:exemplo_firebase/screens/registro_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE1C8A9),
              Color(0xFFC59A64),
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo e texto "Recolhe.ai"
                  Column(
                    children: [
                      const Icon(
                        Icons.recycling,
                        size: 80,
                        color: Colors.green,
                      ),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF109410),
                            Color(0xFF1AE91A),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          'Recolhe.ai',
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Campo de entrada de Email
                  CustomTextField(
                    controller: _emailController,
                    icon: Icons.email,
                    hintText: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira um email válido';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo de entrada de Senha
                  CustomTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hintText: 'Senha',
                    isPassword: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Insira uma senha';
                      }
                      return null;
                    },
                  ),

                  // Link "Esqueceu sua senha?"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Esqueceu sua senha?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Botão Login
                  GradientButton(
                    text: 'Login',
                    onPressed: _validarLogin,
                    textColor: Colors.green.shade900,
                  ),

                  const SizedBox(height: 20),

                  // Texto "Não tem uma conta? Registre-se"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma conta? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistroScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Registre-se',
                          style: TextStyle(
                            color: Color(0xFF109410),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _validarLogin() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        // Realiza o login com o email e senha
        User? user = await _authService.signInWithEmail(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          // Se o login for bem-sucedido, busque o nome no Firestore
          var userDocument = await FirebaseFirestore.instance
              .collection('users') // Sua coleção de usuários
              .doc(user.uid) // Usa o UID do usuário logado
              .get();

          if (userDocument.exists) {
            // Pega o /dados do usuário
            String name = userDocument['nome'];
            String cpf = userDocument['cpf'];
            String email = userDocument['email'];
            String imagem = userDocument['imagem'];
            // Redireciona para a tela inicial passando o nome
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                    name: name, cpf: cpf, email: email, imagem: imagem),
              ),
            );
          } else {
            // Caso o documento não exista
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text("Documento do usuário não encontrado no Firestore."),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Usuário ou senha inválidos"),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }
}

// Widget para campos de entrada com validação
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final String? Function(String?) validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.validator,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 2,
          color: const Color(0xFF109410),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF109410)),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

// Widget para botão com gradiente
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF109410),
            Color(0xFF1AE91A),
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
