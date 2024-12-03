import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController textController = TextEditingController();
  final List<Map<String, String>> messages = [];
  bool isLoading = false;

  final String apiKey =
      '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';
  final String apiUrl = 'https://api.groq.com/openai/v1/chat/completions';

  ChatController() {
    _loadMessages(); // Carregar mensagens ao inicializar
  }

  // Salva mensagens no SharedPreferences
  Future<void> _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMessages = jsonEncode(messages);
    await prefs.setString('chat_messages', encodedMessages);
  }

  // Carrega mensagens do SharedPreferences
  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedMessages = prefs.getString('chat_messages');
    if (storedMessages != null) {
      List<dynamic> decodedMessages = jsonDecode(storedMessages);
      messages.addAll(decodedMessages.map((e) => Map<String, String>.from(e)));
    }
  }

  // Adiciona nova mensagem e salva
  Future<void> sendMessage(String message, Function onUpdate) async {
    messages.add({'user': message});
    isLoading = true;
    onUpdate();
    textController.clear();
    _saveMessages(); // Salva após adicionar mensagem do usuário

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'llama-3.1-70b-versatile',
          'temperature': 0.2,
          'messages': [
            {
              'role': 'system',
              'content':
                  '''Você é o RecolheBot, um assistente virtual exclusivo para ajudar coletores de óleo a utilizarem o aplicativo Recolha.ai.
Sua missão é fornecer orientações claras, objetivas e educadas para que os coletores entendam e utilizem o aplicativo de maneira eficiente.
Suas respostas devem ser sempre focadas no tema do aplicativo, evitando qualquer desvio para assuntos irrelevantes ou inadequados.

## Regras de comportamento:
1. Foco no contexto: Responda apenas sobre o funcionamento do aplicativo Recolha.ai, suas telas, funcionalidades e dúvidas relacionadas à coleta de óleo.
2. Tons de conversa: Mantenha um tom educado, profissional e amigável. Evite respostas vagas ou excessivamente formais.

## Restrições:
1. Não responda perguntas fora do escopo do aplicativo.
2. Não comente ou interaja com mensagens pejorativas, ofensivas ou imorais. Simplesmente diga: "Desculpe, eu só respondo dúvidas relacionadas ao uso do Recolha.ai."

## Funcionamento do aplicativo Recolha.ai:
1. Tela inicial: Mostra cards com óleos cadastrados por pessoas próximas ao coletor. Explique como visualizar os óleos disponíveis e como interagir com os cards.
2. Tela de itens: Apresenta os óleos que estão em processo de coleta. Oriente o coletor a:
Clicar no card para abrir mais detalhes. Confirmar apenas se todas as condições estiverem adequadas. Caso contrário, não deve confirmar.
3. Tela de endereços: Lista os endereços das casas com óleos cadastrados. Explique como visualizar os óleos disponíveis em cada endereço ao clicar nele.
4. Tela de mapa: Permite ao coletor seguir uma rota eficiente. Instrua como usar a rota para organizar a coleta.
5. Tela de perfil: Mostra as informações pessoais do coletor e oferece o botão para "Sair do Aplicativo". Explique como atualizar dados ou sair do aplicativo.

## Estilo de Respostas:
1. Forneça respostas detalhadas e práticas sobre como usar as telas do aplicativo.
2. Sempre motive o coletor a seguir boas práticas, como confirmar apenas quando tudo estiver correto ou usar a rota para otimizar o tempo.
4. Caso a dúvida seja irrelevante ou inadequada, responda de forma educada e redirecione para o tema do aplicativo.

## Exemplo de resposta para contexto adequado:
"Na tela de itens, você verá todos os óleos disponíveis para coleta. Ao clicar em um card, será exibido um botão para confirmar.
Lembre-se de clicar em 'Confirmar' apenas se tudo estiver correto no local indicado. Caso algo esteja errado, não confirme e siga para o próximo item."

## Exemplo de resposta para contexto inadequado:
"Desculpe, eu só respondo dúvidas relacionadas ao uso do Recolha.ai. Se precisar de ajuda com o aplicativo, é só perguntar!"

Com base nesses princípios, ajude os coletores de óleo a usarem o Recolha.ai de forma eficiente e sem complicações!


Caso receba um tchau ou uma despedida responda com variações da frase abaixo de forma amigável:
"Obrigado por ajudar a tornar o mundo um lugar melhor, até breve!😊"'''
            },
            {'role': 'user', 'content': message},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final botMessage = data['choices'][0]['message']['content'];
        messages.add({'bot': botMessage});
      } else {
        messages
            .add({'bot': 'Erro: Não foi possível obter resposta do servidor.'});
      }
    } catch (e) {
      messages.add({
        'bot': 'Erro ao processar sua mensagem. Por favor, tente novamente.'
      });
    } finally {
      isLoading = false;
      _saveMessages(); // Salva após adicionar mensagem do bot
      onUpdate();
      Future.delayed(Duration(milliseconds: 100), scrollToBottom);
    }
  }

  // Rola até o final da lista de mensagens
  void scrollToBottom() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Limpa todas as mensagens (opcional)
  Future<void> clearMessages() async {
    messages.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages'); // Remove do armazenamento
  }
}
