class Rational {
  final int numerator;
  final int denominator;

  const Rational._(this.numerator, this.denominator);

  factory Rational.parse(String input) {
    final text = input.trim();
    if (text.isEmpty) return Rational.zero;
    if (text.contains('/')) {
      final parts = text.split('/');
      if (parts.length != 2) throw FormatException('Invalid fraction: $input');
      final numerator = int.tryParse(parts[0].trim());
      final denominator = int.tryParse(parts[1].trim());
      if (numerator == null || denominator == null || denominator == 0) {
        throw FormatException('Invalid fraction: $input');
      }
      return Rational(numerator, denominator);
    }
    if (text.contains('.')) {
      final negative = text.startsWith('-');
      final unsigned = text.replaceFirst('-', '');
      final parts = unsigned.split('.');
      if (parts.length != 2) {
        throw FormatException('Invalid decimal: $input');
      }
      final whole = int.tryParse(parts.first);
      final digits = parts[1].replaceAll(RegExp(r'0+$'), '');
      final fraction = digits.isEmpty ? 0 : int.tryParse(digits);
      if (whole == null || fraction == null) {
        throw FormatException('Invalid decimal: $input');
      }
      final scale = _tenPow(digits.length);
      var result = whole * scale + fraction;
      if (negative) result = -result;
      return Rational(result, scale);
    }
    final value = int.tryParse(text);
    if (value == null) throw FormatException('Invalid number: $input');
    return Rational(value);
  }

  factory Rational(int numerator, [int denominator = 1]) {
    if (denominator == 0) throw ArgumentError('Denominator cannot be zero');
    var n = numerator;
    var d = denominator;
    if (d < 0) {
      n = -n;
      d = -d;
    }
    final divisor = _gcd(n.abs(), d);
    return Rational._(n ~/ divisor, d ~/ divisor);
  }

  static const Rational zero = Rational._(0, 1);
  static const Rational one = Rational._(1, 1);

  Rational operator +(Rational other) => Rational(
    numerator * other.denominator + other.numerator * denominator,
    denominator * other.denominator,
  );
  Rational operator -(Rational other) => Rational(
    numerator * other.denominator - other.numerator * denominator,
    denominator * other.denominator,
  );
  Rational operator *(Rational other) =>
      Rational(numerator * other.numerator, denominator * other.denominator);
  Rational operator /(Rational other) {
    if (other.numerator == 0) throw ArgumentError('Division by zero');
    return Rational(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  Rational operator -() => Rational(-numerator, denominator);

  bool get isZero => numerator == 0;
  bool get isNegative => numerator < 0;

  @override
  bool operator ==(Object other) =>
      other is Rational &&
      numerator == other.numerator &&
      denominator == other.denominator;
  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() =>
      denominator == 1 ? '$numerator' : '$numerator/$denominator';

  static int _gcd(int a, int b) {
    while (b != 0) {
      final r = a % b;
      a = b;
      b = r;
    }
    return a == 0 ? 1 : a;
  }

  static int _tenPow(int exponent) {
    var value = 1;
    for (var i = 0; i < exponent; i++) {
      value *= 10;
    }
    return value;
  }
}
