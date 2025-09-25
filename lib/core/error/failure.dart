abstract class Failure {
  final String message;
  const Failure(this.message);
}

class CalculationFailure extends Failure {
  const CalculationFailure(super.message);
}