import '../core/math/matrix.dart';
import '../core/math/rational.dart';
import '../models/solution_result.dart';
import '../models/solver_step.dart';
import 'linear_solver_service.dart';

class GaussJordanService extends LinearSolverService {
  @override
  ({SolutionResult solution, List<SolverStep> steps}) solve(
    AugmentedMatrix matrix,
  ) {
    final work = matrix.copy();
    final rows = work.length;
    final cols = rows == 0 ? 0 : work.first.length - 1;
    final elimination = forwardEliminate(work, eliminateAbove: true);
    final steps = elimination.steps;
    final pivotRow = elimination.pivotRow;

    for (var r = 0; r < rows; r++) {
      var coefficientZero = true;
      for (var c = 0; c < cols; c++) {
        if (!work[r][c].isZero) coefficientZero = false;
      }
      if (coefficientZero && !work[r][cols].isZero) {
        final result = const SolutionResult(
          type: SolutionType.noSolution,
          summary: 'No solution',
        );
        steps.add(
          SolverStep(
            matrix: work.copy(),
            operationType: 'COMPLETE',
            description: result.summary,
            formula: 'Complete',
          ),
        );
        return (solution: result, steps: steps);
      }
    }

    final pivotColumns = elimination.pivotColumns;

    late final SolutionResult solution;
    if (pivotColumns.length == cols) {
      final values = List<String>.filled(cols, '0');
      for (var r = 0; r < rows; r++) {
        for (var c = 0; c < cols; c++) {
          if (work[r][c] == Rational.one && pivotColumns.contains(c)) {
            values[c] = work[r][cols].toString();
          }
        }
      }
      solution = SolutionResult(
        type: SolutionType.unique,
        values: values,
        summary: 'Unique solution',
      );
    } else {
      final expressions = <int, ParametricExpression>{};
      for (var c = 0; c < cols; c++) {
        if (!pivotColumns.contains(c)) {
          expressions[c] = ParametricExpression.free(c);
        }
      }
      for (var r = 0; r < rows; r++) {
        var pivotCol = -1;
        for (var c = 0; c < cols; c++) {
          if (work[r][c] == Rational.one && pivotColumns.contains(c)) {
            pivotCol = c;
            break;
          }
        }
        if (pivotCol < 0) continue;
        var expression = ParametricExpression(
          work[r][cols] / work[r][pivotCol],
        );
        for (var c = 0; c < cols; c++) {
          if (c != pivotCol && !work[r][c].isZero) {
            final coefficient = -work[r][c] / work[r][pivotCol];
            expression = expression.add(expressions[c]!.scaled(coefficient));
          }
        }
        expressions[pivotCol] = expression;
      }
      solution = SolutionResult(
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
}
