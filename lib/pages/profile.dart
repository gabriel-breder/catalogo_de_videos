import 'package:catalogo_de_videos/components/bottom_navigator.dart';
import 'package:catalogo_de_videos/components/posters_display.dart';
import 'package:catalogo_de_videos/components/video_card.dart';
import 'package:catalogo_de_videos/model/user.dart';
import 'package:catalogo_de_videos/pages/login.dart';
import 'package:catalogo_de_videos/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static String routename = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final User user;
  bool _initialized = false;

  _signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    setState(() {
      preferences.clear();

      Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (route) => false,
      );
    });
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int? id;
    String? name;
    String? email;
    String? password;

    if (preferences.getInt("value") == null) {
      id = null;
      name = "Visitante";
      email = "";
      password = "";
    } else {
      id = preferences.getInt("id");
      name = preferences.getString("username");
      email = preferences.getString("email");
      password = preferences.getString("password");
    }

    setState(() {
      user = User(id: id, email: email!, name: name!, password: password!);
      _initialized = true;
    });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Perfil"),
          centerTitle: true,
          backgroundColor: ThemeColors.dark),
      backgroundColor: ThemeColors.background,
      body: _initialized
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Icon(
                    Icons.person_4,
                    size: 200,
                    color: ThemeColors.grey,
                  ),
                  Text(
                    user.name,
                    style: TextStyle(color: ThemeColors.text, fontSize: 26),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 10)),
                  Text(
                    user.email,
                    style: TextStyle(color: ThemeColors.text),
                  ),
                ]),
                PostersDisplay(title: "Meus Vídeos", children: [
                  VideoCard(
                      name: "teste",
                      url:
                          'http://fr.web.img6.acsta.net/pictures/20/08/12/11/02/3069967.jpg'),
                  VideoCard(
                      name: "teste",
                      url:
                          'http://fr.web.img6.acsta.net/pictures/20/08/12/11/02/3069967.jpg'),
                  VideoCard(
                      name: "teste",
                      url:
                          'http://fr.web.img6.acsta.net/pictures/20/08/12/11/02/3069967.jpg')
                ]),
                ElevatedButton(onPressed: _signOut, child: Text("Sair"))
              ],
            ))
          : const CircularProgressIndicator(),
      bottomNavigationBar: const BottomNavigationBarWidget(index: 2),
    );
  }
}
