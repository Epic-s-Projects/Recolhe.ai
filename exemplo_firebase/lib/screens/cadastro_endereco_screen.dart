import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroEnderecoPage extends StatefulWidget {
  const CadastroEnderecoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CadastroEnderecoPageState createState() => _CadastroEnderecoPageState();
}

class _CadastroEnderecoPageState extends State<CadastroEnderecoPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores de texto
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  // final TextEditingController _longitudeController = TextEditingController();
  // final TextEditingController _latitudeController = TextEditingController();

  // Método para buscar endereço pelo CEP
  Future<void> _buscarEnderecoPorCEP(String cep) async {
    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey('erro')) {
          _mostrarMensagemErro("CEP não encontrado!");
        } else {
          // Atualiza os campos com os dados da API
          setState(() {
            _ruaController.text = data['logradouro'] ?? '';
            _bairroController.text = data['bairro'] ?? '';
          });
        }
      } else {
        _mostrarMensagemErro("Erro ao buscar o endereço.");
      }
    } catch (e) {
      _mostrarMensagemErro("Erro na conexão: $e");
    }
  }

  // Método para exibir mensagens de erro
  void _mostrarMensagemErro(String mensagem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Erro"),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  Future<void> _salvarDadosNoFirebase() async {
    if (_formKey.currentState?.validate() ?? false) {
      final endereco = {
        "cep": _cepController.text,
        "rua": _ruaController.text,
        "bairro": _bairroController.text,
        "numero": _numeroController.text,
      };

      try {
        // Obtém o UID do usuário autenticado
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          String uid = user.uid; // Pega o UID do usuário autenticado

          // Salva o endereço na subcoleção 'endereco' dentro do documento do usuário
          await FirebaseFirestore.instance
              .collection("users")
              .doc(uid) // Usa o UID do usuário autenticado
              .collection("endereco") // Subcoleção 'endereco'
              .add(endereco); // Adiciona os dados

          // Exibe uma mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Endereço salvo com sucesso!")),
          );

          // Limpa os campos após salvar
          _cepController.clear();
          _ruaController.clear();
          _bairroController.clear();
          _numeroController.clear();
        } else {
          // Se não estiver autenticado, exibe uma mensagem
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Usuário não autenticado.")),
          );
        }
      } catch (e) {
        // Exibe um erro se algo der errado
        _mostrarMensagemErro("Erro ao salvar no Firebase: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastro de Endereço"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "CEP",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Informe o CEP";
                  if (value.length != 8) return "O CEP deve ter 8 dígitos";
                  return null;
                },
                onChanged: (value) {
                  if (value.length == 8) {
                    _buscarEnderecoPorCEP(value);
                  }
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _ruaController,
                decoration: const InputDecoration(
                  labelText: "Rua",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe a rua" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(
                  labelText: "Bairro",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o bairro" : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(
                  labelText: "Número",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Informe o número" : null,
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: _salvarDadosNoFirebase,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                  ),
                  child: const Text(
                    "Salvar",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
