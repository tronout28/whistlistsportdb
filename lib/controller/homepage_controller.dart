import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as path; // Import path package
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:sqlfletwshislistfatih/models/sport_model.dart';

class HomepageController extends GetxController {
  RxList<SportModel> sport = RxList<SportModel>();
  RxList<RxBool> isFavoriteList = RxList<RxBool>();
  var isLoading = false.obs;

  Future<void> initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = documentsDirectory.path + "db_sport";

      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS sport (
              idTeam INTEGER PRIMARY KEY,
              strTeams TEXT,
              strLeague TEXT,
              image_link TEXT
            )
          ''');
        },
      );
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  Future<void> fetchData() async {
    try {
      isLoading.value = true;
      var headers = {"Accept": "Application/json"};
      var response = await http.get(
        Uri.parse(
          "https://thesportsdb.com/api/v1/json/3/search_all_teams.php?l=English%20Premier%20League",
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)["teams"];
        sport.value = data.map((e) => SportModel.fromJson(e)).toList();
        checkFavorite();
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToFavorite({
    required int idTeams,
    required String strTeams,
    required String strLeague,
    required String image_link,
  }) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_sport";
      Database database = await openDatabase(path);
      await database.insert(
          "sport",
          {
            "idTeam": idTeams,
            "strTeams": strTeams,
            "strLeague": strLeague,
            "image_link": image_link,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Error adding to favorite: $e");
    }
  }

  Future<void> deleteFromFavorite(int id) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_sport";
      Database database = await openDatabase(path);
      await database.delete(
        "sport",
        where: "idTeam = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting from favorite: $e");
    }
  }

  Future<void> checkFavorite() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_sport";
      Database database = await openDatabase(path);
      isFavoriteList.value = List.generate(sport.length, (index) => false.obs);
      for (int i = 0; i < sport.length; i++) {
        final result = await database
            .query("sport", where: "idTeam = ?", whereArgs: [sport[i].idTeam]);
        bool isFavorite = result.isNotEmpty;
        isFavoriteList[i].value = isFavorite;
      }
    } catch (e) {
      print("Error adding to favorite: $e");
    }
  }

  @override
  void onInit() {
    initDatabase();
    fetchData();
    super.onInit();
  }
}
