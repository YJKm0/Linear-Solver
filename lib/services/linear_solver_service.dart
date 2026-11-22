import '../core/math/matrix.dart';
import '../core/math/rational.dart';
import '../models/solution_result.dart';
import '../models/solver_step.dart';
import '../utils/app_constants.dart';

abstract class LinearSolverService {
  ({SolutionResult solution, List<SolverStep> steps}) solve(
    AugmentedMatrix matrix,
  );

  String rowLabel(int index) => 'R${subscript(index + 1)}';

  String formatFactor(Rational value) => value.denominator == 1
      ? value.numerator.toString()
      : '${value.numerator}/${value.denominator}';

  String parenthesize(Rational value) => value.denominator == 1
      ? value.numerator.toString()
      : '(${value.numerator}/${value.denominator})';

  String subscript(int value) =>
      value >= 1 && value <= AppConstants.variableSubscripts.length
      ? AppConstants.variableSubscripts[value - 1]
      : value.toString().split('').map((digit) {
          const digits = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉'];
          return digits[int.parse(digit)];
        }).join();

  String formatParametricExpression(ParametricExpression expression) {
    var result = '';
    if (!expression.constant.isZero) result = expression.constant.toString();

    final sortedCoefficients = expression.coefficients.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    for (final entry in sortedCoefficients) {
      final c = entry.key;
      final coefficient = entry.value;
      if (coefficient.isZero) continue;

      final variable = 'x${subscript(c + 1)}';
      final magnitude = coefficient.isNegative ? -coefficient : coefficient;
      final coefficientText = magnitude == Rational.one ? '' : '$magnitude';
      final term = '$coefficientText$variable';

      if (coefficient.isNegative) {
        result = result.isEmpty ? '- $term' : '$result - $term';
      } else {
        result = result.isEmpty ? term : '$result + $term';
      }
    }

    return result.isEmpty ? '0' : result;
  }

  ({List<SolverStep> steps, List<int> pivotColumns, int pivotRow})
  forwardEliminate(AugmentedMatrix work, {required bool eliminateAbove}) {
    final rows = work.length;
    final cols = rows == 0 ? 0 : work.first.length - 1;
    final pivotColumns = <int>[];
    final steps = <SolverStep>[
      SolverStep(
        matrix: work.copy(),
        operationType: 'INITIAL',
        description: 'Begin with the entered augmented matrix',
        formula: '[A | b]',
      ),
    ];
    var pivotRow = 0;

    for (var col = 0; col < cols && pivotRow < rows; col++) {
      var selected = pivotRow;
      while (selected < rows && work[selected][col].isZero) {
        selected++;
      }
      if (selected == rows) continue;
      if (selected != pivotRow) {
        work.swapRows(selected, pivotRow);
        steps.add(
          SolverStep(
            matrix: work.copy(),
            operationType: 'SWAP',
            description: eliminateAbove
                ? 'Swap ${rowLabel(pivotRow)} and ${rowLabel(selected)} to bring a non-zero pivot into position'
                : 'Swap R${pivotRow + 1} and R${selected + 1} to bring a non-zero pivot into position',
            formula: '${rowLabel(pivotRow)} ↔ ${rowLabel(selected)}',
            pivotRow: pivotRow,
            pivotCol: col,
            sourceRow: selected,
            targetRow: pivotRow,
          ),
        );
      }

      final pivot = work[pivotRow][col];
      if (pivot != Rational.one) {
        for (var c = col; c <= cols; c++) {
          work[pivotRow][c] = work[pivotRow][c] / pivot;
        }
        steps.add(
          SolverStep(
            matrix: work.copy(),
            operationType: 'SCALE',
            description: eliminateAbove
                ? 'Scale ${rowLabel(pivotRow)} so the leading entry becomes 1'
                : 'Scale ${rowLabel(pivotRow)} by ${formatFactor(Rational.one / pivot)} so its leading entry becomes 1',
            formula:
                '${rowLabel(pivotRow)} ← ${parenthesize(Rational.one / pivot)}·${rowLabel(pivotRow)}',
            pivotRow: pivotRow,
            pivotCol: col,
            targetRow: pivotRow,
          ),
        );
      }

      pivotColumns.add(col);
      final startRow = eliminateAbove ? 0 : pivotRow + 1;
      final endRow = eliminateAbove ? rows : rows;
      for (var r = startRow; r < endRow; r++) {
        if (eliminateAbove && r == pivotRow) continue;
        if (!eliminateAbove && r <= pivotRow) continue;
        final factor = work[r][col];
        if (factor.isZero) continue;
        for (var c = col; c <= cols; c++) {
          work[r][c] = work[r][c] - factor * work[pivotRow][c];
        }
        steps.add(
          SolverStep(
            matrix: work.copy(),
            operationType: 'ELIMINATE',
            description:
                'Eliminate x${subscript(col + 1)} in ${rowLabel(r)} using the pivot in ${rowLabel(pivotRow)}',
            formula:
                '${rowLabel(r)} ← ${rowLabel(r)} - ${formatFactor(factor)}·${rowLabel(pivotRow)}',
            pivotRow: pivotRow,
            pivotCol: col,
            sourceRow: pivotRow,
            targetRow: r,
          ),
        );
      }
      pivotRow++;
    }

    return (steps: steps, pivotColumns: pivotColumns, pivotRow: pivotRow);
  }
}

class ParametricExpression {
  final Rational constant;
  final Map<int, Rational> coefficients;

  ParametricExpression(this.constant, [Map<int, Rational>? coefficients])
    : coefficients = coefficients ?? <int, Rational>{};

  ParametricExpression.free(int variable)
    : constant = Rational.zero,
      coefficients = <int, Rational>{variable: Rational.one};

  ParametricExpression scaled(Rational factor) {
    final scaledCoefficients = <int, Rational>{};
    for (final entry in coefficients.entries) {
      scaledCoefficients[entry.key] = entry.value * factor;
    }
    return ParametricExpression(constant * factor, scaledCoefficients);
  }

  ParametricExpression add(ParametricExpression other) {
    final combined = Map<int, Rational>.from(coefficients);
    for (final entry in other.coefficients.entries) {
      combined[entry.key] =
          (combined[entry.key] ?? Rational.zero) + entry.value;
    }
    return ParametricExpression(constant + other.constant, combined);
  }
}
