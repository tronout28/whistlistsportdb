import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlfletwshislistfatih/models/sport_model.dart';

class FavoritePageController extends GetxController {
  RxList<MakeupModel> makeups = RxList<MakeupModel>();

  var isLoading = false.obs;

  Future<void> fetchData() async {
    isLoading.value = true;
    Database? database;
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + "db_makeup";
    database = await openDatabase(path);
    final data = await database.query("makeup");
    makeups.value = data.map((e) => MakeupModel.fromJson(e)).toList();
    isLoading.value = false;
  }

  Future<void> deleteFromFavorite(int id, int index) async {
    try {
      Database? database;
      Directory directory = await getApplicationDocumentsDirectory();
      String path = directory.path + "db_makeup";
      database = await openDatabase(path);
      await database.delete("makeup", where: "id = ?", whereArgs: [id]);
      makeups.removeAt(index);
    } catch (e) {
      print("Error deleting from favorite: $e");
    }
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }
}
