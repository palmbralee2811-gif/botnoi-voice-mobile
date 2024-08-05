import 'package:botnoi_voice_mobile/Modals/Delete/delete_modal.dart';
import 'package:botnoi_voice_mobile/Modals/Download/download_modal.dart';
import 'package:botnoi_voice_mobile/Screens/EditWorkspaceScreen/edit_workspace_screen.dart';
import 'package:botnoi_voice_mobile/Screens/WorkspaceScreen/audio_player_widget.dart';
import 'package:flutter/material.dart';

class TextBoxCard extends StatefulWidget {
  final String text;
  final String audioUrl;
  final String imageUrlList;
  final String speakerName;

  final Function(String value)? onTextChanged;
  final Function()? onDelete;

  const TextBoxCard({
    super.key,
    required this.text,
    required this.audioUrl,
    required this.imageUrlList,
    required this.speakerName,
    required this.onTextChanged,
    required this.onDelete,
  });

  @override
  State<TextBoxCard> createState() => _TextBoxCardState();
}

class _TextBoxCardState extends State<TextBoxCard> {
  void _openDownloadModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const DownlaodModal(),
    );
  }

  void _openDeleteModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => const Deletemodal(),
    );
  }

  void _editCard(BuildContext context) async {
    final updatedSentences = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => EditWorkspaceScreen(text: widget.text),
      ),
    );
    if (updatedSentences != null) {
      setState(() {
        widget.onTextChanged!(updatedSentences);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double paddingWidth = MediaQuery.of(context).size.width * 0.025;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingWidth),
      child: SizedBox(
        child: Container(
          constraints: const BoxConstraints(
            minHeight: 180,
          ),
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  widget.imageUrlList.isNotEmpty
                      ? CircleAvatar(
                          // backgroundImage: NetworkImage(widget.image), // replace with actual image URL
                          backgroundImage: NetworkImage(widget.imageUrlList),
                        )
                      : const CircleAvatar(),
                  const SizedBox(width: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.speakerName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Prompt')),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('ไทย',
                            style: TextStyle(
                                color: Colors.grey, fontFamily: 'Prompt')),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () async {
                            // Your download logic here
                            _openDownloadModal();
                          },
                          child:
                              const Icon(Icons.download_for_offline_outlined),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          // onTap: buttomsheetPressed,
                          child: const Icon(Icons.settings),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            if (widget.onDelete != null) {
                              _openDeleteModal();
                              widget.onDelete!();
                            }
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 7),
                child: Divider(color: Colors.grey),
              ),
              Row(
                children: [
                  AudioPlayerWidget(
                    audioUrl: widget.audioUrl,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Prompt',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _editCard(context);
                    },
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
