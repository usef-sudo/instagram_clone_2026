import 'package:flutter/material.dart';
import 'package:instagram_clone/presentation/pages/map_sample.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  WebViewController controller = WebViewController()
    ..loadRequest(Uri.parse("https://flutter.dev/"));

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stack(
        //   children: [
        //     GestureDetector(
        //       onTap: () {
        //         _controller!.value.isPlaying
        //             ? _controller!.pause()
        //             : _controller!.play();
        //       },
        //       child: AspectRatio(
        //         aspectRatio: _controller!.value.aspectRatio,
        //         child: VideoPlayer(_controller!),
        //       ),
        //     ),
        //     Positioned(
        //         right: 10,
        //         child: Center(
        //           child: IconButton(
        //               onPressed: () {
        //                 showDialog(
        //                     context: context,
        //                     builder: (context) {
        //                       return AlertDialog(
        //                         title: Text("Change Playback Speed"),
        //                         content: Column(
        //                           mainAxisSize: MainAxisSize.min,
        //                           children: [
        //                             ListTile(
        //                               title: Text("0.5x"),
        //                               onTap: () {
        //                                 _controller!.setPlaybackSpeed(0.5);
        //                                 Navigator.pop(context);
        //                               },
        //                             ),
        //                             ListTile(
        //                               title: Text("1.0x"),
        //                               onTap: () {
        //                                 _controller!.setPlaybackSpeed(1.0);
        //                                 Navigator.pop(context);
        //                               },
        //                             ),
        //                             ListTile(
        //                               title: Text("1.5x"),
        //                               onTap: () {
        //                                 _controller!.setPlaybackSpeed(1.5);
        //                                 Navigator.pop(context);
        //                               },
        //                             ),
        //                             ListTile(
        //                               title: Text("2.0x"),
        //                               onTap: () {
        //                                 _controller!.setPlaybackSpeed(2.0);
        //                                 Navigator.pop(context);
        //                               },
        //                             ),
        //                           ],
        //                         ),
        //                       );
        //                     });
        //               },
        //               icon: Icon(Icons.speed)),
        //         ))
        //   ],
        // ),
        Expanded(child: WebViewWidget(controller: controller)),
        // Expanded(child: MapSample())
      ],
    );
  }
}
