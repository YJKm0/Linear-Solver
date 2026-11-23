import 'package:flutter/material.dart';

import '../../core/math/matrix.dart';
import '../../core/theme/app_theme.dart';
import '../../models/solution_result.dart';
import '../../utils/app_constants.dart';
import '../../viewmodels/solver_viewmodel.dart';

class AnimatedMatrixBoard extends StatelessWidget {
  const AnimatedMatrixBoard({super.key, required this.viewModel});

  final SolverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final step = viewModel.currentStep;
    final matrix = step?.matrix;
    final rows = matrix?.length ?? viewModel.rows;
    final cols = matrix == null ? viewModel.cols : matrix.first.length - 1;

    return Card(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.cardPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Animated Matrix State ---
              AnimatedSwitcher(
                duration: AppConstants.stepTransitionDuration,
                transitionBuilder: (child, animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: Container(
                  key: ValueKey(viewModel.currentStepIndex),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 22,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // --- Row Labels ---
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var r = 0; r < rows; r++)
                              SizedBox(
                                width: 46,
                                height: 85,
                                child: Center(child: _buildRowLabel(r)),
                              ),
                          ],
                        ),
                        // --- Matrix Brackets & Augmented Divider ---
                        Container(
                          decoration: const BoxDecoration(
                            border: Border.symmetric(
                              vertical: BorderSide(
                                color: AppTheme.inkBlack,
                                width: 3.5,
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var r = 0; r < rows; r++)
                                    _buildRow(r, cols, matrix),
                                ],
                              ),
                              Positioned(
                                left:
                                    (AppConstants.stageCellWidth + 8) * cols +
                                    11.5 +
                                    10,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  width: 2.5,
                                  color: AppTheme.inkBlack,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (viewModel.currentStepIndex == viewModel.steps.length - 1 &&
                  viewModel.steps.isNotEmpty)
                _buildSolutionSummary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(int r, int cols, AugmentedMatrix? matrix) {
    final step = viewModel.currentStep;
    final isTarget =
        r == step?.targetRow && r != step?.pivotRow && r != step?.sourceRow;
    final isSource = r == step?.sourceRow || r == step?.pivotRow;
    final fill = isTarget
        ? AppTheme.canvasBg
        : isSource
        ? AppTheme.canvasBg
        : Colors.transparent;
    final borderColor = isTarget
        ? AppTheme.brandy
        : isSource
        ? AppTheme.seaweed
        : Colors.transparent;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: AppConstants.stepTransitionDuration,
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.fromLTRB(11.5, 6, 11.5, 6),
          decoration: BoxDecoration(
            color: fill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var c = 0; c < cols; c++) _buildCell(r, c, matrix),
              const SizedBox(width: 22.5),
              _buildCell(r, cols, matrix, isConstant: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRowLabel(int r) {
    final step = viewModel.currentStep;
    final isTarget =
        r == step?.targetRow && r != step?.pivotRow && r != step?.sourceRow;
    final isSource = r == step?.sourceRow || r == step?.pivotRow;

    return AnimatedContainer(
      duration: AppConstants.stepTransitionDuration,
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isTarget
            ? AppTheme.brandy
            : isSource
            ? AppTheme.seaweed
            : AppTheme.subtleFill,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isTarget
              ? AppTheme.brandy
              : isSource
              ? AppTheme.seaweed
              : AppTheme.borderSubtle,
        ),
      ),
      child: Text(
        'R${AppConstants.variableSubscripts[r]}',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: isTarget || isSource ? Colors.white : AppTheme.textMuted,
        ),
      ),
    );
  }

  /// Renders a matrix entry with pivot and target styling for the current step.
  /// The constant column receives distinct styling to preserve the augmented-matrix boundary.
  Widget _buildCell(
    int r,
    int c,
    AugmentedMatrix? matrix, {
    bool isConstant = false,
  }) {
    final step = viewModel.currentStep;
    final isPivot = r == step?.pivotRow && c == step?.pivotCol;
    final isTargetCell =
        r == step?.targetRow &&
        c == step?.pivotCol &&
        step?.targetRow != null &&
        step?.pivotCol != null;
    String text;
    if (matrix == null) {
      text = viewModel.grid[r][c].trim().isEmpty
          ? '0'
          : viewModel.grid[r][c].trim();
    } else {
      text = matrix[r][c].toString();
    }

    var fill = isConstant ? AppTheme.subtleFill : AppTheme.surfaceWhite;
    if (isTargetCell) {
      fill = AppTheme.brandy;
    }
    if (isPivot) fill = AppTheme.jasmine;

    var borderColor = isTargetCell ? AppTheme.brandy : AppTheme.borderSubtle;
    var borderWidth = isTargetCell ? 1.5 : 1.0;
    if (isPivot) {
      borderColor = AppTheme.inkBlack;
      borderWidth = 2.0;
    }

    return AnimatedContainer(
      duration: AppConstants.stepTransitionDuration,
      width: AppConstants.stageCellWidth,
      height: AppConstants.stageCellHeight,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: borderWidth),
      ),
      child: Center(
        child: Text(
          text,
          style: isPivot
              ? AppTheme.matrixNumberStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppTheme.inkBlack,
                )
              : AppTheme.matrixNumberStyle,
        ),
      ),
    );
  }

  /// Builds the final classification and variable values beneath the completed matrix.
  Widget _buildSolutionSummary() {
    final result = viewModel.solutionResult;
    if (result == null) return const SizedBox.shrink();
    final lines = <String>[];
    if (result.type == SolutionType.unique) {
      for (var i = 0; i < result.values.length; i++) {
        lines.add(
          'x${AppConstants.variableSubscripts[i]} = ${result.values[i]}',
        );
      }
    } else if (result.type == SolutionType.infinite) {
      for (var i = 0; i < viewModel.cols; i++) {
        final variable = 'x${AppConstants.variableSubscripts[i]}';
        final value = result.parametricExpressions[i];
        lines.add(
          value == 'free'
              ? '$variable is free'
              : '$variable = ${value ?? 'free'}',
        );
      }
    } else {
      lines.add('No values satisfy all equations simultaneously.');
    }
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.canvasBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.borderStrong),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            result.summary,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppTheme.inkBlack,
            ),
          ),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(line, style: AppTheme.matrixNumberStyle),
            ),
        ],
      ),
    );
  }
}
