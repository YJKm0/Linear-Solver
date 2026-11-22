enum SolutionType { unique, infinite, noSolution }

class SolutionResult {
  final SolutionType type;
  final List<String> values;
  final Map<int, String> parametricExpressions;
  final String summary;

  const SolutionResult({
    required this.type,
    this.values = const [],
    this.parametricExpressions = const {},
    required this.summary,
  });
}
