import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import 'login_screen_view.dart';

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

  final AuthController _authController = AuthController();

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
                      onPressed: () => Navigator.pop(context),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _authController.registrar(
                          context: context,
                          email: _emailController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                          name: _nameController.text,
                          cpf: _cpfController.text,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
