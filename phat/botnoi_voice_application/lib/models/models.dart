class User {
  String jwtToken;

  User({required this.jwtToken});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      jwtToken: json['jwtToken'],
    );
  }
}

class ListProject {
  String workspaceId;
  String name;
  String picture;
  String typeWorkspace;
  List<int> speakerList;
  String recentUse;
  List<WorkSpace> workSpaces;

  ListProject({
    required this.workspaceId,
    required this.name,
    required this.picture,
    required this.typeWorkspace,
    required this.speakerList,
    required this.recentUse,
    required this.workSpaces,
  });

  factory ListProject.fromJson(Map<String, dynamic> json) {
    var workspaceList = json['workSpaces'] as List<dynamic>? ?? [];
    List<WorkSpace> workSpaces = workspaceList.map((e) => WorkSpace.fromJson(e)).toList();

    return ListProject(
      workspaceId: json['workspace_id'] ?? '',
      name: json['name'] ?? '',
      picture: json['picture'] ?? '',
      typeWorkspace: json['type_workspace'] ?? '',
      speakerList: List<int>.from(json['speaker_list'] ?? []),
      recentUse: json['recent_use'] ?? '',
      workSpaces: workSpaces,
    );
  }
  void updateWorkSpaces(List<Map<String, dynamic>> textList) {
    workSpaces = textList.map((e) => WorkSpace.fromJson(e)).toList();
  }
}

class WorkSpace {
  String audioId;
  String text;
  int speaker;
  String url;
  String speed;
  String volume;
  bool statusDownload;
  String faceImageUrl;
  String engName;

  WorkSpace({
    required this.audioId,
    required this.text,
    required this.speaker,
    required this.url,
    required this.speed,
    required this.volume,
    required this.statusDownload,
    this.faceImageUrl='',
    this.engName = '',
  });

  factory WorkSpace.fromJson(Map<String, dynamic> json) {
    return WorkSpace(
      audioId: json['audio_id'] ?? '',
      text: json['text'] ?? '',
      speaker: json['speaker'] ?? 0,
      url: json['url'] ?? '',
      speed: json['speed'] ?? '',
      volume: json['volume'] ?? '',
      statusDownload: json['status_download'] ?? false,
    );
  }  
}

class VoiceRequest {
  final String audioId;
  final String language;
  final int speaker;
  final String speed;
  final String text;
  final String textDelay;
  final String typeMedia;
  final String volume;

  VoiceRequest({
    required this.audioId,
    required this.language,
    required this.speaker,
    required this.speed,
    required this.text,
    required this.textDelay,
    required this.typeMedia,
    required this.volume,
  });

  Map<String, dynamic> toJson() {
    return {
      'audio_id': audioId,
      'language': language,
      'speaker': speaker,
      'speed': speed,
      'text': text,
      'text_delay': textDelay,
      'type_media': typeMedia,
      'volume': volume,
    };
  }
}