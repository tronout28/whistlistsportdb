

import 'dart:convert';

List<MakeupModel> productModelFromJson(String str) {
  final parsed = json.decode(str);
  return List<MakeupModel>.from(parsed['leagues'].map((x) => MakeupModel.fromJson(x)));
}
String productModelToJson(List<MakeupModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));


class MakeupModel {
  String? idTeam;
  String? strTeam;
  String? strLeague;
  String? strTeamBadge;

  MakeupModel(
      {this.idTeam,
      this.strTeam,
      this.strLeague,
      this.strTeamBadge,
      });

  MakeupModel.fromJson(Map<String, dynamic> json) {
  idTeam = json['idTeam']; 
  strTeam = json['strTeam'];
  strLeague = json['strLeague'];
  strTeamBadge = json['strTeamBadge'];
}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idTeam'] = this.idTeam as int;
    data['strTeam'] = this.strTeam;
    data['strLeague'] = this.strLeague;
    data['strTeamBadge'] = this.strTeamBadge;
    return data;
  }
}
