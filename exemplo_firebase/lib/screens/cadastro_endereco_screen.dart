import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class ModernAddressRegistrationPage extends StatefulWidget {
  const ModernAddressRegistrationPage({super.key});

  @override
  _ModernAddressRegistrationPageState createState() =>
      _ModernAddressRegistrationPageState();
}

class _ModernAddressRegistrationPageState
    extends State<ModernAddressRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();

  bool _hasAddress = false;
  bool _isEditing = false;

  // Modern color palette
  final Color _accentColor = const Color(0xFF4CAF50); // Earthy green
  // final Color _backgroundColor = const Color(0xFFF5F5F5); // Soft gray
  final Color _backgroundColor = const Color(0xFFF5F5F5);

  @override
  void initState() {
    super.initState();
    _fetchExistingAddress();
  }

  Future<void> _fetchExistingAddress() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('endereco')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          _hasAddress = true;
          _cepController.text = data['cep'] ?? '';
          _ruaController.text = data['rua'] ?? '';
          _bairroController.text = data['bairro'] ?? '';
          _numeroController.text = data['numero'] ?? '';
        });
      }
    } catch (e) {
      _showErrorDialog('Erro ao carregar endereço');
    }
  }

  Future<void> _fetchAddressByCEP(String cep) async {
    final url = Uri.parse("https://viacep.com.br/ws/$cep/json/");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (!data.containsKey('erro')) {
          setState(() {
            _ruaController.text = data['logradouro'] ?? '';
            _bairroController.text = data['bairro'] ?? '';
          });
        }
      }
    } catch (e) {
      _showErrorDialog('Erro ao buscar endereço');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Atenção',
          style: TextStyle(
            color: Color.fromARGB(255, 223, 209, 186),
          ),
          // style: TextStyle(color: Colors.red),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(color: _accentColor),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveAddress() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    final addressData = {
      "cep": _cepController.text,
      "rua": _ruaController.text,
      "bairro": _bairroController.text,
      "numero": _numeroController.text,
    };

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser.uid)
          .collection("endereco")
          .doc("main_address")
          .set(addressData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Endereço salvo com sucesso!'),
          backgroundColor: _accentColor,
        ),
      );

      setState(() {
        _hasAddress = true;
        _isEditing = false;
      });
    } catch (e) {
      _showErrorDialog('Erro ao salvar endereço');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cadastro de Endereço',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: _hasAddress && !_isEditing
            ? _buildAddressView()
            : _buildAddressForm(),
      ),
      floatingActionButton: _hasAddress
          ? FloatingActionButton(
              onPressed: () => setState(() => _isEditing = !_isEditing),
              backgroundColor: _accentColor,
              child: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: Colors.white,
              ),
            )
          : null,
    );
  }

  Widget _buildAddressView() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Endereço Cadastrado',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            _buildAddressDetailRow(
                Icons.location_on, 'CEP', _cepController.text),
            _buildAddressDetailRow(
                Icons.streetview, 'Rua', _ruaController.text),
            _buildAddressDetailRow(
                Icons.location_city, 'Bairro', _bairroController.text),
            _buildAddressDetailRow(
                Icons.home, 'Número', _numeroController.text),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: _accentColor),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 223, 209, 186).withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField(
            controller: _cepController,
            label: 'CEP',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'CEP obrigatório';
              if (value.length != 8) return 'CEP inválido';
              return null;
            },
            onChanged: (value) {
              if (value.length == 8) _fetchAddressByCEP(value);
            },
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _ruaController,
            label: 'Rua',
            validator: (value) =>
                value?.isEmpty == true ? 'Rua obrigatória' : null,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _bairroController,
            label: 'Bairro',
            validator: (value) =>
                value?.isEmpty == true ? 'Bairro obrigatório' : null,
          ),
          const SizedBox(height: 15),
          _buildTextField(
            controller: _numeroController,
            label: 'Número',
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty == true ? 'Número obrigatório' : null,
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            onPressed: _saveAddress,
            style: ElevatedButton.styleFrom(
              backgroundColor: _accentColor,
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Salvar Endereço',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 223, 209, 186),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 223, 209, 186),
          ),
          // filled: true,
          // fillColor: Colors.white,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide.none,
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(12),
          // ),
          // errorBorder: OutlineInputBorder(
          //   borderSide: const BorderSide(color: Colors.red, width: 2),
          //   borderRadius: BorderRadius.circular(12),
          //   borderSide: BorderSide(color: _accentColor),
        ),
      ),
    );
  }
}
