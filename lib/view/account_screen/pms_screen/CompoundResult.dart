enum InterestApplyType { perMonth, perYear }

class CompoundResult {
  final double endBalance;
  final double totalContribution;
  final double profit;
  final List<MonthGrowth> monthWiseData;


  CompoundResult({
    required this.endBalance,
    required this.totalContribution,
    required this.profit,
    required this.monthWiseData,
  });
}



class MonthGrowth {
  final int month;
  final double interest;
  final double contribution;
  final double endBalance;

  MonthGrowth({
    required this.month,
    required this.interest,
    required this.contribution,
    required this.endBalance,
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

  List<MonthGrowth> growthList = [];

  // 🔁 SAME compounding logic for both cases
  for (int month = 1; month <= months; month++) {

    double interest = balance * monthlyRate;

    balance += balance * monthlyRate;
    balance += monthlyContribution;
    totalContribution += monthlyContribution;


    growthList.add(
      MonthGrowth(
        month: month,
        interest: double.parse(interest.toStringAsFixed(2)),
        contribution: monthlyContribution,
        endBalance: double.parse(balance.toStringAsFixed(2)),
      ),
    );
  }


  return CompoundResult(
    endBalance: double.parse(balance.toStringAsFixed(2)),
    totalContribution: double.parse(totalContribution.toStringAsFixed(2)),
    profit: double.parse((balance - totalContribution).toStringAsFixed(2)),
    monthWiseData: growthList,
  );
}


