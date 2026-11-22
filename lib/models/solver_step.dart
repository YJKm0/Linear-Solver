import '../core/math/rational.dart';

class SolverStep {
  final List<List<Rational>> matrix;
  final String operationType;
  final String description;
  final String formula;
  final int? pivotRow;
  final int? pivotCol;
  final int? sourceRow;
  final int? targetRow;

  const SolverStep({
    required this.matrix,
    required this.operationType,
    required this.description,
    required this.formula,
    this.pivotRow,
    this.pivotCol,
    this.sourceRow,
    this.targetRow,
  });

  List<List<Rational>> get snapshot =>
      matrix.map((row) => List<Rational>.from(row)).toList();
}
