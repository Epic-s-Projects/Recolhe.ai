import 'package:aplicativo/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

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
                const CustomTextField(
                  icon: Icons.email,
                  hintText: 'Email',
                ),
                const SizedBox(height: 20),

                // Campo de entrada de Senha
                const CustomTextField(
                  icon: Icons.lock,
                  hintText: 'Senha',
                  isPassword: true,
                ),

                // Link "Esqueceu sua senha?"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Esqueceu sua senha?',
                      style: TextStyle(
                        color: Colors.black, // Atualizado para preto
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Botão Login
                GradientButton(
                  text: 'Login',
                  onPressed: () {},
                  textColor: Colors.green.shade900, // Verde escuro destacado
                ),

                const SizedBox(height: 20),

                // Texto "Não tem uma conta? Registre-se"
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Não tem uma conta? "),
                    GestureDetector(
                      onTap: () {},
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

                const SizedBox(height: 20),

                // Divisor com "OU"
                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.green)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [
                            Color(0xFF109410),
                            Color(0xFF1AE91A),
                          ],
                        ).createShader(bounds),
                        child: const Text(
                          "OU",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white, // Necessário para gradiente
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: Colors.green)),
                  ],
                ),

                const SizedBox(height: 20),

                // Botões de login com Google e Microsoft
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.g_mobiledata,
                          size: 48, color: Color(0xFF109410)),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.grid_3x3,
                          size: 48, color: Color(0xFF109410)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para campos de entrada com ícone e borda em gradiente
class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.hintText,
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
      child: TextField(
        obscureText: isPassword,
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

// Widget para botão de login com gradiente
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
