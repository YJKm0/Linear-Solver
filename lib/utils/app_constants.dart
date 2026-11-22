class AppConstants {
  AppConstants._();

  /// Smallest supported matrix dimension.
  static const int minDimension = 2;

  /// Largest supported matrix dimension.
  static const int maxDimension = 6;
  static const int defaultRows = 3;
  static const int defaultCols = 3;
  static const List<int> allowedDimensions = [2, 3, 4, 5, 6];
  static const List<String> variableSubscripts = ['₁', '₂', '₃', '₄', '₅', '₆'];

  static const int sidebarFlex = 4;
  static const int stageFlex = 6;
  static const int bannerFlex = 2;
  static const int matrixStageFlex = 8;
  static const int controlsFlex = 2;

  static const double screenPadding = 16.0;
  static const double cardPadding = 18.0;
  static const double sectionSpacing = 14.0;
  static const double inputCellHeight = 52.0;
  static const double stageCellWidth = 88.0;
  static const double stageCellHeight = 62.0;

  static const double minWindowWidth = 1280.0;
  static const double minWindowHeight = 780.0;
  static const double defaultWindowWidth = 1440.0;
  static const double defaultWindowHeight = 880.0;

  static const Duration stepTransitionDuration = Duration(milliseconds: 420);
  static const List<double> playbackSpeeds = [0.5, 1.0, 1.5, 2.0];
  static const double defaultPlaybackSpeed = 1.0;
  static const int baseStepIntervalMs = 1800;
}
