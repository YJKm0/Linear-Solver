import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../models/solution_result.dart';
import '../../viewmodels/solver_viewmodel.dart';

class OperationBanner extends StatelessWidget {
  const OperationBanner({super.key, required this.viewModel});

  final SolverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final step = viewModel.currentStep;
    final ready = viewModel.steps.isEmpty;
    final result = viewModel.solutionResult;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            // --- Step Status ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.jasmine,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.inkBlack, width: 1.2),
              ),
              child: Text(
                ready
                    ? 'READY'
                    : 'STEP ${viewModel.currentStepIndex + 1}/${viewModel.steps.length}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.inkBlack,
                ),
              ),
            ),
            const SizedBox(width: 16),
            if (!ready && step != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.inkBlack,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  step.operationType,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            if (!ready && step != null) const SizedBox(width: 12),
            // --- Operation Description & Formula ---
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ready
                              ? 'Initial Augmented Matrix [A | b]'
                              : (step?.description ?? ''),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inkBlack,
                          ),
                        ),
                        if (ready)
                          const Text(
                            'Enter values or pick a preset, then press Solve.',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        if (viewModel.errorMessage != null)
                          Text(
                            viewModel.errorMessage!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.brandy,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!ready && step != null) ...[
                    const SizedBox(width: 12),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppTheme.inkBlack,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        step.formula,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.inkBlack,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (result != null) ...[
              const SizedBox(width: 8),
              _classificationBadge(result.type),
            ],
            // --- Matrix Legend ---
            const SizedBox(width: 8),
            _legendChip('Pivot', AppTheme.jasmine),
            const SizedBox(width: 8),
            _legendChip('Source', AppTheme.seaweed),
            const SizedBox(width: 8),
            _legendChip('Target', AppTheme.brandy),
          ],
        ),
      ),
    );
  }

  Widget _classificationBadge(SolutionType type) {
    final label = switch (type) {
      SolutionType.unique => ('UNIQUE', AppTheme.seaweed),
      SolutionType.infinite => ('INFINITE', AppTheme.jasmine),
      SolutionType.noSolution => ('NO SOLUTION', AppTheme.brandy),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: label.$2,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: label.$2),
      ),
      child: Text(
        label.$1,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: AppTheme.inkBlack,
        ),
      ),
    );
  }

  Widget _legendChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.inkBlack,
            ),
          ),
        ],
      ),
    );
  }
}
