import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/media.dart';
import '../../view_model/media_view_model.dart';

class PlayerListWidget extends StatefulWidget {
  final List<Media> mediaList;
  final Function function;

  const PlayerListWidget({Key? key, required this.mediaList, required this.function}) : super(key: key);

  @override
  State<PlayerListWidget> createState() => _PlayerListWidgetState();
}

class _PlayerListWidgetState extends State<PlayerListWidget> {
  Widget _buildSongItem(Media media) {
    Media? selectedMedia = Provider.of<MediaViewModel>(context).media;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.network(media.artworkUrl ?? ''),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text(
                media.trackName ?? '',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 6,
              ),
              Text(
                media.artistName ?? '',
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                media.collectionName ?? '',
                style: const TextStyle(
                  fontSize: 10.0,
                  color: Colors.grey,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ]),
          ),
          if (selectedMedia != null && selectedMedia.trackName == media.trackName)
            Icon(
              Icons.play_circle_outline,
              color: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget.mediaList.length,
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            Media data = widget.mediaList[index];
            return InkWell(
              onTap: () {
                if (null != data.artistName) {
                  widget.function(data);
                }
              },
              child: _buildSongItem(data),
            );
          },
        ),
      ]),
    );
  }
}
