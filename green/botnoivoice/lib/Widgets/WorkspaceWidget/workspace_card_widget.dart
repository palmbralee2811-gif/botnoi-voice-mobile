import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/EditWorkspaceScreen/edit_workspace_screen.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:botnoivoice/Modals/Delete/DeleteModal.dart';
import 'package:botnoivoice/Modals/Download/DownloadModal.dart';

// ignore: must_be_immutable
class WorkspaceCardWidget extends StatefulWidget {
  final String sentences;
  final String audioUrl;
  final String imageUrlList;
  final String speakerName;

  // final String country;
  // late String sentences;
  // final String id;

  Function(String value)? changedValue;
  Function? onDelete;

  WorkspaceCardWidget({
    super.key,
    required this.sentences,
    required this.audioUrl,
    required this.imageUrlList,
    required this.speakerName,
    required this.changedValue,
    required this.onDelete,
  });
  @override
  State<WorkspaceCardWidget> createState() => _WorkspaceCardWidgetState();
}

class _WorkspaceCardWidgetState extends State<WorkspaceCardWidget> {
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
        builder: (ctx) => EditWorkspaceScreen(sentences: widget.sentences),
      ),
    );
    if (updatedSentences != null) {
      setState(() {
        widget.changedValue!(updatedSentences);
      });
    }
  }
  // void buttomsheetPressed(){
  //   showModalBottomSheet(context: context, builder: (ctx) =>const CustomBottomSheet());
  // }

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
                            //TODO: Download file after open download modal
                            _openDownloadModal();
                            final auth = Provider.of<Authentication>(context,
                                listen: false);
                            auth.downloadFile(widget.audioUrl);
                          },
                          child:
                              const Icon(Icons.download_for_offline_outlined),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          child: const Icon(Icons.edit),
                          onTap: () {
                            //TODO: Edit workspace
                            _editCard(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            //TODO: Delete workspace after open delete modal
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
                      widget.sentences,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'Prompt',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
