import 'rational.dart';

typedef AugmentedMatrix = List<List<Rational>>;

extension AugmentedMatrixX on AugmentedMatrix {
  AugmentedMatrix copy() => map((row) => List<Rational>.from(row)).toList();

  void swapRows(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}
