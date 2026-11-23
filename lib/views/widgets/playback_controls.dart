import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../viewmodels/solver_viewmodel.dart';

class PlaybackControls extends StatelessWidget {
  const PlaybackControls({super.key, required this.viewModel});

  final SolverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final stepCount = viewModel.steps.length;
    final max = stepCount > 1 ? (stepCount - 1).toDouble() : 1.0;
    final value = stepCount == 0
        ? 0.0
        : viewModel.currentStepIndex.clamp(0, stepCount - 1).toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // --- Playback Navigation ---
            IconButton(
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.inkBlack,
                foregroundColor: AppTheme.jasmine,
              ),
              tooltip: viewModel.isPlaying ? 'Pause' : 'Play',
              onPressed: stepCount == 0 ? null : viewModel.togglePlayPause,
              icon: Icon(
                viewModel.isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: stepCount == 0 ? null : viewModel.previousStep,
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            IconButton(
              onPressed: stepCount == 0 ? null : viewModel.nextStep,
              icon: const Icon(Icons.skip_next_rounded),
            ),
            const SizedBox(width: 12),
            // --- Step Timeline ---
            Text(
              'Step ${stepCount == 0 ? 0 : viewModel.currentStepIndex + 1} / $stepCount',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppTheme.inkBlack,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Slider(
                value: value,
                min: 0,
                max: max,
                divisions: stepCount > 1 ? stepCount - 1 : null,
                onChanged: stepCount == 0
                    ? null
                    : (value) => viewModel.goToStep(value.round()),
              ),
            ),
            const SizedBox(width: 12),
            // --- Playback Speed ---
            TextButton(
              onPressed: viewModel.cyclePlaybackSpeed,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.seaweed,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${viewModel.playbackSpeed.toStringAsFixed(1)}x',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
