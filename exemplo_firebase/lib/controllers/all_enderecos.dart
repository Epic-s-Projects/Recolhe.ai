import 'package:cloud_firestore/cloud_firestore.dart';

Future<List<Map<String, dynamic>>> fetchAllAddresses() async {
  List<Map<String, dynamic>> allAddresses = [];

  try {
    // Obter todos os documentos da coleção "users"
    QuerySnapshot usersSnapshot = await FirebaseFirestore.instance.collection("users").get();

    for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
      // Obter a subcoleção "endereco" de cada usuário
      QuerySnapshot enderecoSnapshot = await userDoc.reference.collection("endereco").get();

      for (QueryDocumentSnapshot enderecoDoc in enderecoSnapshot.docs) {
        // Adicionar os dados de cada endereço à lista
        allAddresses.add({
          "userId": userDoc.id, // ID do usuário
          ...enderecoDoc.data() as Map<String, dynamic>, // Dados do endereço
        });
      }
    }
  } catch (e) {
    print("Erro ao buscar endereços: $e");
  }

  return allAddresses;
}
