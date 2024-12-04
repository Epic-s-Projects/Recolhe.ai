import 'package:flutter/material.dart';
import '../../controllers/chatbot_controller.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecolheBot'),
      ),
      body: const Center(
        child: Text('Bem-vindo ao Recolha.ai!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => ChatDialog(),
          );
        },
        child: const Icon(Icons.info, color: Colors.white),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

class ChatDialog extends StatefulWidget {
  @override
  _ChatDialogState createState() => _ChatDialogState();
}

class _ChatDialogState extends State<ChatDialog>
    with SingleTickerProviderStateMixin {
  late ChatController _chatController;
  late AnimationController _animationController;
  late Animation<double> _inputHeightAnimation;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _chatController = ChatController();

    // Configuração da animação
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _inputHeightAnimation = Tween<double>(begin: 60, end: 120).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    // Adiciona listener para o controlador de texto
    _chatController.textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _chatController.textController.text.isNotEmpty;
      _isTyping
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  void _updateUI() {
    setState(() {});
  }

  @override
  void dispose() {
    _chatController.textController.removeListener(_onTextChanged);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Cores mais escuras e sólidas
    final Color backgroundDark = Color(0xFF0A3A0A);
    final Color accentGreen = Color(0xFF0E500E);
    final Color brownAccent = Color(0xFF5C4B3A);

    return Positioned(
      bottom: 16,
      right: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(25),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.35,
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: backgroundDark,
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Cabeçalho com botão de fechar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: accentGreen,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: brownAccent,
                      child: const Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),

                    const Text(
                      'RecolheBot',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.1,
                      ),
                    ),

                    // Botão de Fechar
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red.withOpacity(0.7),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          // Lógica para fechar o chat
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Área de mensagens
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentGreen.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListView.builder(
                    controller: _chatController.scrollController,
                    padding: const EdgeInsets.all(10),
                    itemCount: _chatController.messages.length +
                        (_chatController.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _chatController.messages.length &&
                          _chatController.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: brownAccent,
                            strokeWidth: 2.5,
                          ),
                        );
                      }

                      final message = _chatController.messages[index];
                      final isUser = message.containsKey('user');

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isUser
                                ? brownAccent.withOpacity(0.7)
                                : const Color(0xFF2C5E2C).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            isUser ? message['user']! : message['bot']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Área de input animada
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.all(12),
                    height: _inputHeightAnimation.value,
                    decoration: BoxDecoration(
                      color: accentGreen.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              controller: _chatController.textController,
                              maxLines: _isTyping ? 3 : 1,
                              decoration: const InputDecoration(
                                hintText: 'Mensagem...',
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                  fontWeight: FontWeight.w300,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                              cursorColor: brownAccent,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 6, top: 6),
                          decoration: BoxDecoration(
                            color: brownAccent,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              final text =
                                  _chatController.textController.text.trim();
                              if (text.isNotEmpty) {
                                _chatController.sendMessage(text, _updateUI);
                                _chatController.textController.clear();
                                _animationController.reverse();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
