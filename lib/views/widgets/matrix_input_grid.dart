import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../viewmodels/solver_viewmodel.dart';

class MatrixInputGrid extends StatelessWidget {
  const MatrixInputGrid({super.key, required this.viewModel});

  final SolverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: ValueKey(
        '${viewModel.rows}_${viewModel.cols}_${viewModel.gridVersion}',
      ),
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Variable Headers ---
        Row(
          children: [
            Expanded(
              flex: viewModel.cols,
              child: Row(
                children: [
                  for (var c = 0; c < viewModel.cols; c++)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Center(
                          child: Text(
                            'x${AppConstants.variableSubscripts[c]}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              flex: 1,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Center(
                  child: Text(
                    'b',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.seaweed,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // --- Coefficients, Divider & Constants ---
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: viewModel.cols,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var r = 0; r < viewModel.rows; r++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            for (var c = 0; c < viewModel.cols; c++)
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: _buildCell(r, c),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Container(
                width: 2,
                margin: const EdgeInsets.symmetric(horizontal: 8),
                color: AppTheme.borderStrong,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var r = 0; r < viewModel.rows; r++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildCell(
                            r,
                            viewModel.cols,
                            isConstant: true,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds one editable matrix entry and connects changes to the viewmodel grid.
  Widget _buildCell(int row, int col, {bool isConstant = false}) {
    return SizedBox(
      height: AppConstants.inputCellHeight,
      child: TextFormField(
        key: ValueKey(
          '${viewModel.gridVersion}_${viewModel.rows}_${viewModel.cols}_$row-$col',
        ),
        initialValue: viewModel.grid[row][col],
        textAlign: TextAlign.center,
        style: AppTheme.inputNumberStyle,
        decoration: InputDecoration(
          hintText: '0',
          hintStyle: const TextStyle(color: AppTheme.textMuted),
          filled: true,
          fillColor: isConstant
              ? const Color(0xFFF3F6F4)
              : AppTheme.surfaceWhite,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.borderSubtle),
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppTheme.borderSubtle),
          ),
        ),
        onChanged: (value) => viewModel.updateCell(row, col, value),
      ),
    );
  }
}
