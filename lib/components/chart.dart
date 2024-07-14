import 'package:flutter/material.dart';
import 'package:spent/components/chart_bar.dart';
import 'package:spent/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;

  const Chart({super.key, required this.recentTransaction});

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;
      for (var i = 0; i < recentTransaction.length; i++) {
        bool sameDay = recentTransaction[i].date.day == weekDay.day;
        bool sameMonth = recentTransaction[i].date.month == weekDay.month;
        bool sameYear = recentTransaction[i].date.year == weekDay.year;

        if (sameDay && sameMonth && sameYear) {
          totalSum += recentTransaction[i].value;
        }
      }

      String firstLetterOfWeekDay = DateFormat.E().format(weekDay)[0];

      return {
        'day': firstLetterOfWeekDay,
        'totalValueByDay': totalSum,
      };
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, transaction) {
      return sum + (transaction['totalValueByDay'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactions.map((transaction) {
            final double totalValueByDay =
                transaction['totalValueByDay'] as double;
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: transaction['day'] as String,
                value: totalValueByDay,
                percentage: totalValueByDay / _weekTotalValue,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
