import 'package:cloud_firestore/cloud_firestore.dart';
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
                endereco['bairro'] ?? 'Bairro não informado',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
              SizedBox(height: 8),
              Text(
                endereco['rua'] ?? 'Rua não disponível',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RecicladosPorEnderecoPage extends StatefulWidget {
  final Map<String, dynamic> endereco;

  RecicladosPorEnderecoPage({required this.endereco});

  @override
  _RecicladosPorEnderecoPageState createState() =>
      _RecicladosPorEnderecoPageState();
}

class _RecicladosPorEnderecoPageState extends State<RecicladosPorEnderecoPage> {
  List<Map<String, dynamic>> reciclados = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReciclados();
  }

  Future<void> _loadReciclados() async {
    try {
      List<Map<String, dynamic>> data = await fetchReciclados(widget.endereco);
      setState(() {
        reciclados = data;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar reciclados: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchReciclados(
      Map<String, dynamic> endereco) async {
    List<Map<String, dynamic>> allReciclados = [];

    try {
      QuerySnapshot recicladoSnapshot = await FirebaseFirestore.instance
          .collection("users")
          .doc(endereco['userId'])
          .collection("reciclado")
          .where("enderecoId", isEqualTo: endereco['enderecoId'])
          .get();

      for (QueryDocumentSnapshot recicladoDoc in recicladoSnapshot.docs) {
        allReciclados.add({
          ...recicladoDoc.data() as Map<String, dynamic>,
          'recicladoId': recicladoDoc.id,
        });
      }
    } catch (e) {
      print("Erro ao buscar reciclados: $e");
    }

    return allReciclados;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reciclados por Endereço'),
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
              ? Center(
            child: CircularProgressIndicator(
              valueColor:
              AlwaysStoppedAnimation<Color>(Color(0xFF795548)),
            ),
          )
              : reciclados.isEmpty
              ? Center(
            child: Text(
              'Nenhum reciclado encontrado para este endereço.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF795548),
                fontWeight: FontWeight.bold,
              ),
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: reciclados.length,
            itemBuilder: (context, index) {
              final reciclado = reciclados[index];
              return Card(
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
                        reciclado['tipo'] ?? 'Tipo não disponível',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        reciclado['status'] ?? 'Status não disponível',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
