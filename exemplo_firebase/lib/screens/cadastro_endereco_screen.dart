import 'dart:convert';
import 'package:exemplo_firebase/controllers/app_bar.dart';
import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroEnderecoPage extends StatefulWidget {
  const CadastroEnderecoPage({super.key});

  @override
  _CadastroEnderecoPageState createState() => _CadastroEnderecoPageState();
}

class _CadastroEnderecoPageState extends State<CadastroEnderecoPage> {
  final _formKey = GlobalKey<FormState>();
  final user = UserSession();

  // Controladores de texto
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  bool hasAddress = false; // Flag para verificar se já existe endereço
  String docId = UserSession().userId!; // ID do documento para atualização
  bool showForm = false; // Flag para exibir o formulário

  @override
  void initState() {
    super.initState();
    _checkExistingAddress(); // Verifica se já existe endereço
  }

  Future<void> _checkExistingAddress() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('endereco')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        docId = snapshot.docs.first.id;

        setState(() {
          hasAddress = true;
          _cepController.text = data['cep'] ?? '';
          _ruaController.text = data['rua'] ?? '';
          _bairroController.text = data['bairro'] ?? '';
          _numeroController.text = data['numero'] ?? '';
        });
      }
    }
  }

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
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          if (hasAddress) {
            // Atualiza o endereço existente
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .collection("endereco")
                .doc(docId)
                .update(endereco);
          } else {
            // Adiciona um novo endereço
            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .collection("endereco")
                .add(endereco);
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Endereço salvo com sucesso!")),
          );

          setState(() {
            showForm = false;
          });
        }
      } catch (e) {
        _mostrarMensagemErro("Erro ao salvar no Firebase: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(user: user, showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: hasAddress && !showForm
            ? _buildAddressDisplay()
            : _buildAddressForm(),
      ),
      floatingActionButton: hasAddress
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            showForm = !showForm;
          });
        },
        child: Icon(showForm ? Icons.close : Icons.edit),
      )
          : null,
    );
  }

  Widget _buildAddressDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Endereço Cadastrado:",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16.0),
        Text("CEP: ${_cepController.text}"),
        Text("Rua: ${_ruaController.text}"),
        Text("Bairro: ${_bairroController.text}"),
        Text("Número: ${_numeroController.text}"),
      ],
    );
  }

  Widget _buildAddressForm() {
    return Form(
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
              child: const Text("Salvar"),
            ),
          ),
        ],
      ),
    );
  }
}
