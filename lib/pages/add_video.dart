import 'package:catalogo_de_videos/components/form/form_input.dart';
import 'package:catalogo_de_videos/components/form/form_radio_buttons.dart';
import 'package:catalogo_de_videos/controller/video_controller.dart';
import 'package:catalogo_de_videos/model/video.dart';
import 'package:catalogo_de_videos/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<String> generos = [
  'Comedia',
  'Terror',
  'Aventura',
  'Suspense',
  'Ação'
];

class AddVideo extends StatefulWidget {
  static String routeName = "/add_video";
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  String name = '';
  String url = '';
  String description = '';
  String ageRestriction = '';
  int duration = 0;
  String generoEscolhido = generos.first;
  String releaseDate = '';
  int type = 0;
  int creatorId = 0;
  late SharedPreferences preferences;

  final _formKey = GlobalKey<FormState>();

  _onPressed() async {
    Video _video = Video(
        name: name,
        description: description,
        type: type,
        ageRestriction: ageRestriction,
        durationMinutes: duration,
        releaseDate: releaseDate,
        thumbnailImageId: url,
        creatorid: creatorId);

    int idGenre = -1;
    switch (generoEscolhido) {
      case 'Comedia':
        {
          idGenre = 1;
        }
      case 'Terror':
        {
          idGenre = 2;
        }
      case 'Aventura':
        {
          idGenre = 3;
        }
      case 'Suspense':
        {
          idGenre = 4;
        }
      case 'Ação':
        {
          idGenre = 5;
        }
    }

    if (_formKey.currentState!.validate() && creatorId != 0) {
      int res = await VideoController().saveVideo(_video, idGenre);
      Navigator.pop(context);
      String typeString = "Filme adicionado";
      if (type == 1) typeString = "Série adicionada";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$typeString com sucesso')),
      );
    }
  }

  getPref() async {
    preferences = await SharedPreferences.getInstance();
    creatorId = preferences.getInt("id")!;
    String name = preferences.getString("name")!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Adicionar Vídeo"),
            backgroundColor: ThemeColors.appBar),
        backgroundColor: ThemeColors.background,
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Form(
                  key: _formKey,
                  child: Column(children: [
                    FormInput(
                      label: "Nome",
                      onChanged: (value) => {name = value},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira um nome!';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: "URL da imagem",
                      onChanged: (value) => {url = value},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira uma URL!';
                        } else if (!value.startsWith("http")) {
                          return 'Insira uma URL válida!';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: "Descrição",
                      maxLines: 3,
                      onChanged: (value) => {description = value},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira uma descrição!';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: "Restrição de idade",
                      onChanged: (value) => {ageRestriction = "$value anos"},
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira uma idade mínima!';
                        } else if (int.parse(value) < 0 ||
                            int.parse(value) > 18) {
                          return 'Insira uma número entre 0(livre) e 18!';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: "Duração (minutos)",
                      onChanged: (value) => {duration = int.parse(value)},
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira o tempo de duração!';
                        }
                        return null;
                      },
                    ),
                    FormInput(
                      label: "Data de Lançamento (dd/mm/aaaa)",
                      onChanged: (value) => {releaseDate = value},
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Insira uma data!';
                        }
                        return null;
                      },
                    ),
                    FormRadioButtons(
                      onChanged: (value) {
                        type = value;
                      },
                    ),
                    DropdownButton<String>(
                      value: generoEscolhido,
                      style: const TextStyle(color: Colors.deepPurple),
                      onChanged: (String? value) {
                        setState(() {
                          generoEscolhido = value!;
                        });
                      },
                      items:
                          generos.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    )
                  ]),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                        onPressed: _onPressed,
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              return ThemeColors.formInput;
                            },
                          ),
                        ),
                        child: const Text("Adicionar")))
              ]),
        ));
  }
}
