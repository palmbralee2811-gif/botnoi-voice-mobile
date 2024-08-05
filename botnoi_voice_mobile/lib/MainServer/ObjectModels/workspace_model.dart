import 'package:botnoi_voice_mobile/MainServer/ObjectModels/text_box_model.dart';

class WorkspaceModel {
  String workspaceId;
  String name;
  String picture;
  String typeWorkspace;
  List<int> speakerList;
  String recentUse;
  List<TextBoxModel> textBoxes;

  WorkspaceModel({
    required this.workspaceId,
    required this.name,
    required this.picture,
    required this.typeWorkspace,
    required this.speakerList,
    required this.recentUse,
    required this.textBoxes,
  });

  /// Convert JSON to ListProject
  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    var workspaceList = json['workSpaces'] as List<dynamic>? ?? [];
    List<TextBoxModel> workSpaces =
        workspaceList.map((e) => TextBoxModel.fromJson(e)).toList();

    return WorkspaceModel(
      workspaceId: json['workspace_id'] ?? '',
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      typeWorkspace: json['type_workspace'] ?? '',
      speakerList: List<int>.from(json['speaker_list'] ?? []),
      recentUse: json['recent_use'] ?? '',
      textBoxes: workSpaces,
    );
  }
}
