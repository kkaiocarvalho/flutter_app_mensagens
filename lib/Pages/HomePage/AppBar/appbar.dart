import 'package:flutter/material.dart';
import 'package:hackathon_unipac/Pages/HomePage/AppBar/SettingsPage/settingsProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hackathon_unipac/Pages/Login%20e%20Cad/Login.dart';
import 'package:hackathon_unipac/Utils/textUtil.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => AppBar().preferredSize;
}

final FirebaseAuth auth = FirebaseAuth.instance;

void signOutUser(BuildContext context) async {
  try {

    await auth.signOut().then((value) => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login())
    ));
  } catch (e) {
    print("Erro ao deslogar: $e");
  }
}

class _MyAppBarState extends State<MyAppBar> {
  Color primaryColor = const Color(0xff25d366);
  Color navbarSelectedColor = const Color(0xff25d366);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('UAI - ZAP'),
      backgroundColor: primaryColor,
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            // Adicione ação do ícone de pesquisa
          },
        ),
        Container(
          child: PopupMenuButton<String>(
            onSelected: (value) {
              // Implemente a lógica para cada item do menu selecionado
              if (value == 'opcao1') {
                // Navegar para a tela de perfil
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsProfile()),
                );
              } else if (value == 'opcao2') {
                signOutUser(context);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'opcao1',
                child: Row(children: [
                  Icon(Icons.account_circle, color: Colors.white),
                  SizedBox(width: 6),
                  Text('Perfil', style: TextStyle(color: Colors.white)),
                ]),
              ),
              const PopupMenuItem<String>(
                value: 'opcao2',
                child: Row(children: [
                  Icon(Icons.exit_to_app, color: Colors.red),
                  SizedBox(width: 6),
                  Text('Sair', style: TextStyle(color: Colors.red)),

                ]),
              ),
            ],
            icon: Icon(Icons.more_vert, color: Colors.white),
            color: primaryColor,
            elevation: 0,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      ],
    );
  }

  Size getPreferredSize() {
    final tabBarSize = TabBar(tabs: []).preferredSize;
    final appBarSize = AppBar().preferredSize;
    return Size(tabBarSize.width + appBarSize.width, tabBarSize.height + appBarSize.height);
  }
}