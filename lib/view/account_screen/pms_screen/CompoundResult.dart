enum InterestApplyType { perMonth, perYear }

class CompoundResult {
  final double endBalance;
  final double totalContribution;
  final double profit;

  CompoundResult({
    required this.endBalance,
    required this.totalContribution,
    required this.profit,
  });
}

CompoundResult calculateCompound({
  required double startingBalance,
  required double monthlyContribution,
  required double interestRate,
  required int months,
  required InterestApplyType applyType,
}) {
  double balance = startingBalance;
  double totalContribution = startingBalance;

  // 🔑 Convert interest to MONTHLY rate
  double monthlyRate;

  if (applyType == InterestApplyType.perMonth) {
    // e.g. 5% per month
    monthlyRate = interestRate / 100;
  } else {
    // e.g. 5% per year → 5 / 12 % per month
    monthlyRate = (interestRate / 100) / 12;
  }

  // 🔁 SAME compounding logic for both cases
  for (int month = 1; month <= months; month++) {
    balance += balance * monthlyRate;
    balance += monthlyContribution;
    totalContribution += monthlyContribution;
  }

  return CompoundResult(
    endBalance: double.parse(balance.toStringAsFixed(2)),
    totalContribution: double.parse(totalContribution.toStringAsFixed(2)),
    profit: double.parse((balance - totalContribution).toStringAsFixed(2)),
  );
}