enum PresetType { unique, infinite, noSolution }

class MatrixPresets {
  MatrixPresets._();

  static const unique = <List<String>>[
    ['2', '1', '-1', '8'],
    ['-3', '-1', '2', '-11'],
    ['-2', '1', '2', '-3'],
  ];

  static const infinite = <List<String>>[
    ['1', '2', '-1', '3'],
    ['2', '4', '-2', '6'],
    ['-1', '-2', '1', '-3'],
  ];

  static const noSolution = <List<String>>[
    ['1', '1', '1', '6'],
    ['2', '2', '2', '12'],
    ['1', '1', '1', '7'],
  ];

  static List<List<String>> forType(PresetType type) {
    final source = type == PresetType.unique
        ? unique
        : type == PresetType.infinite
        ? infinite
        : noSolution;
    return source.map((row) => List<String>.from(row)).toList();
  }
}
