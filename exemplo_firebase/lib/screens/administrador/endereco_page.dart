import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exemplo_firebase/screens/administrador/reciclado_por_endereco_page.dart';
import 'package:flutter/material.dart';

class EnderecosPage extends StatefulWidget {
  @override
  _EnderecosPageState createState() => _EnderecosPageState();
}

class _EnderecosPageState extends State<EnderecosPage> {
  List<Map<String, dynamic>> enderecos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEnderecos();
  }

  Future<void> _loadEnderecos() async {
    try {
      List<Map<String, dynamic>> data = await fetchAllEnderecos();
      setState(() {
        enderecos = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar endereços: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchAllEnderecos() async {
    List<Map<String, dynamic>> allEnderecos = [];

    try {
      QuerySnapshot usersSnapshot =
      await FirebaseFirestore.instance.collection("users").get();

      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        QuerySnapshot enderecoSnapshot =
        await userDoc.reference.collection("endereco").get();

        for (QueryDocumentSnapshot enderecoDoc in enderecoSnapshot.docs) {
          allEnderecos.add({
            ...enderecoDoc.data() as Map<String, dynamic>,
            'userId': userDoc.id,
            'enderecoId': enderecoDoc.id,
          });
        }
      }
    } catch (e) {
      print("Erro ao buscar endereços: $e");
    }

    return allEnderecos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endereços'),
        backgroundColor: Color(0xFF4CAF50),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fundoHome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: isLoading
              ? _buildLoadingView()
              : enderecos.isEmpty
              ? _buildEmptyView()
              : _buildEnderecosList(),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_on,
            size: 100,
            color: Color(0xFF4CAF50),
          ),
          SizedBox(height: 16),
          Text(
            'Nenhum endereço encontrado.',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF795548),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnderecosList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: enderecos.length,
      itemBuilder: (context, index) {
        final endereco = enderecos[index];
        return _buildEnderecoCard(endereco);
      },
    );
  }

  Widget _buildEnderecoCard(Map<String, dynamic> endereco) {
    final numero = endereco['numero'] ?? 'Número não disponível';
    final rua = endereco['rua'] ?? 'Rua não disponível';
    final cep = endereco['cep'] ?? 'CEP não informado';
    final bairro = endereco['bairro'] ?? 'Bairro não informado';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecicladosPorEnderecoPage(
              endereco: endereco,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                bairro,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '${rua ?? "Rua não disponível"}, ${numero ?? "Número não disponível"}',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Text(
                cep,
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],

          ),
        ),
      ),
    );
  }
}
