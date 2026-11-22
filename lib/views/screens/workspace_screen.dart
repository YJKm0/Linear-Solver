import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../utils/app_constants.dart';
import '../../utils/matrix_presets.dart';
import '../../viewmodels/solver_viewmodel.dart';
import '../widgets/animated_matrix_board.dart';
import '../widgets/matrix_input_grid.dart';
import '../widgets/operation_banner.dart';
import '../widgets/playback_controls.dart';

class WorkspaceScreen extends StatelessWidget {
  const WorkspaceScreen({super.key, required this.viewModel});

  final SolverViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: AppConstants.sidebarFlex,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: _buildSidebar(),
            ),
          ),
          Expanded(
            flex: AppConstants.stageFlex,
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.screenPadding),
              child: Column(
                children: [
                  Expanded(
                    flex: AppConstants.bannerFlex,
                    child: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, _) =>
                          OperationBanner(viewModel: viewModel),
                    ),
                  ),
                  const SizedBox(height: AppConstants.screenPadding),
                  Expanded(
                    flex: AppConstants.matrixStageFlex,
                    child: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, _) =>
                          AnimatedMatrixBoard(viewModel: viewModel),
                    ),
                  ),
                  const SizedBox(height: AppConstants.screenPadding),
                  Expanded(
                    flex: AppConstants.controlsFlex,
                    child: ListenableBuilder(
                      listenable: viewModel,
                      builder: (context, _) =>
                          PlaybackControls(viewModel: viewModel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(color: AppTheme.inkBlack),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Linear Solver',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                ListenableBuilder(
                  listenable: viewModel,
                  builder: (context, _) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.jasmine,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      viewModel.isGaussJordan ? 'RREF' : 'REF',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.inkBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rows',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ListenableBuilder(
                              listenable: viewModel,
                              builder: (context, _) => _buildSizeDropdown(
                                'Rows',
                                viewModel.rows,
                                (value) =>
                                    viewModel.resizeGrid(value, viewModel.cols),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 18, 10, 0),
                        child: Text(
                          '×',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.inkBlack,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Cols',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.textMuted,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ListenableBuilder(
                              listenable: viewModel,
                              builder: (context, _) => _buildSizeDropdown(
                                'Cols',
                                viewModel.cols,
                                (value) =>
                                    viewModel.resizeGrid(viewModel.rows, value),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.sectionSpacing),
                  ListenableBuilder(
                    listenable: viewModel,
                    builder: (context, _) => SegmentedButton<bool>(
                      style: ButtonStyle(
                        side: WidgetStateProperty.all(
                          const BorderSide(color: AppTheme.borderSubtle),
                        ),
                      ),
                      segments: const [
                        ButtonSegment(value: false, label: Text('Gaussian')),
                        ButtonSegment(value: true, label: Text('Gauss-Jordan')),
                      ],
                      selected: {viewModel.isGaussJordan},
                      onSelectionChanged: (selection) =>
                          viewModel.setMethod(selection.first),
                    ),
                  ),
                  const SizedBox(height: AppConstants.sectionSpacing),
                  ListenableBuilder(
                    listenable: viewModel,
                    builder: (context, _) => Row(
                      children: [
                        Expanded(
                          child: _PresetPill(
                            label: 'Unique',
                            dotColor: AppTheme.seaweed,
                            type: PresetType.unique,
                            selected:
                                viewModel.selectedPreset == PresetType.unique,
                            onTap: () =>
                                viewModel.applyPreset(PresetType.unique),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _PresetPill(
                            label: 'Infinite',
                            dotColor: AppTheme.jasmine,
                            type: PresetType.infinite,
                            selected:
                                viewModel.selectedPreset == PresetType.infinite,
                            onTap: () =>
                                viewModel.applyPreset(PresetType.infinite),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: _PresetPill(
                            label: 'No Sol',
                            dotColor: AppTheme.brandy,
                            type: PresetType.noSolution,
                            selected:
                                viewModel.selectedPreset ==
                                PresetType.noSolution,
                            onTap: () =>
                                viewModel.applyPreset(PresetType.noSolution),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppConstants.sectionSpacing),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Augmented Matrix [A | b]',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.inkBlack,
                        ),
                      ),
                      TextButton(
                        onPressed: viewModel.clearGrid,
                        child: const Text(
                          'Clear',
                          style: TextStyle(color: AppTheme.brandy),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.canvasBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppTheme.borderSubtle),
                      ),
                      child: Center(
                        child: SingleChildScrollView(
                          child: ListenableBuilder(
                            listenable: viewModel,
                            builder: (context, _) =>
                                MatrixInputGrid(viewModel: viewModel),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.sectionSpacing),
                  ElevatedButton.icon(
                    onPressed: viewModel.solve,
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: AppTheme.jasmine,
                      size: 22,
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    label: const Text(
                      'Solve & Visualize',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeDropdown(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return DropdownButtonFormField<int>(
      key: ValueKey('${label}_${value}_${viewModel.gridVersion}'),
      initialValue: value,
      dropdownColor: AppTheme.surfaceWhite,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppTheme.surfaceWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.borderSubtle),
        ),
      ),
      items: AppConstants.allowedDimensions
          .map(
            (dimension) => DropdownMenuItem(
              value: dimension,
              child: Text(
                '$dimension',
                style: const TextStyle(color: AppTheme.inkBlack),
              ),
            ),
          )
          .toList(),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}

class _PresetPill extends StatefulWidget {
  const _PresetPill({
    required this.label,
    required this.dotColor,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color dotColor;
  final PresetType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_PresetPill> createState() => _PresetPillState();
}

class _PresetPillState extends State<_PresetPill> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final activeFill = widget.type == PresetType.unique
        ? const Color(0xFFEAF4EF)
        : widget.type == PresetType.infinite
        ? const Color(0xFFFAF3DF)
        : const Color(0xFFF6EBE8);
    final activeBorder = widget.type == PresetType.unique
        ? AppTheme.seaweed
        : widget.type == PresetType.infinite
        ? AppTheme.inkBlack
        : AppTheme.brandy;
    final activeText = widget.type == PresetType.unique
        ? AppTheme.seaweed
        : widget.type == PresetType.infinite
        ? AppTheme.inkBlack
        : AppTheme.brandy;

    return Tooltip(
      message: '${widget.label} 3×3 preset',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.selected
                  ? activeFill
                  : _hovered
                  ? AppTheme.canvasBg
                  : AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.selected ? activeBorder : AppTheme.borderSubtle,
                width: widget.selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: widget.dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: widget.selected
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: widget.selected ? activeText : AppTheme.inkBlack,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
