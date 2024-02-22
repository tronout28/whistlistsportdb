import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as path; // Import path package
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;
import 'package:sqlfletwshislistfatih/models/sport_model.dart';

class HomepageController extends GetxController {
  RxList<MakeupModel> makeup = RxList<MakeupModel>();
  RxList<RxBool> isFavoriteList = RxList<RxBool>();
  var isLoading = false.obs;

  Future<void> initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = documentsDirectory.path + "db_makeup";

      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
            CREATE TABLE IF NOT EXISTS makeup (
              id INTEGER PRIMARY KEY,
              name TEXT,
              brand TEXT,
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
          "https://www.thesportsdb.com/api/v1/json/3/all_leagues.php",
        ),
        headers: headers,
      );
      if (response.statusCode == 200) {
        makeup.value = productModelFromJson(response.body);
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

  Future<void> addToFavorite(MakeupModel makeupModel) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_makeup";
      Database database = await openDatabase(path);
      await database.insert("makeup", makeupModel.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print("Error adding to favorite: $e");
    }
  }

  Future<void> deleteFromFavorite(int id) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_makeup";
      Database database = await openDatabase(path);
      await database.delete(
        "makeup",
        where: "id = ?",
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting from favorite: $e");
    }
  }

  Future<void> checkFavorite() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_makeup";
      Database database = await openDatabase(path);
      isFavoriteList.value = List.generate(makeup.length, (index) => false.obs);
      for (int i = 0; i < makeup.length; i++) {
        final result = await database
            .query("makeup", where: "id = ?", whereArgs: [makeup[i].idTeam]);
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
