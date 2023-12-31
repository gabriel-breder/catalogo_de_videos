import 'package:catalogo_de_videos/components/bottom_navigator.dart';
import 'package:catalogo_de_videos/pages/add_video.dart';
import 'package:catalogo_de_videos/pages/login.dart';
import 'package:catalogo_de_videos/pages/video_details.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_de_videos/components/posters_display.dart';
import 'package:catalogo_de_videos/components/video_card.dart';
import 'package:catalogo_de_videos/styles/theme_colors.dart';
import 'package:catalogo_de_videos/controller/video_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/video.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoController controller;
  List<Video> movies = [];
  List<Video> series = [];
  bool loaded = false;
  late SharedPreferences preferences;

  _HomePageState() {
    controller = VideoController();
  }

  _signOut() async {
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

  @override
  void initState() {
    super.initState();
    getVideos();
    controller.getMyVideos(0);
  }

  void getVideos() async {
    preferences = await SharedPreferences.getInstance();
    movies = await controller.getMovies();
    series = await controller.getSeries();
    loaded = true;
    setState(() {});
  }

  dynamic onTap(video) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoDetailsScreen(
                  video: video,
                ))).then((value) => setState(() {
          getVideos();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home"),
          leading: Padding(
              padding: EdgeInsets.all(5),
              child: Image.asset('images/logoPng.png')),
          actions: <Widget>[
            IconButton(
              onPressed: _signOut,
              icon: const Icon(Icons.logout),
            )
          ],
          centerTitle: true,
          backgroundColor: ThemeColors.dark),
      backgroundColor: ThemeColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: loaded && preferences.getInt("value") == 1
          ? FloatingActionButton(
              backgroundColor: ThemeColors.purple,
              onPressed: () {
                Navigator.pushNamed(context, AddVideo.routeName)
                    .then((value) => setState(() {
                          getVideos();
                        }));
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: loaded
          ? SingleChildScrollView(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                movies.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: Text(
                          "Nenhum filme encontrado!",
                          style: TextStyle(color: ThemeColors.text),
                        )))
                    : PostersDisplay(
                        title: "Filmes",
                        children: (movies.map((video) => VideoCard(
                              name: video.name,
                              url: video.thumbnailImageId,
                              onTap: () => onTap(video),
                            ))).toList()),
                series.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                            child: Text(
                          "Nenhuma série encontrada!",
                          style: TextStyle(color: ThemeColors.text),
                        )))
                    : PostersDisplay(
                        title: "Séries",
                        children: (series.map((video) => VideoCard(
                              name: video.name,
                              url: video.thumbnailImageId,
                              onTap: () => onTap(video),
                            ))).toList())
              ],
            ))
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: const BottomNavigationBarWidget(index: 0),
    );
  }
}
