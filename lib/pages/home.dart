import 'package:catalogo_de_videos/components/bottom_navigator.dart';
import 'package:catalogo_de_videos/pages/add_video.dart';
import 'package:flutter/material.dart';
import 'package:catalogo_de_videos/components/posters_display.dart';
import 'package:catalogo_de_videos/components/video_card.dart';
import 'package:catalogo_de_videos/styles/theme_colors.dart';
import 'package:catalogo_de_videos/controller/video_controller.dart';
import '../model/video.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VideoController controller;
  List<Video> movies = [];
  List<Video> series = [];
  bool loaded = false;

  _HomePageState() {
    controller = VideoController();
  }

  @override
  void initState() {
    super.initState();
    getVideos();
  }

  void getVideos() async {
    movies = await controller.getMovies();
    series = await controller.getSeries();
    loaded = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Home"),
          centerTitle: true,
          backgroundColor: ThemeColors.dark),
      backgroundColor: ThemeColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: ThemeColors.purple,
        onPressed: () {
          Navigator.pushNamed(context, AddVideo.routeName)
              .then((value) => setState(() {
                    getVideos();
                  }));
        },
        child: const Icon(Icons.add),
      ),
      body: loaded
          ? Column(
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
                            ))).toList())
              ],
            )
          : const Center(child: CircularProgressIndicator()),
      bottomNavigationBar: const BottomNavigatorBarWidget(index: 0),
    );
  }
}
