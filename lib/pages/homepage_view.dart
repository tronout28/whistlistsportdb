import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlfletwshislistfatih/controller/homepage_controller.dart';
import 'package:sqlfletwshislistfatih/models/sport_model.dart';
import 'package:sqlfletwshislistfatih/pages/favoritepage_view.dart';

class HomePageView extends StatelessWidget {
  HomePageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomepageController());

    return Scaffold(
      appBar: AppBar(
        title: Text("League Teams"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => FavoritePageView())
                  ?.then((value) => controller.checkFavorite());
            },
            icon: Icon(Icons.favorite_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Teams in English Premier League",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent),
            ),
            SizedBox(height: 5),
            Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: controller.sport.length,
                    itemBuilder: (context, index) {
                      SportModel team = controller.sport[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                              title: Text(team.strTeam!,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  team.strTeamBadge!,
                                  height: 60,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              trailing: Obx(() {
                                bool isFavorite =
                                    controller.isFavoriteList[index].value;
                                return IconButton(
                                  icon: isFavorite == false
                                      ? Icon(Icons.favorite_border_outlined)
                                      : Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        ),
                                  onPressed: () {
                                    if (isFavorite == false) {
                                      controller.addToFavorite(
                                          idTeams: team.idTeam! as int,
                                          strTeams: team.strTeam!,
                                          strLeague: team.strLeague!,
                                          image_link: team.strTeamBadge!);
                                    } else {
                                      controller.deleteFromFavorite(
                                          team.idTeam! as int);
                                    }
                                    controller.isFavoriteList[index].toggle();
                                  },
                                );
                              })),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
