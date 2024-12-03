import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/screens/administrador/reciclados_proximos.dart';
import 'package:exemplo_firebase/screens/intern_screen_view.dart';
import 'package:exemplo_firebase/screens/registro_screen.dart';
import 'package:exemplo_firebase/screens/set_icon_screen_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controllers/user_data.dart';
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Verifica se o layout está em modo paisagem ou em tela maior
          bool isWideScreen = constraints.maxWidth > 600;

          return Container(
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isWideScreen
                      ? 100.0
                      : 32.0, // Margem ajustada para telas maiores
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo e texto "Recolhe.ai"
                      Column(
                        children: [
                          Image.asset(
                            'assets/recycle_icon.png',
                            width: isWideScreen
                                ? 300
                                : 250, // Ajuste dinâmico da largura
                            height: isWideScreen
                                ? 300
                                : 250, // Ajuste dinâmico da altura
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

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
                        errorStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
                        errorStyle: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
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
                        textColor: Colors.white,
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
          );
        },
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
          // Verificação do email para redirecionamento diretamente no FirebaseAuth
          if (user.email != null && user.email!.contains('@coleta.com')) {
            // Se o email não for de admin, continua o fluxo normal
            var userDocument = await FirebaseFirestore.instance
                .collection('users') // Sua coleção de usuários
                .doc(user.uid) // Usa o UID do usuário logado
                .get();
            // Atualiza o UserSession com os dados do usuário
            final userSession = UserSession();
            userSession.email = user.email;
            userSession.name = userDocument.data()?['nome'] ?? "Usuário";
            userSession.cpf = userDocument.data()?['cpf'] ?? "123";
            userSession.imagem = userDocument.data()?['imagem'];
            userSession.userId = user.uid;

            print(user.email);
            // Se o email for do tipo admin, redireciona para a página de administrador
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NearbyItemsPage(),
              ),
            );
          } else {
            // Se o email não for de admin, continua o fluxo normal
            var userDocument = await FirebaseFirestore.instance
                .collection('users') // Sua coleção de usuários
                .doc(user.uid) // Usa o UID do usuário logado
                .get();

            if (userDocument.exists) {
              // Atualiza o UserSession com os dados do usuário
              final userSession = UserSession();
              userSession.email = user.email;
              userSession.name = userDocument.data()?['nome'] ?? "Usuário";
              userSession.cpf = userDocument.data()?['cpf'] ?? "123";
              userSession.imagem = userDocument.data()?['imagem'];
              userSession.userId = user.uid;

              // Printando os dados do usuário no console
              print("Nome: ${userSession.name}");
              print("Email: ${userSession.email}");
              print("CPF: ${userSession.cpf}");
              print("Imagem: ${userSession.imagem}");
              print("UserID: ${userSession.userId}");

              // Verifica a imagem para redirecionar
              if (userSession.imagem == null || userSession.imagem!.isEmpty) {
                // Redireciona para a página de configuração de ícone
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetIconScreen(userId: user.uid),
                  ),
                );
              } else {
                // Redireciona para a página inicial
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              }
            } else {
              // Documento do usuário não encontrado
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("O Usuário não existe!"),
                ),
              );
            }
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Usuário ou senha inválidos."),
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
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle errorStyle;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.validator,
    this.isPassword = false,
    this.inputFormatters,
    required this.errorStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          width: 3,
          color: const Color(0xFF109410),
        ),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        validator: validator,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFF109410)),
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
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
            borderRadius: BorderRadius.circular(15),
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
