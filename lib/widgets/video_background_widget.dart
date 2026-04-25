import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
// import 'package:supabase_flutter/supabase_flutter.dart'; // Not directly used in this widget, can remove if not needed elsewhere

import '../utils/app_colors.dart'; // <--- Added this import for AppColors

class VideoBackgroundWidget extends StatefulWidget {
  final String videoPath;
  final Widget child;
  final Color overlayColor; // Color to blend with the video for transparency effect
  final double overlayOpacity; // Opacity of the overlay color (0.0 to 1.0)

  const VideoBackgroundWidget({
    Key? key,
    required this.videoPath,
    required this.child,
    this.overlayColor = AppColors.offBlack, // <--- CHANGED DEFAULT TO AppColors.offBlack
    this.overlayOpacity = 0.7,      // <--- CHANGED DEFAULT TO 0.7
  }) : super(key: key);

  @override
  State<VideoBackgroundWidget> createState() => _VideoBackgroundWidgetState();
}

class _VideoBackgroundWidgetState extends State<VideoBackgroundWidget> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.asset(widget.videoPath);
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.setVolume(0.0); // Mute background video
      await _controller.play();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
      }
    } catch (e) {
      print("Error initializing video player: $e");
      // Handle error, maybe show a static background
      if (mounted) {
        setState(() {
          _isVideoInitialized = false; // Or a flag to show error/fallback
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideoInitialized || !_controller.value.isInitialized) {
      // Show a loading indicator or a static background while video loads
      return Container(
        color: widget.overlayColor.withOpacity(0.8), // Darker fallback
        child: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Stack(
      fit: StackFit.expand, // Make the Stack fill the screen
      children: <Widget>[
        // Video Player Layer (Responsive)
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover, // Ensures video covers the screen, might crop
            child: SizedBox(
              width: _controller.value.size.width,
              height: _controller.value.size.height,
              child: VideoPlayer(_controller),
            ),
          ),
        ),
        // Transparency Overlay Layer
        Container(
          color: widget.overlayColor.withOpacity(widget.overlayOpacity),
        ),
        // Content Layer
        widget.child,
      ],
    );
  }
}
