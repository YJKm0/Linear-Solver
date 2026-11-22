import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/math/rational.dart';
import '../models/solution_result.dart';
import '../models/solver_step.dart';
import '../services/gauss_jordan_service.dart';
import '../services/gaussian_service.dart';
import '../utils/app_constants.dart';
import '../utils/matrix_presets.dart';

class SolverViewModel extends ChangeNotifier {
  int rows = AppConstants.defaultRows;
  int cols = AppConstants.defaultCols;
  bool isGaussJordan = true;
  late List<List<String>> grid;
  int gridVersion = 0;
  String? errorMessage;
  PresetType? _selectedPreset;
  PresetType? get selectedPreset => _selectedPreset;

  List<SolverStep> steps = [];
  SolutionResult? solutionResult;
  int currentStepIndex = 0;
  bool isPlaying = false;
  double playbackSpeed = AppConstants.defaultPlaybackSpeed;
  Timer? _timer;

  SolverViewModel() {
    grid = List.generate(rows, (_) => List.generate(cols + 1, (_) => ''));
  }

  SolverStep? get currentStep => steps.isEmpty ? null : steps[currentStepIndex];
  bool get hasSolution => solutionResult != null;

  void resizeGrid(int newRows, int newCols) {
    if (newRows < AppConstants.minDimension ||
        newRows > AppConstants.maxDimension ||
        newCols < AppConstants.minDimension ||
        newCols > AppConstants.maxDimension ||
        (newRows == rows && newCols == cols)) {
      return;
    }
    final updated = List.generate(newRows, (r) {
      return List.generate(newCols + 1, (c) {
        if (r < rows && c < cols) return grid[r][c];
        if (r < rows && c == newCols) return grid[r][cols];
        return '';
      });
    });
    rows = newRows;
    cols = newCols;
    grid = updated;
    gridVersion++;
    _selectedPreset = null;
    _resetSolution();
  }

  void updateCell(int r, int c, String val) {
    grid[r][c] = val.trim();
    _selectedPreset = null;
    notifyListeners();
  }

  void clearGrid() {
    grid = List.generate(rows, (_) => List.generate(cols + 1, (_) => ''));
    gridVersion++;
    _selectedPreset = null;
    _resetSolution();
  }

  void applyPreset(PresetType type) {
    rows = AppConstants.defaultRows;
    cols = AppConstants.defaultCols;
    grid = MatrixPresets.forType(type);
    gridVersion++;
    _selectedPreset = type;
    _resetSolution();
  }

  void setMethod(bool isGaussJordanSelected) {
    if (isGaussJordan == isGaussJordanSelected) return;
    isGaussJordan = isGaussJordanSelected;
    _resetSolution();
  }

  void solve() {
    stopPlayback();
    errorMessage = null;
    try {
      final matrix = List<List<Rational>>.generate(rows, (r) {
        return List<Rational>.generate(cols + 1, (c) {
          final text = grid[r][c].trim();
          if (text.isEmpty) return Rational.zero;
          return Rational.parse(text);
        });
      });
      final result = isGaussJordan
          ? GaussJordanService().solve(matrix)
          : GaussianService().solve(matrix);
      steps = result.steps;
      solutionResult = result.solution;
      currentStepIndex = 0;
      if (steps.length > 1) {
        isPlaying = true;
        _restartTimer();
      }
    } on FormatException catch (error) {
      steps = [];
      solutionResult = null;
      currentStepIndex = 0;
      errorMessage = error.message;
    } on ArgumentError catch (error) {
      steps = [];
      solutionResult = null;
      currentStepIndex = 0;
      errorMessage = error.message?.toString() ?? 'Invalid matrix value';
    }
    notifyListeners();
  }

  void nextStep() {
    if (steps.isEmpty || currentStepIndex >= steps.length - 1) {
      if (isPlaying) stopPlayback();
      return;
    }
    currentStepIndex++;
    if (currentStepIndex >= steps.length - 1 && isPlaying) {
      stopPlayback();
    }
    notifyListeners();
  }

  void previousStep() {
    if (steps.isEmpty || currentStepIndex == 0) return;
    currentStepIndex--;
    notifyListeners();
  }

  void goToStep(int index) {
    if (steps.isEmpty) return;
    currentStepIndex = index.clamp(0, steps.length - 1);
    notifyListeners();
  }

  void togglePlayPause() {
    if (steps.isEmpty) return;
    if (isPlaying) {
      stopPlayback();
      notifyListeners();
    } else {
      if (currentStepIndex >= steps.length - 1) currentStepIndex = 0;
      isPlaying = true;
      notifyListeners();
      _restartTimer();
    }
  }

  void stopPlayback() {
    _timer?.cancel();
    _timer = null;
    if (isPlaying) {
      isPlaying = false;
    }
  }

  void cyclePlaybackSpeed() {
    final speeds = AppConstants.playbackSpeeds;
    final index = speeds.indexOf(playbackSpeed);
    playbackSpeed = speeds[(index + 1) < speeds.length ? index + 1 : 0];
    if (isPlaying) _restartTimer();
    notifyListeners();
  }

  void _restartTimer() {
    _timer?.cancel();
    final interval = Duration(
      milliseconds: (AppConstants.baseStepIntervalMs / playbackSpeed).round(),
    );
    _timer = Timer.periodic(interval, (_) {
      if (steps.isEmpty || currentStepIndex >= steps.length - 1) {
        stopPlayback();
        notifyListeners();
        return;
      }
      currentStepIndex++;
      if (currentStepIndex >= steps.length - 1) {
        stopPlayback();
      }
      notifyListeners();
    });
  }

  void _resetSolution() {
    stopPlayback();
    steps = [];
    solutionResult = null;
    currentStepIndex = 0;
    errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
