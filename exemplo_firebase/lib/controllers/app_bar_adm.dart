import 'package:exemplo_firebase/controllers/user_data.dart';
import 'package:exemplo_firebase/screens/administrador/profile_adm_page.dart';
import 'package:flutter/material.dart';

class CustomAppBarADM extends StatelessWidget implements PreferredSizeWidget {
  final UserSession user;
  final bool showBackButton;

  const CustomAppBarADM({
    required this.user,
    this.showBackButton = false, // Por padrão, a seta não será exibida
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: Colors.transparent, // Fundo transparente
      elevation: 0, // Remove a sombra da AppBar
      automaticallyImplyLeading: false, // Remove a seta de voltar
      title: Text(
        'Olá, ${user.name ?? 'Usuário'}!',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          fontWeight: FontWeight.w600,
          color: Colors.black, // Ajuste de cor para contraste
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: screenWidth * 0.04),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreenADM(),
                ),
              );
            },
            child: CircleAvatar(
              radius: screenWidth * 0.06,
              backgroundColor: Colors.grey.shade200,
              child: (user.imagem != null && user.imagem!.isNotEmpty)
                  ? ClipOval(
                      child: Image.network(
                        user.imagem!,
                        fit: BoxFit.cover,
                        width: screenWidth * 0.12,
                        height: screenWidth * 0.12,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: screenWidth * 0.06,
                      color: Colors.grey.shade600,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
