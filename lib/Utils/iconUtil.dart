import 'package:flutter/material.dart';

class IconAvatar extends StatelessWidget {
  final Color? corBorda;
  final String urlImage;
  final String nameOfPerson;

  IconAvatar({this.corBorda, required this.urlImage, required this.nameOfPerson});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(context: context,
            builder: (context) => PopupDetaialsImage(urlImage: urlImage, nameOfPerson: nameOfPerson));
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: corBorda ?? Colors.transparent,
              width: 1.0),
        ),
        child: Hero(
          tag: urlImage,
          child: CircleAvatar(
            backgroundImage: NetworkImage(urlImage),
          ),
        ),
      ),
    );
  }
}

class PopupDetaialsImage extends StatelessWidget {
  final String urlImage;
  final String nameOfPerson;

  const PopupDetaialsImage({super.key,
    required this.urlImage,
    required this.nameOfPerson
  });

  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Hero(
                tag: urlImage,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      child: AspectRatio(
                        aspectRatio: 1.0, // Relação largura:altura (1.0 para um quadrado)
                        child: Image.network(
                          urlImage,
                          fit: BoxFit.cover, // Ajusta a imagem para cobrir toda a área
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            InfosBottomImage(nameOfPerson: nameOfPerson)
          ],
        ),
      ),
    );
  }
}

class InfosBottomImage extends StatelessWidget {
  final String nameOfPerson;

  InfosBottomImage({required this.nameOfPerson});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 100,// Ocupa a largura máxima disponível
      child: Center(
        child: Text(
          nameOfPerson,
          style: TextStyle(
            color: Colors.black, // Cor do texto
          ),
        ),
      ),
    );
  }

}