import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class VideoPickerWidget extends StatefulWidget {
  @override
  _VideoPickerWidgetState createState() => _VideoPickerWidgetState();
}

class _VideoPickerWidgetState extends State<VideoPickerWidget> {
  XFile? _video;
  late VideoPlayerController _videoController;
  late Future<void> _initializeVideoPlayerFuture;
  bool isPlaying = false;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.file(File(_video?.path ?? ''))
      ..addListener(() {
        if (!mounted) return;
        setState(() {});
      });
    _initializeVideoPlayerFuture = _videoController.initialize();
  }

  Future<void> _pickVideo() async {
    XFile? pickedVideo = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      setState(() {
        _video = pickedVideo;
        _videoController = VideoPlayerController.file(File(_video?.path ?? ''))
          ..addListener(() {
            if (!mounted) return;
            setState(() {});
          });
        _initializeVideoPlayerFuture = _videoController.initialize();
        _videoController.setLooping(true); // Optional: Enable looping
      });
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_video != null)
              AspectRatio(
                aspectRatio: _videoController.value.aspectRatio,
                child: VideoPlayer(_videoController),
              )
            else
              const Text('No video selected'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    setState(() {
                      if (isPlaying) {
                        _videoController.pause();
                      } else {
                        _videoController.play();
                      }
                      isPlaying = !isPlaying;
                    });
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(Icons.stop),
                  onPressed: () {
                    setState(() {
                      _videoController.pause();
                      _videoController.seekTo(Duration.zero);
                      isPlaying = false;
                    });
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Icon(isMuted ? Icons.volume_off : Icons.volume_up),
                  onPressed: () {
                    setState(() {
                      isMuted = !isMuted;
                      _videoController.setVolume(isMuted ? 0.0 : 1.0);
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _pickVideo,
              child: const Text('Pick Video'),
            ),
          ],
        ),
      ),
    );
  }
}
