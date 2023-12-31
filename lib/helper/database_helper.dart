import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instancia = DatabaseHelper.constInterno();
  static Database? _db;

  factory DatabaseHelper() => _instancia;

  DatabaseHelper.constInterno();

  Future<Database> get db async {
    return _db ??= await initDb();
  }

  Future<Database> initDb() async {
    final databasePath = await getDatabasesPath();
    final path = p.join(databasePath, "data.db");

    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        String sql_user = """
        CREATE TABLE user(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name VARCHAR NOT NULL,
            email VARCHAR NOT NULL,
            password VARCHAR NOT NULL
        );""";

        String sql_genre = """
          CREATE TABLE genre(
                      id INTEGER PRIMARY KEY AUTOINCREMENT,
                      name VARCHAR NOT NULL
                  );
          """;

        String sql_video = """
                CREATE TABLE video(
                            id INTEGER PRIMARY KEY AUTOINCREMENT,
                            name VARCHAR(2) NOT NULL,
                            description TEXT NOT NULL,
                          type INTEGER NOT NULL,
                          ageRestriction VARCHAR NOT NULL,
                          durationMinutes INTEGER NOT NULL,
                          thumbnailImageId VARCHAR NOT NULL,
                          releaseDate TEXT NOT NULL,
                          creatorid INTEGER NOT NULL
                        );
                """;

        String sql_video_genre = """
                CREATE TABLE video_genre(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  videoid INTEGER NOT NULL,
                  genreid INTEGER NOT NULL,
                  FOREIGN KEY(videoid) REFERENCES video(id),
                  FOREIGN KEY(genreid) REFERENCES genre(id)
                );
            """;

        await db.execute(sql_user);
        await db.execute(sql_genre);
        await db.execute(sql_video);
        await db.execute(sql_video_genre);

        for (int i = 1; i < 6; i++) {
          String sql_insert_user =
              "INSERT INTO user(name, email, password) VALUES('Teste $i', 'teste$i@teste', '123456');";
          await db.execute(sql_insert_user);
        }

        List<String> generos = [
          'Comedia',
          'Terror',
          'Aventura',
          'Suspense',
          'Ação'
        ];
        for (String genero in generos) {
          String sql_insert_genre =
              "INSERT INTO genre(name) VALUES('$genero');";
          await db.execute(sql_insert_genre);
        }

        List<Map<String, String>> videos = [
          {
            "name": "A casa monstro",
            "url":
                "https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/61da8438155793.57575971afe13.jpg",
          },
          {
            "name": "Avatar",
            "url":
                "http://3.bp.blogspot.com/-H57vRpipBhs/T92h_GLMFAI/AAAAAAAAAAc/zLYxoSfXv9w/s1600/avatar_movie_poster_final_01.jpg",
          },
          {
            "name": "Piratas do Caribe",
            "url":
                "http://images2.fanpop.com/images/photos/8400000/Movie-Posters-movies-8405245-1224-1773.jpg",
          },
          {
            "name": "Liga da Justiça",
            "url":
                "https://www.slashfilm.com/wp/wp-content/images/2017-bestposter-justiceleague.jpg",
          }
        ];

        for (int i = 0; i < 4; i++) {
          String sql_insert_video =
              "INSERT INTO video(name, description, type, ageRestriction, durationMinutes, thumbnailImageId, releaseDate, creatorid) VALUES('${videos[i]["name"]}', 'Descrição $i', 0, '18 anos', 120, '${videos[i]["url"]}', '01/01/2020', ${i + 1});";
          await db.execute(sql_insert_video);
        }

        String add_serie =
            "INSERT INTO video(name, description, type, ageRestriction, durationMinutes, thumbnailImageId, releaseDate,creatorid) VALUES('Flash', 'Série do flash', 1, '18 anos', 120, 'http://fr.web.img6.acsta.net/pictures/20/08/12/11/02/3069967.jpg', '01/01/2020', 1);";
        await db.execute(add_serie);

        String add_video_genre_1 =
            "INSERT INTO video_genre(videoid, genreid) VALUES(1, 2);";
        String add_video_genre_2 =
            "INSERT INTO video_genre(videoid, genreid) VALUES(2, 5);";
        String add_video_genre_3 =
            "INSERT INTO video_genre(videoid, genreid) VALUES(3, 4);";
        String add_video_genre_4 =
            "INSERT INTO video_genre(videoid, genreid) VALUES(4, 3);";
        String add_video_genre_5 =
            "INSERT INTO video_genre(videoid, genreid) VALUES(5, 2);";

        await db.execute(add_video_genre_1);
        await db.execute(add_video_genre_2);
        await db.execute(add_video_genre_3);
        await db.execute(add_video_genre_4);
        await db.execute(add_video_genre_5);
      },
    );
    return db;
  }
}
