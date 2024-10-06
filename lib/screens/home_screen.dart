import 'package:flutter/material.dart';
import 'package:flutter_openai_test/screens/all_models_screen.dart';
import 'package:flutter_openai_test/screens/art_generation/art_generetion_screen.dart';
import 'package:flutter_openai_test/screens/chat/chat_screen.dart';
import 'package:flutter_openai_test/screens/image_generation/image_generation_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("OPEN AI FLUTTER"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          CustomListTileWidget(
            title: "See All Available Models",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AllModelsScreen(),
              ));
            },
          ),
          CustomListTileWidget(
            title: "Chat",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatScreen(),
              ));
            },
          ),
          CustomListTileWidget(
            title: "Image Generation",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ImageGenerationScreen(),
              ));
            },
          ),
          CustomListTileWidget(
            title: "Art Generation",
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ArtGenerationScreen(),
              ));
            },
          ),
        ],
      ),
    );
  }
}

class CustomListTileWidget extends StatelessWidget {
  final String title;
  // final Icon trailing;
  final Function() onTap;
  const CustomListTileWidget({
    super.key,
    required this.title,
    // required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.account_tree_rounded),
        title: Text("$title"),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
