import 'package:flutter/material.dart';
import 'package:wow/app/core/extensions.dart';
import 'package:video_player/video_player.dart';

import '../../../../app/core/styles.dart';
import '../../../../navigation/custom_navigation.dart';
import '../../../../navigation/routes.dart';

class VideoCard extends StatefulWidget {
  final String videoUrl;
  final double height;
  final double? width;

  const VideoCard({
    super.key,
    required this.videoUrl,
    this.height = 250,
    this.width,
  });

  @override
  VideoCardState createState() => VideoCardState();
}

class VideoCardState extends State<VideoCard> {
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _videoController.initialize();
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(
                () {
                  if (_videoController.value.isPlaying) {
                    _videoController.pause();
                  } else {
                    _videoController.play();
                  }
                },
              );
            },
            child: Container(
              height: widget.height,
              width: widget.width ?? context.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
              ),
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
          if (!_videoController.value.isPlaying)
            Center(
              child: IconButton(
                onPressed: () {
                  setState(
                    () {
                      if (_videoController.value.isPlaying) {
                        _videoController.pause();
                      } else {
                        _videoController.play();
                      }
                    },
                  );
                },
                icon: const Icon(
                  Icons.play_circle,
                  size: 50,
                  color: Styles.HINT_COLOR,
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                if (_videoController.value.isPlaying) {
                  _videoController.pause();
                }
                CustomNavigator.push(Routes.videoPreview,
                    arguments: widget.videoUrl);
              },
              icon: const Icon(
                Icons.fullscreen,
                size: 30,
                color: Styles.HINT_COLOR,
              ),
            ),
          )
        ],
      ),
    );
  }
}
