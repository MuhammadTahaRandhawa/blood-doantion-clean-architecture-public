import 'package:chewie/chewie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InAppTutorialPage extends StatefulWidget {
  const InAppTutorialPage({super.key});

  @override
  State<InAppTutorialPage> createState() => _InAppTutorialPageState();
}

class _InAppTutorialPageState extends State<InAppTutorialPage> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset(
        kIsWeb ? 'videos/app_tutorial.mp4' : 'assets/videos/app_tutorial.mp4')
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tutorial_appBar),
        backgroundColor: Colors.redAccent, // Add a bold color to the app bar
      ),
      body: Column(
        children: [
          // Video Player
          _chewieController != null &&
                  _chewieController!.videoPlayerController.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: Chewie(
                    controller: _chewieController!,
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
          // Description Steps
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  Text(
                    AppLocalizations.of(context)!.tutorial_donationSteps,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent, // Match the app bar color
                    ),
                  ),
                  SizedBox(height: 20),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep1,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep2,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep3,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep4,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep5,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep6,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep7,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep8,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep9,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep10,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep11,
                  ),
                  StepCard(
                    step: AppLocalizations.of(context)!.tutorial_donationStep12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StepCard extends StatelessWidget {
  final String step;

  const StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          step,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
