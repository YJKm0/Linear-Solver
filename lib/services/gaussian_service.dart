import '../core/math/matrix.dart';
import '../core/math/rational.dart';
import '../models/solution_result.dart';
import '../models/solver_step.dart';
import 'linear_solver_service.dart';

class GaussianService extends LinearSolverService {
  /// Solves an augmented system using Gaussian elimination and back-substitution.
  /// It also classifies inconsistent and underdetermined systems for the result summary.
  @override
  ({SolutionResult solution, List<SolverStep> steps}) solve(
    AugmentedMatrix matrix,
  ) {
    final work = matrix.copy();
    final rows = work.length;
    final cols = rows == 0 ? 0 : work.first.length - 1;
    final elimination = forwardEliminate(work, eliminateAbove: false);
    final steps = elimination.steps;
    final pivotRow = elimination.pivotRow;

    final rank = _coefficientRank(work);
    final augmentedRank = _augmentedRank(work);
    late final SolutionResult solution;
    if (rank < augmentedRank) {
      solution = const SolutionResult(
        type: SolutionType.noSolution,
        summary: 'No solution',
      );
    } else if (rank < cols) {
      solution = _parametricSolution(work);
    } else {
      final values = List<String>.filled(cols, '0');
      for (var r = cols - 1; r >= 0; r--) {
        var pivotCol = -1;
        for (var c = 0; c < cols; c++) {
          if (!work[r][c].isZero) {
            pivotCol = c;
            break;
          }
        }
        if (pivotCol < 0) continue;
        var value = work[r][cols];
        for (var c = pivotCol + 1; c < cols; c++) {
          value = value - work[r][c] * Rational.parse(values[c]);
        }
        values[pivotCol] = (value / work[r][pivotCol]).toString();
      }
      solution = SolutionResult(
        type: SolutionType.unique,
        values: values,
        summary: 'Unique solution',
      );
      steps.add(
        SolverStep(
          matrix: work.copy(),
          operationType: 'BACK-SUB',
          description:
              'Use back-substitution to solve from the last row upward',
          formula: values
              .asMap()
              .entries
              .map((entry) => 'x${subscript(entry.key + 1)} = ${entry.value}')
              .join(', '),
          pivotRow: cols - 1,
          pivotCol: cols - 1,
        ),
      );
    }
    steps.add(
      SolverStep(
        matrix: work.copy(),
        operationType: 'COMPLETE',
        description: solution.summary,
        formula: 'Complete',
        pivotRow: pivotRow > 0 ? pivotRow - 1 : null,
      ),
    );
    return (solution: solution, steps: steps);
  }

  int _coefficientRank(AugmentedMatrix matrix) {
    if (matrix.isEmpty) return 0;
    var rank = 0;
    final cols = matrix.first.length - 1;
    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < cols; c++) {
        if (!matrix[r][c].isZero) {
          rank++;
          break;
        }
      }
    }
    return rank;
  }

  int _augmentedRank(AugmentedMatrix matrix) {
    if (matrix.isEmpty) return 0;
    var rank = 0;
    for (var r = 0; r < matrix.length; r++) {
      if (matrix[r].any((value) => !value.isZero)) rank++;
    }
    return rank;
  }

  /// Builds variable expressions from free variables after forward elimination.
  /// Backward substitution expresses each pivot variable in terms of those free variables.
  SolutionResult _parametricSolution(AugmentedMatrix matrix) {
    final cols = matrix.first.length - 1;
    final pivotColumns = <int>{};
    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < cols; c++) {
        if (!matrix[r][c].isZero) {
          pivotColumns.add(c);
          break;
        }
      }
    }
    final expressions = <int, ParametricExpression>{};
    for (var c = 0; c < cols; c++) {
      if (!pivotColumns.contains(c)) {
        expressions[c] = ParametricExpression.free(c);
      }
    }
    for (var r = matrix.length - 1; r >= 0; r--) {
      var pivotCol = -1;
      for (var c = 0; c < cols; c++) {
        if (!matrix[r][c].isZero) {
          pivotCol = c;
          break;
        }
      }
      if (pivotCol < 0) continue;

      final pivot = matrix[r][pivotCol];
      var expression = ParametricExpression(matrix[r][cols] / pivot);
      for (var c = pivotCol + 1; c < cols; c++) {
        if (!matrix[r][c].isZero) {
          final coefficient = -matrix[r][c] / pivot;
          expression = expression.add(expressions[c]!.scaled(coefficient));
        }
      }
      expressions[pivotCol] = expression;
    }
    return SolutionResult(
      type: SolutionType.infinite,
      parametricExpressions: {
        for (final entry in expressions.entries)
          entry.key: pivotColumns.contains(entry.key)
              ? formatParametricExpression(entry.value)
              : 'free',
      },
      summary: 'Infinitely many solutions',
    );
  }
}
