import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlfletwshislistfatih/controller/favorite_controller.dart';
import 'package:sqlfletwshislistfatih/models/sport_model.dart';

class FavoritePageView extends StatelessWidget {
  const FavoritePageView({Key? key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritePageController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite",
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.builder(
            itemCount: controller.makeups.length,
            itemBuilder: (context, index) {
              MakeupModel? makeup = controller.makeups[index];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(8),
                      title: Text(
                        'Name: ${makeup.strTeam ?? ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Brand: ${makeup.strLeague ?? ''}',
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          makeup.strTeamBadge?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          controller.deleteFromFavorite(
                            makeup.idTeam! as int,
                            index,
                          );
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                );
            },
          );
        }
      }),
    );
  }
}
