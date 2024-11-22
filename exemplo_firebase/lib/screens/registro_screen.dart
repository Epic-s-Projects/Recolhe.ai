import 'package:flutter/material.dart';
import '../service/auth_service.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Botão Voltar
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.green,
                        size: 28,
                      ),
                    ),
                  ),

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
                  const SizedBox(height: 20),

                  // Campos de texto
                  CustomTextField(
                    controller: _nameController,
                    icon: Icons.person,
                    hintText: 'Nome',
                    validator: (value) =>
                        value!.isEmpty ? 'Informe seu nome' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _emailController,
                    icon: Icons.email,
                    hintText: 'Email',
                    validator: (value) =>
                        value!.isEmpty ? 'Informe seu email' : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _passwordController,
                    icon: Icons.lock,
                    hintText: 'Senha',
                    isPassword: true,
                    validator: (value) => value!.length < 6
                        ? 'A senha deve ter pelo menos 6 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _confirmPasswordController,
                    icon: Icons.lock,
                    hintText: 'Confirmar Senha',
                    isPassword: true,
                    validator: (value) => value != _passwordController.text
                        ? 'As senhas não conferem'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    controller: _cpfController,
                    icon: Icons.badge,
                    hintText: 'CPF',
                    validator: (value) =>
                        value!.isEmpty ? 'Informe seu CPF' : null,
                  ),
                  const SizedBox(height: 24),

                  // Botão de Cadastro
                  GradientButton(
                    text: 'Cadastrar',
                    onPressed: _registrar,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registrar() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Registrar usuário com informações adicionais
        final user = await _authService.registerWithEmail(
          _emailController.text,
          _passwordController.text,
          _nameController.text,
          _cpfController.text,
        );

        if (user != null) {
          // Navegar para a tela de login após o registro
          Navigator.pushNamed(context, '/login');
        } else {
          throw 'Erro ao registrar. Tente novamente.';
        }
      } catch (e) {
        // Mostrar mensagem de erro em caso de falha
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao registrar: $e'),
          ),
        );
      }
    }
  }
}

// Widget para campos de entrada com ícone e borda em gradiente
class CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final bool isPassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.icon,
    required this.hintText,
    this.isPassword = false,
    required this.controller,
    this.validator,
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
        obscureText: isPassword,
        controller: controller,
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

// Widget para botão de cadastro com gradiente
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
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
          style: const TextStyle(
            fontFamily: 'Mulish',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
