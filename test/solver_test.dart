import 'package:flutter_test/flutter_test.dart';
import 'package:linear_algebra_me/core/math/matrix.dart';
import 'package:linear_algebra_me/core/math/rational.dart';
import 'package:linear_algebra_me/models/solution_result.dart';
import 'package:linear_algebra_me/services/gauss_jordan_service.dart';
import 'package:linear_algebra_me/services/gaussian_service.dart';
import 'package:linear_algebra_me/utils/matrix_presets.dart';

AugmentedMatrix _parsePreset(PresetType type) {
  return MatrixPresets.forType(type)
      .map((row) => row.map(Rational.parse).toList())
      .toList();
}

void main() {
  test('Gaussian and Gauss-Jordan solve the unique preset', () {
    final matrix = _parsePreset(PresetType.unique);
    expect(GaussianService().solve(matrix).solution.type, SolutionType.unique);
    final rref = GaussJordanService().solve(matrix);
    final result = rref.solution;
    expect(result.type, SolutionType.unique);
    expect(result.values, ['2', '3', '-1']);
    final finalMatrix = rref.steps.last.matrix;
    for (var r = 0; r < 3; r++) {
      for (var c = 0; c < 3; c++) {
        expect(
          finalMatrix[r][c],
          r == c ? Rational.one : Rational.zero,
          reason: 'RREF must form the identity matrix',
        );
      }
    }
  });

  test('Dependent preset is classified as infinite', () {
    final matrix = _parsePreset(PresetType.infinite);
    expect(
      GaussJordanService().solve(matrix).solution.type,
      SolutionType.infinite,
    );
  });

  test('Inconsistent preset is classified as no solution', () {
    final matrix = _parsePreset(PresetType.noSolution);
    expect(
      GaussJordanService().solve(matrix).solution.type,
      SolutionType.noSolution,
    );
  });

  test('Decimal and fraction strings are parsed exactly', () {
    expect(Rational.parse('0.5').toString(), '1/2');
    expect(Rational.parse('3/4').toString(), '3/4');
  });

  test('Malformed decimals and trailing zeros are handled exactly', () {
    expect(Rational.parse('1.2300').toString(), '123/100');
    expect(Rational.parse('0.0100').toString(), '1/100');
    expect(() => Rational.parse('1.2.3'), throwsFormatException);
  });

  test('Gaussian parametric solution back-substitutes basic variables', () {
    final matrix = <List<Rational>>[
      [Rational.one, Rational(2), Rational(-1), Rational(3)],
      [Rational.zero, Rational.one, Rational(2), Rational(4)],
    ];

    final result = GaussianService().solve(matrix).solution;

    expect(result.type, SolutionType.infinite);
    expect(result.parametricExpressions[0], '-5 + 5x₃');
    expect(result.parametricExpressions[1], '4 - 2x₃');
    expect(result.parametricExpressions[2], 'free');
  });

  test('Gaussian parametric formatting omits zero and unit coefficients', () {
    final matrix = <List<Rational>>[
      [Rational.one, Rational.one, Rational.zero, Rational.zero],
      [Rational.zero, Rational.zero, Rational.one, Rational.zero],
    ];

    final result = GaussianService().solve(matrix).solution;

    expect(result.parametricExpressions[0], '- x₂');
    expect(result.parametricExpressions[1], 'free');
    expect(result.parametricExpressions[2], '0');
  });

  test('Gauss-Jordan parametric expressions use shared formatting', () {
    final matrix = <List<Rational>>[
      [Rational.one, Rational.one, Rational.zero],
    ];

    final result = GaussJordanService().solve(matrix).solution;

    expect(result.type, SolutionType.infinite);
    expect(result.parametricExpressions[0], '- x₂');
    expect(result.parametricExpressions[1], 'free');
  });
}
